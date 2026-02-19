// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract BookingToken is ERC20, Ownable {
    // Constructor to initialize the token with a name, symbol, and initial supply
    constructor() ERC20("Booking Token", "BOOK") Ownable(msg.sender) {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    // Function to mint new tokens, only callable by the owner
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}

// What this Contract does:
// This contract defines a simple ERC20 token called "Booking Token" with the symbol "BOOK". The contract inherits from OpenZeppelin's ERC20 and Ownable contracts. The constructor initializes the token with a name, symbol, and an initial supply of 1,000,000 tokens assigned to the contract deployer. The contract also includes a mint function that allows the owner to create new tokens and assign them to a specified address. This function can only be called by the owner of the contract, ensuring that token minting is controlled and secure.

// Allows owner to distribute tokens to users so they can book services.
// Used by- admin panel, faucet, promotional credits
