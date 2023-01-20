// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.17;

import "./lib/AddressAliasHelper.sol";

contract L2Rand {
    address public l1RandAddressAlias;

    mapping(uint256 => uint256) public rand;
    mapping(uint256 => uint256) public bounty;
    mapping(uint256 => mapping(address => uint256)) public bountyPaid;

    // The should be configured to a value to account for the delay
    // that L1 block.number is updated on L2
    uint256 public constant MIN_LOOK_AHEAD = 100;

    // Wait this number of L1 block before refund to allow retryable ticket to be redeemed
    uint256 public constant WAIT_BEFORE_REFUND = 100;

    function init(address _l1RandAddress) external {
        require(l1RandAddressAlias == address(0), "already initialized");
        l1RandAddressAlias = AddressAliasHelper.applyL1ToL2Alias(_l1RandAddress);
    }

    function request(uint256 l1block) external payable {
        require(l1block > block.number + MIN_LOOK_AHEAD, "l1 block might already be created");
        bounty[l1block] += msg.value;
        bountyPaid[l1block][msg.sender] += msg.value;
    }

    function refund(uint256 l1block, address refundTo) external payable {
        require(block.number > l1block + WAIT_BEFORE_REFUND, "l1 block not yet relayed");
        uint256 _bountyPaid = bountyPaid[l1block][msg.sender];
        require(_bountyPaid > 0, "no bounty paid");
        bountyPaid[l1block][msg.sender] = 0;
        (bool success,) = refundTo.call{value: _bountyPaid}("");
        require(success, "refund failed");
    }

    function report(uint256 l1block, uint256 value, address sender) external {
        require(msg.sender == l1RandAddressAlias, "only l1Rand can call");
        require(rand[l1block] == 0, "already reported");
        rand[value] = value;
        uint256 _bounty = bounty[l1block];
        bounty[l1block] = 0;
        sender.call{value: _bounty}("");
        // should never revert otherwise sender might block the report
    }
}
