// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import {Event} from "../src/Event.sol";

// forge test --match-path test/Event.t.sol -vvvv

contract EventTest is Test {
    Event public _event;

    event Transfer(address indexed from, address indexed to, uint256 amount);

    function setUp() public {
        _event = new Event();
    }

    function testEmitTransferEvent() public {
        vm.expectEmit(true, true, false, true);
        emit Transfer(address(this), address(1234), 100);
        _event.transfer(address(this), address(1234), 100);

        // Only index 1 Checking
        vm.expectEmit(true, false, false, false);
        emit Transfer(address(this), address(12345), 1100);
        _event.transfer(address(this), address(1234), 100);
    }

    function testEmitManyTransferEvent() public {
        address[] memory to = new address[](2);
        to[0] = address(12345);
        to[0] = address(789);

        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 1111;
        amounts[1] = 83749;

        for (uint256 i = 0; i < to.length; i++) {
            vm.expectEmit(true, true, false, true);
            emit Transfer(address(this), to[i], amounts[i]);
        }
        _event.transferMany(address(this), to, amounts);
    }
}
