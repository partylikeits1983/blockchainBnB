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
    
    address[] public owners;
    
    uint256 private fee;
      
    address private renter;

    
    function listProperty(uint256 perNight) public {
        
        // add owner address to list owners
        owners.push(msg.sender);
        
        // adding values to protery struct
        properties[msg.sender].perNight = perNight;


        // owner address
        properties[msg.sender].owner = msg.sender;


        
        properties[msg.sender].paid = false;
        
        properties[msg.sender].available = true;

    }
    
    
    function rentProperty(address payable owner, uint256 nights) public payable returns (uint256) {
        
        renter = msg.sender;

        // calculating fee by calling properties mapping
        fee = nights * properties[owner].perNight;
        
        // require msg.value to be greater than or equal to price per night
        require (msg.value >= fee);

        properties[owner].renter = msg.sender;

        
        properties[owner].paid = true;
        
        properties[owner].available = false;
        
        owner.transfer(fee);
        
        return fee;
        
        
    }
    
}
