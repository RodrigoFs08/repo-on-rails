// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";

interface IDREXToken {
    function mint(address to, uint256 amount) external;

    function burn(address from, uint256 amount) external;

    function balanceOf(address account) external view returns (uint256);
}

interface IExchangeContract {
    function exchangeDrexForTpft(
        address from,
        address to,
        uint256 drexAmount,
        uint256 tpftTokenId,
        uint256 tpftAmount
    ) external;
}

contract STR is AccessControl, AutomationCompatible {
    // Definindo os papeis dentro do sistema
    bytes32 public constant BANCO_CENTRAL_ROLE =
        keccak256("BANCO_CENTRAL_ROLE");
    bytes32 public constant STN_ROLE = keccak256("STN_ROLE");
    bytes32 public constant PARTICIPANTE_ROLE = keccak256("PARTICIPANTE_ROLE");

    IDREXToken public drexToken;
    IExchangeContract public exchangeContract;

    struct OperacaoCompromissada {
        uint256 quantidadeDrex;
        uint256 idTpft;
        uint256 quantidadeTpft;
        address tomador;
        address credor;
        uint256 prazo;
        uint256 taxaAnual;
        uint256 dataInicio;
        bool ativa;
    }

    OperacaoCompromissada[] public operacoesCompromissadas;

    // O construtor configura o criador do contrato como Banco Central
    constructor(address _drexTokenAddress, address _exchangeContractAdress) {
        _grantRole(BANCO_CENTRAL_ROLE, msg.sender);
        drexToken = IDREXToken(_drexTokenAddress);
        exchangeContract = IExchangeContract(_exchangeContractAdress);
    }

    // Funcao para adicionar um novo participante
    function adicionarParticipante(address conta) public {
        require(
            hasRole(BANCO_CENTRAL_ROLE, msg.sender),
            "STR: Somente o Banco Central pode adicionar participantes"
        );
        _grantRole(PARTICIPANTE_ROLE, conta);
    }

    // Funcao para remover um participante
    function removerParticipante(address conta) public {
        require(
            hasRole(BANCO_CENTRAL_ROLE, msg.sender),
            "STR: Somente o Banco Central pode remover participantes"
        );
        _revokeRole(PARTICIPANTE_ROLE, conta);
    }

    // Funcao para adicionar a STN
    function adicionarSTN(address conta) public {
        require(
            hasRole(BANCO_CENTRAL_ROLE, msg.sender),
            "STR: Somente o Banco Central pode adicionar STN"
        );
        _grantRole(STN_ROLE, conta);
    }

    // Funcao para remover a STN
    function removerSTN(address conta) public {
        require(
            hasRole(BANCO_CENTRAL_ROLE, msg.sender),
            "STR: Somente o Banco Central pode remover STN"
        );
        _revokeRole(STN_ROLE, conta);
    }

    // Permitir que participantes solicitem mint de DREX
    function solicitarMintDrex(uint256 amount) public {
        require(
            hasRole(PARTICIPANTE_ROLE, msg.sender),
            "STR: Somente participantes podem solicitar mint"
        );
        drexToken.mint(msg.sender, amount);
    }

    // Permitir que participantes solicitem burn de DREX
    function solicitarBurnDrex(uint256 amount) public {
        require(
            hasRole(PARTICIPANTE_ROLE, msg.sender),
            "STR: Somente participantes podem solicitar burn"
        );
        drexToken.burn(msg.sender, amount);
    }

    function criarOperacaoCompromissada(
        uint256 _quantidadeDrex,
        uint256 _idTpft,
        uint256 _quantidadeTpft,
        address _tomador,
        address _credor,
        uint256 _prazo,
        uint256 _taxaAnual
    ) public {
        require(
            hasRole(BANCO_CENTRAL_ROLE, msg.sender),
            "STR: Somente o Banco Central pode incluir operacoes compromissadas"
        );

        OperacaoCompromissada memory novaOperacao = OperacaoCompromissada({
            quantidadeDrex: _quantidadeDrex,
            idTpft: _idTpft,
            quantidadeTpft: _quantidadeTpft,
            tomador: _tomador,
            credor: _credor,
            prazo: _prazo,
            taxaAnual: _taxaAnual,
            dataInicio: block.timestamp,
            ativa: true
        });
        operacoesCompromissadas.push(novaOperacao);

        exchangeContract.exchangeDrexForTpft(
            _credor,
            _tomador,
            _quantidadeDrex,
            _idTpft,
            _quantidadeTpft
        );
    }

    function calcularTaxa(
        uint256 quantidade,
        uint256 taxaAnual,
        uint256 prazo
    ) internal pure returns (uint256) {
        // Calcula a taxa proporcional ao período da operação
        // A taxa anual é convertida para uma taxa proporcional ao prazo
        // Assumindo que o prazo está em segundos, e o ano tem 365.25 dias (incluindo anos bissextos)
        uint256 taxaPrazo = (taxaAnual * prazo) / (365.25 * 24 * 60 * 60);
        return (quantidade * taxaPrazo) / 100;
    }


function calcularTaxa(uint256 quantidade, uint256 taxaAnual, uint256 prazo) internal pure returns (uint256) {
    // Calcula a taxa proporcional ao período da operação
    // A taxa anual é convertida para uma taxa proporcional ao prazo
    // Assumindo que o prazo está em segundos, e o ano tem 365.25 dias (incluindo anos bissextos)
    prazoSegundos = 1 * 24*60*60
    uint256 taxaPrazo = ((taxaAnual/100)+1) ^ (prazoSegundos/(252 * 24 * 60 * 60))
    return quantidade * taxaPrazo / 100;
}


    function checkUpkeep(
        bytes calldata
    ) external view override returns (bool upkeepNeeded, bytes memory performData) {
        upkeepNeeded = false;
        performData = "";
        for (uint i = 0; i < operacoesCompromissadas.length; i++) {
            if (
                operacoesCompromissadas[i].ativa &&
                block.timestamp >=
                operacoesCompromissadas[i].dataInicio +
                    operacoesCompromissadas[i].prazo
            ) {
                upkeepNeeded = true;
                break;
            }
        }
    }

    function performUpkeep(bytes calldata) external override {
        for (uint256 i = 0; i < operacoesCompromissadas.length; i++) {
            OperacaoCompromissada storage operacao = operacoesCompromissadas[i];
            if (
                operacao.ativa &&
                block.timestamp >= operacao.dataInicio + operacao.prazo
            ) {
                uint256 taxa = calcularTaxa(
                    operacao.quantidadeDrex,
                    operacao.taxaAnual,
                    operacao.prazo
                );
                uint256 quantidadeTotalDrex = operacao.quantidadeDrex + taxa;

                // Verifica se o credor tem fundos suficientes de DREX
                if (
                    drexToken.balanceOf(operacao.credor) >= quantidadeTotalDrex
                ) {
                    // Executar a recompra com taxa aplicada
                    exchangeContract.exchangeDrexForTpft(
                        operacao.tomador,
                        operacao.credor,
                        quantidadeTotalDrex,
                        operacao.idTpft,
                        operacao.quantidadeTpft
                    );
                }

                // Fechar a operação independentemente da disponibilidade de fundos
                operacao.ativa = false;
            }
        }
    }
}
