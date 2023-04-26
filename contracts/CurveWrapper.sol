// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {ERC20} from "solmate/src/tokens/ERC20.sol";

import {BancorFormula} from "./lib/BancorFormula.sol";

contract CurveWrapper is BancorFormula {
    uint32 public reserveRatio;
    uint256 public poolBalance;
    uint256 public totalSupply;

    error AmountNotZero();

    event CurveBuy(address indexed sender, uint256 minted, uint256 cost);
    event CurveSell(address indexed sender, uint256 withdrawn, uint256 reward);

    function setReserveRatio(uint32 _reserveRatio) external {
        reserveRatio = _reserveRatio;
    }

    function setPoolBalance(uint256 _poolBalance) external {
        poolBalance = _poolBalance;
    }

    function setTotalSupply(uint256 _totalSupply) external {
        totalSupply = _totalSupply;
    }

    function calculateBuyPrice(uint256 amount) public view returns (uint256) {
        return calculatePurchaseReturn(totalSupply, poolBalance, reserveRatio, amount);
    }

    function calculateSellPrice(uint256 amount) public view returns (uint256) {
        return calculateSaleReturn(totalSupply, poolBalance, reserveRatio, amount);
    }

    function simulateBuy(uint256 amount) external returns (uint256) {
        if (amount == 0) revert AmountNotZero();

        uint256 toMint = calculateBuyPrice(amount);

        totalSupply += toMint;
        poolBalance += toMint;

        emit CurveBuy(msg.sender, toMint, amount);

        return toMint;
    }

    function simulateSell(uint256 amount) external returns (uint256) {
        if (amount == 0) revert AmountNotZero();

        uint256 reserveAmount = calculateSellPrice(amount);

        poolBalance -= reserveAmount;
        totalSupply -= amount;

        emit CurveSell(msg.sender, amount, reserveAmount);

        return reserveAmount;
    }
}
