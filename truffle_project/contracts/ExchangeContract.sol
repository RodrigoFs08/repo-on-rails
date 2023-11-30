// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract ExchangeContract is AccessControl {
    IERC20 public drexToken;
    IERC1155 public tpftToken;
    
    bytes32 public constant BANCO_CENTRAL_ROLE = keccak256("BANCO_CENTRAL_ROLE");

    constructor(address _drexToken, address _tpftToken, address strAddress) {
        drexToken = IERC20(_drexToken);
        tpftToken = IERC1155(_tpftToken);
        
        // Configurando o papel do Banco Central
        _grantRole(BANCO_CENTRAL_ROLE, strAddress);
    }

    // Trocar DREX por TPFt entre participantes
    function exchangeDrexForTpft(address from, address to, uint256 drexAmount, uint256 tpftTokenId, uint256 tpftAmount) public onlyRole(BANCO_CENTRAL_ROLE) {
        require(drexToken.balanceOf(from) >= drexAmount, "ExchangeContract: Saldo insuficiente de DREX");
        require(tpftToken.balanceOf(to, tpftTokenId) >= tpftAmount, "ExchangeContract: Saldo insuficiente de TPFt");

        drexToken.transferFrom(from, to, drexAmount);
        tpftToken.safeTransferFrom(to, from, tpftTokenId, tpftAmount, "");
    }

}
