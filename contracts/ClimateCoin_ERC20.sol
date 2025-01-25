//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ClimateCoin {
    // Variables
    string constant public name = "ClimateCoin";
    string constant public symbol = "CCC";
    uint8 constant public decimals = 0;     // Sin decimales, para que sea intercambiable por los créditos de carbono
   // uint256 constant public totalSupply = 10e5; // Emitimos 1 millón de ClimateCoin
    uint256  public totalSupply = 0; // Para poder emitir nuevos ClimateCoin
    mapping(address => uint256) public balanceOf;
    mapping (address=> mapping (address => uint256)) public allowance;
    address immutable private tokenCreator;
    
    //Eventos
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    // Error
    error OverFunds(uint256 available, uint256 requested);
    
    // Constructor
    constructor() {
        tokenCreator = msg.sender;
    }

    // Funciones

    // Emision de tokens
    function mint (uint amount) public {

        if (msg.sender != tokenCreator){
            revert("No eres el creador");
        }

        balanceOf[msg.sender] += amount;
        totalSupply +=amount;
            
        emit Transfer(address(0), msg.sender, amount);
    }

    // Quema de tokens
    function burn (uint amount) public  {
        balanceOf [msg.sender] -=amount;
        totalSupply -= amount;
        emit Transfer (msg.sender, address(0), amount);
    }

    function _transfer (address _from, address _to, uint256 _value) private {
        if (balanceOf[_from]<_value){
            revert OverFunds(balanceOf[msg.sender],_value);
        }
        balanceOf [_from] -= _value;
        balanceOf [_to] += _value;

        emit Transfer(_from, _to, _value);    
    }

    function transfer (address _to, uint256 _value) public returns(bool){
      _transfer(msg.sender,_to,_value);
      return true;
    }    

    function approve(address _spender, uint256 _value) public returns (bool success){
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
        allowance[_from][msg.sender] -= _value;
        _transfer (_from,_to,_value);

        return true;
    }

} 