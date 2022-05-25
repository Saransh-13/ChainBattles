//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    struct warrior {
        string name;
        uint256 level;
        uint256 speed;
        uint256 strength;
        uint256 life;
    }
    warrior x;

    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(uint256 => warrior) tokenIdToWarrior;

    constructor() ERC721("Chain Battles", "CHBTL") {}

    function generateCharacter(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="20%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>"
            '<text x="50%" y="30%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Name: ",
            getName(tokenId),
            "</text>",
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Level: ",
            getLevel(tokenId),
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "speed: ",
            getSpeed(tokenId),
            "</text>",
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "strength: ",
            getStrength(tokenId),
            "</text>",
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "life: ",
            getLife(tokenId),
            "</text>",
            "</svg>"
        );
        return string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }
    function getName(uint256 tokenId) public view returns (string memory){
        return tokenIdToWarrior[tokenId].name;
    }
    function getLevel(uint256 tokenId) public view returns (string memory) {
        
        uint256 level = tokenIdToWarrior[tokenId].level;
        return level.toString();
    }

    function getSpeed(uint256 tokenId) public view returns (string memory) {
        uint256 speed = tokenIdToWarrior[tokenId].speed;
        return speed.toString();
    }

    function getStrength(uint256 tokenId) public view returns (string memory) {
        uint256 strength = tokenIdToWarrior[tokenId].strength;
        return strength.toString();
    }

    function getLife(uint256 tokenId) public view returns (string memory) {
        uint256 life = tokenIdToWarrior[tokenId].life;
        return life.toString();
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId),'"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint(string calldata name) public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        x = tokenIdToWarrior[newItemId];
        tokenIdToWarrior[newItemId].name = name;
        tokenIdToWarrior[newItemId].level =0;
        tokenIdToWarrior[newItemId].speed =speedRandom(100);
        tokenIdToWarrior[newItemId].strength =strengthRandom(100);
        tokenIdToWarrior[newItemId].life =lifeRandom(100);
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId),"Please use an existing Token");
        require(
            ownerOf(tokenId) == msg.sender,
            "You are not the owner of this token"
        );
        
        tokenIdToWarrior[tokenId].level=tokenIdToWarrior[tokenId].level+1;
        tokenIdToWarrior[tokenId].speed =speedRandom(100);
        tokenIdToWarrior[tokenId].strength =strengthRandom(100);
        tokenIdToWarrior[tokenId].life =lifeRandom(100);
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    function strengthRandom(uint256 number) public view returns (uint256) {
        return uint256(blockhash(block.number - 1)) % number;
    }

    function lifeRandom(uint256 number) public view returns (uint256) {
        return uint256(blockhash(block.number - 2)) % number;
    }

    function speedRandom(uint256 number) public view returns (uint256) {
        return uint256(blockhash(block.number - 3)) % number;
    }
}