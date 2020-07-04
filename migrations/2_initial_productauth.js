var ProductAuth = artifacts.require("./ProductAuth.sol");

module.exports = function(deployer) {
  deployer.deploy(ProductAuth);
};
