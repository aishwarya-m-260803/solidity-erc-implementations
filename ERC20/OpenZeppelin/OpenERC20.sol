// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyTokenOZ is ERC20, Ownable {

    mapping(address => bool) public isAdmin;

    event AdminAdded(address indexed admin);
    event AdminRemoved(address indexed admin);

    constructor(string memory name, string memory symbol) 
        ERC20(name, symbol) 
        Ownable(msg.sender) 
    {   
        isAdmin[msg.sender] = true;
        _mint(msg.sender, 1000 * (10 ** decimals()));
    }

    modifier onlyAdminOrOwner() {
        require(msg.sender == owner() || isAdmin[msg.sender], "Not Admin or Owner");
        _;
    }

    function mint(address to, uint256 amount) public onlyAdminOrOwner {
        require(to != address(0), "Invalid address");
        _mint(to, amount);
    }

    function addAdmin(address user) public onlyOwner {
        require(user != address(0), "Invalid address");
        require(!isAdmin[user], "Already admin");

        isAdmin[user] = true;
        emit AdminAdded(user);
    }

    function removeAdmin(address user) public onlyOwner {
        require(isAdmin[user], "Not admin");
        require(user != address(0), "Invalid address");

        isAdmin[user] = false;
        emit AdminRemoved(user);
    }

    function renounceOwnership() public override onlyOwner{
        isAdmin[msg.sender]=false;
        super.renounceOwnership();
    }

    function transferOwnership(address newOwner) public override onlyOwner{
        require(newOwner != address(0), "Invalid address");
        address oldOwner = owner();
        isAdmin[oldOwner] = false;
        isAdmin[newOwner] = true;
        super.transferOwnership(newOwner);
    }
}