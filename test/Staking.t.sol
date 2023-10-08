// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import {Staking} from "../src/Staking.sol";
import "../src/Blessed.sol";
import "../src/BlessedWETH.sol";
import "../src/interface/IWETH.sol";
import "./Helpers.sol";

contract StakingTest is Helpers {
    Staking public staking;
    Blessed blessed;
    BlessedWETH Wblessed;
    IWETH weth;
    address WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    address uOne;
    address uTwo;

    uint256 privKeyA;
    uint256 privKeyB;

    Staking.Stake stake;

    function setUp() public {
        (uOne, privKeyA) = mkaddr("USERA");
        (uTwo, privKeyB) = mkaddr("USERB");

        switchSigner(uOne);

        Wblessed = new BlessedWETH();
        blessed = new Blessed();
        staking = new Staking(address(blessed), address(Wblessed));

        stake = Staking.Stake({
            stakedAmount: 1 ether,
            lastStakeTime: 0,
            totalRewards: 0,
            optedForCompounding: false
        });

        weth = IWETH(WETH_ADDRESS);
    }

    function testFuzz_stakeETHValue(uint256 x) public payable {
        staking.stakeETH{value: x}();
    }

    function testStakeEthNoValue() public payable {
        vm.expectRevert(Staking.NoStakeValue.selector);
        staking.stakeETH{value: 0}();
    }

    function testStakeEthNotPayable() public {
        vm.expectRevert();
        staking.stakeETH{value: 1 ether}();
    }

    function testStakeEth() public payable {
        staking.stakeETH{value: 2 ether}();
    }

    function testCompoundRewards() public {
        stake.stakedAmount = 0;
        vm.expectRevert(Staking.NoStakedWETH.selector);
        staking.compoundRewards();
    }

    function testRewardsToCompound() public {}
}
