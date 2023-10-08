// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BlessedWETH is ERC20 {
    constructor() ERC20("Blessed-WETH", "WBLSD") {
        _mint(msg.sender, 1000000 * 10 ** 18); // Mint 1,000,000 Wrapped Blessed tokens to the contract deployer
    }

    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) external {
        _burn(account, amount);
    }
}
