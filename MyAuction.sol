// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract MyAuction {
    constructor() {
        bidders.push(address(0));
        Bid[bidders[0]] = 0;
        owner = msg.sender;
    }

    address public owner;

    uint256 public auc_no;
    uint256 counter;
    address[]  bidders;
    bool result = true;

    mapping(address => uint256) public Bid;
    mapping(address=> uint256) public Balance;
    mapping(address => bool) public check_winner; //check i am winner??

    struct auction {
        ERC1155 token;
        address owner;
        uint256 id;
        uint256 amount;
        bytes data;
        uint256 startTime;
        uint256 endTime;
        uint256 priceTokens;
    }
    mapping(uint256 => auction) public AuctionInfo;

    function createAuction(
        ERC1155 _token,
        // address _owner,
        uint256 _id,
        uint256 _amount,
        bytes memory _data,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _priceTokens
    ) public {
        counter++;
        AuctionInfo[counter] = auction(
            _token,
            msg.sender,
            _id,
            _amount,
            _data,
            _startTime,
            _endTime,
            _priceTokens
        );
        _token.safeTransferFrom(msg.sender, msg.sender, _id, _amount, "");
        // 0x00                  
    }

    function place_Bid(uint256 aucNum) public payable {
        auction storage current = AuctionInfo[aucNum];
        require(current.owner != address(0), "Auction Not Found");
           require(msg.value >= current.priceTokens,
            "MSG: Price less than token amount"
            );
        require(current.amount > 0, "MSG: Token Sold out");
        // require(
        //     msg.value >= current.priceTokens * current.amount,
        //     "MSG: Price less than tokens amount"
        // );
     
        // require(block.timestamp >= current.startTime, "Auction not started");
        // require(block.timestamp <= current.endTime, "Auction was Ended");
        uint256 bidAmount = msg.value;
        uint256 lastbid = Bid[bidders[bidders.length - 1]];
        require(bidAmount > lastbid, "New bid should be higher");
        bidders.push(msg.sender);
        // Bid[msg.sender] += bidAmount;
        Bid[msg.sender] = bidAmount;
        Balance[msg.sender]+=bidAmount;
    }

    function Auction_Winner(uint256 aucNum) public payable {
        require(bidders.length > 1, "ERR: No Bids Found");
        auction storage current = AuctionInfo[aucNum];
        // require(result, "Result Aleready Declared");
        require(owner == msg.sender, "ERR: Only Owner!");
        uint256 winner_index = bidders.length - 1;
        address win = bidders[winner_index];
        check_winner[win] = true;
        require(win != address(0),"MSG: can't transfer to zero addrs");
        payable(current.owner).transfer(Bid[win]);
        // current.token.safeTransferFrom(current.owner, win,current.id,current.amount,"");
        current.token.safeTransferFrom(current.owner, win, current.id, 1, "");
        current.amount-=1;
        delete Bid[win];
        delete Balance[win];
        delete bidders[winner_index];
        // result = false;
    }

    function WithDraw() public payable {
        // require(result == false, "Wait for Result Declaration");
        require(
            Balance[msg.sender] > 0,
            "Your not eligible or You did ur Withdrawal"
        );
        uint256 Deducting_fees = Balance[msg.sender] / 100;
        uint256 transferAmount = Balance[msg.sender] - Deducting_fees;
        payable(msg.sender).transfer(transferAmount);
        delete Balance[msg.sender];
    }
}
// 0x00
