// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import {Test} from "./utils/Test.sol";
import {CurveWrapper} from "../CurveWrapper.sol";

contract CurveWrapperTest is Test {
    CurveWrapper curve;

    function setUp() public {
        curve = new CurveWrapper();

        curve.setReserveRatio(1);
        curve.setPoolBalance(10 ether); // of reserve
        curve.setTotalSupply(10 ether); // of token
    }

    function testInitial() public {
        assertEq(curve.reserveRatio(), 1);
        assertEq(curve.poolBalance(), 10 ether);
        assertEq(curve.totalSupply(), 10 ether);
    }

    function testBuyPrice() public {
        curve.setPoolBalance(10 ^ 6 ether); // of reserve
        curve.setTotalSupply(10 ^ 6 ether); // of token

        curve.calculateBuyPrice(curve.calculateBuyPrice(1 ether));
        // assertEq(res, 0);
    }

    function testSellPrice() public {
        curve.setPoolBalance(10 ^ 6 ether);
        curve.setTotalSupply(10 ^ 6 ether);

        curve.calculateBuyPrice(curve.calculateBuyPrice(1 ether));
        // assertEq(res, 0);
    }
}
