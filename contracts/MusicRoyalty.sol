// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BlockchainMusik is ERC721 {
    address public platform;
    uint256 public nextTokenId;

    struct Song {
        string title;
        string ipfsLink;
        address artist;
        address producer;
    }

    mapping(uint256 => Song) public songs;

    constructor(address _platform) ERC721("BlockchainMusik", "BMK") {
        platform = _platform;
        nextTokenId = 1;
    }

    function registerSong(string memory _title, string memory _ipfsLink, address _producer) public {
        require(_producer != address(0), "Invalid producer address");
        songs[nextTokenId] = Song(_title, _ipfsLink, msg.sender, _producer);
        _mint(msg.sender, nextTokenId);
        nextTokenId++;
    }

    function payRoyalties(uint256 _tokenId) public payable {
        require(ownerOf(_tokenId) != address(0), "Song not registered");
        Song memory song = songs[_tokenId];
        uint256 artistShare = msg.value * 70 / 100;
        uint256 producerShare = msg.value * 20 / 100;
        uint256 platformShare = msg.value * 10 / 100;
        payable(song.artist).transfer(artistShare);
        payable(song.producer).transfer(producerShare);
        payable(platform).transfer(platformShare);
    }
}