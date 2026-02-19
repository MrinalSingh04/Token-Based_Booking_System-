// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/BookingToken.sol";
import "../src/BookingSystem.sol";

contract Deploy is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerKey);

        BookingToken token = new BookingToken();
        BookingSystem booking = new BookingSystem(address(token));

        vm.stopBroadcast();

        console.log("Token:", address(token));
        console.log("Booking:", address(booking));
    }
}
