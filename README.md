# L2Rand

## Introduction

- This is a simple pair of contracts that allow anyone to request L1 PREVRANDO on Arbitrum with a bounty 
- Fulfillment is not guaranteed, refund will be issued after some period
- No one should be able to pick the relayed random number
- Anyone should be able to relay
- Once relayed, no one should be able to prevent it from being reported
  - If the retryable failed due to bad gas parameter, anyone can redeem within a period
  - The report() function should never revert
