// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
contract CredentialManager {
    struct Credential {
        string name;
        string credentialType;
        uint256 issueDate;
        uint256 expirationDate;
        address issuer;
        bool isValid;
    }
    
    mapping(address => Credential[]) public userCredentials;
    
    event CredentialIssued(address indexed user, uint256 credentialId);
    event CredentialVerified(address indexed user, uint256 credentialId, bool isValid);

    function issueCredential(
        address _user,
        string memory _name,
        string memory _credentialType,
        uint256 _issueDate,
        uint256 _expirationDate
    ) public {
        Credential memory newCredential = Credential({
            name: _name,
            credentialType: _credentialType,
            issueDate: _issueDate,
            expirationDate: _expirationDate,
            issuer: msg.sender,
            isValid: true
        });
        
        userCredentials[_user].push(newCredential);
        emit CredentialIssued(_user, userCredentials[_user].length - 1);
    }
    
    function verifyCredential(address _user, uint256 _credentialId) public view returns (Credential memory) {
        require(_credentialId < userCredentials[_user].length, "Invalid credential ID");
        return userCredentials[_user][_credentialId];
    }
    
    function setCredentialValidity(address _user, uint256 _credentialId, bool _isValid) public {
        require(msg.sender == userCredentials[_user][_credentialId].issuer, "Not authorized");
        userCredentials[_user][_credentialId].isValid = _isValid;
        emit CredentialVerified(_user, _credentialId, _isValid);
    }
}
