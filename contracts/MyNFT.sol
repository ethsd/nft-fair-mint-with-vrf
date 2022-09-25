// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "./openzeppelin/ERC721.sol";
import "./openzeppelin/ERC721Enumerable.sol";
import "./openzeppelin/Strings.sol";
import "./chainlink/VRFCoordinatorV2Interface.sol";
import "./chainlink/VRFConsumerBaseV2.sol";

error OnlyTheOwnerCanDoThis();
error WrongMintPrice();
error SoldOut();


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

// VRF Subscription ID 2003: https://vrf.chain.link/mumbai/2003

contract MyNFT is Ownable, ERC721, ERC721Enumerable, VRFConsumerBaseV2 {
    using Strings for uint256;

    // constants
    bytes32 private constant CHAINLINK_HASH = 0x4b09e658ed251bcafeebbc69400383d49f344ace09b9576fe248bb02c003fe9f;
    uint32 private constant CALLBACK_GAS_LIMIT = 2000000;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint16 private constant NUMBER_OF_WORDS = 1;

    // global uints
    uint256 public tokensAvailable;
    uint256 public mintPrice;
    uint64 public subscriptionId;

    // global strings
    string public baseURI;

    // mappings
    mapping(uint256 => address) public requestIdToSender;

    // token array
    uint256[] public tokenPool;

    // Interfaces
    VRFCoordinatorV2Interface internal COORDINATER;

    event FreshMint(
        uint256 indexed requestId,
        uint256 tokenId,
        uint256 randomId,
        address owner
    );

    constructor(
        string memory _myName, 
        string memory _mySymbol, 
        uint256 _price,
        uint256 _totalSupply,
        uint64 _subId
    )
        Ownable(msg.sender)
        ERC721(_myName, _mySymbol)
        VRFConsumerBaseV2(address(0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed))
    {
        mintPrice = _price;
        tokensAvailable = _totalSupply;
        tokenPool = new uint256[](_totalSupply + 1);
        subscriptionId = _subId;
        COORDINATER = VRFCoordinatorV2Interface(address(0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed));
        baseURI = 'https://smart-piglets-founders-club-metadata.s3.us-east-2.amazonaws.com/';
    }

    function _beforeTokenTransfer(
        address _from,
        address _to,
        uint256 _tokenId
    )
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(_from, _to, _tokenId);
    }

    function mint()
        external
        payable
    {
        if (msg.value != mintPrice) revert WrongMintPrice();
        if (tokensAvailable == 0) revert SoldOut();
        
        uint256 requestId = COORDINATER.requestRandomWords(
            CHAINLINK_HASH,
            subscriptionId,
            REQUEST_CONFIRMATIONS,
            CALLBACK_GAS_LIMIT,
            NUMBER_OF_WORDS
        );

        requestIdToSender[requestId] = msg.sender;
    }

    function swap(uint256 _index)
        internal
        view
        returns (uint256)
    {
        if (tokenPool[_index] == 0) {
            return _index;
        }
        return tokenPool[_index];
    }

    function fulfillRandomWords(uint256 _requestId, uint256[] memory randomWords)
        internal
        override
    {
        address newOwner = requestIdToSender[_requestId];
        uint256 randomId = randomWords[0] % tokensAvailable + 1;
        uint256 tokenId;
        if (tokensAvailable == 1) {
            if (tokenPool[1] == 0) {
                tokenId = 1;
            }
            else {
                tokenId = tokenPool[1];
            }
        }
        else if (tokenPool[randomId] == 0) {
            tokenId = randomId;
        }
        else {
            tokenId = tokenPool[randomId];
        }
        // swap if not at tail position
        if (randomId != tokensAvailable) {
            // not tail position, swap
            tokenPool[randomId] = swap(tokensAvailable);
        }
        tokensAvailable -= 1;
        _safeMint(newOwner, tokenId);
        emit FreshMint(_requestId, tokenId, randomId, newOwner);
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

    function setSubscriptionId(uint64 _subId)
        external
        onlyOwner
        returns (bool)
    {
        subscriptionId = _subId;
        return true;
    }

    function withdraw()
        external
        onlyOwner
    {
        payable(msg.sender).transfer(address(this).balance);
    }

    function kill()
        external
        onlyOwner
    {
        selfdestruct(payable(msg.sender));
    }

}

