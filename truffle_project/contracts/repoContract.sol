// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract OperacoesCompromissadas is AccessControl {
    IERC20 public drexToken;
    IERC20 public tpftToken;
    
    struct Operacao {
        address emprestador;
        address tomador;
        uint256 quantidadeDrex;
        uint256 quantidadeTpft;
        bool ativa;
    }

    mapping(uint256 => Operacao) public operacoes;
    uint256 public proximaOperacaoId;

    bytes32 public constant PARTICIPANTE_ROLE = keccak256("PARTICIPANTE_ROLE");

    constructor(address _drexToken, address _tpftToken) {
        drexToken = IERC20(_drexToken);
        tpftToken = IERC20(_tpftToken);
    }

    function iniciarOperacao(address tomador, uint256 quantidadeDrex, uint256 quantidadeTpft) public onlyRole(PARTICIPANTE_ROLE) {
        require(drexToken.balanceOf(msg.sender) >= quantidadeDrex, "OperacoesCompromissadas: Saldo insuficiente de DREX");

        drexToken.transferFrom(msg.sender, address(this), quantidadeDrex);
        tpftToken.transferFrom(tomador, address(this), quantidadeTpft);

        operacoes[proximaOperacaoId] = Operacao(msg.sender, tomador, quantidadeDrex, quantidadeTpft, true);
        proximaOperacaoId++;
    }

    function finalizarOperacao(uint256 operacaoId) public {
        Operacao storage operacao = operacoes[operacaoId];

        require(operacao.ativa, "OperacoesCompromissadas: Operacao inativa ou inexistente");
        require(operacao.emprestador == msg.sender || operacao.tomador == msg.sender, "OperacoesCompromissadas: Nao autorizado");

        drexToken.transfer(operacao.tomador, operacao.quantidadeDrex);
        tpftToken.transfer(operacao.emprestador, operacao.quantidadeTpft);
        
        operacao.ativa = false;
    }

}
