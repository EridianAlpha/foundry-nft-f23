// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "./HelperFunctions.s.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MintBasicNft is Script, DevOpsTools {
    function run() public {
        string
            memory jsonString = '{"name": "PUG", "description": "An adorable PUG pup!", "image": "ipfs://QmSsYRx3LpDAb1GZQm7zZ1AuHZjfbPkD6J7s9r41xu1mf8", "attributes": [{"trait_type": "cuteness", "value": 100}]}';

        string memory jsonBase64Encoded = Base64.encode(bytes(jsonString));

        string memory PUG_URI = string(
            abi.encodePacked("data:application/json;base64,", jsonBase64Encoded)
        );

        address mostRecentDeployed = get_most_recent_deployment(
            "BasicNft",
            block.chainid
        );

        vm.startBroadcast();
        BasicNft(mostRecentDeployed).mintNft(PUG_URI);
        vm.stopBroadcast();
    }
}

contract ReturnBasicNftUri is Script, DevOpsTools {
    function run() public {
        address mostRecentDeployed = get_most_recent_deployment(
            "BasicNft",
            block.chainid
        );

        address ownerAddress = BasicNft(mostRecentDeployed).ownerOf(0);
        string memory nftUri = BasicNft(mostRecentDeployed).tokenURI(0);

        console.log("");
        console.log("Owner Address:\n", ownerAddress);
        console.log("");
        console.log("NFT URI:\n", nftUri);
        console.log("");
    }
}
