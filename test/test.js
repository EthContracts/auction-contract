const Manager = require('./manager');

contract('Auction', (accounts) => {
    let auction;

    beforeEach(async () => {
        escrow = await Manager.create();
    })

    it('test something', async () => {
    });
});
