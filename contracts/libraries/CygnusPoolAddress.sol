// SPDX-License-Identifier: Unlicensed

/**
 *  @title CygnusPoolAddress
 *  @dev Provides functions for deriving Cygnus collateral and borrow addresses deployed by Factory
 */
pragma solidity >=0.8.4;

library CygnusPoolAddress {
    /*  ═══════════════════════════════════════════════════════════════════════════════════════════════════════ 
            1. STORAGE
        ═══════════════════════════════════════════════════════════════════════════════════════════════════════  */

    /**
     *  IMPORTANT: UPDATE WITH LATEST CODE HASH
     *
     *  @notice keccak256(creationCode) of CygnusCollateral.sol contract
     *  @notice Used by Router and CygnusFactory to deploy shuttles
     */
    bytes32 internal constant COLLATERAL_INIT_CODE_HASH =
        0xce3f9ed57d0162dd656adfd980546d1e9458c23acd41fe07710ff12eb64a544d;

    /**
     *  IMPORTANT: UPDATE WITH LATEST CODE HASH
     *
     *  @notice keccak256(creationCode) of CygnusBorrow.sol contract
     *  @notice Used by Router and CygnusFactory to deploy shuttles
     */
    bytes32 internal constant BORROW_INIT_CODE_HASH =
        0x9807b307b07997d2eaecc9202b533d4eaf443b9aba8a9d47d86c913ba3ff18d8;

    /*  ═══════════════════════════════════════════════════════════════════════════════════════════════════════ 
            2. CONSTANT FUNCTIONS
        ═══════════════════════════════════════════════════════════════════════════════════════════════════════  */

    /**
     *  @dev Used by CygnusAltair.sol and Cygnus Factory
     *  @dev create2_address: keccak256(0xff, senderAddress, salt, keccak256(init_code))[12:]
     *  @param lpTokenPair The address of the LP Token
     *  @param factory The address of the Cygnus Factory used to deploy the shuttle
     *  @return collateral The calculated address of the Cygnus collateral contract given `lpTokenPair`
     *                     and `factory` addresses
     */
    function getCollateralContract(
        address lpTokenPair,
        address factory,
        address collateralDeployer
    ) internal pure returns (address collateral) {
        collateral = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xff),
                            collateralDeployer,
                            keccak256(abi.encode(lpTokenPair, factory)),
                            COLLATERAL_INIT_CODE_HASH
                        )
                    )
                )
            )
        );
    }

    /**
     *  @dev Used by CygnusAltair.sol
     *  @dev create2_address: keccak256(0xff, senderAddress, salt, keccak256(init_code))[12:]
     *  @param collateral The address of the LP Token
     *  @param factory The address of the Cygnus Factory used to deploy the shuttle
     *  @param borrowDeployer The address of the CygnusAlbireo contract
     *  @return borrow The calculated address of the Cygnus Borrow contract deployed by factory given
     *          `lpTokenPair` and `factory` addresses along with borrowDeployer contract address
     */
    function getBorrowContract(
        address collateral,
        address factory,
        address borrowDeployer
    ) internal pure returns (address borrow) {
        borrow = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xff),
                            borrowDeployer,
                            keccak256(abi.encode(collateral, factory)),
                            BORROW_INIT_CODE_HASH
                        )
                    )
                )
            )
        );
    }
}
