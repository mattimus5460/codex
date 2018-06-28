pragma solidity ^0.4.24;

import "./CodexOwner.sol";
import "./CodexRegion.sol";

contract CodexRegionManager is CodexOwner{

    /// Region data storage
    address[] public regions;

    /// Create Region
    function _createRegion (string _name, string _state) public onlyOwner returns (uint256) {

        CodexRegion _region = new CodexRegion(_name, _state);

        // Add to regions list storage
        uint256 newRegionArrayId = regions.push(_region) -1;

        return newRegionArrayId;
    }

    function regionCount() view public returns (uint) {
        return regions.length;
    }

    function getCodexRegion(uint index) view public returns (CodexRegion) {
        return CodexRegion(regions[index]);
    }

    function getCodexRegionCreatedBy(uint index) view public returns (address) {
        return CodexRegion(regions[index]).createdBy();
    }

    function getCodexRegionCEO(uint index) view public returns (address) {
        return CodexRegion(regions[index]).ceoAddress();
    }

    function getCodexRegionTreesCount(uint index) view public returns (uint) {
        return CodexRegion(regions[index]).treesCount();
    }
}


contract CodexBase is CodexRegionManager {

    /// Create Tree
    function _createTree(string _treeId, uint regionId)
    public returns (uint256) {

        // Add to tree list storage
        uint256 newTreeInfoArrayId = CodexRegion(regions[regionId]).createTree(_treeId);

        return newTreeInfoArrayId;
    }

}


contract CodexOwnership is CodexBase {
    /*
    Claiming trees as an owner
    - tree property owner needs a way to claim trees

    Marking trees public or private
    - public trees will be seen by more users and has more info available
    - private trees will only have access by the owners and creators
    */

    function _setTreeOwnerForRegion(uint _regionId, address _ownerAddress, uint _treeId) public{
        CodexRegion(regions[_regionId]).setTreeOwner(_ownerAddress, _treeId);
    }

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

