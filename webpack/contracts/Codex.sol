
pragma solidity ^0.4.24;

//* @title CodexOwner
// * @dev The CodexOwner contract has an owner address, and provides basic authorization control
// * functions, this simplifies the implementation of "user permissions"

contract CodexOwner {
  address public owner;


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */

  function Ownable() {
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

  function transferOwnership(address newOwner) onlyOwner {
    if (newOwner != address(0)) {
      owner = newOwner;
    }
  }

}

contract TreeAccessControl is CodexOwner {

    // This facet controls access control for CryptoTrees. There are four roles managed here:
    //
    //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
    //         contracts. It is also the only role that can unpause the smart contract. It is initially
    //         set to the address that created the smart contract in the TreeCore constructor.
    //
    //     - The CFO: The CFO can withdraw funds from TreeCore and its contracts.
    //
    //     - The COO: The COO can set regional managers
    //
    // It should be noted that these roles are distinct without overlap in their access abilities, the
    // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
    // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
    // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
    // convenience. The less we use an address, the less likely it is that we somehow compromise the
    // account.

    /// @dev Emited when contract is upgraded - See README.md for updgrade plan

    event ContractUpgrade(address newContract);

    // The addresses of the accounts (or contracts) that can execute actions within each roles.

    address public ceoAddress;
    address public cfoAddress;
    address public cooAddress;

    // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked

    bool public paused = false;

    /// @dev Access modifier for CEO-only functionality

    modifier onlyCEO() {
        require(msg.sender == ceoAddress);
        _;
    }

    /// @dev Access modifier for CFO-only functionality

    modifier onlyCFO() {
        require(msg.sender == cfoAddress);
        _;
    }

    /// @dev Access modifier for COO-only functionality

    modifier onlyCOO() {
        require(msg.sender == cooAddress);
        _;
    }

    modifier onlyCLevel() {
        require(
            msg.sender == cooAddress ||
            msg.sender == ceoAddress ||
            msg.sender == cfoAddress
        );
        _;
    }

    /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
    /// @param _newCEO The address of the new CEO

    function setCEO(address _newCEO) external onlyCEO {
        require(_newCEO != address(0));

        ceoAddress = _newCEO;
    }

    /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
    /// @param _newCFO The address of the new CFO

    function setCFO(address _newCFO) external onlyCEO {
        require(_newCFO != address(0));

        cfoAddress = _newCFO;
    }

    /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
    /// @param _newCOO The address of the new COO

    function setCOO(address _newCOO) external onlyCEO {
        require(_newCOO != address(0));

        cooAddress = _newCOO;
    }

    /*** Pausable functionality adapted from OpenZeppelin ***/

    /// @dev Modifier to allow actions only when the contract IS NOT paused

    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    /// @dev Modifier to allow actions only when the contract IS paused

    modifier whenPaused {
        require(paused);
        _;
    }

    /// @dev Called by any "C-level" role to pause the contract. Used only when
    ///  a bug or exploit is detected and we need to limit damage.

    function pause() external onlyCLevel whenNotPaused {
        paused = true;
    }

    /// @dev Unpauses the smart contract. Can only be called by the CEO, since
    ///  one reason we may pause the contract is when CFO or COO accounts are
    ///  compromised.
    /// @notice This is public rather than external so it can be called by
    ///  derived contracts.

    function unpause() public onlyCEO whenPaused {
        // can't unpause if contract was upgraded
        paused = false;
    }
}


contract CodexRegionAccessControl is TreeAccessControl {

    /*//onlyCOO?
       Region Management
       - create new regions
       - create roles for regions
       - manage addresses for each role
       - ability to edit/delete bad information

       */
       
       
    mapping (uint => Region) Regions;
    uint[] private regions;

    /// Region Data Struct
    struct Region{
        string name;
        string state;
        address[] managers;
        address[] teamMembers;
        address createdBy; // "owner"
        string regionIdToArrayIds;
        }
        
//onlyCOO?
    /// Region data storage
  // Region[] public regions;

 //   function _createRegion(string _name, string _state, address[] _managers, address[] _teamMembers, string _regionIdToArrayIds){

//        Region memory _region = Region({
//            name: _name,
//            state : _state,
//            managers : _managers,
//            teamMembers : _teamMembers,
//            createdBy : msg.sender,
//            regionIdToArrayIds : _regionIdToArrayIds
//        });

        // Add to regions list storage
//       string newRegionArrayId = regions.push(_region) -1;

        // set id to array id mapping
//    Region[regions] = newRegionArrayId;

//    }

}

    /// Modify Tree
contract CodexOwnership is CodexRegionAccessControl {
    /*
    Claiming trees as an owner
    - tree property owner needs a way to
    */
    /*
    Marking trees public or private
    - public trees will be seen by more users and has more info available
    - private trees will only have access by the owners and creators
    -
  */


}

contract CodexValidationControl is CodexOwnership {
/*
    Validating existing trees
    - tree property owner
    - allow many people to validate the existing tree data

    Tree Owner
    - can edit their tree data but will undo validation state
    - can make trees public or private

    Teams
    - trained users can go out and add new or validate existing trees

    Team Management
    - ability to manage addresses of verified actors in a region
 */
 }

 contract CodexCore is CodexValidationControl {

     /*
        getTree functions
        - retrieve trees by lat/long
        - retrieve all trees for region

    */
    }

contract ERC721 {

    /// Required methods
   function totalSupply() public view returns (uint256 total);
   function balanceOf(address _owner) public view returns (uint256 balance);
   function ownerOf(uint256 _tokenId) external view returns (address owner);
   function approve(address _to, uint256 _tokenId) external;
   function transfer(address _to, uint256 _tokenId) external;
   function transferFrom(address _from, address _to, uint256 _tokenId) external;

    /// Events
    event Transfer(address from, address to, uint256 tokenId);
    event Approval(address owner, address approved, uint256 tokenId);

    /// Optional
    function name() public view returns (string name);
    function symbol() public view returns (string symbol);
    function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
    function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);

    /// ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
    function supportsInterface(bytes4 _interfaceID) external view returns (bool);
}

