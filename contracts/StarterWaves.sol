// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract StarterWaves {
    uint256 totalWaves;
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    mapping(address => uint256) waveCounts;
    mapping(address => uint256) lastWavedAt;

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;

    constructor() payable {
        console.log("Yo I am a contract"); 
    }

    function wave(string memory _message) public {
        require(
            lastWavedAt[msg.sender] + 1 minutes < block.timestamp,
            "Wait for a minute after the last wave!"
        );
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        waveCounts[msg.sender] += 1;
        waves.push(Wave(msg.sender, _message, block.timestamp));
        console.log("%s has waved!", msg.sender);

        uint256 randomNumber = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: ", randomNumber);

        seed = randomNumber;

        // winner winner chicken dinner
        if(randomNumber < 50) {
            console.log("%s won!", msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            require(prizeAmount <= address(this).balance, "Trying to withdraw more money than what the contract has!");

            // sending money
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract!");
        }

        emit NewWave(msg.sender, block.timestamp, _message);    

    }

    function getTotalWaves () public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function getYourWaves() public view returns (uint256) {
        console.log("%s has waved %d times!", msg.sender, waveCounts[msg.sender]);
        return waveCounts[msg.sender];
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }
}
