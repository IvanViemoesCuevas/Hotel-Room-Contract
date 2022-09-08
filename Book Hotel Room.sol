//SPDX-License-Identifier: UNLICENSED

//imports the chosen solidity cersion
pragma solidity 0.8.14;

//imports the hardhat console.log option for printing in the console
import "hardhat/console.sol";

contract HotelRoom {

    //makes the variable address that will get paid when a room is booked
    address payable public owner;

    //makes an enum that shows if the room is vacant/occupied, with the "currentStatus" variable
    enum Statuses {Vacant, Occupied}
    Statuses currenStatus;

    //happens when the contract is deployed
    constructor() public {
        //puts the address that deployed the contract as "owner", which is the address that gets paid
        owner = payable(msg.sender);

        //sets the status of the room to Vacant
        currenStatus = Statuses.Vacant;
    }

    //makes a modifier that automatically checks that the room is vacant
    //if it's not, it'll throw "Currently occupied" error
    modifier onlyWhileVacant {
        require(currenStatus == Statuses.Vacant, "Currently occupied.");
        _;
    }

    //makes a modifier that automatically checks that it's the right amount of Ether
    //if it's not, it'll throw "Not enough Ether, the price is 2 Ether" error
    modifier costs(uint _amount) {
        require(msg.value >= _amount, "Not enough Ether, the price is 2 Ether");
        _;
    }

    //makes an event for when the room is booked
    event Occupy(address _occupant, uint _value);

    //runs the function when we recieve the 2 ether or above, and the room is vacant
    receive() external payable onlyWhileVacant costs(2 ether) {

        //requires that the room is vacant to proceed, if it's not it will throw the error "Currently occupied."
        //we use the modifier instead, since it's more manageable that way
        //require(currenStatus == Statuses.Vacant, "Currently occupied.")

        //puts the rooms status to occupied
        currenStatus = Statuses.Occupied;

        //transfers the cost to the contract owner
        owner.transfer(msg.value);

        //emits that the room is occupied, by who and how much it cost
        emit Occupy(msg.sender, msg.value);
    }

    //We use the recieve() function instead of the traditional, that allows us to only run the function when we recieve the payment.
    //The payment can also only be Ether. This greatly simplifies the smart contract interface.
    //Instead of having to call the function by a specific name, and pass in arguments,
    //you simply pay the smart contract from your wallet, and it books the hotel room for you!
    /* function book() payable onlyWhileVacant costs(2 ether) {

        //requires that the room is vacant to proceed, if it's not it will throw the error "Currently occupied."
        //we use the modifier instead, since it's more manageable that way
        //require(currenStatus == Statuses.Vacant, "Currently occupied.")

        currenStatus = Statuses.Occupied;
        owner.transfer(msg.value);
        emit Occupy(msg.sender, msg.value);
    } */
}
