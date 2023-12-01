// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TPFtToken is ERC1155, Ownable {
    address private authorizedWallet;

    constructor(string memory uri) ERC1155(uri) Ownable(msg.sender) {}

    function setAuthorizedWallet(address _wallet) public onlyOwner {
        authorizedWallet = _wallet;
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public {
        require(
            msg.sender == owner() || msg.sender == authorizedWallet,
            "Not authorized"
        );
        _mint(account, id, amount, data);
    }

    function burn(address account, uint256 id, uint256 amount) public {
        require(
            msg.sender == owner() || msg.sender == authorizedWallet,
            "Not authorized"
        );
        _burn(account, id, amount);
    }
}
