// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import {Wallet} from "../src/Wallet.sol";

// forge test --match-path test/Auth.t.sol -vvvv

contract AuthTest is Test {
    Wallet public wallet;

    function setUp() public {
        wallet = new Wallet();
    }

    function testSetOwner() public {
        wallet.setOwner(address(1));
        assertEq(wallet.owner(), address(1));
    }

    function testFailNotOwner() public {
        vm.prank(address(2)); // Simulate call from address(2), assuming address(2) is not the owner
        wallet.setOwner(address(1)); // Try to set owner to address(1)
    }

    function testFailSetOwner() public {
        wallet.setOwner(address(1));
        vm.startPrank(address(1));
        wallet.setOwner(address(1));
        wallet.setOwner(address(1));
        wallet.setOwner(address(1));
        vm.stopPrank();
        wallet.setOwner(address(1));
    }
}
