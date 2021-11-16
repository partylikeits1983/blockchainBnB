// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
/// @title property listing and rental contract 
contract structMap {

    struct map1 {

        uint256 val1;
        uint256 val2;

    }


    uint256 private i;


    mapping(address => mapping (uint256 => map1)) public structure1;

    mapping(address => uint256[]) private listmapping;


    function setVal(uint256 val1, uint256 val2, uint256 id) public {
        
        require(id <= (listmapping[msg.sender].length - 1), "ID not found");

        structure1[msg.sender][id].val1 = val1;
        structure1[msg.sender][id].val2 = val2;

    }
    
    
    function newMap(uint256 val1, uint256 val2) public {
        
        i = listmapping[msg.sender].length;
        
        structure1[msg.sender][i].val1 = val1;
        structure1[msg.sender][i].val2 = val2;
        
        listmapping[msg.sender].push(1);

    }



    function viewValListLength(address owner) public view returns (uint) {

        return listmapping[owner].length;

    }

}