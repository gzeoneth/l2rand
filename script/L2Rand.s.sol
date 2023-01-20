// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/L2Rand.sol";

contract L2RandScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        new L2Rand();
        vm.stopBroadcast();
    }
}
