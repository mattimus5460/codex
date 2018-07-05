import "../stylesheets/app.css";

import {default as Web3} from 'web3';
import {default as contract} from 'truffle-contract'

import codex_artifacts from '../../build/contracts/CodexCore.json'

var $ = require("jquery");
var jQuery = require("jquery");

var Codex = contract(codex_artifacts);

var accounts;
var account;

var activeRegion;

window.App = {

    start: function () {
        var self = this;

        // Bootstrap t he Codex abstraction for Use.
        Codex.setProvider(web3.currentProvider);

        // web3.eth.contract(Codex.abi).at("0x676445b98b215367c4C8efDCAE660FE86379Cd64");

        // Get the initial account balance so it can be displayed.
        web3.eth.getAccounts(function (err, accs) {
            if (err != null) {
                alert("There was an error fetching your accounts.");
                return;
            }

            if (accs.length == 0) {
                alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
                return;
            }

            accounts = accs;
            account = accounts[0];

            self.refreshBalance();
            self.loadRegions();
        });
    },

    setStatus: function (message) {
        var status = document.getElementById("status");
        status.innerHTML = message;
    },

    refreshBalance: function () {
        web3.eth.getBalance(account, function (error, value) {
            var balance_element = document.getElementById("balance");
            balance_element.innerHTML = web3.fromWei(value.valueOf());
        });
    },

    createRegion: function () {
        var self = this;

        var name = document.getElementById("region-name").value;
        var state = document.getElementById("region-state").value;

        this.setStatus("Initiating transaction... (please wait)");

        var codex;
        Codex.deployed().then(function (instance) {
            codex = instance;
            return codex._createRegion(name, state, {from: account});
        }).then(function () {
            self.setStatus("Transaction complete!");
            self.refreshBalance();
            self.loadRegions();
        }).catch(function (e) {
            console.log(e);
            self.setStatus("Error creating region");
        });
    },

    loadRegions: function () {
        var self = this;

        var codex;
        Codex.deployed().then(function (instance) {
            codex = instance;
            return codex.regionCount();
        }).then(function (value) {
            $("#region-total").html(parseInt(value));
            var n = 0;
            var val = parseInt(value);
            while (n < val) {
                (function(nCur){
                    codex.getCodexRegionData(n).then(function (val2) {
                        $("div#region-table").append("<div>" + val2 +App.getTreeFormButton(nCur)+"</div>");
                    });
                })(n);
                n++;
            }

            self.refreshBalance();
        }).catch(function (e) {
            console.log(e);
            self.setStatus("Error getting regions");
        });
    },

    getTreeFormButton: function(n){
        return "<button onclick='App.loadTreesForRegion(" + n + ")'>Load Trees</button>"
    },

    loadTreesForRegion: function (regionId) {
        var self = this;

        $("table#tree-table").html("");
        var codex;
        Codex.deployed().then(function (instance) {
            codex = instance;
            return codex.getCodexRegionTreesCount(parseInt(regionId));
        }).then(function (value) {
            $("#tree-total").html(parseInt(value));
            activeRegion = parseInt(regionId);

            var n = 0;
            while (n < parseInt(value)) {

                codex._getTreeData(n, regionId).then(function (val2) {
                    $("table#tree-table").append("<li>" + val2 + "</li>");
                });

                n++;
            }

            self.refreshBalance();
        }).catch(function (e) {
            console.log(e);
            self.setStatus("Error getting trees");
        });
    },

    createTreeForRegion: function () {
        var self = this;
        var treeId = document.getElementById("tree-id").value;

        this.setStatus("Initiating transaction... (please wait)");

        var codex;
        Codex.deployed().then(function (instance) {
            codex = instance;
            return codex._createTree(treeId, activeRegion, {from: account});
        }).then(function () {
            self.setStatus("Transaction complete!");
            self.refreshBalance();
            self.loadTreesForRegion(activeRegion);
        }).catch(function (e) {
            console.log(e);
            self.setStatus("Error creating region");
        });
    },
};

window.addEventListener('load', function () {
    // Checking if Web3 has been injected by the browser (Mist/MetaMask)
    if (typeof web3 !== 'undefined') {
        console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 Codex, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
        // Use Mist/MetaMask's provider
        window.web3 = new Web3(web3.currentProvider);
    } else {
        console.warn("No web3 detected. Falling back to http://127.0.0.1:9545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
        // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
        window.web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:9545"));
    }

    App.start();
});
