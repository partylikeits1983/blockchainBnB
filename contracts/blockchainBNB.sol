// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
/// @title property listing and rental contract 
contract blockchainBNB {
    
    struct property {

        address owner;
        uint id;

        uint perNight;
        
        bool available;

        // pay in full or 50% now 50% on arrival
        bool payInFull;

        uint securityDeposit;

    }

    struct rental {
        
        address owner;
        uint id;
        
        address renter;

        uint[] t1;
        uint[] t2;
    
    }

    struct securityDep {

        address owner;
        uint id;

        address renter;

        uint amount;

        uint timestamp;

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


    
    // this list of addresses is for future features - mainly if an owner wants to delete all of their listed properties 
    address[] public owners;
    
    uint private fee;

    uint private payment;

    uint private securityDeposit;

    address private renter;


    // need to use events instead...
    bool private listed;
    bool private rented;




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

    function rentProperty(address payable owner, uint id, uint t1, uint t2) public payable {
    
        require(id <= (listmapping[owner].length - 1), "ID not found");

        
        // there may be a computationally more efficient way of doing this
        for (uint i=0; i<rentals[owner][id].t1.length; i++) {
            
            start = rentals[owner][id].t1[i];
            end = rentals[owner][id].t2[i];
        
            require((end <= t1 || start >= t2) == true);

        }

        require (msg.value >= fee);


        // fee = (nights * properties[owner][id].perNight) + properties[owner][id].securityDeposit;

        // payment = nights * properties[owner][id].perNight;

        securityDeposit = properties[owner][id].securityDeposit;



        duration = (t2 - t1);

        fee = (duration * properties[owner][id].perNight) / 86400 + properties[owner][id].securityDeposit;

        payment = (duration * properties[owner][id].perNight) / 86400;





        rentals[owner][id].owner = owner;
        rentals[owner][id].id = id;
        
        rentals[owner][id].renter = msg.sender;
        
        rentals[owner][id].t1.push(t1);
        rentals[owner][id].t2.push(t2);









        // security Deposit
        securityDeposits[owner][id].owner = owner;

        securityDeposits[owner][id].id = id;
        securityDeposits[owner][id].renter = msg.sender;

        securityDeposits[owner][id].amount += securityDeposit;

        securityDeposits[owner][id].dispute = false;

        securityDeposits[owner][id].timestamp = block.timestamp;

        owner.transfer(payment);
        
    }

    function fileDispute(address owner, uint id, bool dispute) public {

        require(msg.sender == securityDeposits[owner][id].owner);

        securityDeposits[msg.sender][id].dispute = dispute;

    }

    // update price per night 
    function updateRentalPrice(address owner, uint newPrice, uint id) public returns (uint) { 
        
        require (msg.sender == properties[owner][id].owner);

        // properties[owner].available = false; 

        properties[msg.sender][id].perNight = newPrice;

        return newPrice;

    }



     function Time_call() public view returns (uint256){
        return block.timestamp; 
    }
    

}
