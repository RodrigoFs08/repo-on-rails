// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ExchangeContract is Ownable {
    address private authorizedWallet;

    IERC20 public drexToken;
    IERC1155 public tpftToken;
    
    constructor(address _drexToken, address _tpftToken ) Ownable(msg.sender)
 {
        drexToken = IERC20(_drexToken);
        tpftToken = IERC1155(_tpftToken);
    }

    function setAuthorizedWallet(address _wallet) public onlyOwner {
        authorizedWallet = _wallet;
    }

    // Trocar DREX por TPFt entre participantes
    function exchangeDrexForTpft(address from, address to, uint256 drexAmount, uint256 tpftTokenId, uint256 tpftAmount) public  {
        require(msg.sender == owner() || msg.sender == authorizedWallet, "Not authorized");
        require(drexToken.balanceOf(from) >= drexAmount, "ExchangeContract: Saldo insuficiente de DREX");
        require(tpftToken.balanceOf(to, tpftTokenId) >= tpftAmount, "ExchangeContract: Saldo insuficiente de TPFt");


        drexToken.transferFrom(from, to, drexAmount);
        tpftToken.safeTransferFrom(to, from, tpftTokenId, tpftAmount, "0x0");
    }

}
