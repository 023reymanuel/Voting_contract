// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Voting.sol";

contract TestVoting is Test {
    Voting voting;

    // set up function
    function setUp() public {
        voting = new Voting();
    }

    function testInitialSetup() public {
        (uint256 id1, string memory name1, uint256 voteCount1) = voting.getCandidate(1);
        assertEq(id1, 1);
        assertEq(name1, "Candidate 1");
        assertEq(voteCount1, 0);

        (uint256 id2, string memory name2, uint256 voteCount2) = voting.getCandidate(2);
        assertEq(id2, 2);
        assertEq(name2, "Batman 2");
        assertEq(voteCount2, 0);
    }

    function testVoting() public {
        voting.vote(1);

        (,, uint256 voteCount1) = voting.getCandidate(1);
        assertEq(voteCount1, 1);

        bool hasVoted = voting.voters(address(this));
        assertTrue(hasVoted);
        
        // Expect revert if trying to vote again
        vm.expectRevert("You have already voted");
        voting.vote(1);
    }

    function testInvalidCandidate() public {
        vm.expectRevert("Invalid candidate");
        voting.vote(3);
    }
}
