//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Contracto {
    uint256 public num;

    address public creator;

    constructor(uint _num){
        num = _num;
        creator = msg.sender;
    }

    function transferirPropiedad(address nuevoCreador) public {
        if (msg.sender != creator) {
            revert("No puedes modificar el contrato");
        }
        creator = nuevoCreador;
    }

    function nuevoNum (uint _num) public {
        num = _num;
        if (num >=1000) {
            revert("num no puede ser mayor a 1000");
        }
        if (msg.sender != creator) {
            revert ("No eres el creador del contrato");
        }
    }
}