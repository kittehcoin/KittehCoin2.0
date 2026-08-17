// Copyright (c) 2009-2010 Satoshi Nakamoto
// Copyright (c) 2009-2018 The Bitcoin Core developers
// Copyright (c) 2013-2026 The KittehCoin developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#include <pow.h>

#include <arith_uint256.h>
#include <chain.h>
#include <kgw_horizon.h>
#include <primitives/block.h>
#include <uint256.h>

namespace {

/** Litecoin Digishield-style clamp: keep retarget multiply from wrapping / exploding. */
static int64_t ClampTimespan(int64_t actual, int64_t target)
{
    if (target <= 0) return actual;
    const int64_t lo = target / 4;
    const int64_t hi = target * 4;
    if (actual < lo) return lo;
    if (actual > hi) return hi;
    return actual;
}

/**
 * Kimoto Gravity Well with:
 *  - fixed-point event-horizon (portable across compilers)
 *  - timespan clamp before target multiply
 */
unsigned int KimotoGravityWell(const CBlockIndex* pindexLast, const CBlockHeader* pblock,
                              uint64_t TargetBlocksSpacingSeconds, uint64_t PastBlocksMin,
                              uint64_t PastBlocksMax, const Consensus::Params& params)
{
    const CBlockIndex* BlockLastSolved = pindexLast;
    const CBlockIndex* BlockReading = pindexLast;
    uint64_t PastBlocksMass = 0;
    int64_t PastRateActualSeconds = 0;
    int64_t PastRateTargetSeconds = 0;
    arith_uint256 PastDifficultyAverage;
    arith_uint256 PastDifficultyAveragePrev;

    const arith_uint256 bnPowLimit = UintToArith256(params.powLimit);

    if (BlockLastSolved == nullptr || BlockLastSolved->nHeight == 0 ||
        (uint64_t)BlockLastSolved->nHeight < PastBlocksMin) {
        return bnPowLimit.GetCompact();
    }

    for (unsigned int i = 1; BlockReading && BlockReading->nHeight > 0; i++) {
        if (PastBlocksMax > 0 && i > PastBlocksMax) {
            break;
        }
        PastBlocksMass++;

        if (i == 1) {
            PastDifficultyAverage.SetCompact(BlockReading->nBits);
        } else {
            arith_uint256 nBitsDiff;
            nBitsDiff.SetCompact(BlockReading->nBits);
            if (nBitsDiff > PastDifficultyAveragePrev) {
                PastDifficultyAverage = PastDifficultyAveragePrev + ((nBitsDiff - PastDifficultyAveragePrev) / i);
            } else {
                PastDifficultyAverage = PastDifficultyAveragePrev - ((PastDifficultyAveragePrev - nBitsDiff) / i);
            }
        }
        PastDifficultyAveragePrev = PastDifficultyAverage;

        PastRateActualSeconds = BlockLastSolved->GetBlockTime() - BlockReading->GetBlockTime();
        PastRateTargetSeconds = static_cast<int64_t>(TargetBlocksSpacingSeconds * PastBlocksMass);
        if (PastRateActualSeconds < 0) {
            PastRateActualSeconds = 0;
        }

        if (PastBlocksMass >= PastBlocksMin && PastRateActualSeconds != 0 && PastRateTargetSeconds != 0) {
            const size_t idx = PastBlocksMass < KGW_HORIZON_SIZE ? PastBlocksMass : (KGW_HORIZON_SIZE - 1);
            const uint64_t fast_fp = KGW_HORIZON_FP[idx]; // scale 1e6
            // Use 256-bit intermediates: timestamp gaps can make actual*fast_fp overflow uint64.
            arith_uint256 target_scaled = PastRateTargetSeconds;
            target_scaled *= 1000000;
            arith_uint256 actual_scaled = PastRateActualSeconds;
            actual_scaled *= fast_fp;
            arith_uint256 target_fp = PastRateTargetSeconds;
            target_fp *= fast_fp;
            arith_uint256 actual_million = PastRateActualSeconds;
            actual_million *= 1000000;
            // ratio = target/actual; break if ratio >= fast OR ratio <= 1/fast
            const bool too_fast = target_scaled >= actual_scaled;
            const bool too_slow = target_fp <= actual_million;
            if (too_fast || too_slow) {
                assert(BlockReading);
                break;
            }
        }
        if (BlockReading->pprev == nullptr) {
            assert(BlockReading);
            break;
        }
        BlockReading = BlockReading->pprev;
    }

    arith_uint256 bnNew(PastDifficultyAverage);
    if (PastRateActualSeconds != 0 && PastRateTargetSeconds != 0) {
        const int64_t clamped = ClampTimespan(PastRateActualSeconds, PastRateTargetSeconds);
        bnNew *= clamped;
        bnNew /= PastRateTargetSeconds;
    }
    if (bnNew > bnPowLimit) {
        bnNew = bnPowLimit;
    }

    return bnNew.GetCompact();
}

} // namespace

