
pragma solidity ^0.4.21;

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  uint256 totalSupply_;

  /**
  * @dev total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title Standard ERC20 token
 *

 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}

contract DetailedERC20 is ERC20 {
  string public name;
  string public symbol;
  uint8 public decimals;

  function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
  }
}

contract IST20 {

    // off-chain hash
    bytes32 public tokenDetails;

    //transfer, transferFrom must respect use respect the result of verifyTransfer
    function verifyTransfer(address _from, address _to, uint256 _amount) public view returns (bool success);

    //used to create tokens
    function mint(address _investor, uint256 _amount) public returns (bool success);
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

contract ISecurityToken is IST20, Ownable {

    //TODO: Factor out more stuff here
    function checkPermission(address _delegate, address _module, bytes32 _perm) public view returns(bool);

}

//Simple interface that any module contracts should implement
contract IModuleFactory is Ownable {

    ERC20 public polyToken;

    function IModuleFactory(address _polyAddress) public {
      polyToken = ERC20(_polyAddress);
    }

    //Should create an instance of the Module, or throw
    function deploy(bytes _data) external returns(address);

    function getType() public view returns(uint8);

    function getName() public view returns(bytes32);

    //Return the cost (in POLY) to use this factory
    function getCost() public view returns(uint256);

    function getDescription() public view returns(string);

    function getTitle() public view returns(string);

    function getInstructions() public view returns (string);

    //Pull function sig from _data
    function getSig(bytes _data) internal pure returns (bytes4 sig) {
        uint len = _data.length < 4 ? _data.length : 4;
        for (uint i = 0; i < len; i++) {
            sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (len - 1 - i))));
        }
    }

}

//Simple interface that any module contracts should implement
contract IModule {

    address public factory;

    address public securityToken;

    function IModule(address _securityToken) public {
        securityToken = _securityToken;
        factory = msg.sender;
    }

    function getInitFunction() public returns (bytes4);
    
    //Allows owner, factory or permissioned delegate
    modifier withPerm(bytes32 _perm) {
        bool isOwner = msg.sender == ISecurityToken(securityToken).owner();
        bool isFactory = msg.sender == factory;
        require(isOwner||isFactory||ISecurityToken(securityToken).checkPermission(msg.sender, address(this), _perm));
        _;
    }

    modifier onlyOwner {
        require(msg.sender == ISecurityToken(securityToken).owner());
        _;
    }

    modifier onlyFactory {
        require(msg.sender == factory);
        _;
    }

    modifier onlyFactoryOwner {
        require(msg.sender == IModuleFactory(factory).owner());
        _;
    }

    function getPermissions() public view returns(bytes32[]);
}

//Simple interface that any module contracts should implement
contract IModuleRegistry {

    //Checks that module is correctly configured in registry
    function useModule(address _moduleFactory) external;

    function registerModule(address _moduleFactory) external returns(bool);

}

contract ITransferManager is IModule {

    function verifyTransfer(address _from, address _to, uint256 _amount) public view returns(bool);

}

contract IPermissionManager is IModule {

    function checkPermission(address _delegate, address _module, bytes32 _perm) public view returns(bool);

    function changePermission(address _delegate, address _module, bytes32 _perm, bool _valid) public returns(bool);

    function getDelegateDetails(address _delegate) public view returns(bytes32);

}

contract ISecurityTokenRegistry {

    address public polyAddress;

    address public moduleRegistry;
    address public tickerRegistry;

    bytes32 public protocolVersion = "0.0.1";
    mapping (bytes32 => address) public protocolVersionST;

    struct SecurityTokenData {
        string symbol;
        bytes32 tokenDetails;
    }

    mapping(address => SecurityTokenData) securityTokens;
    mapping(string => address) symbols;

    /**
     * @dev Creates a new Security Token and saves it to the registry
     * @param _name Name of the token 
     * @param _symbol Ticker symbol of the security token
     * @param _decimals Decimals value for token
     * @param _tokenDetails off-chain details of the token
     */
    function generateSecurityToken(string _name, string _symbol, uint8 _decimals, bytes32 _tokenDetails) public;

    function setProtocolVersion(address _stVersionProxyAddress, bytes32 _version) public;

    //////////////////////////////
    ///////// Get Functions
    //////////////////////////////
    /**
     * @dev Get security token address by ticker name
     * @param _symbol Symbol of the Scurity token
     * @return address _symbol
     */
    function getSecurityTokenAddress(string _symbol) public view returns (address);

     /**
     * @dev Get security token data by its address
     * @param _securityToken Address of the Scurity token
     * @return string, address, bytes32
     */
    function getSecurityTokenData(address _securityToken) public view returns (string, address, bytes32);
}

