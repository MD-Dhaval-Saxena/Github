// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;


contract Staking{
    uint stakingReward;
    uint public LockUpAmount;
    uint LockstartTime;
    uint LockEndTime;
    mapping(address=>uint) public stakingBal;
    function AddToPool() public payable{
        payable(address(this)).transfer(msg.value);
    }

    function StakToken() public payable{
        require(msg.value > 2 ether,"Staking amount Should be more than 2 Ether");

        stakingBal[msg.sender]=msg.value;
        LockUpAmount+=msg.value / 1 ether;

        // payable(address(this)).transfer(amount * 1 ether);
        payable(address(this)).transfer(msg.value);

    }

    function RewardAdd() public{

    }

    function withdrawAmt(uint amount) public payable {
    // function withdrawAmt() public view returns(uint){
        require(amount <= stakingBal[msg.sender] / 1 ether,"Amount is Not Valid,Try again!");
        payable(msg.sender).transfer(amount * 1 ether);
        LockUpAmount -=amount;
        // return stakingBal[msg.sender];


    }

    receive() external payable {}

    function getContractBal() public view returns(uint){
        return address(this).balance / 1 ether;
    }


}