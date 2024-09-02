// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";

contract SignTest is Test {
    function testSignature() public pure {
        uint256 privateKey = 123;
        address publicKey = vm.addr(privateKey);
        bytes32 messageHash = keccak256(abi.encodePacked("This is a secret message."));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, messageHash);
        address signer = ecrecover(messageHash, v, r, s);
        assertEq(signer, publicKey);
        bytes32 invalidMessageHash = keccak256(abi.encodePacked("invalid message"));
        signer = ecrecover(invalidMessageHash, v, r, s);
        assertTrue(signer != publicKey);
    }
}
