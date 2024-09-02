// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "solmate/tokens/ERC20.sol";

contract Token is ERC20("name", "symbol", 18) {}

import "@openzeppelin/contracts/access/Ownable.sol";

contract TestOz is Ownable {
    constructor(address initialOwner) Ownable(initialOwner) {
        // Additional initialization if needed
    }
}
