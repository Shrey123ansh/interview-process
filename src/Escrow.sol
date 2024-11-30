// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Escrow {
    address public owner;
    address payable public whitelisted;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function whitelist(address _addr) external {
        require(msg.sender == owner, "Only owner can whitelist an address");
        whitelisted = payable(_addr);
    }

    function withdraw(uint256 amount) external {
        require(
            msg.sender == whitelisted,
            "You are not the whitelisted address"
        );

        whitelisted.transfer(amount);
    }

    function balance() external view returns (uint256) {
        return address(this).balance;
    }
}
