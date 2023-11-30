const DREXToken = artifacts.require("DREXToken");

contract("DREXToken", accounts => {
  const [owner, authorized, unauthorized] = accounts;

  let drexToken;

  beforeEach(async () => {
    drexToken = await DREXToken.new("Real Digital", "DREX");
    await drexToken.setAuthorizedWallet(authorized);
  });

  describe("mint", () => {
    it("allows owner to mint tokens", async () => {
      await drexToken.mint(owner, 1000);
      const balance = await drexToken.balanceOf(owner);
      assert.equal(balance.toNumber(), 1000, "The mint function didn't work as expected for owner");
    });

    it("allows authorized wallet to mint tokens", async () => {
      await drexToken.mint(owner, 1000, { from: authorized });
      const balance = await drexToken.balanceOf(owner);
      assert.equal(balance.toNumber(), 1000, "The mint function didn't work as expected for authorized wallet");
    });

    it("prevents unauthorized addresses from minting tokens", async () => {
      try {
        await drexToken.mint(owner, 1000, { from: unauthorized });
        assert.fail("Unauthorized address was able to mint tokens");
      } catch (error) {
        assert(error, "Expected an error but did not get one");
        assert(error.message.includes("Not authorized"), "Expected 'Not authorized' error");
      }
    });
  });

  describe("burn", () => {
    beforeEach(async () => {
      await drexToken.mint(owner, 1000);
    });

    it("allows owner to burn tokens", async () => {
      await drexToken.burn(owner, 500);
      const balance = await drexToken.balanceOf(owner);
      assert.equal(balance.toNumber(), 500, "The burn function didn't work as expected for owner");
    });

    it("allows authorized wallet to burn tokens", async () => {
      await drexToken.burn(owner, 500, { from: authorized });
      const balance = await drexToken.balanceOf(owner);
      assert.equal(balance.toNumber(), 500, "The burn function didn't work as expected for authorized wallet");
    });

    it("prevents unauthorized addresses from burning tokens", async () => {
      try {
        await drexToken.burn(owner, 500, { from: unauthorized });
        assert.fail("Unauthorized address was able to burn tokens");
      } catch (error) {
        assert(error, "Expected an error but did not get one");
        assert(error.message.includes("Not authorized"), "Expected 'Not authorized' error");
      }
    });
  });
});
