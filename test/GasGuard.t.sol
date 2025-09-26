// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/GasGuard.sol";

contract GasGuardTest is Test {
    GasGuard guard;

    function setUp() public {
        guard = new GasGuard(); // default maxGasWei = 30 gwei
    }

    function test_Pass_WhenGasBelowOrEqualLimit() public {
        vm.txGasPrice(25 gwei);
        string memory res = guard.protectedAction();
        assertEq(res, "ok: trap passed");
    }

    function test_Revert_WhenGasAboveLimit() public {
        vm.txGasPrice(60 gwei);
        vm.expectRevert(bytes("gas too high: trap active"));
        guard.protectedAction();
    }

    function test_UpdateLimit_AllowsHigherGas() public {
        // before: 60 gwei would revert
        vm.txGasPrice(60 gwei);
        vm.expectRevert(bytes("gas too high: trap active"));
        guard.protectedAction();

        // after update: should pass
        guard.setMaxGasWei(100 gwei);
        string memory res = guard.protectedAction();
        assertEq(res, "ok: trap passed");
    }

    // (bonus) fuzz: any gas > limit must revert
    function testFuzz_Revert_ForAnyGasAboveLimit(uint96 gasWei) public {
        // bound gas to > 30 gwei up to a safe max
        gasWei = uint96(bound(uint256(gasWei), 30 gwei + 1, 500 gwei));
        vm.txGasPrice(uint256(gasWei));
        vm.expectRevert(bytes("gas too high: trap active"));
        guard.protectedAction();
    }
}
