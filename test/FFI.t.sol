// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";

contract FFITest is Test {
    function testFFI() public {
        string[] memory cmds = new string[](2);
        cmds[0] = "echo";
        cmds[1] = "Hello World!";
        bytes memory result = vm.ffi(cmds);
        console.log(string(result));
    }
}
