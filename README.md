# Credential-Management-System
Credential Management System
Overview
The Credential Management System is a decentralized application (dApp) designed to manage and verify academic and professional credentials using blockchain technology. Built on the Ethereum network with Arbitrum Orbit for scalability, this system allows educational institutions and organizations to issue, verify, and manage credentials securely and transparently.

Key Features
Issue Credentials: Educational institutions and organizations can issue digital credentials directly onto the blockchain.
Verify Credentials: Employers and other entities can quickly and securely verify credentials using the decentralized network.
Manage Validity: Authorized parties can update the validity of credentials as needed.
User Control: Individuals can manage their credentials and share them with employers or institutions as required.
Immutable Records: Credentials are stored immutably on the blockchain, reducing the risk of fraud.
Tech Stack
Blockchain Platform: Ethereum with Arbitrum Orbit for Layer 2 scaling
Smart Contract Language: Solidity
Frontend Framework: HTML, CSS
JavaScript Library: Web3.js
Development Tools: Remix or Truffle for smart contract deployment
Getting Started
Prerequisites
MetaMask: Ensure you have MetaMask or another Web3 provider installed in your browser.
Ethereum Network: Configure MetaMask to use the Ethereum network or Arbitrum testnet for development.
Installation
Clone the Repository:

bash
Copy code
git clone https://github.com/yourusername/credential-management-system.git
cd credential-management-system
Deploy the Smart Contract:

Open the CredentialManager.sol smart contract in Remix or your preferred development environment.
Deploy the contract to the Arbitrum network.
Copy the contract address and ABI.
Update the Frontend:

Open script.js and replace YOUR_CONTRACT_ADDRESS with the address of your deployed contract.
Replace /* Replace with your contract ABI */ with the ABI of your deployed contract.
Serve the Application:

Ensure you have a local server to serve the HTML and JavaScript files. You can use a simple HTTP server like http-server in Node.js:

bash
Copy code
npm install -g http-server
http-server .
Open your browser and navigate to http://localhost:8080 (or the port used by your server) to view the application.

Usage
Issue a Credential
Enter the recipient's Ethereum address.
Provide the credential name and type.
Click "Issue Credential" to issue the credential to the specified address.
Verify a Credential
Enter the recipient's Ethereum address and the credential ID.
Click "Verify Credential" to retrieve and display the credential details.
Set Credential Validity
Enter the recipient's Ethereum address and the credential ID.
Check or uncheck the "Valid" checkbox to set the credential's validity status.
Click "Set Validity" to update the credential's validity.
Contributing
Feel free to contribute to this project by submitting issues or pull requests. Ensure that you follow best practices for coding and testing.

License
This project is licensed under the MIT License. See the LICENSE file for details.

Acknowledgments
Ethereum and Arbitrum: For providing the blockchain infrastructure and scalability solutions.
MetaMask: For enabling easy interaction with Ethereum dApps.
<br>
//solidity code<br>
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
<br>
html code<br>
<!DOCTYPE html>
<html>
<head>
    <title>Credential Management</title>
  <link rel="stylesheet" href="style.css">
    <script src="https://cdn.jsdelivr.net/npm/web3@latest/dist/web3.min.js"></script>
    <script>
        let web3;
        let contract;

        const contractAddress = "YOUR_CONTRACT_ADDRESS";  // Replace with your deployed contract address
        const contractABI = [/* Replace with your contract ABI */];

        window.addEventListener('load', async () => {
            if (window.ethereum) {
                web3 = new Web3(window.ethereum);
                await window.ethereum.request({ method: 'eth_requestAccounts' });
                contract = new web3.eth.Contract(contractABI, contractAddress);
            } else {
                alert('Please install MetaMask!');
            }
        });

        async function issueCredential() {
            const user = document.getElementById('user').value;
            const name = document.getElementById('name').value;
            const type = document.getElementById('type').value;
            const issueDate = Math.floor(new Date().getTime() / 1000);
            const expirationDate = issueDate + 31536000; // 1 year validity

            await contract.methods.issueCredential(user, name, type, issueDate, expirationDate).send({ from: window.ethereum.selectedAddress });
            alert('Credential issued!');
        }

        async function verifyCredential() {
            const user = document.getElementById('user').value;
            const id = parseInt(document.getElementById('credentialId').value);

            const credential = await contract.methods.verifyCredential(user, id).call();
            document.getElementById('credentialDetails').innerText = JSON.stringify(credential, null, 2);
        }

        async function setValidity() {
            const user = document.getElementById('user').value;
            const id = parseInt(document.getElementById('credentialId').value);
            const isValid = document.getElementById('isValid').checked;

            await contract.methods.setCredentialValidity(user, id, isValid).send({ from: window.ethereum.selectedAddress });
            alert('Credential validity updated!');
        }
    </script>
</head>
<body>
    <h1>Credential Management System</h1>
    <div>
        <h2>Issue Credential</h2>
        <input id="user" type="text" placeholder="User Address" />
        <input id="name" type="text" placeholder="Credential Name" />
        <input id="type" type="text" placeholder="Credential Type" />
        <button onclick="issueCredential()">Issue Credential</button>
    </div>
    <div>
        <h2>Verify Credential</h2>
        <input id="user" type="text" placeholder="User Address" />
        <input id="credentialId" type="number" placeholder="Credential ID" />
        <button onclick="verifyCredential()">Verify Credential</button>
        <pre id="credentialDetails"></pre>
    </div>
    <div>
        <h2>Set Credential Validity</h2>
        <input id="user" type="text" placeholder="User Address" />
        <input id="credentialId" type="number" placeholder="Credential ID" />
        <label for="isValid">Valid</label>
        <input id="isValid" type="checkbox" />
        <button onclick="setValidity()">Set Validity</button>
    </div>
</body>
</html>
<br>//csscode<br>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f9;
    color: #333;
    margin: 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
}

h1 {
    margin-top: 20px;
    color: #333;
}

div {
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    padding: 20px;
    margin: 20px;
    width: 90%;
    max-width: 600px;
}

h2 {
    margin-top: 0;
    color: #555;
}

input, button {
    display: block;
    width: calc(100% - 22px);
    margin: 10px 0;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 16px;
}

button {
    background-color: #007bff;
    color: #fff;
    border: none;
    cursor: pointer;
}

button:hover {
    background-color: #0056b3;
}

pre {
    background-color: #f0f0f0;
    border: 1px solid #ddd;
    padding: 10px;
    border-radius: 4px;
    white-space: pre-wrap;
    word-wrap: break-word;
}

label {
    margin-right: 10px;
}
