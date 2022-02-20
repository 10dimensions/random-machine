// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

struct ticketData { 
    string ticketURIExists;
    uint256 ticketIdToValue;
}

contract Ticket is ERC721Upgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;

    CountersUpgradeable.Counter private _ticketIdCounter;

    //Keep the record of  nfts
    mapping(uint256 => ticketData) internal _ticketData;

    function initializeTicket() internal {
        __ERC721_init("Ticket", "TKT");
    }
    
    function _setTicketURI(uint256 ticketId, string memory _ticketURI) internal virtual {
        require( _exists(ticketId),"ERC721Metadata: URI set of nonexistent ticket");
        _ticketData[ticketId].ticketURIExists = _ticketURI;
    }
    
    function ticketURI(uint256 ticketId) public view returns (string memory) {
        require(_exists(ticketId), "ERC721Metadata: URI query for nonexistent ticket");

        string memory _ticketURI = _ticketData[ticketId].ticketURIExists;
        return _ticketURI;
    }

    function safeMint(address to, string memory _ticketURI, uint256 _nftPrice) internal returns (uint256) {
        uint256 ticketId = _ticketIdCounter.current();
        _ticketIdCounter.increment();
        _safeMint(to, ticketId);

        _ticketData[ticketId].ticketIdToValue = _nftPrice;
        _setTicketURI(ticketId, _ticketURI);

        return ticketId;
    }
    
}