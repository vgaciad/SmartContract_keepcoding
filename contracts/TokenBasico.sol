// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract TokenAntonio{
    string public nombre ="Token Antonio";
    string public simbolo = "TKA";
    uint8 public decimales = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed  to, uint256);

    constructor (uint256 suministroInicial){
        totalSupply = suministroInicial * 10 * decimales;
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender,totalSupply);
    }

    function transfer(address to, uint256 cantidad) public returns (bool){
        require(to !=address(0), " No puedes enviar a el address 0");
        require(balanceOf[msg.sender] >= cantidad, "Balance insuficiente");

        balanceOf[msg.sender] -= cantidad;
        balanceOf[to]+= cantidad;

        emit Transfer(msg.sender, to, cantidad);
        return true;

    }
}