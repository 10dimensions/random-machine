//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract RandomMachine {

    address public owner;
    address payable[] public records;
    uint public stateId;
    uint public startTimestamp;
    mapping (uint => address payable) public machineHistory;

    constructor() {
        owner = msg.sender;
        stateId = 1;
        startTimestamp = block.timestamp;
    }

    function getWinnerByLottery(uint lottery) public view returns (address payable) {
        return machineHistory[lottery];
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getRecords() public view returns (address payable[] memory) {
        return records;
    }

    function enter() public payable {
        require (block.timestamp >= startTimestamp + 1 seconds && block.timestamp <= startTimestamp + 100 seconds);

        require(msg.value > .01 ether);

        // address of player entering lottery
        records.push(payable(msg.sender));
    }

    function getRandomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function pickWinner() public onlyowner {
        uint index = getRandomNumber() % records.length;
        records[index].transfer(address(this).balance);

        machineHistory[stateId] = records[index];
        stateId++;
        

        // reset the state of the contract
        records = new address payable[](0);
    }

    modifier onlyowner() {
      require(msg.sender == owner);
      _;
    }

}
