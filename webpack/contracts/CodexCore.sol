pragma solidity ^0.4.24;

import "./CodexOwner.sol";
import "./CodexRegionManager.sol";

contract CodexRegionManagerWrapper is CodexOwner{

    /*
     *  This contract contains functions to
     *      manage the CodexRegionManagers
     *
     */

    /// CodexRegionManager data storage
    address[] public regions;

    /// Create Region
    function _createRegion (string _name, string _state) public onlyOwner returns (uint256) {

        CodexRegionManager _region = new CodexRegionManager(_name, _state);

        // Add to regions list storage
        uint256 newRegionArrayId = regions.push(_region) -1;

        return newRegionArrayId;
    }

    function regionCount() view public returns (uint) {
        return regions.length;
    }

    function getCodexRegion(uint index) view public returns (CodexRegionManager) {
        return CodexRegionManager(regions[index]);
    }

    function getCodexRegionCreatedBy(uint index) view public returns (address) {
        return CodexRegionManager(regions[index]).createdBy();
    }

    function getCodexRegionName(uint index) view public returns (string) {
        return CodexRegionManager(regions[index]).name();
    }

    function getCodexRegionData(uint index) view public returns (string, string, address) {
        CodexRegionManager curRegion = CodexRegionManager(regions[index]);
        return (curRegion.name(), curRegion.state(), curRegion.createdBy());
    }

    function getCodexRegionCEO(uint index) view public returns (address) {
        return CodexRegionManager(regions[index]).ceoAddress();
    }

    function getCodexRegionTreesCount(uint index) view public returns (uint) {
        return CodexRegionManager(regions[index]).treesCount();
    }
}


contract CodexBase is CodexRegionManagerWrapper {

    /*
     *  This contract contains functions to
     *      manage trees within CodexRegionManagers
     *
     */

    /// Create Tree
    function _createTree(string _treeId, uint regionId)
    public returns (uint256) {

        // Add to tree list storage
        uint256 newTreeInfoArrayId = CodexRegionManager(regions[regionId]).createTree(_treeId);

        return newTreeInfoArrayId;
    }

}


contract CodexOwnership is CodexBase {

    /*
     *  This contract contains functions to
     *      manage tree owners within CodexRegionManagers
     *
     */

    /// Set Tree Owner
    function _setTreeOwnerForRegion(uint _regionId, address _ownerAddress, uint _treeId) public{
        CodexRegionManager(regions[_regionId]).setTreeOwner(_ownerAddress, _treeId);
    }

    /// Get Tree Owner
    function _getTreeOwnerForRegion(uint _regionId, uint _treeId) public view returns (address){
        return CodexRegionManager(regions[_regionId]).getOwnerByTreeId(_treeId);
    }


    /*
     *  This function can be used as a permissions check for tree edits
     *      to be used before any other service attempts to edit the external tree data
     *
     *  The external services could call this with the active users account/address
     *      and would prevent editing of the data if this check fails
     */
    function _canEditTree(uint _regionId, uint _treeId) public view returns (bool){
        return CodexRegionManager(regions[_regionId]).canEditTree(tx.origin, _treeId);
    }

}


contract CodexTeamManager is CodexOwnership {
    /*
     *  This contract contains functions to
     *      manage team members within CodexRegionManagers
     *
     */

}


contract CodexTreeValidation is CodexTeamManager {
    /*
     *  This contract contains functions to
     *      validate existing trees as team members
     *
     */
}


contract CodexCore is CodexTreeValidation {
    /*
     *  This contract is the main contract that would be deployed
     *
     */

    /// Retrieve Tree Data
    function _getTreeData(uint _treeId, uint _regionId)
    public view returns (string) {
        return CodexRegionManager(regions[_regionId]).getTreeData(_treeId);
    }

}

