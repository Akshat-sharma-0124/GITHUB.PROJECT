// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GITHUB.PROJECT Smart Contract
/// @author ...
/// @notice A simple on-chain repository tracker for GitHub-like functionality
/// @dev Demonstrates basic CRUD and event usage on the Ethereum blockchain

contract Project {
    struct Repository {
        uint id;
        string name;
        string description;
        address owner;
    }

    uint private nextRepoId;
    mapping(uint => Repository) public repositories;

    event RepositoryCreated(uint indexed id, string name, address indexed owner);
    event RepositoryUpdated(uint indexed id, string newDescription);
    event RepositoryTransferred(uint indexed id, address indexed newOwner);

    /// @notice Create a new repository
    /// @param _name The name of the repository
    /// @param _description The repository description
    function createRepository(string calldata _name, string calldata _description) external {
        repositories[nextRepoId] = Repository(nextRepoId, _name, _description, msg.sender);
        emit RepositoryCreated(nextRepoId, _name, msg.sender);
        nextRepoId++;
    }

    /// @notice Update the repository’s description
    /// @param _id The repository ID
    /// @param _newDescription The new description text
    function updateRepository(uint _id, string calldata _newDescription) external {
        Repository storage repo = repositories[_id];
        require(msg.sender == repo.owner, "Only owner can update");
        repo.description = _newDescription;
        emit RepositoryUpdated(_id, _newDescription);
    }

    /// @notice Transfer repository ownership to a new address
    /// @param _id The repository ID
    /// @param _newOwner The address of the new owner
    function transferOwnership(uint _id, address _newOwner) external {
        Repository storage repo = repositories[_id];
        require(msg.sender == repo.owner, "Only owner can transfer");
        repo.owner = _newOwner;
        emit RepositoryTransferred(_id, _newOwner);
    }
}
