/**
 *Submitted for verification at BscScan.com on 2022-03-16
*/

/**
 *Submitted for verification at BscScan.com on 2022-03-14
*/

//YEZFIRE: Anti-snipe - No sell within 1 hour of purchase

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
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
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }
    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");
        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly
                // solhint-disable-next-line no-inline-assembly
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

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);
    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}
interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);
    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);
    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);
    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);
    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;
    function initialize(address, address) external;
}

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
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
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
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
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
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
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
        bool approveMax, uint8 v, bytes32 r, bytes32 s
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

interface IWETH {
    function deposit() external payable;
    function balanceOf(address _owner) external returns (uint256);
    function transfer(address _to, uint256 _value) external returns (bool);
    function withdraw(uint256 _amount) external;
}


contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }
    function owner() public view returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    function renounceOwnership() external virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
        //The following line avoids exploiting previous lock/unlock to regain ownership
        _previousOwner = address(0);
    }
    function transferOwnership(address newOwner) external virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
    function geUnlockTime() external view returns (uint256) {
        return _lockTime;
    }
    //Locks the contract for owner for the amount of time provided
    function lock(uint256 time) external virtual onlyOwner {
        _previousOwner = _owner;
        _owner = address(0);
        _lockTime = block.timestamp + time;
        emit OwnershipTransferred(_owner, address(0));
    }
    //Unlocks the contract for owner when _lockTime is exceeds
    function unlock() external virtual {
        require(_previousOwner == msg.sender, "You don't have permission to unlock");
        require(block.timestamp > _lockTime , "Contract is locked until 7 days");
        emit OwnershipTransferred(_owner, _previousOwner);
        _owner = _previousOwner;
        _previousOwner = address(0);
    }
}

