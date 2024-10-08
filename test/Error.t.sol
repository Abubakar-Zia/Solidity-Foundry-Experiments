// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import {Error} from "../src/Error.sol";

contract ErrorTest is Test {
    Error public err;

    function setUp() public {
        err = new Error();
    }

    function testFail() public {
        err.throwError();
    }

    function testRevert() public {
        vm.expectRevert();
        err.throwError();
    }

    function testRevertWithMessage() public {
        vm.expectRevert(bytes("not authorized"));
        err.throwError();
    }

    function testThrowCustomError() public {
        vm.expectRevert(Error.NotAuthorized.selector);
        err.throwCustomError();
    }

    function testAssertion() public pure {
        assertEq(uint256(1), uint256(1), "Test 1");
        assertEq(uint256(1), uint256(1), "Test 2");
        assertEq(uint256(1), uint256(1), "Test 3");
        assertEq(uint256(1), uint256(1), "Test 4");
        assertEq(uint256(1), uint256(1), "Test 5");
    }
}
