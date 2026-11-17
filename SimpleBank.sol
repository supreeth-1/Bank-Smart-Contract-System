// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SimpleBank
 * @notice Educational banking demonstration using test ETH only.
 * @dev No real-world identity checks, credit assessment, or liquidation.
 */
contract SimpleBank {
    address public immutable owner;
    uint256 public lendingPool;
    uint256 private entered;

    mapping(address => bool) public approvedCustomers;
    mapping(address => uint256) public balances;

    struct Loan {
        uint256 principal;
        uint256 amountDue;
        uint256 collateral;
    }
    mapping(address => Loan) public loans;

    event CustomerApproved(address indexed customer);
    event Deposited(address indexed customer, uint256 amount);
    event Withdrawn(address indexed customer, uint256 amount);
    event Transferred(address indexed from, address indexed to, uint256 amount);
    event PoolFunded(address indexed admin, uint256 amount);
    event LoanTaken(address indexed customer, uint256 principal, uint256 amountDue, uint256 collateral);
    event LoanRepaid(address indexed customer, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only admin");
        _;
    }

    modifier onlyCustomer() {
        require(approvedCustomers[msg.sender], "Customer not approved");
        _;
    }

    modifier nonReentrant() {
        require(entered == 0, "Reentrant call");
        entered = 1;
        _;
        entered = 0;
    }

    constructor() {
        owner = msg.sender;
        approvedCustomers[msg.sender] = true;
    }

    // In this classroom demo, approval is manual (NOT real KYC).
    function approveCustomer(address customer) external onlyOwner {
        require(customer != address(0), "Invalid address");
        approvedCustomers[customer] = true;
        emit CustomerApproved(customer);
    }

    function deposit() external payable onlyCustomer {
        require(msg.value > 0, "Amount must be positive");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external onlyCustomer nonReentrant {
        require(amount > 0, "Amount must be positive");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "ETH transfer failed");
        emit Withdrawn(msg.sender, amount);
    }

    function transferTo(address receiver, uint256 amount) external onlyCustomer {
        require(approvedCustomers[receiver], "Receiver not approved");
        require(receiver != msg.sender, "Cannot send to self");
        require(amount > 0, "Amount must be positive");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Transferred(msg.sender, receiver, amount);
    }

    // Admin separately supplies the ETH available for lending.
    function fundLendingPool() external payable onlyOwner {
        require(msg.value > 0, "Amount must be positive");
        lendingPool += msg.value;
        emit PoolFunded(msg.sender, msg.value);
    }

    // Fixed 5% fee; collateral must be at least twice the requested loan.
    function takeLoan(uint256 amount) external payable onlyCustomer nonReentrant {
        require(amount > 0, "Amount must be positive");
        require(loans[msg.sender].amountDue == 0, "Repay existing loan");
        require(amount <= lendingPool, "Lending pool too small");
        require(msg.value >= amount * 2, "Need 200% ETH collateral");

        uint256 fee = (amount * 5) / 100;
        loans[msg.sender] = Loan(amount, amount + fee, msg.value);
        lendingPool -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Loan transfer failed");
        emit LoanTaken(msg.sender, amount, amount + fee, msg.value);
    }

    // Repayment comes from wallet ETH (Remix VALUE field), not bank balance.
    function repayLoan() external payable onlyCustomer nonReentrant {
        Loan memory loan = loans[msg.sender];
        require(loan.amountDue > 0, "No active loan");
        require(msg.value == loan.amountDue, "Send exact amount due");

        delete loans[msg.sender];
        lendingPool += msg.value;

        (bool success, ) = payable(msg.sender).call{value: loan.collateral}("");
        require(success, "Collateral refund failed");
        emit LoanRepaid(msg.sender, msg.value);
    }

    function myBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}
