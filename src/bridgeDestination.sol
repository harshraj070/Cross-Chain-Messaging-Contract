// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@layerzerolabs/lzApp/NonblockingLzApp.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BridgeDestination is ERC20, NonblockingLzApp {
    event Minted(address indexed user, uint256 amount);

    constructor(
        address _lzEndpoint
    )
        ERC20("WrappedToken", "wTKN")
        NonblockingLzApp(_lzEndpoint)
        Ownable(msg.sender)
    {}

    function _nonblockingLzReceive(
        uint16,
        bytes memory _payload,
        uint64,
        bytes memory
    ) internal override {
        (address user, uint256 amount) = abi.decode(
            _payload,
            (address, uint256)
        );
        _mint(user, amount);
        emit Minted(user, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
