// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract Bank{
    // Check the msg.owner fd amount and than withdraw because smart contract --
    //                 contains all fdowners value
    constructor() {
        owner=msg.sender;
    }

    address private owner;
    address private fdOwner;
    mapping(address=>uint256)  accounts;
    mapping(address=>bool) public CheckAccount;
    mapping(address=>uint256) public fdAmount;
    uint public fdStartTime; //1676136051  Saturday, February 11, 2023 10:50:51 PM
    uint public fdEndTIme; // 1676913651  Monday, February 20, 2023 10:50:51 PM
    mapping(address=>bool)  blockedAcc;
    uint fees=0.00005 ether;
    uint feesColl=0;

    
    function createAcc() public  {
        require(CheckAccount[msg.sender]==false,"Account Aleready Created Succefully");
        require(blockedAcc[msg.sender]==false,"You are blocked by the Owner");
        accounts[msg.sender]=msg.sender.balance;
        CheckAccount[msg.sender]=true;

    }

    function createFD() public payable {
        require(blockedAcc[msg.sender]==false,"You are blocked by the Owner");
        require(CheckAccount[msg.sender],"Create Account First");
        require(msg.value > 2 ether,"FD Amount Should be more than 2 Ether");
        require(msg.value < msg.sender.balance,"Value Should be Less Than Your Balance");
        payable(address(this)).transfer(0.00005 ether);
        payable(address(this)).transfer(msg.value);
        fdAmount[msg.sender]+=msg.value / 1 ether;
        fdStartTime=block.timestamp;
        
    }

    function DaysFd()public view returns(uint){
        return (fdEndTIme - fdStartTime ) / 60 / 60 / 24;
    }

    function getBalance(address _address) public view returns(uint256){
        require(CheckAccount[msg.sender],"Create Account First");
        require(blockedAcc[msg.sender]==false,"You are blocked by the Owner");
        return _address.balance / 1 ether;
    }

    function getFdAMount(address _add) public view returns(uint256){
        require(CheckAccount[msg.sender],"Create Account First");
        // require(msg.sender==owner,"Only Owner Can Access");
        // require(tx.origin==fdOwner,"Only Owner Can Access");
        return fdAmount[_add];
    }

    receive() external payable {}
    
    function getContractBal() public view returns(uint){
        require(blockedAcc[msg.sender]==false,"You are blocked by the Owner");
        return address(this).balance / 1 ether;

    }

    function WithdrawFD(uint256 amount) public payable {
        require(amount <= fdAmount[msg.sender] / 1 ether,"Amount is Not Valid,Try again!");
        require(CheckAccount[msg.sender],"Create Account First");
        require(blockedAcc[msg.sender]==false,"You are blocked by the Owner");
        // require(fdAmount[msg.sender] > amount * 1 ether,"Inserted Invalid fd Amount");
        require(amount <= address(this).balance,"Insuffiecent Funds for Withdrawal");
        payable(msg.sender).transfer(amount * 1 ether);
        fdAmount[msg.sender]-=msg.value / 1 ether;
        fdEndTIme=1676470061;
        // fdEndTIme=block.timestamp;

    }

    function CloseAcc() public{
        require(CheckAccount[msg.sender]==true,"Account Not Exist,Create Account First");
        require(blockedAcc[msg.sender]==false,"You are blocked by the Owner");
        CheckAccount[msg.sender]=false;
        delete accounts[msg.sender];

    }

// If after created the account user marked as blacklisted then account should be closed
    function BlockUsr(address _add) public {
        CloseAcc();
        require(msg.sender == owner,"Only Owner Has the Permission");
        blockedAcc[_add]=true;

    }
     function UnBlockUsr(address _add) public {
        require(msg.sender == owner,"Only Owner Has the Permission");
        blockedAcc[_add]=false;     
    }


}