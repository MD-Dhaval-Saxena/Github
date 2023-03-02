// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTauction {
    constructor() {
        cnt = 0;
        bidders.push(address(0));
        Bid[bidders[0]] = 0;
    }

    uint256 cnt;

    uint256 auc_no;
    uint256 Bid_count;
    uint256 counter;
    uint256 _highestBid;
    address[] public bidders;
    bool result=true;

    mapping(uint256 => Bid_details) public bidData;
    mapping(uint256 => auction) public AucInfo;
    mapping(address => uint256) public Bid;
    mapping(address => uint256) public myBid;

    // mapping(uint256 => uint256) public totalbids;

    function getAllBidders() public view returns (address[] memory) {
        return bidders;
    }

    struct auction {
        ERC721 token;
        address auction_owner;
        uint256 nftid;
        uint256 startTime;
        uint256 endTime;
        uint256 baseValue;
    }
    struct Bid_details {
        address inv;
        uint256 currBid;
    }

    function createAuction(
        ERC721 _token,
        uint256 _nftid,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _baseValue
    ) public {
        counter++;
        AucInfo[counter] = auction(
            _token,
            msg.sender,
            _nftid,
            _startTime,
            _endTime,
            _baseValue
        );
        // require(_startTime > 0, "startTime is can't be zero");
        // require(_endTime > _startTime, "Endtime can't before Starttime");
        _token.transferFrom(msg.sender, address(this), _nftid);
    }

    function place_Bid(uint256 aucNum) public payable {
        auction storage current = AucInfo[aucNum];
        // require(block.timestamp >= current.startTime, "Auction not started");
        // require(block.timestamp <= current.endTime, "Auction was Ended");
        uint256 bidAmount = msg.value;
        cnt++;
        require(current.auction_owner != address(0), "Auction Not Found");
        // uint256 a =  bidData[aucNum].currBid == 0 ? current.baseValue : bidData[aucNum].currBid;
        // require(bidAmount >= a , "Amount not valid");

        require(bidAmount >= current.baseValue, "Amount not valid");
        require(
            bidAmount > bidData[aucNum].currBid,
            "New bid should be higher"
        );
        bidders.push(msg.sender);
        // Bid[bidders[cnt]] = bidAmount;
        Bid[msg.sender] = bidAmount;
        bidData[aucNum] = Bid_details(msg.sender, bidAmount);
        myBid[msg.sender] = bidAmount;
    }


    function Auction_Winner(uint256 aucNum) public payable {
        require(result,"Result Aleready Declared");
        auction storage current = AucInfo[aucNum];
        require(msg.sender != current.auction_owner, "ERR: Only Owner!");
        // Highest bid
        uint256 winner = bidders.length - 1;
        address win = bidders[winner];
        payable(current.auction_owner).transfer(Bid[win]);
        current.token.transferFrom(address(this), win, current.nftid);
        delete Bid[win];
        delete bidders[winner];
        result=false;
    }

    function WithDraw(uint256 aucNum) public payable {
        auction storage current = AucInfo[aucNum];
        require(myBid[msg.sender] > 0, "Your not eligible");
        uint256 Deducting_fees = myBid[msg.sender] / 100;
        payable(current.auction_owner).transfer(Deducting_fees);
        uint256 transferAmount = myBid[msg.sender] - Deducting_fees;
        payable(msg.sender).transfer(transferAmount);
    }
}
