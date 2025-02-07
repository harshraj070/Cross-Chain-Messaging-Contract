//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@layerzerolabs/lzApp/NonblockingLzApp.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

abstract contract bridgeSource is NonblockingLzApp {
    IERC20 public token;
    address public destination;

    event Locked(address indexed user, uint256 amount);
    constructor(
        address _token,
        address _lzEndPoint
    ) NonblockingLzApp(_lzEndPoint) Ownable(msg.sender) {
        token = IERC20(_token);
    }

    function lockToken(uint16 dstnChainid, uint256 _amount) external payable {
        require(
            token.transferFrom(msg.sender, address(this), _amount),
            "Transfer failed"
        );

        bytes memory payload = abi.encode(dstnChainid, _amount);
        _lzSend(
            dstnChainid,
            payload,
            payable(msg.sender),
            address(0),
            bytes(""),
            msg.value
        );

        emit Locked(msg.sender, _amount);
    }

    function _nonblockingLzReceive(
        uint16,
        bytes memory,
        uint64,
        bytes memory
    ) internal override {
        revert("Source contract should not receive messages");
    }
}
