var Covid19CryptoFund = artifacts.require("./Covid19CryptoFund.sol");

module.exports = async function(deployer, network, accounts) {
    //there is no better way to do it async: https://github.com/trufflesuite/truffle/issues/501
        deployer.then(async () => {
            await deployer.deploy(
                Covid19CryptoFund
            );
        })
}