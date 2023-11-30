// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DREXToken is ERC20, Ownable {
    address private authorizedWallet;

    constructor(string memory name, string memory symbol)
        ERC20(name, symbol)
        Ownable(msg.sender)
    {
    }

    function setAuthorizedWallet(address _wallet) public onlyOwner {
        authorizedWallet = _wallet;
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender == owner() || msg.sender == authorizedWallet, "Not authorized");
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public {
        require(msg.sender == owner() || msg.sender == authorizedWallet, "Not authorized");
        _burn(from, amount);
    }
}

