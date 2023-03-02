// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Onetoken is ERC20, Ownable, ERC20Burnable {
    uint256 public MaxSupply;

    constructor(uint256 _amount) ERC20("onetoken", "otk") {
        MaxSupply = _amount;
    }

    mapping(address => bool) public exemptedACC;
    mapping(address => uint256) public maxToken;

    function mint() public payable {
        require(msg.value >= 0.1 ether, "Minimum Mint is 0.1 ETH");
        require(msg.value <= 2 ether, "Maximum Mint Amount is 2 Ether");
        require(
            maxToken[msg.sender] < 20000000000000000000000000,
            "You Minted Maximum amount of Tokens"
        );
        require(totalSupply() < MaxSupply, "Total Supply Is Reached");
        uint256 Mintamount = (msg.value * 10000000);
        maxToken[msg.sender] += Mintamount;

        _mint(msg.sender, Mintamount);
    }

    function burn(uint256 amount) public override {
        uint256 burnamount = amount / 10000000;
        payable(msg.sender).transfer(burnamount);
        _burn(msg.sender, amount);
    }

    function transfer(address to, uint256 amount)
        public
        override
        returns (bool)
    {
        if (exemptedACC[msg.sender]) {
            _transfer(msg.sender, to, amount);
        }
        amount -= amount / 10;
        burn(amount / 10);
        _transfer(msg.sender, to, amount);

        return true;
    }

    function AddExemptedAcc(address add_) public onlyOwner {
        exemptedACC[add_] = true;
    }

    receive() external payable {}

    function getContractBal() public view returns (uint256) {
        // return address(this).balance / 1 wei ;
        return address(this).balance / 1 wei;
    }

    function getContractToken() public view returns (uint256) {
        return address(this).balance;
    }
}

// Owner account: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
// Mint ==   0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,100
// transferMy=
// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,90

// Receiver Account:0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// transferMy=
// 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,90


// 1000000000000000000000000