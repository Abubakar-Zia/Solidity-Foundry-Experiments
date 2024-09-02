// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
    }

    function test_Increment() public {
        counter.inc();
        assertEq(counter.count(), 1);
    }

    // function test_Decrement_Underflow() public {
    //     counter.dec();
    // }
    function test_Decrement_Underflow_Better() public {
        vm.expectRevert();
        counter.dec();
    }

    function test_Decrement_SettingValue() public {
        counter.inc();
        counter.inc();
        counter.dec();
        assertEq(counter.count(), 1);
    }
}
