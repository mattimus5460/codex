pragma solidity ^0.4.24;

contract CodexCreator {
    address public owner;

    /**
    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
    * account.
    */
    constructor() public {
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

    /// Option #1
    /// Tree data storage
    string[] public trees;

    /// Tree Ids for region ids
    mapping(uint256 => uint256) treeIdsByRegionId;

    /// Tree ownership address mappings
    mapping(address => uint256[]) treeOwners;


    /// TODO Store Tree Ids by lat/long mappings


    /// Create Tree
    /// TODO enforce a region role
    function createTree(string _treeId)
    public returns (uint256) {

        // Add to tree list storage
        uint256 newTreeInfoArrayId = trees.push(_treeId) -1;

        return newTreeInfoArrayId;
    }

    /// Modify Tree


}


contract CodexOwnership is CodexBase {
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

*/

}

