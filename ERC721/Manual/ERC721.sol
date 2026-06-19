//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

interface IERC721Receiver{
        function onERC721Received(
            address operator,
            address from,
            uint256 tokenId,
            bytes calldata data
        )external returns(bytes4);
    }

contract MyERC721{
    string public name;
    string public symbol;
    address public owner;

    mapping(uint256 => address) private  _owners; 
    mapping(address => uint256) public _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => bool) public isAdmin;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event AdminAdded(address indexed admin);
    event AdminRemoved(address indexed admin);
    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    constructor (string memory _name, string memory _symbol){
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
        isAdmin[msg.sender] = true;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Not Owner");
        _;
    }

    modifier onlyAdminOrOwner(){
        require(msg.sender == owner || isAdmin[msg.sender], "Not Admin or Owner");
        _;
    }

    function _checkOnERC721Received(
        address operator,
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal returns (bool) {
        if (_isContract(to)) {
            try IERC721Receiver(to).onERC721Received(
                operator,
                from,
                tokenId,
                data
            ) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch {
                return false;
            }
        } else {
            return true;
        }
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Not allowed");
        require(ownerOf(tokenId) == from, "Not owner");
        _requireValidAddress(to);

        _transfer(from, to, tokenId);

        require(
            _checkOnERC721Received(msg.sender, from, to, tokenId, data),
            "Receiver not implemented"
        );
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        safeTransferFrom(from, to, tokenId, "");
    }

    function _isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    function _requireMinted(uint256 tokenId) internal view {
        require(_owners[tokenId] != address(0), "Token does not exist");
    }

    function _requireValidAddress(address user) internal pure{
        require(user != address(0), "Invalid address");
    }

    function balanceOf(address owner) public view returns (uint256) {
        _requireValidAddress(owner);
        return _balances[owner];
    }

        function ownerOf(uint256 tokenId)public view returns(address){
            _requireMinted(tokenId);
            return _owners[tokenId];
        }

    function mint(address to, uint256 tokenId) public onlyAdminOrOwner {
        require(_owners[tokenId] == address(0), "Already minted");
        _requireValidAddress(to);

        _owners[tokenId] = to;
        _balances[to]++;

        emit Transfer(address(0), to, tokenId);
    }

    function getApproved(uint256 tokenId) public view returns(address){
        _requireMinted(tokenId);
        return _tokenApprovals[tokenId];
    }

    function approve(address to, uint256 tokenId) public{
        address owner = ownerOf(tokenId);

        require(
            msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "Not authorized"
        );
        require( to != owner , "Cannot approve yourself");

        _tokenApprovals[tokenId] = to;

        emit Approval(owner, to, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId)public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Not allowed");
        require(ownerOf(tokenId) == from, "Not owner");
        _requireValidAddress(to);

        _transfer(from, to, tokenId);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId)internal view returns (bool){
        address owner = ownerOf(tokenId);

        return (
            spender == owner ||
            getApproved(tokenId) == spender ||
            isApprovedForAll(owner, spender)
        );
    }

    function _transfer(address from, address to, uint256 tokenId)internal{
        delete _tokenApprovals[tokenId];
        require(ownerOf(tokenId) == from, "Transfer from incorrect owner");

        _balances[from]--;
        _balances[to]++;
        _owners[tokenId] = to;  

        emit Transfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
        return
            interfaceId == 0x80ac58cd || // ERC721
            interfaceId == 0x01ffc9a7;   // ERC165
    }

    function addAdmin(address user) public onlyOwner{
        _requireValidAddress(user);
        require(!isAdmin[user], "Already Admin");

        isAdmin[user] = true;
        emit AdminAdded(user);
    }

    function removeAdmin(address user)public onlyOwner{
        require(isAdmin[user], "Not an admin");

        isAdmin[user]=false;
        emit AdminRemoved(user);
    }

    function transferOwnership(address newOwner) public onlyOwner{
        _requireValidAddress(newOwner);

        address oldOwner = owner;

        isAdmin[oldOwner] = false;
        isAdmin[newOwner] = true;

        owner = newOwner;

        emit OwnershipTransferred(oldOwner, newOwner);
    }

    function setApprovalForAll(address operator, bool approved) public{
        _requireValidAddress(operator);
        require(operator != msg.sender, "Cannot approve yourself");
        _operatorApprovals[msg.sender][operator] = approved;

        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address owner, address operator) public view returns (bool){
        return _operatorApprovals[owner][operator];
    }
}