# Gas Price Trap

A simple trap that blocks transactions when gas prices go crazy high. Think of it as a shield against those nasty MEV attacks and gas price spikes that can drain your wallet.

## What it does

GasGuard is a smart contract that:
- Keeps an eye on gas prices for every transaction
- Blocks transactions if gas price > 30 gwei (you can change this)
- Lets the owner update the gas limit whenever needed
- Shouts "gas too high: trap active" when things get expensive

## Quick Start (Local Testing)

```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Clone and setup
git clone <your-repo>
cd gas-price-trap
bun install

# Compile and test locally
forge build
forge test -vv
```

## Testing

```bash
# Run tests to see gas trap in action
forge test -vv
```

Tests show:
- Gas price > 30 gwei → blocked ❌
- Gas price ≤ 30 gwei → allowed ✅
- Only owner can update limits

## Configuration

The `drosera.toml` file is already set up with:
- Response contract: `0x66847043dA36DE12D536054A11F3364E386bb7bc`
- Function: `setMaxGasWei(uint256)`
- Cooldown: 15 blocks
- Sample size: 1 block

## Main Functions

- `setMaxGasWei(uint256)`: Update gas price limit (owner only)
- `protectedAction()`: Demo function that gets blocked when gas is high
- `maxGasWei`: Variable that stores the current gas price limit

## Notes

- Default gas price limit: 30 gwei (30,000,000,000 wei)
- Trap kicks in when gas price exceeds the set limit
- Perfect for protecting against MEV attacks and gas price spikes
