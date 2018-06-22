var CodexCore = artifacts.require("./CodexCore.sol");

contract('CodexCore', function (accounts) {
    it("should have owner be the tx.origin account", function () {
        return CodexCore.deployed().then(function (instance) {
            return instance.codexOwner();
        }).then(function (value) {
            assert.equal(value, accounts[0], "owner did not match creator");
        });
    });

    it("create the first region with 0 index/id", function () {
        var codex;
        return CodexCore.deployed().then(function (instance) {
            codex = instance;
            return codex._createRegion.call("Test County Name","Test State Name", [], []);
        }).then(function (newRegionId) {
            return assert.equal(0, newRegionId, "region id was incorrect");
        })
    });

    it("should send coin correctly", function () {
        var meta;

        //    Get initial balances of first and second account.
        var account_one = accounts[0];
        var account_two = accounts[1];

        var account_one_starting_balance;
        var account_two_starting_balance;
        var account_one_ending_balance;
        var account_two_ending_balance;

        var amount = 10;

        return Codex.deployed().then(function (instance) {
            meta = instance;
            return meta.getBalance.call(account_one);
        }).then(function (balance) {
            account_one_starting_balance = balance.toNumber();
            return meta.getBalance.call(account_two);
        }).then(function (balance) {
            account_two_starting_balance = balance.toNumber();
            return meta.sendCoin(account_two, amount, {from: account_one});
        }).then(function () {
            return meta.getBalance.call(account_one);
        }).then(function (balance) {
            account_one_ending_balance = balance.toNumber();
            return meta.getBalance.call(account_two);
        }).then(function (balance) {
            account_two_ending_balance = balance.toNumber();

            assert.equal(account_one_ending_balance, account_one_starting_balance - amount, "Amount wasn't correctly taken from the sender");
            assert.equal(account_two_ending_balance, account_two_starting_balance + amount, "Amount wasn't correctly sent to the receiver");
        });
    });
});
