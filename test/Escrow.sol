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
        owner = address(this);
        user1 = address(0x123);
        user2 = address(0x456);

        escrow = new Escrow();
    }

    function testOnlyWhitelistedCanWithdraw() public {
        escrow.whitelist(user1);

        vm.deal(address(escrow), 1 ether);

        vm.prank(user2);
        vm.expectRevert("You are not the whitelisted address");
        escrow.withdraw(0.5 ether);
    }

    function testWithdrawInsufficientFunds() public {
        escrow.whitelist(user1);

        vm.deal(address(escrow), 0.2 ether);

        vm.prank(user1);
        vm.expectRevert();
        escrow.withdraw(0.5 ether);
    }

    receive() external payable {}
}
