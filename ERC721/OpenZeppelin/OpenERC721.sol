//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721URIStorage, Ownable {

    uint256 private _tokenId;

    mapping(address => bool) public isAdmin;

    event AdminAdded(address indexed admin);
    event AdminRemoved(address indexed admin);

    constructor(string memory name_, string memory symbol_) 
        ERC721(name_, symbol_) 
        Ownable(msg.sender)
    {
        isAdmin[msg.sender] = true; 
    }

    modifier onlyAdminOrOwner() {
        require(owner() == msg.sender || isAdmin[msg.sender], "Not Authorized");
        _;
    }

    function mint(address to, string memory uri) public onlyAdminOrOwner {
        _safeMint(to, _tokenId);
        _setTokenURI(_tokenId, uri);
        _tokenId++; 
    }

    function addAdmin(address user) public onlyOwner {
        require(user != address(0), "Invalid address");
        require(!isAdmin[user], "Already admin");
        
        isAdmin[user] = true;
        emit AdminAdded(user);
    }

    function removeAdmin(address user) public onlyOwner {
        require(isAdmin[user], "Not Admin");
        
        isAdmin[user] = false;
        emit AdminRemoved(user);
    }

    function transferOwnership(address newOwner) public override onlyOwner {
        require(newOwner != address(0), "Invalid address");
        address oldOwner = owner();
        
        isAdmin[oldOwner] = false;
        isAdmin[newOwner] = true;
        
        super.transferOwnership(newOwner);
    }
}