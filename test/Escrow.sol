// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Escrow.sol";

contract EscrowTest is Test {
    Escrow escrow;
    address alice = address(0x1);
    address jack = address(0x2);

    function setUp() public {
        // Alice deploys the Escrow contract
        vm.startPrank(alice);
        escrow = new Escrow();
        vm.stopPrank();
    }

    function testDepositAndBalance() public {
        // Fund Alice with 1 Ether
        vm.deal(alice, 1 ether);

        // Alice deposits 1 Ether into the contract
        vm.startPrank(alice);
        (bool success, ) = address(escrow).call{value: 1 ether}("");
        assertTrue(success, "Deposit failed");
        vm.stopPrank();

        // Verify the contract balance
        assertEq(escrow.balance(), 1 ether, "Incorrect contract balance");
    }

    function testWhitelistAndWithdraw() public {
        // Fund Alice with 1 Ether
        vm.deal(alice, 1 ether);
        vm.deal(jack, 0); // Jack starts with 0 balance

        // Alice deposits Ether
        vm.startPrank(alice);
        (bool success, ) = address(escrow).call{value: 1 ether}("");
        assertTrue(success, "Deposit failed");

        // Alice whitelists Jack
        escrow.whitelist(jack);
        assertEq(
            escrow.whitelisted(),
            jack,
            "Whitelisted address is incorrect"
        );
        vm.stopPrank();

        // Jack withdraws the Ether
        vm.startPrank(jack);
        escrow.withdraw(1 ether);
        vm.stopPrank();

        // Verify balances
        assertEq(
            address(jack).balance,
            1 ether,
            "Jack did not receive the withdrawn Ether"
        );
        assertEq(escrow.balance(), 0, "Contract balance should be zero");
    }
}
