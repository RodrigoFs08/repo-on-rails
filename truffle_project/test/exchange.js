const DREXToken = artifacts.require("DREXToken");
const TPFTToken = artifacts.require("TPFTToken"); 
const ExchangeContract = artifacts.require("ExchangeContract");

contract("ExchangeContract", accounts => {
  const [owner, bancoCentral, user1, user2] = accounts;
  let drexToken, tpftToken, exchangeContract;

  beforeEach(async () => {
    drexToken = await DREXToken.new("Real Digital", "DREX");
    tpftToken = await TPFTToken.new("nlft"); 
    exchangeContract = await ExchangeContract.new(drexToken.address, tpftToken.address, bancoCentral);

    // Suponha que o tokenID 1 é um token fungível dentro do seu contrato ERC1155
    const tpftTokenId = 1;
    const data = web3.utils.asciiToHex("preço:1000");

    // Distribuindo tokens para testes
    await drexToken.mint(user1, 1000);
    await tpftToken.mint(user2, tpftTokenId, 500,data); 
  });

  it("deve permitir a troca de DREX por TPFt", async () => {
    const tpftTokenId = 1;
    await drexToken.approve(exchangeContract.address, 100, { from: user1 });
    await tpftToken.setApprovalForAll(exchangeContract.address, true, { from: user2 });

    await exchangeContract.exchangeDrexForTpft(user1, user2, 100, tpftTokenId, 50, { from: bancoCentral });

    const finalDrexUser1 = await drexToken.balanceOf(user1);
    const finalTpftUser1 = await tpftToken.balanceOf(user1, tpftTokenId);
    const finalDrexUser2 = await drexToken.balanceOf(user2);
    const finalTpftUser2 = await tpftToken.balanceOf(user2, tpftTokenId);

    assert.equal(finalDrexUser1.toNumber(), 900);
    assert.equal(finalTpftUser1.toNumber(), 50);
    assert.equal(finalDrexUser2.toNumber(), 100);
    assert.equal(finalTpftUser2.toNumber(), 450);
  });

});
