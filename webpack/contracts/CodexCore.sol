pragma solidity ^0.4.24;

contract CodexCreator {
    address public codexOwner;

    constructor() public {
        codexOwner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == codexOwner);
        _;
    }
}

contract CodexRegionAccessControl is CodexCreator {

    /*
       Region Management
       - create new regions
       - create roles for regions
       - manage addresses for each role
       - ability to edit/delete bad information

       */

    /// Region Data Struct
    struct Region{
        string name;
        string state;
        address[] managers;
        address[] teamMembers;
        address createdBy; // "owner"
    }

    /// Region data storage
    Region[] public regions;

    function _createRegion (string _name, string _state, address[] _managers, address[] _teamMembers) public returns (uint256) {

        Region memory _region = Region({
            name: _name,
            state : _state,
            managers : _managers,
            teamMembers : _teamMembers,
            createdBy : msg.sender
        });

        // Add to regions list storage
        uint256 newRegionArrayId = regions.push(_region) -1;

        return newRegionArrayId;
    }

}

contract CodexBase is CodexRegionAccessControl {

    /// Tree Data Struct
    struct TreeInfo {
        uint32 latlong;
        string family;
        string genus;
        string species;
        uint8 height;
        uint8 canopy;
        uint8 dab;
        uint8 dbh;
        uint8 scaffold;
        uint8 tertiary;
        //Assets//
        string fruit;
        string leaves;
        //flowers necessary?
        //     string flowers;
        //Environment//
        string water;
        string soil;

    }

    /// Tree Storage
    mapping(uint256 => TreeInfo[]) treesByRegionId;

    /*
    /// Tree ownership address mappings
    //treeId keeps track of TreeInfo from setTreeInfo function below
    mapping(address => TreeInfo) trees;
    uint256[] private treeIds;

    //Attempting to apply ownership to trees input through setTreeInfo
    mapping(uint32 => address) treeOwner;
    address[] public treeInfoToOwner;

    mapping(address => Codex) treesOwned;

    //Aiming to find out how to assing ownership as well as transfer of ownership maybe in another contract?
    //trees[x] = { tree struct } and treesToOwner[x] = addressOfOwner


    /// Create Tree
    //Allows 32 digit number input that pairs with TreeInfo. Because we will have several contracts we might be
    //able allow users to input their trees latitude/longitude consecutively. ie: 332319111153414 takes you to a tree here: https://bit.ly/2sh52x3
    function setTreeInfo(uint32 _latlong, string _family, string _genus, string _species, uint8 _height, uint8 _canopy, uint8 _dab, uint8 _dbh, uint8 _scaffold, string _fruit, string _leaves, string _water, string _soil) onlyOwner public {
        var tree = trees[_latlong];

        tree.family = _family;
        tree.genus = _genus;
        tree.species = _species;
        tree.height = _height;
        tree.canopy = _canopy;
        tree.dab = _dab;
        tree.dbh = _dbh;
        tree.scaffold = _scaffold;
        // tree.tertiary = _tertiary; excluded due to stack limits, gotta find a way to get this in //
        tree.fruit = _fruit;
        tree.leaves = _leaves;
        tree.water = _water;
        tree.soil = _soil;
        //
        treeId.push(_latlong) - 1;
    }
    */

    /// Modify Tree


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


contract CodexOwnership is CodexBase { //}, ERC721 {
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


    //Calls all existing tree info within contract through _latlong
    function getTreeIds() view public returns (uint256[]) {
        return treeIds;
    }

    //Pulls all TreeInfo from a tree. Must keep private due to stack limits
    function getTree(uint32 _uint32) view private returns (string, string, string, uint8, uint8, uint8, uint8, uint8, string, string, string, string) {
        return (trees[_uint32].family, trees[_uint32].genus, trees[_uint32].species, trees[_uint32].height, trees[_uint32].canopy, trees[_uint32].dab, trees[_uint32].dbh, trees[_uint32].scaffold, trees[_uint32].fruit, trees[_uint32].leaves, trees[_uint32].water, trees[_uint32].soil);
    }

    //Pulls all info that may be displayed due to stack limits
    function searchTree(uint32 _uint32) view public returns (string, string, string, uint8, uint8, string, string) {
        return (trees[_uint32].family, trees[_uint32].genus, trees[_uint32].species, trees[_uint32].height, trees[_uint32].canopy, trees[_uint32].fruit, trees[_uint32].leaves);
    }

    //Calls up a count of all trees listed in contract
    function countTrees() view public returns (uint) {
        return treeId.length;
    }
    */

}

