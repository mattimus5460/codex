pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/CodexCore.sol";

contract TestCodexCore {

  function testContractOwnerAfterNewContract() public {
    CodexCore codex = CodexCore(DeployedAddresses.CodexCore());

    Assert.equal(codex.owner(), tx.origin, "Owner should match origin");
  }

  function testCreateRegion() public {
    CodexCore codex = CodexCore(DeployedAddresses.CodexCore());

    codex._createRegion("Test County Name","Test State Name");

    Assert.equal(1, codex.regionCount(), "region should have count of 1");
  }

  function testCreateMultipleRegion() public {
    CodexCore codex = CodexCore(DeployedAddresses.CodexCore());

    codex._createRegion("Test County Name","Test State Name");
    codex._createRegion("Test County Name","Test State Name");
    codex._createRegion("Test County Name","Test State Name");

    Assert.equal(4, codex.regionCount(), "region should have count of 4");
  }

  function testRegionValues() public {
    CodexCore codex = CodexCore(DeployedAddresses.CodexCore());
    CodexRegion region = codex.getCodexRegion(0);

    Assert.equal("Test County Name", region.name(), "region should have name Test County Name");
    Assert.equal("Test State Name", region.state(), "region should have state Test State Name");

    Assert.equal(tx.origin, codex.getCodexRegionCreatedBy(0), "region should have origin as createdBy");
    Assert.equal(tx.origin, codex.getCodexRegionCEO(0), "region should have origin as ceo");

  }

  function testCreateTree() public {
    CodexCore codex = CodexCore(DeployedAddresses.CodexCore());

    codex._createTree("TestTreeId", 0);

    Assert.equal(1, codex.getCodexRegion(0).treesCount(), "region should have 1 tree");

  }

  function testSetTreeOwner() public {
    CodexCore codex = CodexCore(DeployedAddresses.CodexCore());

    codex._setTreeOwnerForRegion(0, tx.origin, 0);
    codex._setTreeOwnerForRegion(0, tx.origin, 1);

    Assert.equal(2, codex.getCodexRegion(0).getTreeIdsByOwner(tx.origin).length, "owner should have 2 trees");
  }


}