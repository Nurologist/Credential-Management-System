# Credential-Management-System
![image](https://github.com/user-attachments/assets/807bb905-81aa-4737-9007-e98dfc2aa4b8)
---
# Credential Management System
## Vision
The Credential Management System aims to revolutionize how academic and professional credentials are issued, verified, and managed by leveraging blockchain technology. By utilizing the Ethereum network and Arbitrum Orbit for scalability, this dApp provides a secure, transparent, and decentralized solution to combat credential fraud and streamline verification processes.
## Contract Address

The smart contract has been deployed to the Arbitrum network. Use the following details to interact with the contract:

- **Contract Address:** '0x40f3dc39d12ea1cc626b7bb5ca35dbb2137bfa42'
- ![image](https://github.com/user-attachments/assets/7422609d-bfd6-4587-94f8-7c0bdf91f85e)

- **ABI:** Available in `script.js` and `abi.json` in the repository.

## Future Scope

1. **Integration with Educational Platforms:** Develop APIs to integrate with existing educational platforms for automatic credential issuance.
2. **Advanced Analytics:** Implement features for analytics and reporting on credential issuance and verification trends.
3. **Enhanced User Features:** Introduce features like credential renewal reminders and integration with digital wallets.
4. **Cross-Chain Support:** Explore integration with other blockchain networks for broader interoperability and scalability.

## Contact Details

For any inquiries, feedback, or contributions, please reach out to:

- **Project Maintainer:** Meghraj Dhakal
- **Email:**meghrajdhakal966@gmail.com
- **GitHub:** https://github.com/Nurologist

Feel free to open issues or submit pull requests for improvements. Your contributions and feedback are highly appreciated!
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
    background-color: #e3f2fd; /* Light blue background */
    color: #333;
    margin: 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    transition: background-color 0.3s ease;
}

h1 {
    margin-top: 20px;
    color: #0d47a1; /* Dark blue color */
    transition: color 0.3s ease;
}

div {
    background-color: #ffffff; /* White background */
    border-radius: 12px;
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
    padding: 25px;
    margin: 20px;
    width: 90%;
    max-width: 600px;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

div:hover {
    transform: translateY(-7px);
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.25);
}

h2 {
    margin-top: 0;
    color: #ff6f00; /* Vibrant orange */
    transition: color 0.3s ease;
}

input, button {
    display: block;
    width: calc(100% - 22px);
    margin: 10px 0;
    padding: 12px;
    border: 2px solid #ddd;
    border-radius: 6px;
    font-size: 16px;
    transition: border-color 0.3s ease, box-shadow 0.3s ease;
}

input:focus, button:focus {
    border-color: #ff4081; /* Pink focus border */
    box-shadow: 0 0 10px rgba(255, 64, 129, 0.5);
    outline: none;
}

button {
    background-color: #8e24aa; /* Deep purple button */
    color: #fff;
    border: none;
    cursor: pointer;
    transition: background-color 0.3s ease, transform 0.2s ease;
}

button:hover {
    background-color: #6a1b9a; /* Darker purple on hover */
    transform: translateY(-3px);
}

button:active {
    background-color: #4a148c; /* Even darker purple when active */
    transform: translateY(1px);
}

pre {
    background-color: #ffecb3; /* Soft yellow background */
    border: 1px solid #ffc107; /* Gold border */
    padding: 12px;
    border-radius: 6px;
    white-space: pre-wrap;
    word-wrap: break-word;
    transition: background-color 0.3s ease, border-color 0.3s ease;
}

pre:hover {
    background-color: #fff8e1; /* Lighter yellow on hover */
    border-color: #ffa000; /* Slightly darker gold border */
}

label {
    margin-right: 10px;
    font-weight: bold;
    color: #00796b; /* Teal color */
    transition: color 0.3s ease;
}

label:hover {
    color: #004d40; /* Darker teal on hover */
}
