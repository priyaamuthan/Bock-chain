
pragma solidity ^0.8.0;

contract Voting {
    mapping(string => uint256) public votes;
    mapping(address => bool) public hasVoted; // Track if an address has voted
    string[] public candidates;

    event Voted(address indexed voter, string candidate); // Event to log votes

    constructor(string[] memory _candidates) {
        candidates = _candidates;
    }

    function vote(string memory _candidate) public {
        require(validCandidate(_candidate), "Invalid candidate");
        require(!hasVoted[msg.sender], "You have already voted!"); // Prevent multiple votes

        votes[_candidate] += 1;
        hasVoted[msg.sender] = true; // Mark user as voted

        emit Voted(msg.sender, _candidate); // Emit vote event
    }

    function validCandidate(string memory _candidate) private view returns (bool) {
        for (uint i = 0; i < candidates.length; i++) {
            if (keccak256(abi.encodePacked(candidates[i])) == keccak256(abi.encodePacked(_candidate))) {
                return true;
            }
        }
        return false;
    }

    function getAllVotes() public view returns (string[] memory, uint256[] memory) {
        uint256[] memory voteCounts = new uint256[](candidates.length);
        for (uint i = 0; i < candidates.length; i++) {
            voteCounts[i] = votes[candidates[i]];
        }
        return (candidates, voteCounts);
    }
}
