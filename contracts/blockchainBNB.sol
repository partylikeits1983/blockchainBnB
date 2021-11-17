// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
/// @title property listing and rental contract 
contract blockchainBNB {
    
    struct property {

        address owner;
        uint id;

        // price per night 
        uint perNight;
        
        // owner can pause new rentals 
        bool available;

        // pay in full or 50% now 50% on arrival
        // functionality not yet built in
        bool payInFull;

        // security Deposit 
        uint securityDeposit;

        // array of all rentals 
        uint[] t1;
        uint[] t2;

    }

    struct rental {
        
        address owner;
        uint id;
        
        address renter;

        // check in check out time of renter
        uint t1;
        uint t2;
    
    }

    struct securityDep {

        address owner;
        uint id;

        address renter;

        // renter will be able to withdraw deposit after certain amount of time 
        uint amount;

        // this will be used to release after x number of days 
        uint timestamp;

        // default is false
        bool dispute;

    }


    // property struct mapping 
    mapping(address => mapping (uint => property)) public properties;


    // rental struct mapping 
    mapping(address => mapping (uint => rental)) public rentals;


    // allows for multiple property listings per address @dev potentially can be optimized
    mapping(address => uint[]) private listmapping;


    // security deposit mapping 
    mapping(address => mapping (uint => securityDep)) public securityDeposits;


    
    
    uint private fee;

    uint private payment;

    uint private securityDeposit;

    // also used by releaseDeposit
    address private renter;


    // used by listProperty and rentProperty
    uint private ID;
    
    function listProperty(uint perNight, bool payInFull, uint SD) public {
        
        ID = listmapping[msg.sender].length;
        
        properties[msg.sender][ID].owner = msg.sender;
        properties[msg.sender][ID].id = ID;
        
        properties[msg.sender][ID].perNight = perNight;
        
        properties[msg.sender][ID].available = true;

        properties[msg.sender][ID].payInFull = payInFull;
        properties[msg.sender][ID].securityDeposit = SD;
        
        listmapping[msg.sender].push(1);

    }



    uint256 private start;
    uint256 private end;

    uint private duration;


    // handle multiple rentals per renter 
    mapping (address => uint[]) private previousRentals;


    function rentProperty(address payable owner, uint id, uint t1, uint t2) public payable {
    
        require(id <= (listmapping[owner].length - 1), "ID not found");


        duration = (t2 - t1);
        
        // renters should be able to rent a property for a few hours if they wish
        require(duration <= 86400);


        
        // for loop to check if rental dates overlap with other renters 
        for (uint i=0; i<properties[owner][id].t1.length; i++) {
            
            start = properties[owner][id].t1[i];
            end = properties[owner][id].t2[i];
        
            require((end <= t1 || start >= t2) == true);

        }

        require (msg.value >= fee);

        // currently will not work if duration is < 86400 seconds 
        



        securityDeposit = properties[owner][id].securityDeposit;

        fee = (duration * properties[owner][id].perNight) / 86400 + properties[owner][id].securityDeposit;

        payment = (duration * properties[owner][id].perNight) / 86400;



        // push to rental struct 
        // rental struct is mapped to renter address not owner address 


        // renter cannot currently have multiple rentals....

        // create array of rentals of address.... 
        // map renter address to array 
        // check length of that array ++ 

        ID = listmapping[msg.sender].length;

        rentals[msg.sender][ID].owner = owner;
        rentals[msg.sender][ID].id = id;
        
        rentals[msg.sender][ID].renter = msg.sender;

        rentals[msg.sender][ID].t1 = t1;
        rentals[msg.sender][ID].t2 = t2;


        // push check in and check out to properties struct 
        
        properties[owner][id].t1.push(t1);
        properties[owner][id].t2.push(t2);


        // security Deposit struct 

        securityDeposits[owner][id].owner = owner;

        securityDeposits[owner][id].id = id;
        securityDeposits[owner][id].renter = msg.sender;

        securityDeposits[owner][id].amount += securityDeposit;

        securityDeposits[owner][id].dispute = false;

        securityDeposits[owner][id].timestamp = block.timestamp;

        owner.transfer(payment);
        
    }



    // update price per night 
    function updateRentalPrice(address owner, uint newPrice, uint id) public returns (uint) { 
        
        require (msg.sender == properties[owner][id].owner);

        // properties[owner].available = false; 

        properties[msg.sender][id].perNight = newPrice;

        return newPrice;

    }


    // in future members of DAO can vote to resolve dispute 
    function fileDispute(address owner, uint id, bool dispute) public {

        require(msg.sender == securityDeposits[owner][id].owner);

        securityDeposits[msg.sender][id].dispute = dispute;

    }
    
    
    uint private amount;
    
    // user is renter
    function releaseDeposit(address owner, uint id, address payable user) public {
        
        require(msg.sender == securityDeposits[owner][id].owner || msg.sender == securityDeposits[owner][id].renter);
        
        // release after a week 
        require(securityDeposits[owner][id].timestamp + 604800 < block.timestamp, "Deposit still on hold");
        require(securityDeposits[owner][id].dispute == false, "Owner has filed a dispute");
   
        amount = securityDeposits[owner][id].amount;
        
        user.transfer(amount);
        
        
    }


     function Time_call() public view returns (uint256){
        return block.timestamp; 
    }
    

}
