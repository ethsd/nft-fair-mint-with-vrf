// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "./openzeppelin/ERC721.sol";
import "./openzeppelin/Strings.sol";

error OnlyTheOwnerCanDoThis();
error WrongMintPrice();


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

    uint256 public tokenCount;
    uint256 public mintPrice;
    string public baseURI;


    constructor(string memory _myName, string memory _mySymbol, uint256 _price)
        Ownable(msg.sender)
        ERC721(_myName, _mySymbol)
    {
        mintPrice = _price;
    }

    function mint()
        public
        payable
    {
        if (msg.value != mintPrice) revert WrongMintPrice();
        tokenCount += 1;
        _safeMint(msg.sender, tokenCount);
    }

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

    /*
     * Admin functions
     */
    function setBaseURI(string memory _newBaseURI)
        external
        onlyOwner
        returns (bool)
    {
        baseURI = _newBaseURI;
        return true;
    }

    function setMintPrice(uint256 _newPrice)
        external
        onlyOwner
        returns (bool)
    {
        mintPrice = _newPrice;
        return true;
    }

    function kill()
        external
        onlyOwner
    {
        selfdestruct(payable(msg.sender));
    }

}

