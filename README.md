# 📘 Token-Based Booking System (Smart Contracts)

Production-grade Solidity smart contracts for a **Token-Powered Booking Platform** built with **Foundry**, featuring secure payments, refunds, admin-managed services, and custom-error optimized gas usage.

---

## 🚀 Deployment Details (Sepolia Testnet)

### BookingToken Contract

* **Address:** `0xc98E63aFB782C96eb24af410c3c63091Db663a73`
* **Explorer:** https://sepolia.etherscan.io/address/0xc98E63aFB782C96eb24af410c3c63091Db663a73
* **Network:** Sepolia

---

### BookingSystem Contract

* **Address:** `0xeAaDD7C8200FcC208eA126FF945F6D03a59378A0`
* **Explorer:** https://sepolia.etherscan.io/address/0xeAaDD7C8200FcC208eA126FF945F6D03a59378A0
* **Network:** Sepolia

---

## 📦 Contracts Overview

### BookingToken.sol

ERC20 utility token used for platform payments.

**Features**

* Name: `Booking Token`
* Symbol: `BOOK`
* Initial Supply: **1,000,000 tokens**
* Owner mintable
* OpenZeppelin-secured implementation

**Purpose**

* Used as payment currency for bookings
* Distributed via admin panel / faucet / rewards

---

### BookingSystem.sol

Core booking logic contract.

**Architecture Features**

* Admin-created services
* Refundable bookings
* Multiple bookings per user
* Pausable system
* Reentrancy protection
* SafeERC20 transfers
* Custom errors for gas efficiency

---

## 🔐 Security Design

* Custom Errors (gas optimized reverts)
* Checks-Effects-Interactions pattern
* ReentrancyGuard on state-changing calls
* Pausable emergency stop
* Strict validation checks
* Immutable payment token address

---

## 📊 Data Structures

### Service

```
name
price
active
```

### Booking

```
user
serviceId
amountPaid
cancelled
timestamp
```

---

## 📡 Events

* `ServiceAdded`
* `ServiceUpdated`
* `Booked`
* `Cancelled`

Designed for backend indexers + frontend live UI updates.

---

## 🧪 Testing

Run full test suite

```bash
forge test -vvv
```

Gas snapshot

```bash
forge snapshot
```

Coverage

```bash
forge coverage
```

---

## 📁 Project Structure

```
src/
 ├── BookingToken.sol
 └── BookingSystem.sol

script/
 ├── Deploy.s.sol
 

test/
 ├── BookingToken.t.sol
 └── BookingSystem.t.sol
```

---

## 🔄 User Flow

1. Admin deploys BookingToken
2. Admin deploys BookingSystem with token address
3. Admin creates services
4. User approves token
5. User books service
6. Tokens transferred to contract
7. User may cancel → refund issued

---

## 🧱 Tech Stack

* Solidity ^0.8.24
* Foundry
* OpenZeppelin Contracts
* Sepolia Testnet

---

## 🔮 Future Upgrades

* NFT Booking Receipts
* Signature-based bookings
* Backend indexer API
* Loyalty rewards system
* Booking expiry automation
* Upgradeable proxy version

---

## 👨‍💻 Author

**Mrinal Singh**
Smart Contract Engineer
Solidity • Foundry • Web3 Architecture

---

## 📜 License

MIT
