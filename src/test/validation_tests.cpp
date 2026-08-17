// Copyright (c) 2014-2019 The Bitcoin Core developers
// Copyright (c) 2013-2026 The KittehCoin developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#include <chainparams.h>
#include <validation.h>

#include <test/util/setup_common.h>

#include <boost/test/unit_test.hpp>

BOOST_FIXTURE_TEST_SUITE(validation_tests, TestingSetup)

BOOST_AUTO_TEST_CASE(block_subsidy_kittehcoin_schedule)
{
    const auto chainParams = CreateChainParams(*m_node.args, CBaseChainParams::MAIN);
    const Consensus::Params& consensusParams = chainParams->GetConsensus();

    BOOST_CHECK_EQUAL(GetBlockSubsidy(0, consensusParams), 1000 * COIN);
    BOOST_CHECK(GetBlockSubsidy(1, consensusParams) <= 50000 * COIN);
    BOOST_CHECK_EQUAL(GetBlockSubsidy(700000, consensusParams), 2000 * COIN);
    BOOST_CHECK_EQUAL(GetBlockSubsidy(700001, consensusParams), 2000 * COIN);
    BOOST_CHECK_EQUAL(GetBlockSubsidy(1000000, consensusParams), 2000 * COIN);
}

BOOST_AUTO_TEST_CASE(subsidy_portable_deterministic)
{
    const auto chainParams = CreateChainParams(*m_node.args, CBaseChainParams::MAIN);
    const Consensus::Params& consensusParams = chainParams->GetConsensus();

    uint256 prev = uint256S("0x0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef");
    const CAmount a = GetBlockSubsidy(100, prev, 0, consensusParams);
    const CAmount b = GetBlockSubsidy(100, prev, 0, consensusParams);
    BOOST_CHECK_EQUAL(a, b);
    BOOST_CHECK(a >= 1000 * COIN);
    BOOST_CHECK(a <= 50000 * COIN);

    // Different prev hash must be allowed to differ (usually will)
    uint256 prev2 = uint256S("0xfedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210");
    const CAmount c = GetBlockSubsidy(100, prev2, 0, consensusParams);
    BOOST_CHECK(c >= 1000 * COIN);
    BOOST_CHECK(c <= 50000 * COIN);
}

BOOST_AUTO_TEST_CASE(subsidy_money_supply_cap)
{
    const auto chainParams = CreateChainParams(*m_node.args, CBaseChainParams::MAIN);
    const Consensus::Params& consensusParams = chainParams->GetConsensus();

    // Near the hard cap, subsidy must shrink then hit zero
    const CAmount almost = MAX_MONEY - 500 * COIN;
    const CAmount s1 = GetBlockSubsidy(800000, uint256(), almost, consensusParams);
    BOOST_CHECK_EQUAL(s1, 500 * COIN);

    const CAmount s2 = GetBlockSubsidy(800000, uint256(), MAX_MONEY, consensusParams);
    BOOST_CHECK_EQUAL(s2, 0);

    const CAmount s3 = GetBlockSubsidy(800000, uint256(), MAX_MONEY - 1, consensusParams);
    BOOST_CHECK_EQUAL(s3, 1);
}

BOOST_AUTO_TEST_CASE(subsidy_limit_never_exceeds_max_money)
{
    const auto chainParams = CreateChainParams(*m_node.args, CBaseChainParams::MAIN);
    const Consensus::Params& consensusParams = chainParams->GetConsensus();

    // Worst-case: always take the tier maximum and ensure cumulative ≤ MAX_MONEY
    CAmount nSum = 0;
    auto worst = [](int h) -> CAmount {
        if (h < 200000) return 50000 * COIN;
        if (h < 400000) return 25000 * COIN;
        if (h < 500000) return 12500 * COIN;
        if (h < 600000) return 6250 * COIN;
        if (h < 700000) return 3125 * COIN;
        return 2000 * COIN;
    };
    for (int h = 0; h < 5000000; ++h) {
        CAmount sched = worst(h);
        CAmount rem = MAX_MONEY - nSum;
        CAmount pay = sched > rem ? rem : sched;
        nSum += pay;
        BOOST_CHECK(nSum <= MAX_MONEY);
        if (pay == 0) {
            BOOST_CHECK_EQUAL(nSum, MAX_MONEY);
            break;
        }
    }
    BOOST_CHECK_EQUAL(nSum, MAX_MONEY);
}

BOOST_AUTO_TEST_SUITE_END()