contract YEZ is Context, IERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _rOwned;
    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) private _isExcludedFromReward;
    address[] private _excludedAddressesFromReward;
   
    string constant private _name = "YezFire";
    string constant private _symbol = "YEZ";
    uint256 constant private _decimals = 9;

    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal = 350000000000 * 10**9;
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;
    uint256 private _tBurnTotal;
    address public _marketingWalletAddress = 0x933E22ACDa60473FEE32F9D29e4E17Eb23d54DBC;

    bool public CooldownEnabled = true;
    uint256 public cooldownTimerInterval = 3600;

    mapping (address => uint) private SELLcooldownTimer;
    mapping (address => bool) public isTimelockExempt;
  

    uint256 public _taxFee;
    uint256 private _previousTaxFee = _taxFee;
    uint256 public _liquidityFee;
    uint256 private _previousLiquidityFee = _liquidityFee;
    uint256 public _burnFee;
    uint256 private _previousBurnFee = _burnFee;
    uint256 public _marketingFee;
    uint256 private _previousMarketingFee = _marketingFee;
    uint256 private totalFee = _taxFee.add(_liquidityFee).add(_marketingFee).add(_burnFee);


    
    uint256 public BUYTaxFee = 25;
    uint256 public BUYLiquidityFee = 25;
    uint256 public BUYMarketingFee = 25;
    uint256 public BUYBurnFee = 25;
    uint256 public BUYtotalFees = BUYTaxFee.add(BUYLiquidityFee).add(BUYMarketingFee).add(BUYBurnFee);

    uint256 public SELLTaxFee = 50;
    uint256 public SELLLiquidityFee = 50;
    uint256 public SELLMarketingFee = 50;
    uint256 public SELLBurnFee = 50;
    uint256 public SELLtotalFees = SELLTaxFee.add(SELLLiquidityFee).add(SELLMarketingFee).add(SELLBurnFee);

    IUniswapV2Router02 public immutable uniswapV2RouterObject;
    address public immutable uniswapV2wETHAddr;
    address public immutable uniswapV2PairAddr;
    address public immutable uniswapV2RouterAddr;
    address constant private _blackholeZero = address(0);
    address constant private _blackholeDead = 0x000000000000000000000000000000000000dEaD;
    
    bool inSwapAndLiquify;
    bool public swapAndLiquifyEnabled = true;
    bool public startPresale;
    
    uint256 public _maxTxAmount = _tTotal.mul(5).div(100000);
    uint256 public numTokensSellToAddToLiquidity = 100000000 * 10**9;
    
    event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );
    
    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }
    
    constructor() {
        _rOwned[owner()] = _rTotal;
       // address _uniswapV2RouterAddr=0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3; //BNB test net
        address _uniswapV2RouterAddr=0x10ED43C718714eb63d5aA57B78B54704E256024E; //BNB


        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_uniswapV2RouterAddr);
        uniswapV2RouterAddr = _uniswapV2RouterAddr;
		uniswapV2wETHAddr = _uniswapV2Router.WETH();
         // Create a uniswap pair for this new token
        uniswapV2PairAddr = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());
        // set the rest of the contract variables
        uniswapV2RouterObject = _uniswapV2Router;
        
        //exclude owner and this contract from fee
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_marketingWalletAddress] = true;
        //_isExcludedFromFee[uniswapV2PairAddr] = true;

        isTimelockExempt[_blackholeDead] = true;
        isTimelockExempt[address(this)] = true;
        isTimelockExempt[_marketingWalletAddress] = true;

        emit Transfer(_blackholeZero, owner(), _tTotal);
}


    function name() external pure returns (string memory) {
        return _name;
    }

    function symbol() external pure returns (string memory) {
        return _symbol;
    }

    function decimals() external pure returns (uint8) {
        return uint8(_decimals);
    }

    function totalSupply() external view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcludedFromReward[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) external view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        _transfer(sender, recipient, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function isExcludedFromReward(address account) external view returns (bool) {
        return _isExcludedFromReward[account];
    }

    function deliver(uint256 tAmount) external {
        address sender = _msgSender();
        require(!_isExcludedFromReward[sender], "Excluded addresses cannot call this function");
        (uint256 rAmount,,,,,,) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rTotal = _rTotal.sub(rAmount);
        _tFeeTotal = _tFeeTotal.add(tAmount);
    }

    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns(uint256) {
        require(tAmount <= _tTotal, "Amount must be less than supply");
        if (!deductTransferFee) {
            (uint256 rAmount,,,,,,) = _getValues(tAmount);
            return rAmount;
        } else {
            (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
            return rTransferAmount;
        }
    }

    function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
        require(rAmount <= _rTotal, "Amount must be less than total reflections");
        uint256 currentRate =  _getRate();
        return rAmount.div(currentRate);
    }

    function excludeFromReward(address account) external onlyOwner() {
      
        require(!_isExcludedFromReward[account], "Account is already excluded");
        if(_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcludedFromReward[account] = true;
        _excludedAddressesFromReward.push(account);
    }

    function includeInReward(address account) external onlyOwner() {
        require(_isExcludedFromReward[account], "Account is already excluded");
        for (uint256 i = 0; i < _excludedAddressesFromReward.length; i++) {
            if (_excludedAddressesFromReward[i] == account) {
                _excludedAddressesFromReward[i] = _excludedAddressesFromReward[_excludedAddressesFromReward.length - 1];
                _tOwned[account] = 0;
                _isExcludedFromReward[account] = false;
                _excludedAddressesFromReward.pop();
                break;
            }
        }
    }
   
    //Allow excluding from fee certain contracts, usually lock or payment contracts, but not the router or the pool.
    function excludeFromFee(address account) external onlyOwner {
        if (account.isContract() && account != uniswapV2PairAddr && account != uniswapV2RouterAddr)
        _isExcludedFromFee[account] = true;
    }
    // Do not include back this contract. Owner can renounce being feeless.
    function includeInFee(address account) external onlyOwner {
        if (account != address(this))
        _isExcludedFromFee[account] = false;
    }
    
    function changeBuyFee(uint256 buyTaxFee, uint256 BuyLiquidityFee, uint256 buyMarketingFee, uint256 buyBurnFee) external onlyOwner
    {
        BUYTaxFee = buyTaxFee;
        BUYLiquidityFee = BuyLiquidityFee;
        BUYMarketingFee = buyMarketingFee;
        BUYBurnFee = buyBurnFee;
        BUYtotalFees = BUYTaxFee.add(BUYMarketingFee).add(BUYMarketingFee).add(BUYBurnFee);
    }

    function changeSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellMarketingFee, uint256 sellBurnFee) external onlyOwner
    {
        SELLTaxFee = sellTaxFee;
        SELLLiquidityFee = sellLiquidityFee;
        SELLMarketingFee = sellMarketingFee;
        SELLBurnFee = sellBurnFee;
        SELLtotalFees = SELLTaxFee.add(SELLMarketingFee).add(SELLMarketingFee).add(SELLBurnFee);
    }
   
    function setMaxTxPercent(uint256 maxTxPercent, uint256 divisor) external onlyOwner() {
        _maxTxAmount = _tTotal.mul(maxTxPercent).div(
            10**(divisor)
        );
    }

    function setMarkeitngWallet(address wallet) external onlyOwner()
    {
        _marketingWalletAddress = wallet;
    }

    function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner() {
        swapAndLiquifyEnabled = _enabled;
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }
    
    
    receive() external payable {}

    function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
        _rTotal = _rTotal.sub(rFee).sub(rBurn);
        _tFeeTotal = _tFeeTotal.add(tFee);
        _tBurnTotal = _tBurnTotal.add(tBurn);
        _tTotal = _tTotal.sub(tBurn);
    }

    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
        (uint256 tTransferAmount, uint256 tFee, uint256 tBurn,uint256 tLiquidity) = _getTValues(tAmount);
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, tLiquidity, _getRate());
        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn, tLiquidity);
    }

    function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
        uint256 tFee = calculateTaxFee(tAmount);
        uint256 tBurn = calculateBurnFee(tAmount);
        uint256 tLiquidity = calculateLiquidityFee(tAmount);
        uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn).sub(tLiquidity);
        return (tTransferAmount, tFee, tBurn, tLiquidity);
    }

    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 rBurn = tBurn.mul(currentRate);
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        uint256 totalTax = rFee.add(rBurn).add(rLiquidity);
        uint256 rTransferAmount = rAmount.sub(totalTax);
        return (rAmount, rTransferAmount, rFee);
    }

    function _getRate() private view returns(uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns(uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;      
        for (uint256 i = 0; i < _excludedAddressesFromReward.length; i++) {
            if (_rOwned[_excludedAddressesFromReward[i]] > rSupply || _tOwned[_excludedAddressesFromReward[i]] > tSupply) return (_rTotal, _tTotal);
            rSupply = rSupply.sub(_rOwned[_excludedAddressesFromReward[i]]);
            tSupply = tSupply.sub(_tOwned[_excludedAddressesFromReward[i]]);
        }
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }
    
    
    
    function calculateTaxFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_taxFee).div(
            10**3
        );
    }

    function calculateBurnFee(uint256 _amount) private view returns (uint256) {
    
     return _amount.mul(_burnFee).div(10**3);
    }

    function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_marketingFee).div(
            10**3
        );
    }

     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_liquidityFee).div(
            10**3
        );
    }

    function _takeLiquidity(uint256 tLiquidity) private {
        uint256 currentRate =  _getRate();
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
        if(_isExcludedFromReward[address(this)])
            _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
    }
    
    function _takeMarketing(address sender, uint256 tMarketing) private returns(uint256){
      uint256 rMarketing = calculateMarketingFee(tMarketing);
      _rOwned[_marketingWalletAddress] = _rOwned[_marketingWalletAddress].add(rMarketing);
      _rOwned[sender] = _rOwned[sender].sub(rMarketing);
      emit Transfer(sender, _marketingWalletAddress, rMarketing);
      return rMarketing;
    }
     
    function removeAllFee() private {
        if(_taxFee == 0 && _marketingFee== 0 && _burnFee == 0 && _liquidityFee == 0) return;
        
        _previousTaxFee = _taxFee;
        _previousBurnFee = _burnFee;
        _previousMarketingFee = _marketingFee;
        _previousLiquidityFee = _liquidityFee;
        
        _taxFee = 0;
        _burnFee = 0;
        _marketingFee= 0;
        _liquidityFee = 0;
    }
    
    function restoreAllFee() private {
        _taxFee = _previousTaxFee;
        _burnFee = _previousBurnFee;
        _marketingFee= _previousMarketingFee;
        _liquidityFee = _previousLiquidityFee;
    }

    

    function isExcludedFromFee(address account) public view returns(bool) {
        return _isExcludedFromFee[account];
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }


    function cooldownEnabled(bool _status, uint8 _interval) public onlyOwner {
        CooldownEnabled = _status;
        cooldownTimerInterval = _interval;
    }


    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        if(from != owner() && to != owner())
            require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
        //indicates if fee should be deducted from transfer
        uint8 takeFee = 1;

        if(startPresale){takeFee = 0;}
 
        //if any account belongs to _isExcludedFromFee account then remove the fee
        if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
            takeFee = 0;
        }
        if(takeFee == 1){
        if(from == uniswapV2PairAddr)
        {
            _taxFee = BUYTaxFee;
            _liquidityFee = BUYLiquidityFee;
            _marketingFee = BUYMarketingFee;
            _burnFee = BUYBurnFee;
            totalFee = BUYtotalFees;
            SELLcooldownTimer[to] = block.timestamp;        
        }

        else if(to == uniswapV2PairAddr)
        {
            if(CooldownEnabled &&
            !isTimelockExempt[from])
            {require(block.timestamp - SELLcooldownTimer[from] > cooldownTimerInterval, "YEZ: You can not sell within 1 hour of your last purchase!!");}
            
            _taxFee = SELLTaxFee;
            _liquidityFee = SELLLiquidityFee;
            _marketingFee = SELLMarketingFee;
            _burnFee = SELLBurnFee;
            totalFee = SELLtotalFees;
            }
        

        }
        if(takeFee == 1)
        {
        uint256 marketingAmount = _takeMarketing(from, amount);
        amount = amount - marketingAmount;}

        // is the token balance of this contract address over the min number of
        // tokens that we need to initiate a swap + liquidity lock?
        // also, don't get caught in a circular liquidity event.
        // also, don't swap & liquify if sender is uniswap pair.
        uint256 contractTokenBalance = balanceOf(address(this));
     
        if(contractTokenBalance >= _maxTxAmount)
        {
            contractTokenBalance = _maxTxAmount;
        }
        
        bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
        if (
            overMinTokenBalance &&
            !inSwapAndLiquify &&
            from != uniswapV2PairAddr &&
            swapAndLiquifyEnabled &&
			takeFee == 1 //avoid costly liquify on p2p sends
        ) {
            //add liquidity
            swapAndLiquify(contractTokenBalance);
        }
       
        //transfer amount, it will take tax, burn, liquidity fee
        _tokenTransfer(from,to,amount,takeFee);
    }

    
	
    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
        // split the contract balance into halves
        uint256 half = contractTokenBalance.div(2);
        uint256 otherHalf = contractTokenBalance.sub(half);

        // capture the contract's current ETH balance.
        // this is so that we can capture exactly the amount of ETH that the
        // swap creates, and not make the liquidity event include any ETH that
        // has been manually sent to the contract
        uint256 initialETHBalance = address(this).balance;

        // swap tokens for ETH
        swapTokensForEth(half); // <- this breaks the ETH -> token swap when swap+liquify is triggered

        // how much ETH did we just swap into?
        uint256 ETHBalanceFromSwap = address(this).balance.sub(initialETHBalance);

        // add liquidity to uniswap
        addLiquidity(otherHalf, ETHBalanceFromSwap);
        emit SwapAndLiquify(half, ETHBalanceFromSwap, otherHalf);
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2wETHAddr;

        _approve(address(this), uniswapV2RouterAddr, tokenAmount);

        // make the swap
        uniswapV2RouterObject.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), uniswapV2RouterAddr, tokenAmount);
        //_approve(uniswapV2RouterObject.WETH(), uniswapV2RouterAddr, ethAmount);

        // add the liquidity
        uniswapV2RouterObject.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            _blackholeDead,
            block.timestamp
        );
    }

    //this method is responsible for taking all fee, if takeFee is true
    function _tokenTransfer(address sender, address recipient, uint256 amount,uint8 feePlan) private {
        if(feePlan == 0) //no fees
            removeAllFee();
        
        if (_isExcludedFromReward[sender] && !_isExcludedFromReward[recipient]) {
            _transferFromExcluded(sender, recipient, amount);
        } else if (!_isExcludedFromReward[sender] && _isExcludedFromReward[recipient]) {
            _transferToExcluded(sender, recipient, amount);
        } else if (!_isExcludedFromReward[sender] && !_isExcludedFromReward[recipient]) {
            _transferStandard(sender, recipient, amount);
        } else if (_isExcludedFromReward[sender] && _isExcludedFromReward[recipient]) {
            _transferBothExcluded(sender, recipient, amount);
        } else {
            _transferStandard(sender, recipient, amount);
        }
        
        if(feePlan != 1) //restore standard fees
            restoreAllFee();
    }

    function _transferStandard(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
        uint256 currentRate =  _getRate();
        uint256 rBurn =  tBurn.mul(currentRate);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _reflectFee(rFee, rBurn, tFee, tBurn);
        emit Transfer(sender, recipient, tTransferAmount);
        if (tBurn > 0) emit Transfer(sender, _blackholeZero, tBurn); 
       
    }

    function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
        uint256 currentRate =  _getRate();
        uint256 rBurn =  tBurn.mul(currentRate);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
        _takeLiquidity(tLiquidity);       
        _reflectFee(rFee, rBurn, tFee, tBurn);
        emit Transfer(sender, recipient, tTransferAmount);
        if (tBurn > 0) emit Transfer(sender, _blackholeZero, tBurn); 
     
    }

    function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
        uint256 currentRate =  _getRate();
        uint256 rBurn =  tBurn.mul(currentRate);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _reflectFee(rFee, rBurn, tFee, tBurn);
        _takeLiquidity(tLiquidity);
        emit Transfer(sender, recipient, tTransferAmount);
        if (tBurn > 0) emit Transfer(sender, _blackholeZero, tBurn); 

    }

    function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
        uint256 currentRate =  _getRate();
        uint256 rBurn =  tBurn.mul(currentRate);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
        _takeLiquidity(tLiquidity);
        _reflectFee(rFee, rBurn, tFee, tBurn);
        emit Transfer(sender, recipient, tTransferAmount);
        if (tBurn > 0) emit Transfer(sender, _blackholeZero, tBurn); 
    }

    function prepareForPresale() external onlyOwner
    {
        startPresale = true;
        _maxTxAmount = _tTotal;
    }

    function EndPresale() external onlyOwner
    {
        startPresale = false;
        _maxTxAmount = _tTotal.mul(5).div(100000);
    }

      
    function withdrawStuckBNB() external onlyOwner{
        require (address(this).balance > 0, "Can't withdraw negative or zero");
        payable(owner()).transfer(address(this).balance);
    }

    function removeStuckToken(address _address) external onlyOwner {
        require(_address != address(this), "Can't withdraw tokens destined for liquidity");
        require(IERC20(_address).balanceOf(address(this)) > 0, "Can't withdraw 0");

        IERC20(_address).transfer(owner(), IERC20(_address).balanceOf(address(this)));
    }

}
