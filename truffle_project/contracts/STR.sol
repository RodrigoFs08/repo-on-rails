// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";

interface IDREXToken {
    function mint(address to, uint256 amount) external;
    function burn(address from, uint256 amount) external;
}

interface ExchangeContract {
    function exchangeDrexForTpft(address from, address to, uint256 drexAmount, uint256 tpftTokenId, uint256 tpftAmount) public
}

contract STR is AccessControl {
    // Definindo os papeis dentro do sistema
    bytes32 public constant BANCO_CENTRAL_ROLE = keccak256("BANCO_CENTRAL_ROLE");
    bytes32 public constant STN_ROLE = keccak256("STN_ROLE");
    bytes32 public constant PARTICIPANTE_ROLE = keccak256("PARTICIPANTE_ROLE");
    
    IDREXToken public drexToken;

    // O construtor configura o criador do contrato como Banco Central
    constructor(address _drexTokenAddress) {
        _grantRole(BANCO_CENTRAL_ROLE, msg.sender);
         drexToken = IDREXToken(_drexTokenAddress);

    }

    // Funcao para adicionar um novo participante
    function adicionarParticipante(address conta) public {
        require(hasRole(BANCO_CENTRAL_ROLE, msg.sender), "STR: Somente o Banco Central pode adicionar participantes");
        _grantRole(PARTICIPANTE_ROLE, conta);
    }

    // Funcao para remover um participante
    function removerParticipante(address conta) public {
        require(hasRole(BANCO_CENTRAL_ROLE, msg.sender), "STR: Somente o Banco Central pode remover participantes");
        _revokeRole(PARTICIPANTE_ROLE, conta);
    }

    // Funcao para adicionar a STN
    function adicionarSTN(address conta) public {
        require(hasRole(BANCO_CENTRAL_ROLE, msg.sender), "STR: Somente o Banco Central pode adicionar STN");
        _grantRole(STN_ROLE, conta);
    }

    // Funcao para remover a STN
    function removerSTN(address conta) public {
        require(hasRole(BANCO_CENTRAL_ROLE, msg.sender), "STR: Somente o Banco Central pode remover STN");
        _revokeRole(STN_ROLE, conta);
    }

        // Permitir que participantes solicitem mint de DREX
    function solicitarMintDrex(uint256 amount) public {
        require(hasRole(PARTICIPANTE_ROLE, msg.sender), "STR: Somente participantes podem solicitar mint");
        drexToken.mint(msg.sender, amount);
    }

    // Permitir que participantes solicitem burn de DREX
    function solicitarBurnDrex(uint256 amount) public {
        require(hasRole(PARTICIPANTE_ROLE, msg.sender), "STR: Somente participantes podem solicitar burn");
        drexToken.burn(msg.sender, amount);
    }
    
}
