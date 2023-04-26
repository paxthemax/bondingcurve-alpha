// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {ERC20} from "solmate/src/tokens/ERC20.sol";
import {SafeTransferLib} from "solmate/src/utils/SafeTransferLib.sol";

import {BancorFormula} from "./lib/BancorFormula.sol";

import "./test/utils/Test.sol";

contract BondingCurveToken is ERC20, BancorFormula, Test {
    using SafeTransferLib for ERC20;

    error NoZeroPurchase();
    error InvalidBalance(address sender, uint256 amount);

    uint32 public immutable reserveRatio;
    ERC20 public immutable reserveToken;

    event CurveBuy(address indexed buyer, uint256 ethAmount, uint256 tokensReceived);
    event CurveSell(address indexed seller, uint256 tokenAmount, uint256 ethReceived);

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        address reserveTokenAddress,
        uint32 _reserveRatio,
        uint256 _initialTotalSupply,
        uint256 _initialPoolBalance
    ) ERC20(_name, _symbol, _decimals) {
        reserveToken = ERC20(reserveTokenAddress);
        reserveRatio = _reserveRatio;

        _mint(address(this), _initialTotalSupply);
        reserveToken.safeTransferFrom(msg.sender, address(this), 1);
    }

    function poolBalance() public view returns (uint256) {
        return reserveToken.balanceOf(address(this));
    }

    function buy(uint256 reserveAmount) external {
        if (reserveAmount == 0) revert NoZeroPurchase();

        uint256 tokensToMint = calculatePurchaseReturn(
            totalSupply,
            poolBalance(),
            reserveRatio,
            reserveAmount
        );

        _mint(msg.sender, tokensToMint);

        reserveToken.transferFrom(msg.sender, address(this), reserveAmount);

        emit CurveBuy(msg.sender, reserveAmount, tokensToMint);
    }

    function sell(uint256 tokenAmount) external {
        if (balanceOf[msg.sender] < tokenAmount) revert InvalidBalance(msg.sender, tokenAmount);

        uint256 reserveAmount = calculateSaleReturn(
            totalSupply,
            poolBalance(),
            reserveRatio,
            tokenAmount
        );

        _burn(msg.sender, tokenAmount);

        reserveToken.safeTransfer(msg.sender, reserveAmount);

        emit CurveSell(msg.sender, tokenAmount, reserveAmount);
    }
}
