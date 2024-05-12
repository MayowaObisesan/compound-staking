// // SPDX-License-Identifier: MIT
// pragma solidity 0.8.20;

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/utils/math/Math.sol";
// // import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
// import "./Blessed.sol";
// import "./BlessedWETH.sol";
// import "./interface/IWETH.sol";

// contract Staking {
//     using Math for uint256;

//     address WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
//     IWETH public weth;

//     Blessed public blessedToken;
//     BlessedWETH public Wblessed;

//     uint256 public annualInterestRate = 14; // 14% annual interest rate
//     uint256 public compoundingFeePercentage = 1; // 1% compounding fee

//     struct Stake {
//         uint256 stakedAmount;
//         uint256 lastStakeTime;
//         uint256 totalRewards;
//         bool optedForCompounding;
//     }

//     mapping(address => Stake) public stakers;

//     // EVENTS
//     event Staked(address indexed user, uint256 amount);
//     event Compounded(address indexed user, uint256 amount);
//     event Withdrawn(address indexed user, uint256 amount);

//     constructor(address _blessedToken, address _blessedWETHToken) {
//         weth = IWETH(weth);
//         blessedToken = Blessed(_blessedToken);
//         Wblessed = BlessedWETH(_blessedWETHToken);
//     }

//     function stakeETH() external {
//         uint256 ethAmount = msg.value;
//         require(ethAmount > 0, "Amount must be greater than 0");

//         weth.deposit{value: ethAmount}();
//         Wblessed.mint(msg.sender, ethAmount);

//         // Update the Struct
//         Stake memory staker = stakers[msg.sender];
//         staker.stakedAmount = staker.stakedAmount + ethAmount;
//         staker.lastStakeTime = block.timestamp;

//         emit Staked(msg.sender, ethAmount);
//     }

//     function optForCompound(bool _compound) external {}

//     // Compound earned tokens into WETH and stake again
//     function compound() external {
//         Stake storage userStake = stakes[msg.sender];
//         require(userStake.amount > 0, "No stake to compound");

//         uint256 earnedTokens = userStake.earnedTokens;
//         require(earnedTokens > 0, "No earned tokens to compound");
//         uint256 compoundingFee = (earnedTokens * COMPOUNDING_FEE_PERCENT) / 100;
//         uint256 stakableTokens = earnedTokens - compoundingFee;
//         require(stakableTokens > 0, "Compounding fee too high");

//         // Convert reward tokens to WETH and stake
//         rewardToken.safeTransferFrom(msg.sender, address(this), earnedTokens);
//         weth.deposit{value: stakableTokens / 10}(); // Convert 10 reward tokens to 1 WETH
//         _stake(msg.sender, stakableTokens / 10);

//         // Deduct compounding fee
//         rewardToken.safeTransfer(owner(), compoundingFee);

//         userStake.earnedTokens = 0;
//     }
// }
