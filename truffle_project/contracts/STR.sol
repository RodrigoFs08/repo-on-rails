// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract STR is AccessControl {
    // Definindo os papeis dentro do sistema
    bytes32 public constant BANCO_CENTRAL_ROLE = keccak256("BANCO_CENTRAL_ROLE");
    bytes32 public constant STN_ROLE = keccak256("STN_ROLE");
    bytes32 public constant PARTICIPANTE_ROLE = keccak256("PARTICIPANTE_ROLE");

    // O construtor configura o criador do contrato como Banco Central
    constructor() {
        _grantRole(BANCO_CENTRAL_ROLE, msg.sender);
    }

    // Funcao para adicionar um novo participante
    function adicionarParticipante(address conta) public {
        require(hasRole(BANCO_CENTRAL_ROLE, msg.sender), "STR: Somente o Banco Central pode adicionar participantes");
        grantRole(PARTICIPANTE_ROLE, conta);
    }

    // Funcao para remover um participante
    function removerParticipante(address conta) public {
        require(hasRole(BANCO_CENTRAL_ROLE, msg.sender), "STR: Somente o Banco Central pode remover participantes");
        revokeRole(PARTICIPANTE_ROLE, conta);
    }

    // Funcao para adicionar a STN
    function adicionarSTN(address conta) public {
        require(hasRole(BANCO_CENTRAL_ROLE, msg.sender), "STR: Somente o Banco Central pode adicionar STN");
        grantRole(STN_ROLE, conta);
    }

    // Funcao para remover a STN
    function removerSTN(address conta) public {
        require(hasRole(BANCO_CENTRAL_ROLE, msg.sender), "STR: Somente o Banco Central pode remover STN");
        revokeRole(STN_ROLE, conta);
    }
}
