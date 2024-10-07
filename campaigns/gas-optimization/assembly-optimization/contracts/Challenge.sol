// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

abstract contract Challenge {

    /**
     * @notice Returns a copy of the given array in a gas-efficient way.
     * @dev This contract will be called internally.
     * @param array The array to copy.
     * @return copy The copied array.
     */
    function copyArray(bytes memory array) 
        internal 
        pure 
        returns (bytes memory copy) 
    {
        assembly {
            // Load the length of the array
            let len := mload(array)

            // Allocate memory for the copy
            copy := mload(0x40)     // Load free memory pointer
            mstore(0x40, add(copy, add(len, 0x20))) // Update free memory pointer
            mstore(copy, len)       // Set the length of the copy

            // Copy data from source to destination in one go
            let src := add(array, 0x20)   // Start of source array data
            let dest := add(copy, 0x20)   // Start of destination array data

            // Use calldatacopy-like functionality for efficient copying
            for { let end := add(src, len) } lt(src, end) { src := add(src, 0x20) dest := add(dest, 0x20) } {
                mstore(dest, mload(src))
            }
        }
    }
}
