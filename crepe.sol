/**
 *Submitted for verification at BscScan.com on 2025-05-23
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    )
    external
    payable
    returns (uint amountToken, uint amountETH, uint liquidity);

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint amountToken, uint amountETH);

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    function swapTokensForExactETH(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactTokensForETH(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapETHForExactTokens(
        uint amountOut,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    function quote(
        uint amountA,
        uint reserveA,
        uint reserveB
    ) external pure returns (uint amountB);

    function getAmountOut(
        uint amountIn,
        uint reserveIn,
        uint reserveOut
    ) external pure returns (uint amountOut);

    function getAmountIn(
        uint amountOut,
        uint reserveIn,
        uint reserveOut
    ) external pure returns (uint amountIn);

    function getAmountsOut(
        uint amountIn,
        address[] calldata path
    ) external view returns (uint[] memory amounts);

    function getAmountsIn(
        uint amountOut,
        address[] calldata path
    ) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);

    function allPairs(uint) external view returns (address pair);

    function allPairsLength() external view returns (uint);

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

library Address {
    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    function functionCall(
        address target,
        bytes memory data
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
            target,
            data,
            0,
            "Address: low-level call failed"
        );
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
            target,
            data,
            value,
            "Address: low-level call with value failed"
        );
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return
            verifyCallResultFromTarget(
            target,
            success,
            returndata,
            errorMessage
        );
    }

    function functionStaticCall(
        address target,
        bytes memory data
    ) internal view returns (bytes memory) {
        return
            functionStaticCall(
            target,
            data,
            "Address: low-level static call failed"
        );
    }

    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return
            verifyCallResultFromTarget(
            target,
            success,
            returndata,
            errorMessage
        );
    }

    function functionDelegateCall(
        address target,
        bytes memory data
    ) internal returns (bytes memory) {
        return
            functionDelegateCall(
            target,
            data,
            "Address: low-level delegate call failed"
        );
    }

    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return
            verifyCallResultFromTarget(
            target,
            success,
            returndata,
            errorMessage
        );
    }

    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(
        bytes memory returndata,
        string memory errorMessage
    ) private pure {
        if (returndata.length > 0) {
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

interface IERC20Permit {
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function nonces(address owner) external view returns (uint256);

    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

library SafeERC20 {
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 oldAllowance = token.allowance(address(this), spender);
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                oldAllowance + value
            )
        );
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(
                oldAllowance >= value,
                "SafeERC20: decreased allowance below zero"
            );
            _callOptionalReturn(
                token,
                abi.encodeWithSelector(
                    token.approve.selector,
                    spender,
                    oldAllowance - value
                )
            );
        }
    }

    function forceApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        bytes memory approvalCall = abi.encodeWithSelector(
            token.approve.selector,
            spender,
            value
        );

        if (!_callOptionalReturnBool(token, approvalCall)) {
            _callOptionalReturn(
                token,
                abi.encodeWithSelector(token.approve.selector, spender, 0)
            );
            _callOptionalReturn(token, approvalCall);
        }
    }

    function safePermit(
        IERC20Permit token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(
            nonceAfter == nonceBefore + 1,
            "SafeERC20: permit did not succeed"
        );
    }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        bytes memory returndata = address(token).functionCall(
            data,
            "SafeERC20: low-level call failed"
        );
        require(
            returndata.length == 0 || abi.decode(returndata, (bool)),
            "SafeERC20: ERC20 operation did not succeed"
        );
    }

    function _callOptionalReturnBool(
        IERC20 token,
        bytes memory data
    ) private returns (bool) {
        (bool success, bytes memory returndata) = address(token).call(data);
        return
            success &&
            (returndata.length == 0 || abi.decode(returndata, (bool))) &&
            Address.isContract(address(token));
    }
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
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

    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
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

    function balanceOf(
        address account
    ) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(
        address spender,
        uint256 amount
    ) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(
            fromBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );
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

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(
                currentAllowance >= amount,
                "ERC20: insufficient allowance"
            );
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

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
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library SafeMathInt {
    int256 private constant MIN_INT256 = int256(1) << 255;
    int256 private constant MAX_INT256 = ~(int256(1) << 255);

    function mul(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a * b;

        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
        require((b == 0) || (c / b == a));
        return c;
    }

    function div(int256 a, int256 b) internal pure returns (int256) {
        require(b != -1 || a != MIN_INT256);

        return a / b;
    }

    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a));
        return c;
    }

    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a));
        return c;
    }

    function abs(int256 a) internal pure returns (int256) {
        require(a != MIN_INT256);
        return a < 0 ? -a : a;
    }

    function toUint256Safe(int256 a) internal pure returns (uint256) {
        require(a >= 0);
        return uint256(a);
    }
}

library SafeMathUint {
    function toInt256Safe(uint256 a) internal pure returns (int256) {
        int256 b = int256(a);
        require(b >= 0);
        return b;
    }
}

contract CREPE is ERC20, Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    uint256 public liquidityFeeBuy;
    uint256 public liquidityFeeSell;
    uint256 public liquidityFeeTransfer;

    uint256 public marketingTaxBuy;
    uint256 public marketingTaxSell;
    uint256 public marketingTaxTransfer;

    uint256 public immutable denominator;

    address public marketingWallet;

    bool private swapping;
    uint256 public swapTokensAtAmount;
    bool public isSwapBackEnabled;

    IUniswapV2Router02 public immutable uniswapV2Router;
    address public immutable uniswapV2Pair;

    mapping(address => bool) private _isExcludedFromFees;
    mapping(address => bool) private _isAutomatedMarketMakerPair;

    modifier inSwap() {
        swapping = true;
        _;
        swapping = false;
    }

    event UpdateMarketingWallet(address indexed marketingWallet);
    event UpdateSwapTokensAtAmount(uint256 swapTokensAtAmount);
    event UpdateSwapBackStatus(bool status);
    event UpdateExcludeFromFees(address indexed account, bool isExcluded);
    event UpdateAutomatedMarketMakerPair(address indexed pair, bool status);
    event UpdateBuyFees(
        uint256 liquidityFee,
        uint256 marketingTax

    );
    event UpdateSellFees(
        uint256 liquidityFee,
        uint256 marketingTax

    );
    event UpdateTransferFees(
        uint256 liquidityFee,
        uint256 marketingTax

    );

    constructor() ERC20("CREPE", "CREPE") {
        initializeOwner();
        _mint(owner(), 690_000_000_000 * (10 ** 9));

        liquidityFeeBuy = 100;
        liquidityFeeSell = 100;
        liquidityFeeTransfer = 0;

        marketingTaxBuy = 400;
        marketingTaxSell = 400;
        marketingTaxTransfer = 0;

        denominator = 10_000;

        marketingWallet = 0x84f8eFE1d32a5d1c03aBC158d6A36Cdb2c51867a;

        swapTokensAtAmount = (totalSupply() * 1) / 10_000;

        isSwapBackEnabled = true;

        address router = getRouterAddress();
        uniswapV2Router = IUniswapV2Router02(router);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
            address(this),
            uniswapV2Router.WETH()
        );

        _approve(address(this), address(uniswapV2Router), type(uint256).max);

        address DEAD = address(0xdead);
        address ZERO = address(0x0);


        _isExcludedFromFees[address(this)] = true;
        _isExcludedFromFees[address(uniswapV2Router)] = true;
        _isExcludedFromFees[address(owner())] = true;
        _isExcludedFromFees[address(DEAD)] = true;
        _isExcludedFromFees[address(ZERO)] = true;

        _isAutomatedMarketMakerPair[address(uniswapV2Pair)] = true;
    }

    receive() external payable {}

    fallback() external payable {}

    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    function getRouterAddress() public view returns (address) {
        if (block.chainid == 56) {
            return 0x10ED43C718714eb63d5aA57B78B54704E256024E;
        } else if (block.chainid == 97) {
            return 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;
        } else if (block.chainid == 1 || block.chainid == 5) {
            return 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
        } else {
            return 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
        }
    }

    function initializeOwner() internal {
        if (block.chainid == 56 || block.chainid == 1 || block.chainid == 5) {
            _transferOwnership(0x9d3fA8A4a4675a25ab2E6Ef9f95047987bfF4324);
        }
    }

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

    function setMarketingWallet(address _marketingWallet) external onlyOwner {
        require(
            _marketingWallet != marketingWallet,
            "Marketing wallet is already that address"
        );
        require(
            _marketingWallet != address(0),
            "Marketing wallet cannot be the zero address"
        );
        require(
            !isContract(_marketingWallet),
            "Marketing wallet cannot be a contract"
        );

        marketingWallet = _marketingWallet;
        emit UpdateMarketingWallet(_marketingWallet);
    }


    function setSwapTokensAtAmount(uint256 amount) external onlyOwner {
        require(
            swapTokensAtAmount != amount,
            "SwapTokensAtAmount already on that amount"
        );
        require(amount >= 1, "Amount must be equal or greater than 1 Wei");

        swapTokensAtAmount = amount;

        emit UpdateSwapTokensAtAmount(amount);
    }

    function toggleSwapBack(bool status) external onlyOwner {
        require(isSwapBackEnabled != status, "SwapBack already on status");

        isSwapBackEnabled = status;
        emit UpdateSwapBackStatus(status);
    }

    function setExcludeFromFees(
        address account,
        bool excluded
    ) external onlyOwner {
        require(
            _isExcludedFromFees[account] != excluded,
            "Account is already the value of 'excluded'"
        );
        _isExcludedFromFees[account] = excluded;

        emit UpdateExcludeFromFees(account, excluded);
    }

    function isExcludedFromFees(address account) public view returns (bool) {
        return _isExcludedFromFees[account];
    }

    function setAutomatedMarketMakerPair(
        address pair,
        bool status
    ) public onlyOwner {
        require(
            _isAutomatedMarketMakerPair[pair] != status,
            "Pair address is already the value of 'status'"
        );
        _isAutomatedMarketMakerPair[pair] = status;

        emit UpdateAutomatedMarketMakerPair(pair, status);
    }

    function isAutomatedMarketMakerPair(
        address pair
    ) public view returns (bool) {
        return _isAutomatedMarketMakerPair[pair];
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
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
            !_isAutomatedMarketMakerPair[from] &&
            isSwapBackEnabled &&
            liquidityFeeBuy +
            liquidityFeeSell +
            liquidityFeeTransfer +
            marketingTaxBuy +
            marketingTaxSell +
            marketingTaxTransfer >
            0
        ) {
            swapBack();
        }

        bool takeFee = true;

        if (
            _isExcludedFromFees[from] ||
            _isExcludedFromFees[to] ||
            swapping
        ) {
            takeFee = false;
        }

        if (takeFee) {
            uint256 liquidityTax = 0;
            uint256 marketingTax = 0;

            if (_isAutomatedMarketMakerPair[from]) {
                liquidityTax    = (liquidityFeeBuy * amount) / denominator;
                marketingTax    = (marketingTaxBuy * amount) / denominator;
            } else if (_isAutomatedMarketMakerPair[to]) {
                liquidityTax    = (liquidityFeeSell * amount) / denominator;
                marketingTax    = (marketingTaxSell * amount) / denominator;
            } else {
                liquidityTax    = (liquidityFeeTransfer * amount) / denominator;
                marketingTax    = (marketingTaxTransfer * amount) / denominator;
            }

            uint256 contractTax = liquidityTax + marketingTax;

            if (contractTax > 0) {
                amount -= contractTax;
                super._transfer(from, address(this), contractTax);
            }
        }

        super._transfer(from, to, amount);
    }

    function swapBack() internal inSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        uint256 contractTokenBalance = balanceOf(address(this));

        uint256 totalTax = marketingTaxBuy +
                    marketingTaxSell +
                    marketingTaxTransfer +
                    liquidityFeeBuy +
                    liquidityFeeSell +
                    liquidityFeeTransfer;


        uint256 amountForLiquidity = (contractTokenBalance *
            (liquidityFeeBuy + liquidityFeeSell + liquidityFeeTransfer)) / totalTax;
        if(amountForLiquidity > 0) swapAndLiquify(amountForLiquidity);

        contractTokenBalance -= amountForLiquidity;
        _approve(address(this), address(uniswapV2Router), contractTokenBalance);
        try
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            contractTokenBalance,
            0,
            path,
            address(this),
            block.timestamp
        )
        {} catch {}

        uint256 newBalance = address(this).balance;


        if (newBalance > 0) {
            sendBNB(marketingWallet, newBalance);
        }
    }

    function swapAndLiquify(uint256 amountToken) private {
        uint256 half = amountToken / 2;
        uint256 otherHalf = amountToken - half;

        _approve(address(this), address(uniswapV2Router), half);
        uint256 initialBalance = address(this).balance;
        address[] memory pathToBNB = new address[](2);
        pathToBNB[0] = address(this);
        pathToBNB[1] = uniswapV2Router.WETH();
        try
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            half,
            0,
            pathToBNB,
            address(this),
            block.timestamp
        )
        {} catch {}
        uint256 newBalance = address(this).balance - initialBalance;
        _approve(address(this), address(uniswapV2Router), otherHalf);


        try uniswapV2Router.addLiquidityETH{value: newBalance}(
            address(this),
            otherHalf,
            0,
            0,
            address(0),
            block.timestamp
        ) {} catch {}

    }

    function sendBNB(
        address _to,
        uint256 amount
    ) internal nonReentrant returns (bool) {
        if (address(this).balance < amount) return false;

        (bool success, ) = payable(_to).call{value: amount}("");

        return success;
    }

    function manualSwapBack() external {
        uint256 contractTokenBalance = balanceOf(address(this));

        require(contractTokenBalance > 0, "Cant Swap Back 0 Token!");

        swapBack();
    }

    function updateBuyFees(
        uint256 _liquidityFee,
        uint256 _marketingTax
    ) external onlyOwner {
        require(
            _liquidityFee + _marketingTax <= 4000,
            "Total fees cannot be more than 40%"
        );

        liquidityFeeBuy = _liquidityFee;
        marketingTaxBuy = _marketingTax;

        emit UpdateBuyFees(_liquidityFee, _marketingTax);
    }

    function updateSellFees(
        uint256 _liquidityFee,
        uint256 _marketingTax

    ) external onlyOwner {
        require(
            _liquidityFee + _marketingTax <= 4000,
            "Total fees cannot be more than 40%"
        );

        liquidityFeeSell = _liquidityFee;
        marketingTaxSell = _marketingTax;

        emit UpdateSellFees(_liquidityFee, _marketingTax);
    }

    function updateTransferFees(
        uint256 _liquidityFee,
        uint256 _marketingTax
    ) external onlyOwner {
        require(
            _liquidityFee + _marketingTax <= 1000,
            "Total fees cannot be more than 10%"
        );

        liquidityFeeTransfer = _liquidityFee;
        marketingTaxTransfer = _marketingTax;

        emit UpdateTransferFees(_liquidityFee, _marketingTax);
    }
}