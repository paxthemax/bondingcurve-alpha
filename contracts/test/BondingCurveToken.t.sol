// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import {SafeTransferLib} from "solmate/src/utils/SafeTransferLib.sol";

import {Test} from "./utils/Test.sol";
import {TestERC20} from "../test/utils/mocks/TestERC20.sol";
import {BondingCurveToken} from "../BondingCurveToken.sol";

contract BondingCurveTokenTest is Test {
    TestERC20 reserve;
    BondingCurveToken curve;

    uint32 public constant RESERVE_RATIO = 1;
    uint256 public constant INITIAL_TOTAL_SUPPLY = 10 ether;
    uint256 public constant INITIAL_POOL_BALANCE = 10 ether;

    function setUp() public {
        reserve = new TestERC20();

        reserve.mint(address(this), INITIAL_POOL_BALANCE);
        reserve.approve(address(curve), INITIAL_POOL_BALANCE);

        curve = new BondingCurveToken(
            "",
            "",
            18,
            address(reserve),
            RESERVE_RATIO,
            INITIAL_TOTAL_SUPPLY,
            INITIAL_POOL_BALANCE
        );
    }

    function testInvariant() public {
        // assertEq(curve.name(), "");
        // assertEq(curve.symbol(), "");
        // assertEq(curve.decimals(), 18);
        // assertEq(curve.reserveRatio(), RESERVE_RATIO);
    }

    // function testBuy(uint256 amount) public {
    //     if (amount == 0) amount = 1;

    //     address alice = address(0xABBA);
    //     uint256 aliceReserveAmount = amount;

    //     reserve.mint(alice, aliceReserveAmount);
    //     assertEq(reserve.balanceOf(alice), aliceReserveAmount);

    //     vm.prank(alice);
    //     reserve.approve(address(curve), aliceReserveAmount);
    //     assertEq(reserve.allowance(alice, address(curve)), aliceReserveAmount);

    //     uint256 alicePreDepositBal = reserve.balanceOf(alice);

    //     // vm.prank(address(curve));
    //     // reserve.transferFrom(alice, address(curve), aliceReserveAmount);
    //     // curve.buy(aliceReserveAmount);
    // }

    // function testInitial() public {
    //     assertEq(reserve.balanceOf(address(curve)), 10 ether); // pool balance
    //     assertEq(curve.balanceOf(address(curve)), 10 ether); // initial supply
    // }

    // function testBuy() public {
    //     address testAddr = address(0xBEEF);
    //     vm.prank(testAddr);

    //     reserve.mint(testAddr, 10 ether);
    //     assertEq(reserve.balanceOf(testAddr), 10 ether);

    //     reserve.transfer(address(0xDEAD), 1 ether);
    //     // curve.buy(1 ether);
    // }
}
