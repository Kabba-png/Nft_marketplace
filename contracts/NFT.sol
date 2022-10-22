// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721URIStorage {
 
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
 
    address private marketplaceAddress;
    mapping(uint => address) private _creators;

    event TokenMinted(uint indexed tokenId, string tikenURI, address marketplaceAddress);
 
 
    constructor(address _marketplaceAddress)ERC721("Kabba", "KB") {
        marketplaceAddress = _marketplaceAddress;

    }

    function mint(string memory tokenURI) public returns (uint256) {
        _tokenIds.increment();
        uint newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId); 
        _creators[newItemId] = msg.sender;
        _setTokenURI(newItemId, tokenURI);

        setApprovalForAll(marketplaceAddress, true);

        emit TokenMinted(newItemId, tokenURI, marketplaceAddress);
        return newItemId;
    }

    function getTokenOwnedByMe() public view returns(uint [] memory){
        uint numberOfExistingToken = _tokenIds.current();
        uint numberOfOwnedToken = balanceOf(msg.sender);
        uint[] memory ownedTokenIds = new uint[](numberOfOwnedToken);

        uint currentIndex = 0;
        for (uint i = 0; i < numberOfExistingToken; i++) {
            uint tokenId = i + 1;
            if(ownerOf(tokenId) != msg.sender) continue;
            ownedTokenIds[currentIndex] = tokenId;
            currentIndex += 1;
        } 
        return ownedTokenIds;
    }
    function getTokenCreatorById(uint tokenId) public view returns(address) {
        return _creators[tokenId];
    }
    function getTokenCreatedByMe() public view returns(uint [] memory){
        uint256 numberOfExistingTokens = _tokenIds.current();
        uint256 numberOfTokensCreated = 0;

        for (uint i = 0; i < numberOfExistingTokens; i++) {
            uint tokenId = i + 1;
            if(_creators[tokenId] != msg.sender) continue;
            numberOfTokensCreated +=1;
        }

        uint256[] memory createdTokenIds = new uint256[](numberOfTokensCreated);
        uint currentIndex = 0;
        for (uint i = 0; i < numberOfExistingTokens; i++){
            uint tokenId = i + 1;
            if(_creators[tokenId] != msg.sender) continue;
            createdTokenIds[currentIndex] = tokenId;
            currentIndex +=1;
        }

        return createdTokenIds;
        
    }
}