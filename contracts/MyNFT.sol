// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "./openzeppelin/ERC721.sol";

contract MyNFT is ERC721 {
    
    constructor(string memory myName, string memory mySymbol)
        ERC721(myName, mySymbol)
    {}
}

