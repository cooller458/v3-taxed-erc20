# 🥞 CREPE V3 - Advanced Tax Token for Uniswap V3

## Overview

**CREPE V3** is a sophisticated ERC20 token contract designed specifically for Uniswap V3 ecosystem with an advanced tax mechanism. The contract implements automated liquidity generation, marketing fund collection, and multi-tier pool support while maintaining compatibility across multiple chains.

## 🚀 Key Features

### Advanced Tax System
- **Buy Tax**: 5% (1% Liquidity + 4% Marketing)
- **Sell Tax**: 5% (1% Liquidity + 4% Marketing) 
- **Transfer Tax**: 0% (wallet-to-wallet transfers)
- **Dynamic Tax Configuration**: Owner can adjust rates up to maximum limits

### Uniswap V3 Integration
- **Multi-Tier Pool Support**: 0.01%, 0.05%, 0.3%, 1% fee tiers
- **Dynamic Pool Detection**: Automatic detection of V3 pools
- **Position Manager Integration**: Liquidity provision through official V3 contracts
- **Cross-Chain Compatibility**: Ethereum, BSC, Goerli, BSC Testnet

### SwapBack Mechanism
- **Automatic Conversion**: Tax tokens → ETH at configurable thresholds
- **Manual Trigger**: Owner can manually execute swapback
- **Liquidity Addition**: Automatic LP creation with collected taxes
- **Marketing Distribution**: Direct ETH transfer to marketing wallet

### Security Features
- **Access Control**: Owner-only administrative functions
- **Fee Exclusion System**: Configurable tax exemptions
- **Reentrancy Protection**: Safe external calls
- **Emergency Functions**: Token rescue capabilities

## 📊 Token Specifications

| Parameter | Value |
|-----------|-------|
| **Name** | CREPE V3 |
| **Symbol** | CREPE |
| **Decimals** | 9 |
| **Total Supply** | 690,000,000,000 CREPE |
| **Max Buy/Sell Tax** | 40% |
| **Max Transfer Tax** | 10% |
| **Initial Tax Rates** | 5% (Buy/Sell), 0% (Transfer) |

## 🛠️ Installation & Setup

### Prerequisites
```bash
node >= 16.0.0
npm >= 8.0.0
```

### Install Dependencies
```bash
npm install
```

### Compile Contracts
```bash
npx hardhat compile
```

### Run Tests
```bash
# Run all tests
npx hardhat test

# Run specific test files
npx hardhat test test/CREPE_V3.test.js
npx hardhat test test/Coverage.test.js
npx hardhat test test/Triggers.test.js
```

## 🚀 Deployment

### Environment Setup
Create `.env` file:
```env
PRIVATE_KEY=your_private_key_here
ETHERSCAN_API_KEY=your_etherscan_api_key
BSC_API_KEY=your_bscscan_api_key
```

### Deploy to Networks

#### Ethereum Mainnet
```bash
npx hardhat ignition deploy ignition/modules/CREPE_V3.js --network mainnet
```

#### BSC Mainnet
```bash
npx hardhat ignition deploy ignition/modules/CREPE_V3.js --network bsc
```

#### Goerli Testnet
```bash
npx hardhat ignition deploy ignition/modules/CREPE_V3.js --network goerli
```

### Verify Contract
```bash
npx hardhat verify --network mainnet DEPLOYED_CONTRACT_ADDRESS
```

## 🔧 Contract Interaction

### Administrative Functions

#### Update Tax Rates
```solidity
// Update buy taxes (max 40%)
updateBuyFees(uint256 _liquidityFee, uint256 _marketingTax)

// Update sell taxes (max 40%)
updateSellFees(uint256 _liquidityFee, uint256 _marketingTax)

// Update transfer taxes (max 10%)
updateTransferFees(uint256 _liquidityFee, uint256 _marketingTax)
```

#### Pool Management
```solidity
// Add/remove V3 pool
setV3Pool(address pool, uint24 fee, bool status)

// Create new V3 pool
createV3Pool(uint24 fee, uint160 sqrtPriceX96)

// Check pool status
isV3Pool(address pool, uint24 fee) returns (bool)
isAnyV3Pool(address account) returns (bool)
```

#### SwapBack Configuration
```solidity
// Set swap threshold
setSwapTokensAtAmount(uint256 amount)

// Toggle swapback
toggleSwapBack(bool status)

// Manual swapback
manualSwapBack()
```

#### Fee Exclusion Management
```solidity
// Set fee exclusion
setExcludeFromFees(address account, bool excluded)

// Check exclusion status
isExcludedFromFees(address account) returns (bool)
```

### View Functions

#### Tax Information
```solidity
liquidityFeeBuy() returns (uint256)      // Current buy liquidity tax
marketingTaxBuy() returns (uint256)      // Current buy marketing tax
liquidityFeeSell() returns (uint256)     // Current sell liquidity tax
marketingTaxSell() returns (uint256)     // Current sell marketing tax
```

#### Configuration
```solidity
swapTokensAtAmount() returns (uint256)   // Current swap threshold
isSwapBackEnabled() returns (bool)       // SwapBack status
marketingWallet() returns (address)      // Marketing wallet address
```

## 🏗️ Architecture

### Contract Structure
```
CREPE_V3
├── ERC20 (Base token functionality)
├── Ownable (Access control)
├── ReentrancyGuard (Security)
├── Tax System
│   ├── Buy/Sell/Transfer tax calculation
│   ├── Fee exclusion management
│   └── Dynamic rate configuration
├── V3 Integration
│   ├── Multi-tier pool support
│   ├── Pool detection system
│   └── Position manager integration
├── SwapBack System
│   ├── Automatic threshold triggers
│   ├── Manual execution
│   └── Liquidity provision
└── Emergency Functions
    ├── Token rescue
    └── ETH rescue
```

