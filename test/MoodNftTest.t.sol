// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {DeployMoodNft} from "../script/DeployNft.s.sol";

contract MoodNftTest is Test {
    DeployMoodNft public deployer;
    MoodNft moodNft;
    address USER = makeAddr("user");

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function test_ViewTokenURI() public {
        vm.prank(USER);
        moodNft.mintNft();
        console.log(moodNft.tokenURI(0));
    }

    function test_FlipTokenToSad() public {
        vm.startPrank(USER);
        moodNft.mintNft();
        assertEq(keccak256("Happy"), keccak256(abi.encodePacked(moodNft.getMood(0))));
        moodNft.flipMood(0);
        assertEq(keccak256("Sad"), keccak256(abi.encodePacked(moodNft.getMood(0))));

        vm.stopPrank();
    }
}
