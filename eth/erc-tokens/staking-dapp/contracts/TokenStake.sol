// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract tokenStake is ERC20, ERC20Burnable {
    // Staker info
    struct Staker {
        // The deposited tokens of the Staker
        uint256 deposited;
        // Last time of details update for Deposit
        uint256 timeOfLastUpdate;
        // Calculated, but unclaimed rewards. These are calculated each time
        // a user writes to the contract
        uint256 unclaimedRewards;
    }

    unit private _totalStaked; 
    // Rewards per hour. A fraction calculated as x/10.000.000 to get the percentage
    uint256 public rewardsPerHour = 285; // 0.00285%/h or 25% APR

    // Mapping of address to Staker info
    mapping(address => Staker) internal stakers;

    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {}

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event Rewarded(address indexed user, uint256 reward);

    function stake(uint256 _amount) public {
        require(
            balanceOf(msg.sender) >= _amount,
            "Can't stake more than you own"
        );
        if (stakers[msg.sender].deposited == 0) {
            stakers[msg.sender].deposited = _amount;
            stakers[msg.sender].timeOfLastUpdate = block.timestamp;
            stakers[msg.sender].unclaimedRewards = 0;
        } else {
            uint256 rewards = calculateRewards(msg.sender);
            stakers[msg.sender].unclaimedRewards += rewards;
            stakers[msg.sender].deposited += _amount;
            stakers[msg.sender].timeOfLastUpdate = block.timestamp;
        }

        transferFrom(msg.sender, address(this), _amount);
        emit Staked(msg.sender, _amount);
    }

    // Calculate the rewards since the last update on Deposit info
    function calculateRewards(address _staker)
        internal
        view
        returns (uint256 rewards)
    {
        return (((((block.timestamp - stakers[_staker].timeOfLastUpdate) /
            3600) * stakers[_staker].deposited) * rewardsPerHour) / 10000000);
    }

    function claimRewards() external {
        uint256 _rewards = calculateRewards(msg.sender) + stakers[msg.sender].unclaimedRewards;
        require(_rewards > 0, "No rewards!");
        stakers[msg.sender].unclaimedRewards = 0;
        stakers[msg.sender].timeOfLastUpdate = block.timestamp;
        _mint(msg.sender, _reward);

        emit Rewarded(msg.sender, reward);
        }
    }

    // Withdraw all stake and rewards and mints them to the msg.sender
    function unstake() public {
        require(stakers[msg.sender].deposited > 0, "You have no deposit");
        
        // uint256 _rewards = calculateRewards(msg.sender) +
        //     stakers[msg.sender].unclaimedRewards;
        uint256 _deposit = stakers[msg.sender].deposited;
        stakers[msg.sender].deposited = 0;
        stakers[msg.sender].timeOfLastUpdate = 0;
        _totalStaked -= _deposit;
        
        transfer(msg.sender, _amount);
        claimRewards();

        emit Unstaked(msg.sender, _amount);
    }

    
    
    // Function useful for fron-end that returns user stake and rewards by address
    function getDepositInfo(address _user)
        public
        view
        returns (uint256 _stake, uint256 _rewards)
    {
        _stake = stakers[_user].deposited;
        _rewards =
            calculateRewards(_user) +
            stakers[msg.sender].unclaimedRewards;
        return (_stake, _rewards);
    }

}

