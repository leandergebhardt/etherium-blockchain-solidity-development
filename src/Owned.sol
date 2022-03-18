pragma solidity ^0.8;

contract Owned {
    address owner;

    constructor () {
        owner = msg.sender;
    }

    modifier isOwner() {
        require(msg.sender == owner, "You are not the Owner!");
        _;
    }

    function isOwned(address _addressToTest) public view returns(bool){
        if(_addressToTest == owner) {
            return true;
        } else {
            return false;
        }

    }
}