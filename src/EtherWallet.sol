// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract EtherWallet {
    address public owner;

    constructor() {
        owner = (msg.sender);
    }

    address payable public whitlistaddr;

    receive() external payable {}

    function whitelist(address _addr) external {
        require(owner == msg.sender, "you are not a owner address");
        whitlistaddr = payable(_addr);
    }

    function withdraw(uint256 amount) external {
        require(
            whitlistaddr == msg.sender,
            "you are not a whitlistaddr address"
        );
        payable(msg.sender).transfer(amount);
    }

    function balance() external view returns (uint256) {
        return address(this).balance;
    }
}
