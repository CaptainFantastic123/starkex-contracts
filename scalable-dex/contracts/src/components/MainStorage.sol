pragma solidity ^0.5.2;

import "../interfaces/IFactRegistry.sol";
import "../upgrade/ProxyStorage.sol";
import "../libraries/Common.sol";
/*
  Holds ALL the main contract state (storage) variables.
*/
contract MainStorage is ProxyStorage {

    IFactRegistry escapeVerifier_;

    // Global dex-frozen flag.
    bool stateFrozen;                               // NOLINT: constable-states.

    // Time when unFreeze can be successfully called (UNFREEZE_DELAY after freeze).
    uint256 unFreezeTime;                           // NOLINT: constable-states.

    // Pending deposits.
    // A map STARK key => asset id => vault id => quantized amount.
    mapping (uint256 => mapping (uint256 => mapping (uint256 => uint256))) pendingDeposits;

    // Cancellation requests.
    // A map STARK key => asset id => vault id => request timestamp.
    mapping (uint256 => mapping (uint256 => mapping (uint256 => uint256))) cancellationRequests;

    // Pending withdrawals.
    // A map STARK key => asset id => quantized amount.
    mapping (uint256 => mapping (uint256 => uint256)) pendingWithdrawals;

    // vault_id => escape used boolean.
    mapping (uint256 => bool) escapesUsed;

    // Number of escapes that were performed when frozen.
    uint256 escapesUsedCount;                       // NOLINT: constable-states.

    // Full withdrawal requests: stark key => vaultId => requestTime.
    // stark key => vaultId => requestTime.
    mapping (uint256 => mapping (uint256 => uint256)) fullWithdrawalRequests;

    // State sequence number.
    uint256 sequenceNumber;                         // NOLINT: constable-states uninitialized-state.

    // Vaults Tree Root & Height.
    uint256 vaultRoot;                              // NOLINT: constable-states uninitialized-state.
    uint256 vaultTreeHeight;                        // NOLINT: constable-states uninitialized-state.

    // Order Tree Root & Height.
    uint256 orderRoot;                              // NOLINT: constable-states uninitialized-state.
    uint256 orderTreeHeight;                        // NOLINT: constable-states uninitialized-state.

    // True if and only if the address is allowed to add tokens.
    mapping (address => bool) tokenAdmins;

    // True if and only if the address is allowed to register users.
    mapping (address => bool) userAdmins;

    // True if and only if the address is an operator (allowed to update state).
    mapping (address => bool) operators;

    // Mapping of contract ID to asset data.
    mapping (uint256 => bytes) assetTypeToAssetInfo;    // NOLINT: uninitialized-state.

    // Mapping of registered contract IDs.
    mapping (uint256 => bool) registeredAssetType;      // NOLINT: uninitialized-state.

    // Mapping from contract ID to quantum.
    mapping (uint256 => uint256) assetTypeToQuantum;    // NOLINT: uninitialized-state.

    // This mapping is no longer in use, remains for backwards compatibility.
    mapping (address => uint256) starkKeys_DEPRECATED;  // NOLINT: naming-convention.

    // Mapping from STARK public key to the Ethereum public key of its owner.
    mapping (uint256 => address) ethKeys;               // NOLINT: uninitialized-state.

    // Timelocked state transition and availability verification chain.
    StarkExTypes.ApprovalChainData verifiersChain;
    StarkExTypes.ApprovalChainData availabilityVerifiersChain;

    // Batch id of last accepted proof.
    uint256 lastBatchId;                            // NOLINT: constable-states uninitialized-state.

    // Mapping between sub-contract index to sub-contract address.
    mapping(uint256 => address) subContracts;       // NOLINT: uninitialized-state.

    // Mapping of permissive tokens.
    // AssetType of tokens that are not ERC20 compliant (e.g. XAUT) and require permissive handling.
    mapping (uint256 => bool) permissiveAssetType;      // NOLINT: uninitialized-state.
}
