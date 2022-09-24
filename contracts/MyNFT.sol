// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "./openzeppelin/ERC721.sol";
import "./openzeppelin/Strings.sol";

error OnlyTheOwnerCanDoThis();

contract Ownable {
    address public owner;
    constructor(address _owner)
    {
        owner = _owner;
    }

    modifier onlyOwner()
    {
        if (msg.sender != owner) revert OnlyTheOwnerCanDoThis();
        _;
    }

    function updateOwner(address _newOwner)
        external
        onlyOwner
        returns (bool)
    {
        owner = _newOwner;
        return true;
    }
}

contract MyNFT is Ownable, ERC721 {
    using Strings for uint256;

    string public baseURI;

    constructor(string memory myName, string memory mySymbol)
        Ownable(msg.sender)
        ERC721(myName, mySymbol)
    {}

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        string memory baseURI_ = _baseURI();
        return bytes(baseURI_).length > 0 ? string(abi.encodePacked(baseURI_, tokenId.toString(), ".json")) : "";
    }

    function _baseURI() 
        internal 
        view 
        virtual 
        override 
        returns (string memory)
    {
        return baseURI;
    }

    function setBaseURI(string memory _newBaseURI)
        external
        onlyOwner
        returns (bool)
    {
        baseURI = _newBaseURI;
        return true;
    }


}

