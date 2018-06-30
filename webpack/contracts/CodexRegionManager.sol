pragma solidity ^0.4.24;

import "./CodexRegionRoles.sol";

contract CodexRegion is CodexRegionRoles {

    /// Region Fields
    string public name;
    string public state;
    address[] teamMembers;
    address public createdBy;

    /// Tree data storage
    string[] public trees;

    /// Tree ownership address mappings
    mapping(address => uint256[]) allTreesForOwner;
    mapping(uint256 => address) treeOwnersByTreeId;

}

contract CodexRegionManager is CodexRegion {

    /*
       To add a new region for managing trees,
        we would instantiate a new CodexRegionManager

       A CodexRegionManager has functions to:
        - manage all trees for a region
        - set tree owners
        - set team members

       Tree Owner
        - can edit their tree data but will undo validation state
        - can make trees public or private

       Validating existing trees
        - tree property owner
        - allow many people to validate the existing tree data

        Teams
        - trained users can go out and add new or validate existing trees

        Team Management
        - ability to manage addresses of verified actors in a region
   */


    /**
    * @dev The constructor sets the createdBy to the sender
    * account.
    */
    constructor(string _name, string _state) public {
        require(bytes(_name).length > 0);
        require(bytes(_state).length > 0);

        createdBy = tx.origin;
        name = _name;
        state = _state;
    }


    /// Create Tree
    function createTree(string _treeId)
    public onlyCEO returns (uint256) {

        // Add to tree list storage
        uint256 newTreeInfoArrayId = trees.push(_treeId) -1;

        return newTreeInfoArrayId;
    }

    /// All trees count
    function treesCount() view public returns (uint) {
        return trees.length;
    }

    /// Set the owner of a single tree by tree array id
    function setTreeOwner(address _ownerAddress, uint _treeId) public returns (bool){
        require(_ownerAddress != address(0));

        allTreesForOwner[_ownerAddress].push(_treeId);

        treeOwnersByTreeId[_treeId] = _ownerAddress;

        return true;
    }

    /// Get all tree array ids for an owner
    function getTreeIdsByOwner(address _ownerAddress) public view returns (uint256[]){
        return allTreesForOwner[_ownerAddress];
    }

    /// Get the owner for a tree
    function getOwnerByTreeId(uint _treeId) public view returns (address){
        return treeOwnersByTreeId[_treeId];
    }

    /// get the data for a tree by tree array id
    function getTreeData(uint _treeId) public view returns (string){
        return trees[_treeId];
    }


    function canEditTree(address _ownerAddress, uint _treeId) public view returns (bool){
        require(treeOwnersByTreeId[_treeId] == _ownerAddress);
        return true;
    }
}