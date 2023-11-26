// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract ExchangeContract is AccessControl {
    IERC20 public drexToken;
    IERC20 public tpftToken;
    
    bytes32 public constant BANCO_CENTRAL_ROLE = keccak256("BANCO_CENTRAL_ROLE");

    constructor(address _drexToken, address _tpftToken, address strAddress) {
        drexToken = IERC20(_drexToken);
        tpftToken = IERC20(_tpftToken);
        
        // Configurando o papel do Banco Central
        _grantRole(BANCO_CENTRAL_ROLE, strAddress);
    }

    // Trocar DREX por TPFt entre participantes
    function exchangeDrexForTpft(address from, address to, uint256 drexAmount, uint256 tpftAmount) public onlyRole(BANCO_CENTRAL_ROLE) {
        require(drexToken.balanceOf(from) >= drexAmount, "ExchangeContract: Saldo insuficiente de DREX");
        require(tpftToken.balanceOf(to) >= tpftAmount, "ExchangeContract: Saldo insuficiente de TPFt");

        drexToken.transferFrom(from, to, drexAmount);
        tpftToken.transferFrom(to, from, tpftAmount);
    }

    // Trocar TPFt por DREX entre participantes
    function exchangeTpftForDrex(address from, address to, uint256 tpftAmount, uint256 drexAmount) public onlyRole(BANCO_CENTRAL_ROLE) {
        require(tpftToken.balanceOf(from) >= tpftAmount, "ExchangeContract: Saldo insuficiente de TPFt");
        require(drexToken.balanceOf(to) >= drexAmount, "ExchangeContract: Saldo insuficiente de DREX");

        tpftToken.transferFrom(from, to, tpftAmount);
        drexToken.transferFrom(to, from, drexAmount);
    }

}
