pragma solidity 0.8.13;

contract CodeChallenge {
    mapping(address => uint) public balance;
    mapping(address => bool) public adminList;

    constructor() {
        adminList[msg.sender] = true;
    }

    modifier onlyAdmins() {
        require(adminList[msg.sender], "Only for admins");
        _;
    }

    function depositMoney() public payable {
        balance[msg.sender] += msg.value;
        
    }

    function withdrawMoney(address payable _to, uint _amount) public payable onlyAdmins{
        require(balance[msg.sender] >= _amount, "Incufficient funds");
        balance[msg.sender] -= _amount;
        _to.transfer(_amount);
    }
    
    function withdrawAll(address payable _to) public payable onlyAdmins{
        require(balance[msg.sender] > 0, "You dont have any funds");
        
        uint maxAmount = balance[msg.sender];

        balance[msg.sender] = 0;
        _to.transfer(maxAmount);
    }

    function sendMoneyTo(address payable _to, uint _amount) public payable {
        require(balance[msg.sender] > 0, "You dont have any funds");
        balance[msg.sender] -= _amount;
        _to.transfer(_amount);
    }

    fallback() external payable {
        balance[msg.sender] += msg.value;
    }
}