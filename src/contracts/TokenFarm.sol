pragma solidity ^0.5.0;

import "./DappToken.sol";
import "./DaiToken.sol";

contract TokenFarm{

    string public tokenName="Dapp token farm";
    DappToken public dappToken;
    DaiToken public daiToken; 
    address public owner;
    

    mapping(address =>uint) public stakingBalance;
    mapping(address=>bool) public hasStaked;
    mapping(address=>bool) public isStaking;

    address[] public stakers;


    constructor(DappToken _dappToken,DaiToken _daiToken) public{
           dappToken=_dappToken;
           daiToken=_daiToken; 
           owner=msg.sender;
    }

    function stakeTokens(uint _amount) public{

        require(_amount>0,"amount can't be zero");

        daiToken.transferFrom(msg.sender, address(this), _amount);

        stakingBalance[msg.sender]=stakingBalance[msg.sender]+_amount;

        if(!hasStaked[msg.sender]){
            stakers.push(msg.sender);
        }

        isStaking[msg.sender]=true;  
        hasStaked[msg.sender]=true;

    }


    function unstakeTokens() public{
        uint balance=stakingBalance[msg.sender];
        require(balance>0,"balance can't be zero");
        daiToken.transfer(msg.sender,balance);
        stakingBalance[msg.sender]=0;

        isStaking[msg.sender]=false;
    }


    function issueTokens() public{

        require(msg.sender==owner,"caller must be the owner");
        for(uint i=0;i<stakers.length;i++){
            address recipient=stakers[i];
            uint balance=stakingBalance[recipient];
            if(balance>0)
            dappToken.transfer(recipient,balance);
        }
    }

}