// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import {Auction} from "../src/Time.sol";

contract TimeTest is Test {
    Auction public auction;
    uint256 private startAt;

    // vm.warp - set block.timestamp to future timestamp
    // vm.roll - set block.number
    // skip - increment current timestamp
    // rewind - decrement current timestamp

    function setUp() public {
        auction = new Auction();
        startAt = block.timestamp;
    }

    function testBidFailsBeforeStartTime() public {
        auction.bid();
        vm.expectRevert(bytes("cannot bid"));
    }

    function testBid() public {
        vm.warp(startAt + 1 days);
        auction.bid();
    }

    function testBidFailsAfterTime() public {
        vm.expectRevert(bytes("cannot bid"));
        vm.warp(startAt + 2 days);
        auction.bid();
    }

    function testTimestamp() public {
        uint256 t = block.timestamp;
        skip(100);
        assertEq(block.timestamp, t + 100);

        rewind(10);
        assertEq(block.timestamp, t + 100 - 10);
    }

    function testBlockNumber() public {
        vm.roll(999);
        assertEq(block.number, 999);
    }
}