/**
* @title SecurityToken
* @notice SecurityToken is an ERC20 token with added capabilities:
* - Implements the ST-20 Interface
* - Transfers are restricted
* - Modules can be attached to it to control its behaviour
* - ST should not be deployed directly, but rather the SecurityTokenRegistry should be used
*/
contract SecurityToken is ISecurityToken, StandardToken, DetailedERC20 {
    using SafeMath for uint256;

    bytes32 public securityTokenVersion = "0.0.1";

    // Reference to the POLY token.
    ERC20 public polyToken;

    struct ModuleData {
        bytes32 name;
        address moduleAddress;
    }

    address public moduleRegistry;

    uint8 public constant PERMISSIONMANAGER_KEY = 1;
    uint8 public constant TRANSFERMANAGER_KEY = 2;
    uint8 public constant STO_KEY = 3;

    // Module list should be order agnostic!
    mapping (uint8 => ModuleData[]) public modules;
    mapping (uint8 => bool) public modulesLocked;

    uint8 public constant MAX_MODULES = 10;

    event LogModuleAdded(
        uint8 indexed _type,
        bytes32 _name,
        address _moduleFactory,
        address _module,
        uint256 _moduleCost,
        uint256 _budget,
        uint256 _timestamp
    );

    event LogModuleRemoved(uint8 indexed _type, address _module, uint256 _timestamp);
    event LogModuleBudgetChanged(uint8 indexed _moduleType, address _module, uint256 _budget);
    event Mint(address indexed to, uint256 amount);

    //if _fallback is true, then we only allow the module if it is set, if it is not set we only allow the owner
    modifier onlyModule(uint8 _moduleType, bool _fallback) {
      //Loop over all modules of type _moduleType
        bool isModuleType = false;
        for (uint8 i = 0; i < modules[_moduleType].length; i++) {
            isModuleType = isModuleType || (modules[_moduleType][i].moduleAddress == msg.sender);
        }
        if (_fallback && !isModuleType) {
            require(msg.sender == owner);
        } else {
            require(isModuleType);
        }
        _;
    }

    function SecurityToken(
        string _name,
        string _symbol,
        uint8 _decimals,
        bytes32 _tokenDetails,
        address _securityTokenRegistry
    )
    public
    DetailedERC20(_name, _symbol, _decimals)
    {
        //When it is created, the owner is the STR
        moduleRegistry = ISecurityTokenRegistry(_securityTokenRegistry).moduleRegistry();
        polyToken = ERC20(ISecurityTokenRegistry(_securityTokenRegistry).polyAddress());
        tokenDetails = _tokenDetails;
    }

    function addModule(
        address _moduleFactory,
        bytes _data,
        uint256 _maxCost,
        uint256 _budget,
        bool _locked
    ) external onlyOwner {
        _addModule(_moduleFactory, _data, _maxCost, _budget, _locked);
    }

    /**
    * @notice _addModule handles the attachment (or replacement) of modules for the ST
    * E.G.: On deployment (through the STR) ST gets a TransferManager module attached to it
    * to control restrictions on transfers.
    * @param _moduleFactory is the address of the module factory to be added
    * @param _data is data packed into bytes used to further configure the module (See STO usage)
    * @param _maxCost max amount of POLY willing to pay to module. (WIP)
    * @param _locked whether or not the module is supposed to be locked
    */
    //You are allowed to add a new moduleType if:
    //  - there is no existing module of that type yet added
    //  - the last member of the module list is replacable
    function _addModule(address _moduleFactory, bytes _data, uint256 _maxCost, uint256 _budget, bool _locked) internal {
        //Check that module exists in registry - will throw otherwise
        IModuleRegistry(moduleRegistry).useModule(_moduleFactory);
        IModuleFactory moduleFactory = IModuleFactory(_moduleFactory);
        require(modules[moduleFactory.getType()].length < MAX_MODULES);
        uint256 moduleCost = moduleFactory.getCost();
        require(moduleCost <= _maxCost);
        //Check that this module has not already been set as locked
        require(!modulesLocked[moduleFactory.getType()]);
        //Approve fee for module
        require(polyToken.approve(_moduleFactory, moduleCost));
        //Creates instance of module from factory
        address module = moduleFactory.deploy(_data);
        //Approve ongoing budget
        require(polyToken.approve(module, _budget));
        //Add to SecurityToken module map
        modules[moduleFactory.getType()].push(ModuleData(moduleFactory.getName(), module));
        modulesLocked[moduleFactory.getType()] = _locked;
        //Emit log event
        emit LogModuleAdded(moduleFactory.getType(), moduleFactory.getName(), _moduleFactory, module, moduleCost, _budget, now);
    }

    /**
    * @dev removes a module attached to the SecurityToken
    * @param _moduleType is which type of module we are trying to remove
    * @param _moduleIndex is the index of the module within the chosen type
    */
    function removeModule(uint8 _moduleType, uint8 _moduleIndex) external onlyOwner {
        require(_moduleIndex < modules[_moduleType].length);
        require(modules[_moduleType][_moduleIndex].moduleAddress != address(0));
        require(!modulesLocked[_moduleType]);
        //Take the last member of the list, and replace _moduleIndex with this, then shorten the list by one
        emit LogModuleRemoved(_moduleType, modules[_moduleType][_moduleIndex].moduleAddress, now);
        modules[_moduleType][_moduleIndex] = modules[_moduleType][modules[_moduleType].length - 1];
        modules[_moduleType].length = modules[_moduleType].length - 1;
    }

    function getModule(uint8 _moduleType, uint _index) public view returns (bytes32, address, bool) {
        if (modules[_moduleType].length > 0) {
            return (
            modules[_moduleType][_index].name,
            modules[_moduleType][_index].moduleAddress,
            modulesLocked[_moduleType]
            );
        }else {
            return ("", address(0), false);
        }

    }

    /**
    * @dev allows the owner to withdraw unspent POLY stored by them on the ST.
    * Owner can transfer POLY to the ST which will be used to pay for modules that require a POLY fee.
    */
    function withdrawPoly(uint256 _amount) public onlyOwner {
        require(polyToken.transfer(owner, _amount));
    }

    /**
    * @dev allows owner to approve more POLY to one of the modules
    */
    function changeModuleBudget(uint8 _moduleType, uint8 _moduleIndex, uint256 _budget) public onlyOwner {
        require(_moduleType != 0);
        require(_moduleIndex < modules[_moduleType].length);
        require(polyToken.approve(modules[_moduleType][_moduleIndex].moduleAddress, _budget));
        emit LogModuleBudgetChanged(_moduleType, modules[_moduleType][_moduleIndex].moduleAddress, _budget);
    }

    /**
     * @dev Overloaded version of the transfer function
     */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(verifyTransfer(msg.sender, _to, _value));
        return super.transfer(_to, _value);
    }

    /**
     * @dev Overloaded version of the transferFrom function
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(verifyTransfer(_from, _to, _value));
        return super.transferFrom(_from, _to, _value);
    }

    // Permissions this to a TransferManager module, which has a key of 2
    // If no TransferManager return true
    function verifyTransfer(address _from, address _to, uint256 _amount) public view returns (bool success) {
        if (modules[TRANSFERMANAGER_KEY].length == 0) {
            return true;
        }
        for (uint8 i = 0; i < modules[TRANSFERMANAGER_KEY].length; i++) {
            if (ITransferManager(modules[TRANSFERMANAGER_KEY][i].moduleAddress).verifyTransfer(_from, _to, _amount)) {
                return true;
            }
        }
        return false;
    }

    /**
    * @dev mints new tokens and assigns them to the target _investor.
    * Can only be called by the STO attached to the token (Or by the ST owner if there's no STO attached yet)
    */
    function mint(address _investor, uint256 _amount) public onlyModule(STO_KEY, true) returns (bool success) {
        require(verifyTransfer(address(0), _investor, _amount));
        totalSupply_ = totalSupply_.add(_amount);
        balances[_investor] = balances[_investor].add(_amount);
        emit Mint(_investor, _amount);
        emit Transfer(address(0), _investor, _amount);
        return true;
    }

    //TODO: Implement this function
    function investorStatus(address /* _investor */) public pure returns (uint8 _status) {
        return 0;
    }

    // Permissions this to a Permission module, which has a key of 1
    // If no Permission return false - note that IModule withPerm will allow ST owner all permissions anyway
    // this allows individual modules to override this logic if needed (to not allow ST owner all permissions)
    function checkPermission(address _delegate, address _module, bytes32 _perm) public view returns(bool) {
        if (modules[PERMISSIONMANAGER_KEY].length == 0) {
            return false;
        }

        for (uint8 i = 0; i < modules[PERMISSIONMANAGER_KEY].length; i++) {
            if (IPermissionManager(modules[PERMISSIONMANAGER_KEY][i].moduleAddress).checkPermission(_delegate, _module, _perm)) {
                return true;
            }
        }
    }
}
