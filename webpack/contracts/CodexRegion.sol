pragma solidity ^0.4.24;

import "./CodexRegionRoles.sol";

contract CodexRegion is CodexRegionRoles {

    /*
       Region Management
       - create new regions
       - manage roles for regions
       - manage addresses for each role
       - designated addresses have ability to edit/delete bad information

       */

    string public name;
    string public state;
    address[] teamMembers;
    address public createdBy;


    /// Tree data storage
    string[] public trees;

    /// Tree ownership address mappings
    mapping(address => uint256[]) treeOwners;

    /// TODO Store Tree Ids by lat/long mappings

    /**
    * @dev The constructor sets the createdBy to the sender
    * account.
    */
    constructor(string _name, string _state) public {
        createdBy = tx.origin;
        name = _name;
        state = _state;
    }

    /// Create Tree
    /// TODO enforce a region role
    function createTree(string _treeId)
    public onlyCEO returns (uint256) {

        // Add to tree list storage
        uint256 newTreeInfoArrayId = trees.push(_treeId) -1;

        return newTreeInfoArrayId;
    }

    function treesCount() view public returns (uint) {
        return trees.length;
    }


}