const Auction = artifacts.require("./Auction.sol");
const fs = require('fs');

module.exports = (deployer, network) => {
    let target = Auction;
    deployer.deploy(target).then(() => {
        fs.writeFileSync('.deployed', JSON.stringify({auction: target.address}));
    });
};
