# ChainBank — Bank Smart Contract System

A beginner-friendly **runnable banking website** for a blockchain engineering classroom project, based on the *Bank Smart Contract System* presentation.

## Files (only 3)

- `index.html` — complete responsive website, with CSS and JavaScript inside the file
- `SimpleBank.sol` — Solidity smart contract: approve, deposit, withdraw, transfer, fund lending pool, borrow, repay
- `README.md` — instructions

## Run the website instantly

1. Download this folder / unzip the ZIP archive.
2. **Double-click `index.html`** to open it in Chrome, Edge or Firefox.
3. Leave **Instant Demo** selected. Use the demo account selector to switch between Alex (admin), Asha, and Ravi.
4. Try `Fund lending pool` (Alex), `Deposit` (Asha), `Transfer`, `Withdraw`, `Take loan`, then `Repay`.
5. The activity log and balances update and persist in your browser (`localStorage`). Use **Reset demo** to start over.

**Important:** Instant Demo is a browser-based **simulation**, not a real blockchain. All demo ETH is fake and cannot be withdrawn as actual crypto. You don't need Node.js, npm, or Git to run this mode. The website's blockchain option needs a wallet, internet, and a deployed contract.

## Run it with a real smart contract (Sepolia testnet only)

1. Install [MetaMask](https://metamask.io/) browser extension and select the **Sepolia** test network. Enable test networks in MetaMask if needed.
2. Obtain a little Sepolia **test ETH** from a reputable test faucet to pay for transactions. Never send actual ETH or reveal a seed phrase.
3. Open [Remix IDE](https://remix.ethereum.org/), create `SimpleBank.sol`, and paste in the code.
4. Compile with Solidity **0.8.20 or newer**.
5. Open **Deploy & Run Transactions**, choose **Injected Provider - MetaMask** (or the current equivalent), verify MetaMask is on **Sepolia**, and deploy the `SimpleBank` contract. Confirm the wallet prompt.
6. Copy the **deployed contract address** from Remix.
7. Open `index.html` in Chrome, choose **Sepolia Blockchain**, paste the contract address, and click **Load contract** / **Connect MetaMask**.
8. As the deploying wallet (admin), you are approved automatically. Use **Fund lending pool**. To let another wallet transact, select it in MetaMask, copy its address, switch back to the deploying admin wallet, and use **Approve customer**. Then switch to the new wallet and reconnect in the website.
9. Test deposits, withdrawals and transfers. For a loan, supply 200% collateral; repayment requires principal plus a 5% fee **from the wallet ETH**. All transactions consume **testnet gas**.

The website loads ethers.js v6 from a CDN for blockchain mode, so internet connectivity is needed. Chrome sometimes restricts wallet injection on `file://` pages. If MetaMask does not appear, run the site through VS Code's **Live Server** extension, or use `python -m http.server 8000` in the project folder and visit `http://localhost:8000` (this command runs a web server and does not use Git).

**Safety:** Only the **Sepolia test network** is accepted by the website. Do **not** deploy this classroom contract on mainnet or use real cryptocurrency. The educational contract is unaudited and lacks real KYC, liquidation, credit management, off-chain privacy and production security.

## How it connects to the presentation

| PPT concept | This project |
|---|---|
| AccountManager / AccessControl | Admin wallet approval and customer whitelist |
| BankVault | Deposit and withdraw test ETH |
| TransferModule | Transfer internal balances between approved customers |
| LoanManager | 200%-collateral loan; repayment unlocks collateral |
| InterestEngine | Simplified to a fixed **5% fee**, not time-based interest |
| Audit trail | Solidity events; website shows demo or session activity |

It combines the presentation's six modules into **one Solidity file** to keep the project small. Blockchain mode does not store private KYC data on chain. Instant Demo is a simulation, while blockchain mode sends real transactions on Sepolia.

## GitHub upload WITHOUT Git commands

1. Ask your friend to create a new repository, e.g. `chainbank-smart-contract-system`, in **their GitHub account**.
2. Your friend may grant your GitHub account collaborator access, or they can log in to the GitHub website themselves on your laptop. You do not need their password or Git credentials.
3. In the repository click **Add file → Upload files**. Upload these **three individual files** (not only the ZIP).
4. Click **Commit changes**.
5. To publish the front-end as a website, in the repository go to **Settings → Pages → Build and deployment → Deploy from a branch → main / (root) → Save**. The resulting GitHub Pages URL hosts `index.html` (public repositories generally work on free plans; publishing may take a few minutes).
6. Share the Pages link to demonstrate the **Instant Demo** website directly in a browser. For the blockchain option, users still need MetaMask, Sepolia test ETH, and the address of a deployed contract.

If **Add file** is unavailable, confirm the signed-in account has write permission to the repository. Git commands on your own laptop are not required.

## Suggested classroom demo sequence

1. Open website and show modern dashboard, balances and history.
2. As Alex, fund 5 demo ETH into the pool.
3. Switch to Asha and deposit 2 ETH; withdraw 0.5 ETH.
4. Transfer 0.25 ETH to Ravi and switch accounts to show the credited balance.
5. As Asha, request a 1 ETH loan (2 ETH collateral, 1.05 ETH due), then repay and show collateral released.
6. Explain that instant demo runs locally, then show `SimpleBank.sol` in Remix as the on-chain implementation.

## Disclaimer

Educational prototype only; not an actual bank, regulated deposit product, or audited financial contract. No genuine identity verification or loan liquidation is implemented.
