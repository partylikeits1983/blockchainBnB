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

        // pay in full or 50% now 50% on arrival
        bool payInFull;
        uint256 securityDeposit;

    }

    // still trying to figure out how to have multiple properties per address...
    struct locations {
        uint256[] listofproperties;

    }

    struct OWNER_RATINGS {
        address owner;
        uint256 rating;
        address[] renters;
    }

    struct RENTER_RATINGS {
        address renter;
        uint256 rating;
    }


    
    mapping(address => property) public properties;


    mapping(address=>uint256) security;

    
    // this list of addresses is for future features - mainly if an owner wants to delete all of their listed properties 
    address[] public owners;
    
    uint256 private fee;

    uint256 private payment;

    uint256 private securityDeposit;

    address private renter;


    // need to use events instead...

    bool private listed;
    bool private rented;


    // rating functionality: 

    //mapping(address => OWNER_RATINGS) public ownerRatings;

    //mapping(address => RENTER_RATINGS) public renterRatings;

    //address[] private renters;



    function listProperty(uint256 perNight, bool payInFull, uint256 SD) public returns (bool) {
        
        // add owner address to list owners
        owners.push(msg.sender);
        
        // adding values to protery struct
        properties[msg.sender].perNight = perNight;

        // owner address
        properties[msg.sender].owner = msg.sender;

        // renter address at listing will be initially set to 0x00 address
        
        properties[msg.sender].paid = false;
        
        properties[msg.sender].available = true;


        properties[msg.sender].payInFull = payInFull;

        properties[msg.sender].securityDeposit = SD;

        listed = true;

        return listed;

    }
    
    
    function rentProperty(address payable owner, uint256 nights) public payable returns (uint256, bool) {
        
        renter = msg.sender;

        // calculating fee by calling properties mapping
        // @dev eventually needs to be calculated using block timestamp 
        fee = (nights * properties[owner].perNight) + properties[owner].securityDeposit;

        payment = nights * properties[owner].perNight;

        securityDeposit = properties[owner].securityDeposit;


        // need to add time lock on deposit if there are no disputes 
        // security deposit can be == 0 
        security[owner] += securityDeposit;


        // require msg.value to be greater than or equal to price per night
        require (msg.value >= fee);

        // this is for future features 
        properties[owner].owner = owner;

        properties[owner].renter = msg.sender;

        properties[owner].paid = true;
        
        properties[owner].available = false;
        
        owner.transfer(payment);

        rented = true;

        return (fee, rented);
        
    }


    // update price per night 
    function updateRentalPrice(uint256 newPrice) public returns (uint256) { 
        
        require (msg.sender == properties[msg.sender].owner);

        properties[msg.sender].perNight = newPrice;

        return newPrice;

    }

}
