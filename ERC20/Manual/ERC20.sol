// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MyToken {

    string public name;
    string public symbol;
    uint8 public decimals = 18;

    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => bool) public isAdmin;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event AdminAdded(address indexed admin);
    event AdminRemoved(address indexed admin);
    event OwnershipTransferred(address indexed oldOwner,  address indexed newOwner);

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;

        owner = msg.sender;

        uint256 supply = 1000 * (10 ** decimals);
        totalSupply = supply;
        balanceOf[msg.sender] = supply;

        emit Transfer(address(0), msg.sender, supply);
    }

    function _checkBalance(address user, uint256 value) internal view {
        require(balanceOf[user] >= value, "Insufficient balance");
    }

    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0), "Invalid address");

        _checkBalance(from, value);

        balanceOf[from] -= value;
        balanceOf[to] += value;

        emit Transfer(from, to, value);
    }

    function transfer(address to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0), "Invalid address");

        allowance[msg.sender][spender] = value;

        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {

        uint256 allowed = allowance[from][msg.sender];
        require(allowed >= value, "Allowance exceeded");

        _transfer(from, to, value);

        allowance[from][msg.sender] = allowed - value;

        return true;
    }

    modifier onlyOwner(){
        require(msg.sender == owner,"Not owner");
        _;
    }

    modifier onlyAdmin(){
        require(msg.sender == owner || isAdmin[msg.sender], "Not Admin or Owner");
        _;
    }

    function mint(address to, uint256 value) public onlyAdmin returns (bool){
        require(to != address(0),"Invalid address");

        totalSupply += value;
        balanceOf[to] += value;

        emit Transfer(address(0), to, value);
        return true;

    }

    function transferOwnership(address newOwner) public onlyOwner{
        require(newOwner != address(0), "Invalid address");

        address oldOwner = owner;

        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);

    }

    function addAdmin(address user) public onlyOwner{
        require(user != address(0), "Invalid Address");
        require(!isAdmin[user], "Already admin");

        isAdmin[user] = true;
        emit AdminAdded(user);

    }

    function removeAdmin(address user) public onlyOwner{
        require(isAdmin[user], "Not Admin ");

        isAdmin[user] = false;
        emit AdminRemoved(user);
    }
}



























