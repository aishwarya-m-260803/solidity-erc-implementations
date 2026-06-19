# 🚀 Token Standards Implementation (ERC20 & ERC721)

This repository contains implementations of Ethereum token standards built in two approaches:

1. From scratch (manual implementation)
2. Using OpenZeppelin (industry-standard library)

The goal of this project is to understand both the internal working and production-level usage of ERC standards.

---

## 📌 Overview

### 🔹 ERC20 (Fungible Tokens)

* Tokens are identical and interchangeable
* Example: currency, points, utility tokens

### 🔹 ERC721 (Non-Fungible Tokens)

* Each token is unique
* Example: NFTs, digital art, certificates

---

# 🪙 ERC20 Implementation

## 🔸 Manual Implementation

* Balance tracking using mappings
* Transfer and allowance system (`approve`, `transferFrom`)
* Event emission (`Transfer`, `Approval`)
* Custom ownership/admin logic

## 🔸 OpenZeppelin Implementation

* Built using OpenZeppelin ERC20
* Secure and optimized contract
* Integrated `Ownable` for access control

---

# 🖼️ ERC721 Implementation

## 🔸 Manual Implementation

* Ownership tracking (`tokenId → owner`)
* Transfer functions (`transferFrom`, `safeTransferFrom`)
* Approval system (`approve`, `setApprovalForAll`)
* Safe transfer using `IERC721Receiver`
* Custom admin-based minting
* Metadata understanding (`tokenURI`)

## 🔸 OpenZeppelin Implementation

* Built using:

  * `ERC721`
  * `ERC721URIStorage`
  * `Ownable`
* Minting with `_safeMint`
* Metadata using `_setTokenURI`
* Role-based access control (Owner + Admin)

---

# 🔥 Key Concepts

## 🔹 Fungible vs Non-Fungible

| Feature  | ERC20    | ERC721       |
| -------- | -------- | ------------ |
| Type     | Fungible | Non-Fungible |
| Identity | Same     | Unique       |
| Use Case | Currency | NFTs         |

---

## 🔹 Metadata (tokenURI)

* Links NFT to off-chain JSON data
* JSON contains:

  * Name
  * Description
  * Image

```text
tokenId → tokenURI → JSON → NFT display
```

---

# ⚖️ Manual vs OpenZeppelin

| Aspect   | Manual             | OpenZeppelin |
| -------- | ------------------ | ------------ |
| Learning | Deep understanding | Moderate     |
| Security | Risk-prone         | Audited      |
| Use Case | Educational        | Production   |

---

# 📂 Project Structure

```
ERC20/
 ├── ManualERC20.sol
 ├── OpenZeppelinERC20.sol

ERC721/
 ├── ManualERC721.sol
 ├── OpenZeppelinERC721.sol
```

---

# 👩‍💻 Author

**Aishwarya M**

---

# 🤝 Contributing

Contributions are welcome!
Feel free to fork the repository, open issues, or submit pull requests to improve the project.

---



---
