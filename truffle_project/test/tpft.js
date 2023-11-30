const TPFtToken = artifacts.require("TPFtToken");

contract("TPFtToken", (accounts) => {
    const [admin, minter, otherAccount] = accounts;
    let tpftToken;

    beforeEach(async () => {
        tpftToken = await TPFtToken.new("Your_URI");
    });

    it("deve atribuir as roles DEFAULT_ADMIN_ROLE e MINTER_ROLE ao criador do contrato", async () => {
        const isAdmin = await tpftToken.hasRole(await tpftToken.DEFAULT_ADMIN_ROLE(), admin);
        const isMinter = await tpftToken.hasRole(await tpftToken.MINTER_ROLE(), admin);
        assert(isAdmin, "O criador do contrato não tem a role DEFAULT_ADMIN_ROLE");
        assert(isMinter, "O criador do contrato não tem a role MINTER_ROLE");
    });

    it("deve permitir que um minter cunhe tokens", async () => {
        const id = 1;
        const amount = 1000;
        await tpftToken.mint(otherAccount, id, amount, "0x0", { from: admin });
        const balance = await tpftToken.balanceOf(otherAccount, id);
        assert.equal(balance.toNumber(), amount, "Quantidade cunhada incorreta");
    });

    it("não deve permitir que contas não minters cunhem tokens", async () => {
        const id = 1;
        const amount = 1000;
        try {
            await tpftToken.mint(otherAccount, id, amount, "0x0", { from: otherAccount });
            assert.fail("A transação deveria ter falhado");
        } catch (error) {
            assert(error.toString().includes("revert"), "A transação não falhou por revert");
        }
    });

    it("deve permitir que um minter queime tokens", async () => {
        const id = 1;
        const amount = 1000;
        await tpftToken.mint(otherAccount, id, amount, "0x0", { from: admin });
        await tpftToken.burn(otherAccount, id, amount, { from: admin });

        const finalBalance = await tpftToken.balanceOf(otherAccount, id);
        assert.equal(finalBalance.toNumber(), 0, "Tokens não foram queimados corretamente");
    });

    it("não deve permitir que contas não minters queimem tokens", async () => {
        const id = 1;
        const amount = 1000;
        await tpftToken.mint(otherAccount, id, amount, "0x0", { from: admin });
        try {
            await tpftToken.burn(otherAccount, id, amount, { from: otherAccount });
            assert.fail("A transação deveria ter falhado");
        } catch (error) {
            assert(error.toString().includes("revert"), "A transação não falhou por revert");
        }
    });
});
