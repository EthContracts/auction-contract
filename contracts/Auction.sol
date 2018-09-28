pragma solidity 0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/AddressUtils.sol";
import "openzeppelin-solidity/contracts/ReentrancyGuard.sol";

// import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/AddressUtils.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/ReentrancyGuard.sol";


contract Auction is Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using AddressUtils for address;

    uint256 internal fee = 1 finney;
    uint256 internal lowestBid = 1 finney;
    uint256 internal earned = 0;

    // Status of bidding
    enum Status {
        Ongoing,
        Finished,
        Failed
    }

    // Bidding
    struct Bidding {
        address author;
        address broker;
        address highestBidder;
        uint256 highestBid;
        uint256 minimumBid;
        uint256 deadline;
        Status status;
    }

    // List of bidding auctions
    Bidding[] public auctions;

    // Events
    event NewAuction(
        uint256 auctionId,
        address author,
        address broker,
        uint256 minimumBid,
        uint256 deadline
    );

    constructor() Ownable() public {}

    function createNewAuction(
        address author,
        address broker,
        uint256 minimumBid,
        uint256 deadline
    ) external payable nonReentrant() {
        require(!author.isContract());
        if (broker != address(0)) {
            require(!broker.isContract());
            require(msg.value == fee.mul(2));
            broker.transfer(fee);
        }
        else {
            require(msg.value == fee);
        }
        require(minimumBid >= lowestBid);
        auctions.push(Bidding(
            author,
            broker,
            address(0),
            0,
            minimumBid,
            deadline,
            Status.Ongoing
        ));
        earned = earned.add(fee);
        uint256 auctionId = auctions.length.sub(1);
        emit NewAuction(
            auctionId, 
            author,
            broker, 
            minimumBid, 
            deadline
        );
    }

    function bidInAuction() external payable nonReentrant() {

    }

    function finishAuction() external nonReentrant() {
        
    }

    function checkEarned() external view onlyOwner() returns (uint256) {
        return earned;
    }

    function withdraw() external onlyOwner() nonReentrant() {
        owner.transfer(earned);
        earned = 0;
    }

    function() public {
        // Do not accept ether, revert payments
        // If you want to donate send ether to 'owner' of contract
        revert();
    }
}
