//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

interface IERC20{

    //getters
    function totalSupply() external view returns(uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    //functions
    function transfer(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256);
}

contract DioCoin is IERC20{

    string public constant name = "Dio Coin";
    string public constant symbol = "Dio";
    uint public constant decimals = 18;

    mapping (address => uint256) balance;

    mapping (address => mapping(address=>uint256)) allowed;

    uint256 totalSupply_ = 10 ether;

    constructor(){
        balance[msg.sender] = totalSupply_;
    }

    function totalSupply() public override view returns (uint256){
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256){
        return balance[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balance[msg.sender]);
        balance[msg.sender] = balance[msg.sender]-numTokens;
        balance[receiver] = balance[receiver]+numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool){
        require(numTokens <= balance[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balance[owner] = balance[owner]-numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balance[buyer] = balance[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }


}
