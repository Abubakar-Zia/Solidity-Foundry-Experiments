// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract InvariantPractice {
    bool public flag;

    function func_1() external {}
    function func_2() external {}
    function func_3() external {}
    function func_4() external {}

    function func_5() external {
        flag = true;
    }
}

import {Test, console} from "forge-std/Test.sol";

contract InvariantPracticeTest is Test {
    InvariantPractice private target;

    function setUp() public {
        target = new InvariantPractice();
    }

    function invariant_flagIsAlwaysFalse() public view {
        assertEq(target.flag(), false);
    }
}
