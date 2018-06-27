pragma solidity ^0.4.24;

// The original version which shows all of the ideas but has since been refactored and simplified
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
       - manage roles for regions
       - manage addresses for each role
       - designated addresses have ability to edit/delete bad information

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

    /// Create Region
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
        address createdBy;

    }
    /// Option #1
    /// Tree data storage
    TreeInfo[] public trees;

    /// Tree Ids for region ids
    mapping(uint256 => uint256) treeIdsByRegionId;

    /// Tree ownership address mappings
    mapping(address => uint256[]) treeOwners;


    /// Option #2
    /// Tree data storage
    mapping(uint256 => TreeInfo[]) public treesByRegionId;

    /// Tree ownership address mappings
    /// address -> regionIds -> treeIds
    mapping(address => mapping(uint256 => uint256[])) treeOwnersByRegionId;


    /// TODO Store Tree Ids by lat/long mappings



    /// Create Tree
    /// TODO enforce a region role
    function createBasicTreeInfo(uint32 _latlong, string _family, string _genus, string _species)
    public returns (uint256) {

        TreeInfo memory _treeInfo = TreeInfo({
            family: _family,
            latlong : _latlong,
            genus : _genus,
            species : _species,
            createdBy : msg.sender
        });

        // Add to tree list storage
        uint256 newTreeInfoArrayId = trees.push(_treeInfo) -1;

        return newTreeInfoArrayId;
    }


/*
    /// This function fails due to stack limits at 16 parameters, we need to break this into multiple functions
    function createTreeInfo(uint32 _latlong, string _family, string _genus, string _species,
        uint8 _height, uint8 _canopy, uint8 _dab, uint8 _dbh, uint8 _scaffold, uint8 _tertiary,
        string _fruit, string _leaves, string _water, string _soil)  public returns (uint256) {

        TreeInfo memory _treeInfo = TreeInfo({
            family: _family,
            latlong : _latlong,
            genus : _genus,
            species : _species,
            height : _height,
            canopy : _canopy,
            dab : _dab,
            dbh : _dbh,
            scaffold : _scaffold,
            tertiary : _tertiary,
            fruit : _fruit,
            leaves : _leaves,
            water : _water,
            soil : _soil,
            createdBy : msg.sender
            });

        // Add to tree list storage
        uint256 newTreeInfoArrayId = trees.push(_treeInfo) -1;

        return newTreeInfoArrayId;
    }*/

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
    - tree property owner needs a way to claim trees

    Marking trees public or private
    - public trees will be seen by more users and has more info available
    - private trees will only have access by the owners and creators
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
        return trees.length;
    }

}

