// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Escrow.sol";

contract EscrowTest is Test {
    Escrow public escrow;
    address public owner;
    address public user1;
    address public user2;

    function setUp() public {
        // Setup the testing environment
        owner = address(this); // Test contract acts as the owner
        user1 = address(0x123);
        user2 = address(0x456);

        escrow = new Escrow(); // Deploy the Escrow contract
    }

    function testOnlyWhitelistedCanWithdraw() public {
        escrow.whitelist(user1);

        // Fund the contract with 1 ether
        vm.deal(address(escrow), 1 ether);

        // Attempt withdrawal from a non-whitelisted address
        vm.prank(user2);
        vm.expectRevert("You are not the whitelisted address");
        escrow.withdraw(0.5 ether);
    }

    function testWithdrawInsufficientFunds() public {
        escrow.whitelist(user1);

        // Fund the contract with only 0.2 ether
        vm.deal(address(escrow), 0.2 ether);

        // Attempt to withdraw more than the balance
        vm.prank(user1);
        vm.expectRevert(); // Default revert for insufficient balance
        escrow.withdraw(0.5 ether);
    }

    receive() external payable {} // To receive funds in tests
}
