// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
/// @title property listing and rental contract 
contract structMap {

    struct map1 {

        uint256 val1;
        uint256 val2;

    }


    uint private n;

    mapping(address => mapping (uint256 => map1)) public structure1;

    mapping(address => uint256[]) public listmapping;


    function setVal(uint256 val1, uint256 val2) public {

        structure1[msg.sender][0].val1 = val1;
        structure1[msg.sender][0].val2 = val2;


    }


    function addValList(uint256 val1) public {

        listmapping[msg.sender].push(val1);


    }

    function viewValListLength(address owner) public view returns (uint) {

        
        return listmapping[owner].length;

    }

}