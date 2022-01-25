// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {

  event newWave(address indexed from, uint256 timestamp, string message);

  struct Wave {
    address waver;
    string message;
    uint256 timestamp;
  }

  uint256 totalWaves;

  Wave[] waves;

  constructor() {}

  function wave(string memory _message) public {
    totalWaves += 1;
    console.log("%s waved w/ message %s", msg.sender, _message);

    waves.push(Wave(msg.sender, _message, block.timestamp));

    emit newWave(msg.sender, block.timestamp, _message);
  }

  function getAllWaves() public view returns (Wave[] memory) {
    return waves;
  }

  function getTotalWaves() public view returns (uint256) {
    return totalWaves;
  }
}