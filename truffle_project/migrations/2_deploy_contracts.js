const STR = artifacts.require("STR");
const DREXToken = artifacts.require("DREXToken");
const TPFtToken = artifacts.require("TPFtToken");
const ExchangeContract = artifacts.require("ExchangeContract");

module.exports = async function (deployer) {

  // Deploy do DREXToken
  await deployer.deploy(DREXToken, "Real Digital", "DREX");
  const drexToken = await DREXToken.deployed();

  // Deploy do TPFtToken
  await deployer.deploy(TPFtToken, "{'tipo':'LFT'}");
  const tpftToken = await TPFtToken.deployed();


  // Deploy do ExchangeContract
  const exchange = await deployer.deploy(ExchangeContract, drexToken.address, tpftToken.address);

  // Deploy do STR
  await deployer.deploy(STR, drexToken.address, exchange.address);
  const str = await STR.deployed();




};
