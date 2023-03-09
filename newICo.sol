// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./WinToken.sol";

contract ICO {
    constructor(
        address _token,
        address _owner,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _priceToken
    ) {
        Owner = msg.sender;
        counter++;
        require(
            /*_startTime >= block.timestamp && */
            _endTime > _startTime && _priceToken != 0,
            "err:1"
        );
        icoInfo = InfoToken(
            ERC20(_token),
            _owner,
            _startTime,
            _endTime,
            _priceToken
        );
    }

    struct InfoToken {
        ERC20 token;
        address owner;
        uint256 startTime;
        uint256 endTime;
        uint256 priceToken;
    }

    InfoToken icoInfo;
    
    function getICOinfo() public view returns(InfoToken memory){
        return icoInfo;
    }
    // mapping(uint256 => InfoToken) public icoInfo;

    event E_createIco(address tokenAdd, uint256 icoNm);

    uint256 counter;
    address Owner;
    uint256 public transferAmount;
    uint256 public icos;

    
    function addToken(uint256 _amount)
        public
        payable
        returns (uint256)
    {
        icoInfo.token.transferFrom(msg.sender, address(this), _amount);
        return icoInfo.token.balanceOf(address(this));
    }

    function Invest() public payable returns (uint256 tokenRecived)
    {   
        require(msg.value > 0,"fees not paid");
        // require(icoInfo[numICO].owner != address(0), "No Ico Found");
        // require(block.timestamp >= icoInfo[numICO].startTIme,"Ico not started");
        // require(block.timestamp <= icoInfo[numICO].endTime, "Ico was Ended");
        // require(icoInfo[numICO].amount > 0,"All tokens sold");
        // require(_amount <= icoInfo[numICO].amount, "Tokens Not available");
        // InfoToken memory current = icoInfo[numICO];

        uint256 currentAmount = icoInfo.token.balanceOf(address(this));
        require(currentAmount > 0, "Insufficient Balance");
        uint256 tokenPrice = icoInfo.priceToken;
        tokenRecived = (msg.value / tokenPrice) * 10 **18;

        uint256 amoutnInEth = (tokenPrice * currentAmount) / 10**18;
        if (tokenRecived > currentAmount) {
            transferAmount  = msg.value - amoutnInEth;
            payable(icoInfo.owner).transfer(msg.value - transferAmount);
            icoInfo.token.transfer(msg.sender, currentAmount);
            payable(msg.sender).transfer(transferAmount);
        } else {
            require(msg.value >= transferAmount, "Err:fee not paid");
            payable(icoInfo.owner).transfer(msg.value);
            icoInfo.token.transfer(msg.sender, tokenRecived);
        }
    }
}

// 0.01 ===10000000000000000
// 0.02 ===20000000000000000
