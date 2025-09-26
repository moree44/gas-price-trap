// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title Gas Price Trap (POC)
/// @notice Blocks actions when gas price exceeds a configurable limit (simple anti-MEV filter)
contract GasGuard {
    uint256 public maxGasWei = 30_000_000_000; // 30 gwei
    address public owner;

    event MaxGasUpdated(uint256 oldValue, uint256 newValue);

    constructor() { owner = msg.sender; }

    /// @notice Update gas limit (wei)
    function setMaxGasWei(uint256 _newLimit) external {
        require(msg.sender == owner, "not authorized");
        emit MaxGasUpdated(maxGasWei, _newLimit);
        maxGasWei = _newLimit;
    }

    /// @notice Demo action to prove the trap
    function protectedAction() external view returns (string memory) {
        require(tx.gasprice <= maxGasWei, "gas too high: trap active");
        return "ok: trap passed";
    }
}