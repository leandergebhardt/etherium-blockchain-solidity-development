pragma solidity 0.8.13;

import './Owned.sol';

contract Allowance is Owned{

    event AllowanceChanged(address indexed _forWho, address indexed _romWhom, uint _oldAmount, uint _newAmount);
    mapping(address => uint) public allowance;

    function addAllowance(address _who, uint _amount) public isOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }

    modifier ownerOrAllowed(uint _amount) {
        require(isOwned(msg.sender) || allowance[msg.sender] >= _amount, "You are not allowed");
        _;
    }

    function reduceAllowance(address _who ,uint _amount) internal {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who] - _amount);
        allowance[_who] -= _amount; 
    }
}

contract SimpleWallet is Allowance{

    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "There are not enough funds stored in the smart contract");
        if(!isOwned(msg.sender)) {
            reduceAllowance(msg.sender, _amount);
        }
        _to.transfer(_amount);
    }
}