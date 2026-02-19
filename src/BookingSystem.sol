// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import "openzeppelin-contracts/contracts/utils/Pausable.sol";

contract BookingSystem is Ownable, ReentrancyGuard, Pausable {
    using SafeERC20 for IERC20;

    // =============================================================
    //                          ERRORS
    // =============================================================

    error InvalidPrice();
    error ServiceNotFound();
    error ServiceInactive();
    error NotBookingOwner();
    error AlreadyCancelled();
    error ZeroAddress();
    error InvalidServiceId();

    // =============================================================
    //                          STORAGE
    // =============================================================

    IERC20 public immutable paymentToken;

    uint256 public serviceCount;
    uint256 public bookingCount;

    struct Service {
        string name;
        uint256 price;
        bool active;
    }

    struct Booking {
        address user;
        uint256 serviceId;
        uint256 amountPaid;
        bool cancelled;
        uint256 timestamp;
    }

    mapping(uint256 => Service) public services;
    mapping(uint256 => Booking) public bookings;

    // =============================================================
    //                          EVENTS
    // =============================================================

    event ServiceAdded(uint256 indexed id, string name, uint256 price);
    event ServiceUpdated(uint256 indexed id, uint256 newPrice, bool active);
    event Booked(uint256 indexed bookingId, address indexed user, uint256 indexed serviceId);
    event Cancelled(uint256 indexed bookingId);

    // =============================================================
    //                        CONSTRUCTOR
    // =============================================================

    constructor(address tokenAddress) Ownable(msg.sender) {
        if (tokenAddress == address(0)) revert ZeroAddress();
        paymentToken = IERC20(tokenAddress);
    }

    // =============================================================
    //                      ADMIN FUNCTIONS
    // =============================================================

    function addService(string calldata name, uint256 price) external onlyOwner {
        if (price == 0) revert InvalidPrice();

        unchecked {
            serviceCount++;
        }

        services[serviceCount] = Service({name: name, price: price, active: true});

        emit ServiceAdded(serviceCount, name, price);
    }

    function updateService(uint256 id, uint256 newPrice, bool active) external onlyOwner {
        if (id == 0 || id > serviceCount) revert ServiceNotFound();

        Service storage s = services[id];

        s.price = newPrice;
        s.active = active;

        emit ServiceUpdated(id, newPrice, active);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    // =============================================================
    //                      USER FUNCTIONS
    // =============================================================

    function book(uint256 serviceId) external whenNotPaused nonReentrant {
        if (serviceId == 0 || serviceId > serviceCount) {
            revert InvalidServiceId();
        }

        Service memory s = services[serviceId];

        if (!s.active) revert ServiceInactive();

        paymentToken.safeTransferFrom(msg.sender, address(this), s.price);

        unchecked {
            bookingCount++;
        }

        bookings[bookingCount] = Booking({
            user: msg.sender, serviceId: serviceId, amountPaid: s.price, cancelled: false, timestamp: block.timestamp
        });

        emit Booked(bookingCount, msg.sender, serviceId);
    }

    function cancel(uint256 bookingId) external nonReentrant {
        Booking storage b = bookings[bookingId];

        if (b.user != msg.sender) revert NotBookingOwner();
        if (b.cancelled) revert AlreadyCancelled();

        b.cancelled = true;

        paymentToken.safeTransfer(msg.sender, b.amountPaid);

        emit Cancelled(bookingId);
    }

    // =============================================================
    //                      VIEW HELPERS
    // =============================================================

    function getService(uint256 id) external view returns (Service memory) {
        if (id == 0 || id > serviceCount) revert ServiceNotFound();
        return services[id];
    }

    function getBooking(uint256 id) external view returns (Booking memory) {
        return bookings[id];
    }
}
