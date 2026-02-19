// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/BookingSystem.sol";
import "../src/BookingToken.sol";

contract BookingSystemTest is Test {
    BookingToken token;
    BookingSystem booking;

    address owner = address(this);
    address user = address(1);
    address attacker = address(2);

    uint256 servicePrice = 100 ether;

    // =============================================================
    //                           SETUP
    // =============================================================

    function setUp() public {
        token = new BookingToken();
        booking = new BookingSystem(address(token));

        // give user tokens
        token.mint(user, 1000 ether);

        // approve contract
        vm.prank(user);
        token.approve(address(booking), type(uint256).max);
    }

    // =============================================================
    //                      DEPLOYMENT TESTS
    // =============================================================

    function testTokenAddressSet() public view {
        assertEq(address(booking.paymentToken()), address(token));
    }

    // =============================================================
    //                     SERVICE MANAGEMENT
    // =============================================================

    function testAddService() public {
        booking.addService("Hotel Room", servicePrice);

        (string memory name, uint256 price, bool active) = booking.services(1);

        assertEq(name, "Hotel Room");
        assertEq(price, servicePrice);
        assertTrue(active);
    }

    function testOnlyOwnerCanAddService() public {
        vm.prank(user);
        vm.expectRevert();
        booking.addService("Fail", servicePrice);
    }

    function testUpdateService() public {
        booking.addService("Room", servicePrice);

        booking.updateService(1, 200 ether, false);

        (, uint256 price, bool active) = booking.services(1);

        assertEq(price, 200 ether);
        assertFalse(active);
    }

    // =============================================================
    //                       BOOKING FLOW
    // =============================================================

    function testBookingFlow() public {
        booking.addService("Room", servicePrice);

        vm.prank(user);
        booking.book(1);

        (address bookUser, uint256 serviceId, uint256 amount, bool cancelled,) = booking.bookings(1);

        assertEq(bookUser, user);
        assertEq(serviceId, 1);
        assertEq(amount, servicePrice);
        assertFalse(cancelled);
    }

    function testTokenTransferredOnBooking() public {
        booking.addService("Room", servicePrice);

        uint256 beforeBal = token.balanceOf(address(booking));

        vm.prank(user);
        booking.book(1);

        uint256 afterBal = token.balanceOf(address(booking));

        assertEq(afterBal - beforeBal, servicePrice);
    }

    // =============================================================
    //                       CANCELLATION
    // =============================================================

    function testCancelBooking() public {
        booking.addService("Room", servicePrice);

        vm.prank(user);
        booking.book(1);

        uint256 before = token.balanceOf(user);

        vm.prank(user);
        booking.cancel(1);

        uint256 afterBal = token.balanceOf(user);

        assertGt(afterBal, before);

        (,,, bool cancelled,) = booking.bookings(1);
        assertTrue(cancelled);
    }

    function testCannotCancelTwice() public {
        booking.addService("Room", servicePrice);

        vm.prank(user);
        booking.book(1);

        vm.prank(user);
        booking.cancel(1);

        vm.prank(user);
        vm.expectRevert();
        booking.cancel(1);
    }

    function testNonOwnerCannotCancel() public {
        booking.addService("Room", servicePrice);

        vm.prank(user);
        booking.book(1);

        vm.prank(attacker);
        vm.expectRevert();
        booking.cancel(1);
    }

    // =============================================================
    //                       PAUSE TESTS
    // =============================================================

    function testPauseStopsBooking() public {
        booking.addService("Room", servicePrice);
        booking.pause();

        vm.prank(user);
        vm.expectRevert();
        booking.book(1);
    }

    function testUnpauseRestoresBooking() public {
        booking.addService("Room", servicePrice);
        booking.pause();
        booking.unpause();

        vm.prank(user);
        booking.book(1);

        assertEq(booking.bookingCount(), 1);
    }

    // =============================================================
    //                      EDGE CASES
    // =============================================================

    function testInvalidServiceId() public {
        vm.prank(user);
        vm.expectRevert();
        booking.book(999);
    }

    function testInactiveServiceCannotBeBooked() public {
        booking.addService("Room", servicePrice);
        booking.updateService(1, servicePrice, false);

        vm.prank(user);
        vm.expectRevert();
        booking.book(1);
    }
}

// Skill	          Demonstrated

// State validation	       ✔
// Access control	       ✔
// Token economics	       ✔
// Security logic	       ✔
// Failure testing	       ✔
// Edge cases    	       ✔
// Role simulation	       ✔
