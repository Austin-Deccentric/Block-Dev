// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Base64.sol";

contract atadiaNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    // uint256 public tokenCounter;

    mapping(uint256 => string) public tokenIdtoMetadata;

    constructor() ERC721("OG Atadia", "ATD") {}

    function mintNFT(address recipient, string memory input) public returns(string memory) {
        // use tokenCounter as an id for each created token
        // use _safeMint inherited from ERC721 contract to mint a token
        
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        tokenIdtoMetadata[newItemId] = input;
        _safeMint(recipient, newItemId);
        string memory createdTokenURI = tokenURI(newItemId);

        return createdTokenURI;
    }

    function getMetadata(uint256 _tokenId) public view returns (string memory) {
        return tokenIdtoMetadata[_tokenId];
    }

    // encodes metadata 
    function tokenURI(uint256 tokenId) override(ERC721) public view returns (string memory) {
        string memory metadata = getMetadata(tokenId);
        string memory json = Base64.encode(bytes(string(abi.encodePacked(metadata))));
        return string(abi.encodePacked('data:application/json;base64,', json));
    }


}