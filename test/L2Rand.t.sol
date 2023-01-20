// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../src/L2Rand.sol";

contract L2RandTest is Test {
    L2Rand public l2rand;
    address public l1RandAddress = address(1001);
    address public bountyhunter = address(1002);

    function setUp() public {
        l2rand = new L2Rand();
        l2rand.init(l1RandAddress);
    }

    function testBounty() public {
        l2rand.request{value: 1337}(1000);
        vm.startPrank(l2rand.l1RandAddressAlias());
        l2rand.report(1000, 42, bountyhunter);
        assertEq(bountyhunter.balance, 1337);
        vm.stopPrank();
    }

    function testRefund() public {
        l2rand.request{value: 1337}(1000);
        vm.roll(1000 + l2rand.WAIT_BEFORE_REFUND() + 1);
        l2rand.refund(1000, bountyhunter);
        assertEq(bountyhunter.balance, 1337);
    }
}
