// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTAuction {
    constructor() {
        cnt = 0;
        bidders.push(address(0));
        Bid[cnt][bidders[0]] = 0;
        owner = msg.sender;
    }

    address owner;
    uint256 cnt;

    uint256 auc_no;
    uint256 counter;
    address[] bidders;
    bool result = true;

    mapping(uint256 => auction) public AucInfo;
    mapping(uint=>mapping(address => uint256)) public Bid;
    mapping(address => bool) public check_winner; //check i am winner??

    // For testing
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

    function createAuction(
        ERC721 _token,
        uint256 _nftid,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _baseValue
    ) public {
        require(owner == msg.sender, "ERR : Only Owner!");
        counter++;
        AucInfo[counter] = auction(
            _token,
            msg.sender,
            _nftid,
            _startTime,
            _endTime,
            _baseValue
        );
        // require(_startTime > block.timestamp, "ERR: StartTime Not valid");
        // require(_endTime > _startTime, "ERR: Endtime can't before Starttime");
        _token.transferFrom(msg.sender, address(this), _nftid);
    }

    function place_Bid(uint256 aucNum) public payable {
        cnt++;
        auction storage current = AucInfo[aucNum];
        require(current.auction_owner != address(0), "Auction Not Found");
        // require(block.timestamp >= current.startTime, "Auction not started");
        // require(block.timestamp <= current.endTime, "Auction was Ended");
        uint256 bidAmount = msg.value;
        require(bidAmount >= current.baseValue, "Amount not Provided");
        uint256 lastbid = Bid[aucNum][bidders[bidders.length - 1]];
        require(bidAmount > lastbid, "New bid should be higher");
        bidders.push(msg.sender);
        Bid[aucNum][msg.sender] = bidAmount;
    }

    function Auction_Winner(uint256 aucNum) public payable {
        require(bidders.length > 1, "ERR: No Bids Found");
        auction storage current = AucInfo[aucNum];
        require(result, "Result Aleready Declared");
        require(owner == msg.sender, "ERR: Only Owner!");
        // // Highest bid
        uint256 winner_index = bidders.length - 1;
        address win = bidders[winner_index];
        check_winner[win] = true;
        payable(current.auction_owner).transfer(Bid[aucNum][win]);
        current.token.transferFrom(address(this), win, current.nftid);
        delete Bid[aucNum][win];
        delete bidders[winner_index];
        result = false;
    }

    function WithDraw(uint aucNum) public payable {
        require(result==false,"Wait for Result Declaration");
        require(Bid[aucNum][msg.sender] > 0, "Your not eligible or You did ur Withdrawal");
        uint256 Deducting_fees = Bid[aucNum][msg.sender] / 100;
        uint256 transferAmount = Bid[aucNum][msg.sender] - Deducting_fees;
        payable(msg.sender).transfer(transferAmount);
        delete Bid[aucNum][msg.sender];
    }
}

// bids
// 1st  100000000000000000
// 2  1000000000000000000
// 3 2000000000000000000
// 4 3000000000000000000

