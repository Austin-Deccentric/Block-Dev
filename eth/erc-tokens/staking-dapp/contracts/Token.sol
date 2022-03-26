// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "./TokenStake.sol";

contract Atadia is ERC20, Ownable{
    constructor() ERC20("Atadia", "ATA"){
        _mint(msg.sender, 5000 );
    }
    // Staking Contract Address
    address stakeContract;

    // Only the TokenSale contract can mint new tokens. 
    modifier onlyTokenStake {
        require (msg.sender == stakeContract);
        _;
    }

    function issueToken(address receiver, uint256 amount) external onlyTokenStake returns(bool sent){
        _mint(receiver, amount);
        return true;
    }

    /*
     @dev Set this before making Token sales. 
    This tells our modifier which contract has the right to mint new tokens.
    */
    function setTokenStakeAddress (address _stakeContract) public onlyOwner{
        stakeContract = _stakeContract;
    }
}

contract DEX is Ownable {

    // Event that logs sale operation
    event BuyTokens(address _buyer, uint256 _amountEth, uint256 _amountToken);
    
    // rate
    uint256 public rate = 1000;
    Atadia public token;
    address internal _owner;

    constructor(address ca) {
        token = Atadia(ca);
        _owner = msg.sender;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function buyToken() payable public {
        require( msg.value > 0, "Your ETH balance is low." );
        
        uint256 base = 1 ether;
        uint256 amtpayed = div(msg.value, base, "Division by zero error");
        uint256 amountToBuy = mul(amtpayed,  rate);
        require(amountToBuy > 0, "Send some ether");
        uint256 _balance = token.balanceOf(_owner);
        require(amountToBuy <= _balance, "Reserve is low");
        
        // Mint new tokens to provided address
        (bool sent) = token.transferFrom(_owner, msg.sender, amountToBuy);
        require(sent, "Failed to complete sale");

        emit BuyTokens(msg.sender, msg.value, amountToBuy);
    }

     function modifyTokenBuyPrice(uint256 _rate) public onlyOwner {
        rate = _rate;
    }    
}