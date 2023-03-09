// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ICO.sol";

contract IcoCreate {

    uint256 counter;
    mapping(uint256 => address) icoAddress;

    
    
    event CreateICO(
        address icoAddress, 
        uint256 icoNumber
    );


    function deploy_ico( 
        address _token,
        uint256 startTime,
        uint256 endTime,
        uint256 priceToken
    ) public {
        counter++;
        ICO ico = new ICO(_token, msg.sender, startTime, endTime, priceToken);
        icoAddress[counter] = address(ico);
        emit CreateICO(address(ico), counter);
    }
}