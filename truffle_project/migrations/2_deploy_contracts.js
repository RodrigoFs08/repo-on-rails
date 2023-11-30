const STR = artifacts.require("STR");
const DREXToken = artifacts.require("DREXToken");
const TPFtToken = artifacts.require("TPFtToken");
const ExchangeContract = artifacts.require("ExchangeContract");
const OperacoesCompromissadas = artifacts.require("OperacoesCompromissadas");

module.exports = async function (deployer) {

  // Deploy do DREXToken
  await deployer.deploy(DREXToken, "Real Digital", "DREX");
  const drexToken = await DREXToken.deployed();

  // Deploy do STR
  await deployer.deploy(STR,drexToken.address);
  const str = await STR.deployed();

  // Deploy do TPFtToken
  await deployer.deploy(TPFtToken,"{'tipo':'LFT'}");
  const tpftToken = await TPFtToken.deployed();

  // Deploy do ExchangeContract
  await deployer.deploy(ExchangeContract, drexToken.address, tpftToken.address, str.address);

  // Deploy do OperacoesCompromissadas
  await deployer.deploy(OperacoesCompromissadas, drexToken.address, tpftToken.address);
};
