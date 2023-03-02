// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Username{
    mapping (address => string) public usernames ;
    mapping (string =>bool) CheckUser;
    mapping (string=>address) public usrAddress;
    uint public creationTime = block.timestamp;


    function setUsername(string memory _username) public { 
        // setUsername function calls
        bytes memory u = bytes(_username);
        // Validations for username
        require(bytes(u).length != 0  ,"Username Can't be Empty");
        require(bytes(u).length >= 7  ,"Username Can't be less than 7 Char");
        require(bytes(u).length <= 20  ,"Username Can't be More than 20 Char");
        require(u[0] != '0' && u[0] != '9' ,"Username can't starts with Number");
        
        usernames[msg.sender]=_username;
        // usrAddress[_username]=msg.sender;
        usrAddress[_username]=msg.sender;
        // require(usrAddress[_username]=msg.sender,"No User Account Address Found");
        
        // CheckUser is False
        // CheckUSer takes username and sets CheckUser= True
        require(!CheckUser[_username],"This username is not available");
         // Second time calls CheckUser bcz it's aleraedy true it throws error
        CheckUser[_username]=true;

    }

    function getUsername() public view returns(string memory){
        require(usernames[msg.sender]);
        return usernames[msg.sender];
    }
    function deleteAcc(string memory _username) public {
        bytes memory usr=bytes(usernames[ms])
        delete usernames[msg.sender];
        CheckUser[_username]=false;
    }

    // function getAddress(address  _address) public view returns(string memory){
    //     return usrAddress[_username];
    // }

}

// search with username=>address and error handling(string=>addr)
// transaction.origin(tx.origin)
// inline assembly