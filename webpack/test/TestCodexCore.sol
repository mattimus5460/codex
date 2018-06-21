pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/CodexCore.sol";

contract TestCodexCore {

  function testContractOwnerAfterNewContract() public {
    CodexCore codex = CodexCore(DeployedAddresses.CodexCore());

    Assert.equal(codex.codexOwner(), tx.origin, "Owner should match origin");
  }



}