contract CodexBase is CodexValidationControl, ERC721 {
        
     //Info Gathered From Trees
    struct TreeInfo {
        uint latlong;
        string family;
        string genus;
        string species;
        uint8 height;
        uint8 canopy;
        uint8 dab;
        uint8 dbh;
        uint8 scaffold;
//     uint8 tertiary; can't set due to stack limits
        string fruit;
        string leaves;
//      flowers necessary?
//      string flowers;
        string water;
        string soil;
    }

   // struct SoilTrack {
//}
    //treeIndex keeps track of TreeInfo for each tree that is collected from _createTree function below
    mapping (uint => TreeInfo) trees;
    uint[] private treeIndex;

    event CreateTreeIndex(
        address indexed _from,
        uint _latlong,
        string _family,
        string _genus,
        string _species,
        uint8 _height,
        uint8 _canopy,
        string _fruit,
        string _leaves,
        string _soil);


    //Allows number input that is saved within TreeInfo struct. We will use _latlong for treeIds
    //ie: 332319111153414 takes you to a tree here: https://bit.ly/2sh52x3
    function _createTree(uint _latlong, string _family, string _genus, string _species, uint8 _height, uint8 _canopy, uint8 _dab, uint8 _dbh, uint8 _scaffold, string _fruit, string _leaves, string _water, string _soil) onlyOwner public {
        var tree = trees[_latlong];

        tree.family = _family;
        tree.genus = _genus;
        tree.species = _species;
        tree.height = _height;
        tree.canopy = _canopy;
        tree.dab = _dab;
        tree.dbh = _dbh;
        tree.scaffold = _scaffold;
        tree.fruit = _fruit;
        tree.leaves = _leaves;
        tree.water = _water;
        tree.soil = _soil;


        //sets _latlong as treeId
        treeIndex.push(_latlong) -1;
        emit CreateTreeIndex(msg.sender, _latlong, _family, _genus, _species, _height, _canopy, _fruit, _leaves, _soil);
    }

     //Calls all trees listed within the treeIndex
    function treeList() view public returns(uint[]) {
        return treeIndex;
    }

    //Pulls most important info to be displayed, limited to 6 fields due to stack limits
    function findTree(uint TreeId) view public returns (string, string, string, uint8, uint8, string) {
            return (
            trees[TreeId].family,
            trees[TreeId].genus,
            trees[TreeId].species,
            trees[TreeId].height,
            trees[TreeId].canopy,
            trees[TreeId].fruit
            );
    }

    //Pulls additional TreeInfo from a _latlong treeId. Must split up returned information due to stack limits
    function moreInfo(uint TreeId) view public returns (uint8, uint8, uint8, string, string, string) {
        return (
        trees[TreeId].dab,
        trees[TreeId].dbh,
        trees[TreeId].scaffold,
        trees[TreeId].fruit,
        trees[TreeId].water,
        trees[TreeId].soil
        );
    }

    //Calls up a count of all trees listed in contract
    function countTrees() view public returns (uint) {
        return treeIndex.length;
    }

}



