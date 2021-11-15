// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
/// @title property listing and rental contract 
contract blockchainBNB {
    
    struct property {
        uint256 perNight;

        address owner;
        address renter;

        bool paid;  // if true, that person already voted
        bool available;

    }


    mapping(address => property) public properties;
    
    // this list of addresses is for future features - mainly if an owner wants to delete all of their listed properties 
    address[] public owners;
    
    uint256 private fee;
      
    address private renter;

    
    // future functions:

    // function:  update rental price
    // struct mapping: owner can have multiple rental properties
    // function: pay half to reserve, pay in full on arrival 
    // struct: owners can have ratings
    // struct: renters can have ratings
    // function: security deposit
    // enable payment in ERC20 



    function listProperty(uint256 perNight) public {
        
        // add owner address to list owners
        owners.push(msg.sender);
        
        // adding values to protery struct
        properties[msg.sender].perNight = perNight;

        // owner address
        properties[msg.sender].owner = msg.sender;

        // renter address at listing will be initially set to 0x00 address
        
        properties[msg.sender].paid = false;
        
        properties[msg.sender].available = true;

    }
    
    
    function rentProperty(address payable owner, uint256 nights) public payable returns (uint256) {
        
        renter = msg.sender;

        // calculating fee by calling properties mapping
        // @dev eventually needs to be calculated using block timestamp 
        fee = nights * properties[owner].perNight;
        
        // require msg.value to be greater than or equal to price per night
        require (msg.value >= fee);

        // this is for future features 
        properties[owner].renter = owner;

        properties[owner].renter = msg.sender;

        
        properties[owner].paid = true;
        
        properties[owner].available = false;
        
        owner.transfer(fee);
        
        return fee;
        
        
    }
    
}
