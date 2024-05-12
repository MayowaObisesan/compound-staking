// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/utils/math/Math.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "./Blessed.sol";
import "./BlessedWETH.sol";
import "./interface/IWETH.sol";
import {console2} from "forge-std/Test.sol";

contract Staking {
    address WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    IWETH public weth;

    Blessed public blessedToken;
    BlessedWETH public WBlessed;

    // Address of the ERC-20 Token
    address owner;

    // Address of the ERC-20 Token that participants will stake
    // Duration of the staking period
    // total amount of tokens staked in the contract
    // mapping to track the staked balances of individual users
    // mapping to store the rewards earned by users

    // Constructor Function
    // Staking function
    // Unstaking function
    // Reward calculation
    // Reward claiming
    // Events
    // Modifiers
    // Security measures
    // Time locks

    struct User {
        uint256 amount;
        uint256 timeStaked;
    }

    function constructor() {
        owner = msg.sender;
    }

    function stake() external payable {
        uint256 _amount = msg.value;
        // Lock up a certain amount of tokens within the staking contract.
        User memory _user;
        _user["amount"] = _amount;
        _user["timeStaked"] = block.timestamp;

        staked[msg.sender] = true;
    }
}
