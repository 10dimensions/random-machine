//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "contracts/Proxy/Proxiable.sol";
import "contracts/Core/RandomMachine.sol";

contract BaseContract is OwnableUpgradeable, RandomMachine, Proxiable {

    function updateCode(address newCode) onlyOwner public {
        updateCodeAddress(newCode);
    }

}
