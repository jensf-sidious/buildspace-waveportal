// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {

  uint256 private seed;
  uint256 totalWaves;

  event newWave(address indexed from, uint256 timestamp, string message);

  struct Wave {
    address waver;
    string message;
    uint256 timestamp;
  }

  Wave[] waves;

  /*
  * address => uint mapping
  */
  mapping(address => uint256) public lastWavedAt;

  // payable: can send ether to users
  constructor() payable {
    // set the initial seed
    seed = (block.timestamp + block.difficulty) % 100;
  }

  function wave(string memory _message) public {

    /*
    * Make sure the current timestamp is at least 15
    * minutes bigger than the last timestamp from this address
    */
    require(
      lastWavedAt[msg.sender] + 30 seconds < block.timestamp, "Wait at least 15 minutes!"
    );

    /*
    * Update the timestamp for the user
    */
    lastWavedAt[msg.sender] = block.timestamp;

    totalWaves += 1;
    console.log("%s waved w/ message %s", msg.sender, _message);

    waves.push(Wave(msg.sender, _message, block.timestamp));

    /*
    * Generate a new seed for the nect user
    */
    seed = (block.timestamp + block.difficulty) % 100;
    console.log("Random seed generated: %d", seed);

    if(seed <= 50) {
      console.log("%s won!", msg.sender);

      // solidity knows the keyword ether.
      uint256 prizeAmount = 0.0001 ether;
      // Check that the prizeAmount is less than the contract's balance
      require(
        prizeAmount <= address(this).balance,
        "Trying to withdraw more money than the contract has."
      );
      // Magic line to send money :P
      // Syntax is a little weird
      (bool success, ) = (msg.sender).call{value: prizeAmount}("");
      require(success, "Failed to withdraw monety from contract.");
    }

    emit newWave(msg.sender, block.timestamp, _message);
  }

  function getAllWaves() public view returns (Wave[] memory) {
    return waves;
  }

  function getTotalWaves() public view returns (uint256) {
    return totalWaves;
  }
}