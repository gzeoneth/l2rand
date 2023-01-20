// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.17;

import "./interface/IInbox.sol";

contract L1Rand {
    IInbox public immutable inbox;
    address public immutable l2RandAddress;

    constructor(address _inbox, address _l2RandAddress) {
        inbox = IInbox(_inbox);
        l2RandAddress = _l2RandAddress;
    }

    function relay(uint256 blocknumber, uint256 maxSubmissionCost, uint256 gasLimit, uint256 maxFeePerGas)
        external
        payable
    {
        require(block.number == blocknumber, "wrong block number");
        bytes memory data =
            abi.encodeWithSignature("report(uint256,uint256,address)", block.number, block.difficulty, msg.sender);
        inbox.createRetryableTicket{value: msg.value}({
            to: l2RandAddress,
            l2CallValue: 0,
            maxSubmissionCost: maxSubmissionCost,
            excessFeeRefundAddress: msg.sender,
            callValueRefundAddress: address(0), // no one can cancel the retryable
            gasLimit: gasLimit,
            maxFeePerGas: maxFeePerGas,
            data: data
        });
    }
}
