const STR = artifacts.require("STR");
const DrexTokenMock = artifacts.require("DREXToken");
console.log('aqui')

contract("STR", (accounts) => {
    const bancoCentral = accounts[0];
    const participante = accounts[1];
    const stn = accounts[2];
    const terceiro = accounts[3];
    let str_contract;
    let drexTokenMock;

    beforeEach(async () => {
        drexTokenMock = await DrexTokenMock.new("Real Digital", "DREX",{ from: bancoCentral });
        str_contract = await STR.new(drexTokenMock.address, { from: bancoCentral });
        p = await str_contract.PARTICIPANTE_ROLE();
        p_stn = await str_contract.STN_ROLE()
    });

    it("deve atribuir o papel de Banco Central ao criador", async () => {
        const eBancoCentral = await str_contract.hasRole(await str_contract.BANCO_CENTRAL_ROLE(), bancoCentral);
        assert(eBancoCentral, "Criador não é o Banco Central");
    });

    it("deve permitir que o Banco Central adicione um participante", async () => {
        await str_contract.adicionarParticipante(participante, { from: bancoCentral });
        const eParticipante = await str_contract.hasRole(p, participante);
        assert(eParticipante, "Participante não foi adicionado corretamente");
    });

    it("não deve permitir que um terceiro adicione um participante", async () => {
        try {
            await str_contract.adicionarParticipante(participante, { from: terceiro });
            assert.fail("Terceiro não deveria poder adicionar um participante");
        } catch (error) {
            assert(error.message.includes("STR: Somente o Banco Central pode adicionar participantes"), "Erro inesperado ao adicionar participante");
        }
    });

    // Teste de Remover Participante
    it("deve permitir que o Banco Central remova um participante", async () => {
        await str_contract.adicionarParticipante(participante, { from: bancoCentral });
        await str_contract.removerParticipante(participante, { from: bancoCentral });
        const eParticipante = await str_contract.hasRole(p, participante);
        assert(!eParticipante, "Participante não foi removido corretamente");
    });

    it("não deve permitir que um terceiro remova um participante", async () => {
        await str_contract.adicionarParticipante(participante, { from: bancoCentral });
        try {
            await str_contract.removerParticipante(participante, { from: terceiro });
            assert.fail("Terceiro não deveria poder remover um participante");
        } catch (error) {
            assert(error.message.includes("STR: Somente o Banco Central pode remover participantes"), "Erro inesperado ao remover participante");
        }
    });

    // Teste de Adicionar STN
    it("deve permitir que o Banco Central adicione a STN", async () => {
        await str_contract.adicionarSTN(stn, { from: bancoCentral });
        const eSTN = await str_contract.hasRole(p_stn, stn);
        assert(eSTN, "STN não foi adicionada corretamente");
    });

    it("não deve permitir que um terceiro adicione a STN", async () => {
        try {
            await str_contract.adicionarSTN(stn, { from: terceiro });
            assert.fail("Terceiro não deveria poder adicionar a STN");
        } catch (error) {
            assert(error.message.includes("STR: Somente o Banco Central pode adicionar STN"), "Erro inesperado ao adicionar STN");
        }
    });

    // Teste de Remover STN
    it("deve permitir que o Banco Central remova a STN", async () => {
        await str_contract.adicionarSTN(stn, { from: bancoCentral });
        await str_contract.removerSTN(stn, { from: bancoCentral });
        const eSTN = await str_contract.hasRole(p_stn, stn);
        assert(!eSTN, "STN não foi removida corretamente");
    });

    it("não deve permitir que um terceiro remova a STN", async () => {
        await str_contract.adicionarSTN(stn, { from: bancoCentral });
        try {
            await str_contract.removerSTN(stn, { from: terceiro });
            assert.fail("Terceiro não deveria poder remover a STN");
        } catch (error) {
            assert(error.message.includes("STR: Somente o Banco Central pode remover STN"), "Erro inesperado ao remover STN");
        }
    });

    // Teste para função de solicitar mint de DREX
    it("deve permitir que um participante solicite mint de DREX", async () => {
        await drexTokenMock.setAuthorizedWallet(str_contract.address);
        await str_contract.adicionarParticipante(participante, { from: bancoCentral });
        await str_contract.solicitarMintDrex(100, { from: participante });
        const balance = await drexTokenMock.balanceOf(participante);
        assert.equal(balance.toNumber(), 100, "Mint de DREX não foi realizado corretamente");
    });

    // Teste para verificar se não-participantes não podem solicitar mint de DREX
    it("não deve permitir que um não-participante solicite mint de DREX", async () => {
        try {
            await str_contract.solicitarMintDrex(100, { from: terceiro });
            assert.fail("Não-participante não deveria poder solicitar mint de DREX");
        } catch (error) {
            assert(error.message.includes("Somente participantes podem solicitar mint"), "Erro inesperado ao solicitar mint de DREX");
        }
    });

    // Teste para função de solicitar burn de DREX
    it("deve permitir que um participante solicite burn de DREX", async () => {
        await drexTokenMock.setAuthorizedWallet(str_contract.address);
        await str_contract.adicionarParticipante(participante, { from: bancoCentral });
        await str_contract.solicitarMintDrex(100, { from: participante });
        await str_contract.solicitarBurnDrex(50, { from: participante });
        const balance = await drexTokenMock.balanceOf(participante);
        assert.equal(balance.toNumber(), 50, "Burn de DREX não foi realizado corretamente");
    });

    // Teste para verificar se não-participantes não podem solicitar burn de DREX
    it("não deve permitir que um não-participante solicite burn de DREX", async () => {
        try {
            await str_contract.solicitarBurnDrex(50, { from: terceiro });
            assert.fail("Não-participante não deveria poder solicitar burn de DREX");
        } catch (error) {
            assert(error.message.includes("Somente participantes podem solicitar burn"), "Erro inesperado ao solicitar burn de DREX");
        }
    });

});

