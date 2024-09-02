// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Wallet} from "../src/Wallet.sol";

// Examples of deal and hoax
// deal(address, uint) - Set balance of address
// hoax(address, uint) - deal + prank, Sets up a prank and set balance

contract WalletTest is Test {
    Wallet public wallet;

    function setUp() public {
        wallet = new Wallet{value: 1e18}();
    }

    function _send(uint256 amount) private {
        (bool ok,) = address(wallet).call{value: amount}("");
        require(ok, "send ETH failed");
    }

    function testEthBalance() public {
        console.log("Eth Balance", address(this).balance / 1e18);
    }

    function testSendEth() public {
        uint256 balance = address(wallet).balance;
        deal(address(1), 100);
        assertEq(address(1).balance, 100);

        deal(address(1), 10);
        assertEq(address(1).balance, 10);

        deal(address(1), 123);
        vm.prank(address(1));
        _send(123);

        hoax(address(1), 144);
        _send(144);

        assertEq(address(wallet).balance, balance + 123 + 144);
    }
}
