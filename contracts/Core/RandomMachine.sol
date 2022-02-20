//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "contracts/ticket/Ticket.sol";

import "hardhat/console.sol";

contract RandomMachine is Initializable, OwnableUpgradeable, Ticket {

    address payable[] public records;
    uint public stateId;
    uint public startTimestamp;
    uint256 public cost = 0.005 ether;
    mapping (uint => address payable) public machineHistory;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function initialize() initializer public {
        __Ownable_init();

        stateId = 1;
        startTimestamp = block.timestamp;

        initializeTicket();
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
        require (block.timestamp >= startTimestamp + 60 seconds && block.timestamp <= startTimestamp + 100 seconds);
        require(msg.sender != address(0));
        require(msg.value >= cost);

        // address of player entering lottery
        records.push(payable(msg.sender));
    }

    function getRandomNumber() public view returns (uint) {
        address ownerAddress = owner(); 
        return uint(keccak256(abi.encodePacked(ownerAddress, block.timestamp)));
    }

    function pickWinner() public onlyOwner {
        uint index = getRandomNumber() % records.length;
        records[index].transfer(address(this).balance * 50/100);

        machineHistory[stateId] = records[index];
        stateId++;
        
        // reset the state of the contract
        records = new address payable[](0);
    }

}
