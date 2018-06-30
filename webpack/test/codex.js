var CodexCore = artifacts.require("./CodexCore.sol");
var CodexRegion = artifacts.require("./CodexRegionManager.sol");


contract('CodexCore', function (accounts) {
    it("should have owner be the tx.origin account", function () {
        return CodexCore.deployed().then(function (instance) {
            return instance.owner();
        }).then(function (value) {
            assert.equal(value, accounts[0], "owner did not match creator");
        });
    });

    it("create the first region with 0 index/id", function () {
        var codex;
        return CodexCore.deployed().then(function (instance) {
            codex = instance;
            return codex._createRegion.call("Test County Name","Test State Name");
        }).then(function (newRegionId) {
            return assert.equal(0, newRegionId, "region id was incorrect");
        })
    });

    it("should have createdBy as sender", function () {
        var codex;
        return CodexCore.deployed().then(function (instance) {
            codex = instance;
            codex._createRegion("Test County Name","Test State Name");
            return codex.getCodexRegionCreatedBy.call(0);
        }).then(function (region) {
            return assert.equal(accounts[0], region, "createdBy was incorrect");
        })

    });

    it("should have ceoAddress as sender", function () {
        var codex;
        return CodexCore.deployed().then(function (instance) {
            codex = instance;
            codex._createRegion("Test County Name","Test State Name");
            return codex.getCodexRegionCEO.call(0);
        }).then(function (region) {
            return assert.equal(accounts[0], region, "ceoAddress was incorrect");
        })

    });

    it("should add a tree to a region", function () {
        var codex;
        return CodexCore.deployed().then(function (instance) {
            codex = instance;
            codex._createTree("TestTreeId", 0);
            return codex.getCodexRegionTreesCount(0);
        }).then(function (regionTreeCount) {
            return assert.equal(1, regionTreeCount, "tree count incorrect");
        })

    });

    it("should have the proper tree data", function () {
        var codex;
        return CodexCore.deployed().then(function (instance) {
            codex = instance;
            return codex._getTreeData(0, 0);
        }).then(function (tree) {
            return assert.equal("TestTreeId", tree, "tree data incorrect");
        })

    });

    it("should set the tree owner", function () {
        var codex;
        return CodexCore.deployed().then(function (instance) {
            codex = instance;
            codex._setTreeOwnerForRegion(0, "0xf17f52151ebef6c7334fad080c5704d77216b732", 0);
            return codex._getTreeOwnerForRegion(0,0);
        }).then(function (owner) {
            return assert.equal("0xf17f52151ebef6c7334fad080c5704d77216b732", owner, "tree owner incorrect");
        })

    });
});
