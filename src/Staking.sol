// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "./Blessed.sol";

contract StakingContract is Ownable {
    using SafeMath for uint256;

    IERC20 public weth;
    Blessed public blessedToken;

    uint256 public annualInterestRate = 14; // 14% annual interest rate
    uint256 public compoundingFeePercentage = 1; // 1% compounding fee

    struct Stake {
        uint256 stakedAmount;
        uint256 lastStakeTime;
        uint256 totalRewards;
        bool optedForCompounding;
    }

    mapping(address => Stake) public stakers;

    event Staked(address indexed user, uint256 amount);
    event Compounded(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    constructor(address _weth, address _blessedToken) {
        weth = IERC20(_weth);
        blessedToken = Blessed(_blessedToken);
    }

    function stakeETH(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");

        // Transfer ETH from the user to the contract
        weth.transferFrom(msg.sender, address(this), amount);

        // Mint "Blessed-WETH" tokens to the user
        blessedToken.mint(msg.sender, amount.mul(10)); // 1 ETH = 10 Blessed tokens

        // Update staker's information
        Stake storage staker = stakers[msg.sender];
        staker.stakedAmount = staker.stakedAmount.add(amount);
        staker.lastStakeTime = block.timestamp;

        emit Staked(msg.sender, amount);
    }

    function compoundRewards() external {
        Stake storage staker = stakers[msg.sender];

        require(staker.stakedAmount > 0, "No staked WETH");

        uint256 rewardsToCompound = calculateRewardsToCompound(msg.sender);

        require(rewardsToCompound > 0, "No rewards to compound");

        uint256 fee = rewardsToCompound.mul(compoundingFeePercentage).div(100);

        // Mint additional Blessed tokens for the compounding fee
        blessedToken.mint(owner(), fee);

        // Convert rewards to WETH
        uint256 wethToStake = rewardsToCompound.sub(fee).div(10); // 1 ETH = 10 Blessed tokens

        // Stake the converted WETH as principal
        staker.stakedAmount = staker.stakedAmount.add(wethToStake);

        // Update staker's total rewards and last stake time
        staker.totalRewards = staker.totalRewards.add(
            rewardsToCompound.sub(fee)
        );
        staker.lastStakeTime = block.timestamp;

        emit Compounded(msg.sender, rewardsToCompound.sub(fee));
    }

    function withdraw() external {
        Stake storage staker = stakers[msg.sender];

        require(staker.stakedAmount > 0, "No staked WETH");

        uint256 rewardsToWithdraw = staker.totalRewards;

        require(rewardsToWithdraw > 0, "No rewards to withdraw");

        // Transfer staked WETH and rewards to the user
        weth.transfer(msg.sender, staker.stakedAmount);
        blessedToken.burn(msg.sender, rewardsToWithdraw);

        // Reset staker's information
        staker.stakedAmount = 0;
        staker.totalRewards = 0;
        staker.lastStakeTime = 0;

        emit Withdrawn(msg.sender, staker.stakedAmount.add(rewardsToWithdraw));
    }

    function setAnnualInterestRate(uint256 _rate) external onlyOwner {
        annualInterestRate = _rate;
    }

    function setCompoundingFeePercentage(
        uint256 _feePercentage
    ) external onlyOwner {
        require(_feePercentage <= 100, "Fee percentage exceeds 100%");
        compoundingFeePercentage = _feePercentage;
    }

    function calculateRewardsToCompound(
        address stakerAddress
    ) internal view returns (uint256) {
        Stake storage staker = stakers[stakerAddress];
        uint256 timeSinceLastStake = block.timestamp.sub(staker.lastStakeTime);
        uint256 annualSeconds = 365 days;
        uint256 annualRate = annualInterestRate.mul(annualSeconds).div(100);
        return
            staker.stakedAmount.mul(annualRate).mul(timeSinceLastStake).div(
                annualSeconds
            );
    }
}
