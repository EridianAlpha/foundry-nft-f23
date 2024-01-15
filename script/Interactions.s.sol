// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MintBasicNft is Script {
    function run() public {
        string
            memory jsonString = '{"name": "PUG", "description": "An adorable PUG pup!", "image": "ipfs://QmSsYRx3LpDAb1GZQm7zZ1AuHZjfbPkD6J7s9r41xu1mf8", "attributes": [{"trait_type": "cuteness", "value": 100}]}';

        string memory jsonBase64Encoded = Base64.encode(bytes(jsonString));

        string memory PUG_URI = string(
            abi.encodePacked("data:application/json;base64,", jsonBase64Encoded)
        );

        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "BasicNft",
            block.chainid
        );

        vm.startBroadcast();
        BasicNft(mostRecentDeployed).mintNft(PUG_URI);
        vm.stopBroadcast();
    }
}

contract ReturnBasicNftUri is Script {
    function run() public {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "BasicNft",
            block.chainid
        );

        vm.startBroadcast();
        string memory nftUri = BasicNft(mostRecentDeployed).tokenURI(0);
        address ownerAddress = BasicNft(mostRecentDeployed).ownerOf(0);

        console.log("NFT URI:", nftUri);
        console.log("Owner Address:", ownerAddress);
        vm.stopBroadcast();
    }
}
