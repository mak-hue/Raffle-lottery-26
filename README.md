# 🎲 Provably Random Raffle Contract

## 📝 About

This project implements a fully automated, decentralized, and provably fair lottery system using **Solidity**. It leverages **Chainlink VRF v2.5** for cryptographically secure randomness and **Chainlink Automation** for trustless execution.

## 🚀 Deployment Details

The contract is live on the **Ethereum Sepolia Testnet**.

  * **Contract Address:** [`0x40F4b9205c130EBc55517d7B4Ff71D6805e83634`]([https://www.google.com/search?q=%5Bhttps://sepolia.etherscan.io/address/0x40f4b9205c130ebc55517d7b4ff71d6805e83634%23code%5D\(https://sepolia.etherscan.io/address/0x40f4b9205c130ebc55517d7b4ff71d6805e83634%23code\](https://sepolia.etherscan.io/address/0x40F4b9205c130EBc55517d7B4Ff71D6805e83634))
  * **Network:** Sepolia (Testnet)

-----

## 🛠 Features

1.  **Ticket Entry:** Users enter by paying a set `entranceFee`.
2.  **Automated Draw:** The raffle draws a winner automatically once a specific time `interval` has passed.
3.  **Provable Randomness:** Winners are selected via Chainlink VRF, ensuring no one (not even the developer) can rig the results.
4.  **Full Payout:** The entire balance of the contract is transferred to the winner automatically.

-----

## 💻 Frontend Integration Guide

To build a frontend for this raffle, use the following technical details:

### 1\. Key Functions to Call

| Function | Type | Description |
| :--- | :--- | :--- |
| `enterRaffle()` | `payable` | Send ETH equal to the entrance fee to join. |
| `getEntranceFee()` | `view` | Returns the required ETH to enter. |
| `getRaffleState()` | `view` | `0` = OPEN, `1` = CALCULATING. |
| `getRecentWinner()` | `view` | Returns the address of the last winner. |
| `getPlayer(index)` | `view` | Returns the address of a player at a specific index. |

### 2\. Events to Listen For

Frontend apps should listen to these events to update the UI in real-time:

  * `RaffleEntered(address indexed player)`: Trigger a "New entrant\!" notification.
  * `WinnerPicked(address indexed winner)`: Trigger a "Winner announced\!" celebration UI.

-----

## 🧪 Testing Suite

This project uses **Foundry** for a robust testing environment.

### 1\. Local Testing (Anvil)

Simulates the VRF using mocks to test logic without spending real ETH.

```bash
forge test
```

### 2\. Forked Testing

Tests against a snapshot of the Sepolia network to ensure integration with real Chainlink nodes works as expected.

```bash
forge test --fork-url $SEPOLIA_RPC_URL
```

### 3\. Integration Tests

Verifies the full lifecycle: `Enter -> PerformUpkeep -> FulfillRandomness -> Payout`.

-----

## 🛠 Setup & Installation

1.  **Clone the repo**
2.  **Install dependencies:**
    ```bash
    make install # or forge install
    ```
3.  **Build the project:**
    ```bash
    forge build
    ```

-----

## 🛡 Security

  * **CEI Pattern:** Uses Checks-Effects-Interactions to prevent re-entrancy.
  * **Gas Optimized:** Custom errors (`Raffle__SendMoreToEnterRaffle`) are used instead of strings to save gas.
  * **Immutable Variables:** Critical addresses and fees are set once at deployment to prevent tampering.

-----

## 🤝 Contributing

Contributions are welcome\! Please feel free to submit a Pull Request.

**Author:** Echomak
