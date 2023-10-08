# REQUIREMENTS

**1. Staking Contract and Token Creation:**

- Create a staking contract that allows users to stake Ether (ETH) only.
- When users stake ETH, it is automatically converted to Wrapped Ether (WETH) and stored in the contract.
- Additionally, a custom token named "Blessed" is created.

**2. Reward Distribution:**

- The staking contract should distribute rewards in the form of the "Blessed" token.
- The annualized interest rate (APR) for these rewards is set at 14%.
- Users earn rewards based on the proportion of their staked ETH relative to the total staked ETH.
- For example, if a user brings in 1 ETH and no compounding occurs, they should earn 14% of "Blessed" tokens, multiplied by 10, per year.

**3. Auto-Compounding Option:**

- Users have the option to opt in for auto compounding of their rewards.
- Auto-compounding means their earned "Blessed" tokens are automatically converted back to WETH using a 1:10 ratio and staked as principal.
- Users who choose to auto compound are charged a 1% fee of their WETH balance each month. This fee is deducted to reward the person who triggers the compounding operation.

**4. External Trigger for Compounding:**

- The compounding operation can be triggered by anyone externally.
- The person who triggers the compounding operation receives a reward, which comes from the total auto-compounding fees collected from users in the pool.
- In other words, those who opt for auto compounding contribute 1% of their WETH balance each month towards the reward for the person who triggers compounding.

**5. Withdrawals:**

- Users should be able to withdraw their staked WETH and earned "Blessed" tokens.
- The withdrawals can be either instant or non-instant, meaning they might have certain withdrawal restrictions or lock-up periods.

In summary, the contract's primary function is to allow users to stake ETH, earn "Blessed" tokens as rewards at an annualized rate of 14%, and provide the option to auto compound those rewards. The compounding fee is deducted from users who opt for auto compounding, and external users can trigger the compounding process and receive rewards for doing so. Withdrawals can be subject to certain conditions as specified in the contract.

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

<https://book.getfoundry.sh/>

## Usage

### Build

```shell
forge build
```

### Test

```shell
forge test
```

### Format

```shell
forge fmt
```

### Gas Snapshots

```shell
forge snapshot
```

### Anvil

```shell
anvil
```

### Deploy

```shell
forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
cast <subcommand>
```

### Help

```shell
forge --help
anvil --help
cast --help
```
