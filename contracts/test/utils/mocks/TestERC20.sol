// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {ERC20} from "solmate/src/tokens/ERC20.sol";

contract TestERC20 is ERC20 {
    uint8 private constant DECIMALS = 18;

    constructor() ERC20("", "", DECIMALS) {}

    function mint(address to, uint256 amount) public virtual {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public virtual {
        _burn(from, amount);
    }
}
