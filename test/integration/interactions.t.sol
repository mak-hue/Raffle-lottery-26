//unit test
//integration test testing how the different contracts interact with each other
//forked test testing how he contract work in a simulated mainnet environment
//staging test testing in real evnvironment either testnet or mainnet

//fuzzing test testing with random data to find edge cases and vulnerabilities
//stateful test testing the contract's behavior over time and with different states
//stateless test testing the contract's behavior without relying on any specific state or context
//formal verification using mathematical methods to prove the correctness of the contract's logic and behavior

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {Raffle} from "../../src/Raffle.sol";
import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {VRFCoordinatorV2_5Mock} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

contract RaffleIntegrationTest is Test {
    Raffle public raffle;
    HelperConfig public helperConfig;

    uint256 entranceFee;
    uint256 interval;
    address vrfCoordinator;
    uint256 subscriptionId;

    address public PLAYER = makeAddr("player");
    uint256 public constant STARTING_USER_BALANCE = 10 ether;

    function setUp() external {
        // We use the actual deployment script to ensure the test environment
        // matches the real deployment (Sub created, funded, consumer added)
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.deployContract();

        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        entranceFee = config.entranceFee;
        interval = config.interval;
        vrfCoordinator = config.vrfCoordinator;
        subscriptionId = config.subscriptionId;

        vm.deal(PLAYER, STARTING_USER_BALANCE);
    }

    /**
     * @notice This is a massive integration test.
     * It tests: Raffle -> VRFCoordinator -> Raffle (Fulfillment) -> Payout
     */
    function testRaffleIntegratesWithVRFAndPicksWinner() public {
        // 1. Arrange: User enters raffle
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();

        // 2. Arrange: Warp time so upkeep is needed
        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1);

        // 3. Act: Chainlink Automation triggers performUpkeep
        // We record logs to catch the requestId emitted by the VRFCoordinator
        vm.recordLogs();
        raffle.performUpkeep(""); 
        
        // entries[1] is usually the RandomWordsRequested event
        bytes32 requestId = vm.getRecordedLogs()[1].topics[1];

        // 4. Act: VRF Node (Mock) fulfills the request
        // This simulates the external VRF service calling back into your contract
        uint256 startingBalance = address(raffle).balance;
        
        VRFCoordinatorV2_5Mock(vrfCoordinator).fulfillRandomWords(
            uint256(requestId),
            address(raffle)
        );

        // 5. Assert: Verify the interaction results
        // - The winner should be the only player (PLAYER)
        // - The state should be back to OPEN
        // - The raffle balance should be 0 (payout complete)
        // - The winner's balance should have increased
        assert(raffle.getRecentWinner() == PLAYER);
        assert(uint256(raffle.getRaffleState()) == 0);
        assert(address(raffle).balance == 0);
        assert(PLAYER.balance == (STARTING_USER_BALANCE - entranceFee) + startingBalance);
    }
}