### Tax Flow Diagram
```
User Transaction
       ↓
Pool Detection → Is V3 Pool? → Apply Buy/Sell Tax
       ↓                           ↓
Regular Transfer → Apply Transfer Tax
       ↓                           ↓
Tax Collection → Contract Balance
       ↓
Threshold Check → SwapBack Trigger
       ↓
Token → ETH Conversion
       ↓
Liquidity + Marketing Distribution
```

## 🧪 Testing

### Test Coverage
- **Total Tests**: 126
- **Success Rate**: 98.4%
- **Coverage Areas**: 
  - Core functionality
  - Edge cases
  - Security scenarios
  - Trigger mechanisms
  - Integration tests

### Test Categories

#### Core Functionality Tests
```bash
npx hardhat test test/CREPE_V3.test.js
```
- Token deployment and configuration
- Tax mechanism validation
- Pool detection system
- Administrative functions

#### Edge Case Coverage Tests
```bash
npx hardhat test test/Coverage.test.js
```
- Boundary value testing
- Error condition handling
- Security validations
- State consistency checks

#### Trigger Mechanism Tests
```bash
npx hardhat test test/Triggers.test.js
```
- SwapBack threshold triggers
- Pool detection triggers
- Fee exclusion dynamics
- Complex multi-trigger scenarios

## 🔒 Security Features

### Access Control
- **Owner-only functions**: Tax updates, pool management, wallet changes
- **Fee exclusion system**: Configurable tax exemptions
- **Maximum limits**: 40% max buy/sell tax, 10% max transfer tax

### Protection Mechanisms
- **Reentrancy guards**: Safe external contract interactions
- **Input validation**: Parameter bounds checking
- **Emergency functions**: Token and ETH rescue capabilities

### Audit Considerations
- Comprehensive test suite with 98.4% success rate
- Edge case coverage for all critical functions
- Security-focused design patterns
- Transparent tax mechanism

## 🌐 Multi-Chain Support

### Supported Networks
| Network | Chain ID | DEX | Router Address |
|---------|----------|-----|----------------|
| Ethereum | 1 | Uniswap V3 | `0xE592427A0AEce92De3Edee1F18E0157C05861564` |
| BSC | 56 | PancakeSwap V3 | `0x13f4EA83D0bd40E75C8222255bc855a974568Dd4` |
| Goerli | 5 | Uniswap V3 | `0xE592427A0AEce92De3Edee1F18E0157C05861564` |
| BSC Testnet | 97 | PancakeSwap V3 | `0x9a489505a00cE272eAa5e07Dba6491314CaE3796` |

### Cross-Chain Features
- Automatic router detection based on chain ID
- Network-specific factory and position manager addresses
- Consistent tax behavior across all supported chains

## 📈 Gas Optimization

### Efficient Design Patterns
- Packed storage variables
- Minimal external calls
- Optimized tax calculations
- Efficient pool detection

### Gas Usage Estimates
- **Transfer (no tax)**: ~65,000 gas
- **Transfer (with tax)**: ~85,000 gas
- **SwapBack execution**: ~200,000 gas
- **Pool management**: ~50,000 gas

## 🔍 Events

### Tax Events
```solidity
event UpdateBuyFees(uint256 liquidityFee, uint256 marketingTax);
event UpdateSellFees(uint256 liquidityFee, uint256 marketingTax);
event UpdateTransferFees(uint256 liquidityFee, uint256 marketingTax);
```

### Configuration Events
```solidity
event UpdateMarketingWallet(address indexed marketingWallet);
event UpdateSwapTokensAtAmount(uint256 swapTokensAtAmount);
event UpdateSwapBackStatus(bool status);
event UpdateExcludeFromFees(address indexed account, bool isExcluded);
event UpdateV3Pool(address indexed pool, uint24 fee, bool status);
```

## 🚨 Important Notes

### Tax Behavior
- **V3 Pool Transactions**: Subject to buy/sell tax (5% default)
- **Wallet Transfers**: No tax by default (0%)
- **Excluded Addresses**: Owner, contract, routers automatically excluded
- **SwapBack Trigger**: Automatic when threshold reached during transactions

### Deployment Checklist
- [ ] Set appropriate marketing wallet
- [ ] Configure swap threshold
- [ ] Add V3 pools for target fee tiers
- [ ] Verify tax rates
- [ ] Test on testnet first
- [ ] Verify contract on block explorer

## 🤝 Contributing

### Development Setup
1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Install dependencies: `npm install`
4. Make changes and test: `npx hardhat test`
5. Commit changes: `git commit -m 'Add amazing feature'`
6. Push to branch: `git push origin feature/amazing-feature`
7. Open pull request

### Code Standards
- Follow Solidity style guide
- Add comprehensive tests for new features
- Maintain existing test coverage
- Document public functions

## 📞 Contact & Support

### Development Team
- **Telegram**: [@l0xmr](https://t.me/l0xmr)

### Resources
- **Documentation**: See [TEST.md](./TEST.md) for detailed test scenarios
- **Contract Source**: [contracts/crepe_v3.sol](./contracts/crepe_v3.sol)
- **Test Files**: [test/](./test/) directory

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## ⚠️ Disclaimer

This contract is provided as-is for educational and development purposes. While extensively tested, users should:

- Conduct their own security audits
- Test thoroughly on testnets before mainnet deployment
- Understand the tax implications and mechanics
- Be aware of the regulatory requirements in their jurisdiction

**Use at your own risk. The developers are not responsible for any financial losses.**

---

*Built with ❤️ for the DeFi community*