unsigned int GetNextWorkRequired(const CBlockIndex* pindexLast, const CBlockHeader *pblock, const Consensus::Params& params)
{
    assert(pindexLast != nullptr);
    unsigned int nProofOfWorkLimit = UintToArith256(params.powLimit).GetCompact();

    if (params.fPowKimotoGravityWell) {
        if (params.fPowAllowMinDifficultyBlocks) {
            if (pblock->GetBlockTime() > pindexLast->GetBlockTime() + params.nPowTargetSpacing * 2) {
                return nProofOfWorkLimit;
            }
        }
        return KimotoGravityWell(pindexLast, pblock, params.nPowTargetSpacing,
                                 params.nKGWPastBlocksMin, params.nKGWPastBlocksMax, params);
    }

    // Only change once per difficulty adjustment interval
    if ((pindexLast->nHeight+1) % params.DifficultyAdjustmentInterval() != 0)
    {
        if (params.fPowAllowMinDifficultyBlocks)
        {
            // Special difficulty rule for testnet:
            if (pblock->GetBlockTime() > pindexLast->GetBlockTime() + params.nPowTargetSpacing*2)
                return nProofOfWorkLimit;
            else
            {
                const CBlockIndex* pindex = pindexLast;
                while (pindex->pprev && pindex->nHeight % params.DifficultyAdjustmentInterval() != 0 && pindex->nBits == nProofOfWorkLimit)
                    pindex = pindex->pprev;
                return pindex->nBits;
            }
        }
        return pindexLast->nBits;
    }

    // Go back by what we want to be 14 days worth of blocks
    int nHeightFirst = pindexLast->nHeight - (params.DifficultyAdjustmentInterval()-1);
    assert(nHeightFirst >= 0);
    const CBlockIndex* pindexFirst = pindexLast->GetAncestor(nHeightFirst);
    assert(pindexFirst);

    return CalculateNextWorkRequired(pindexLast, pindexFirst->GetBlockTime(), params);
}

unsigned int CalculateNextWorkRequired(const CBlockIndex* pindexLast, int64_t nFirstBlockTime, const Consensus::Params& params)
{
    if (params.fPowNoRetargeting)
        return pindexLast->nBits;

    // Limit adjustment step
    int64_t nActualTimespan = pindexLast->GetBlockTime() - nFirstBlockTime;
    if (nActualTimespan < params.nPowTargetTimespan/4)
        nActualTimespan = params.nPowTargetTimespan/4;
    if (nActualTimespan > params.nPowTargetTimespan*4)
        nActualTimespan = params.nPowTargetTimespan*4;

    // Retarget
    const arith_uint256 bnPowLimit = UintToArith256(params.powLimit);
    arith_uint256 bnNew;
    bnNew.SetCompact(pindexLast->nBits);
    bnNew *= nActualTimespan;
    bnNew /= params.nPowTargetTimespan;

    if (bnNew > bnPowLimit)
        bnNew = bnPowLimit;

    return bnNew.GetCompact();
}

bool CheckProofOfWork(uint256 hash, unsigned int nBits, const Consensus::Params& params)
{
    bool fNegative;
    bool fOverflow;
    arith_uint256 bnTarget;

    bnTarget.SetCompact(nBits, &fNegative, &fOverflow);

    // Check range
    if (fNegative || bnTarget == 0 || fOverflow || bnTarget > UintToArith256(params.powLimit))
        return false;

    // Check proof of work matches claimed amount
    if (UintToArith256(hash) > bnTarget)
        return false;

    return true;
}
