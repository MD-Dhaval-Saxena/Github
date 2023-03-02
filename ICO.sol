// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract myIco {

    struct InfoToken {
        IERC20 token;
        address owner;
        uint256 amount;
        uint256 startTIme;
        uint256 endTime;
        uint256 priceToken; //1000 token=1 eth
    }
    struct InvestorInfo{
        address owner;
        uint256 tokens;
        uint256 tokensValue;
    }

    mapping(uint256 => InfoToken) public icoInfo;
    mapping(address=>InvestorInfo) public invInfo;
    mapping(address=>uint256) public Investor;
    uint256 counter;
    uint256 public invAmount;

    function createIco(
        IERC20 _token,
        // address _owner,
        uint256 _amount,
        uint256 _startTIme,
        uint256 _endTime,
        uint256 _priceToken
    ) public {
        counter++;
        require(_startTIme > 0,"startTime is can't be zero");
        require(_endTime > _startTIme,"Endtime can't before Starttime");
        icoInfo[counter] =InfoToken(_token, msg.sender, _amount, _startTIme, _endTime, _priceToken);
    }

    function Invest(uint numICO,uint256 _amount)public payable {
        require(icoInfo[numICO].owner != address(0),"No Ico Found");
        require(block.timestamp >= icoInfo[numICO].startTIme,"Ico not started");
        require(block.timestamp <= icoInfo[numICO].endTime,"Ico was Ended");
        require(icoInfo[numICO].amount > 0,"All tokens sold");        
        require(_amount <= icoInfo[numICO].amount,"Tokens Not available");

        invAmount= _amount * icoInfo[numICO].priceToken;
        invInfo[msg.sender]=InvestorInfo(msg.sender,_amount,invAmount);
        icoInfo[numICO].amount-=_amount;

    }
    function Withdraw(uint numICO)public{



    }

}
