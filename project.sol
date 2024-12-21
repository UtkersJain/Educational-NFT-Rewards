// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EducationalNFTRewards is ERC20, Ownable {
    IERC721 public educationalNFT;
    uint256 public rewardRatePerSecond;
    mapping(uint256 => uint256) public lastClaimedTime;

    constructor(
        address _educationalNFT,
        uint256 _rewardRatePerSecond,
        address _initialOwner
    ) ERC20("EduToken", "EDU") Ownable(_initialOwner) {
        educationalNFT = IERC721(_educationalNFT);
        rewardRatePerSecond = _rewardRatePerSecond;
    }

    function claimRewards(uint256 _tokenId) external {
        require(educationalNFT.ownerOf(_tokenId) == msg.sender, "Caller is not the owner of this NFT");

        uint256 currentTime = block.timestamp;
        uint256 lastClaimed = lastClaimedTime[_tokenId];

        if (lastClaimed == 0) {
            lastClaimed = currentTime;
        }

        uint256 rewards = (currentTime - lastClaimed) * rewardRatePerSecond;
        lastClaimedTime[_tokenId] = currentTime;

        _mint(msg.sender, rewards);
    }

    function setRewardRate(uint256 _newRate) external onlyOwner {
        rewardRatePerSecond = _newRate;
    }

    function setEducationalNFT(address _newNFT) external onlyOwner {
        educationalNFT = IERC721(_newNFT);
    }
}
