// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/BookingToken.sol";

contract TokenTest is Test {
    BookingToken token;

    function setUp() public {
        token = new BookingToken();
    }

    function testInitialSupply() public view {
        uint256 expectedSupply = 1000000 * 10 ** token.decimals();
        assertEq(token.totalSupply(), expectedSupply, "Initial supply should be 1,000,000 BOOK");
    }

    function testMinting() public {
        address recipient = address(0x123);
        uint256 mintAmount = 500 * 10 ** token.decimals();

        // Mint tokens to the recipient
        token.mint(recipient, mintAmount);

        // Check the recipient's balance
        assertEq(token.balanceOf(recipient), mintAmount, "Recipient should have received the minted tokens");
    }

    function testOnlyOwnerCanMint() public {
        address nonOwner = address(0x456);
        uint256 mintAmount = 500 * 10 ** token.decimals();

        // Expect a revert when a non-owner tries to mint
        vm.prank(nonOwner);
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", nonOwner));
        token.mint(nonOwner, mintAmount);
    }
}
