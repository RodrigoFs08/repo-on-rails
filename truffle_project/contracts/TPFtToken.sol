// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract TPFtToken is ERC1155, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor(string memory uri) ERC1155(uri) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data) public onlyRole(MINTER_ROLE) {
        _mint(account, id, amount, data);
    }

    function burn(address account, uint256 id, uint256 amount) public onlyRole(MINTER_ROLE) {
        _burn(account, id, amount);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

}
