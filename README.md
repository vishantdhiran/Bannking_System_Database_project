# Bannking_System_Database_project

This project demonstrates a complete SQL-based Banking System workflow built using Microsoft SQL Server.
It models essential banking operations such as customer creation, account management, transactions (deposit, withdrawal, and transfer), and transaction history tracking — all implemented through stored procedures.

PROJECT STRUCTURE:-
File: BankingSystem_full_workflow.sql
This single SQL script:
Creates the BankingSystem database.
Defines all required tables:
Customers
Accounts
Transactions
Implements key stored procedures for workflow automation.
Inserts sample data and executes workflow examples.

DATABASE SCHEMA OVERVIEW:-
TABLE: CUSTOMERS
CustomerID (INT, Primary Key)
Name (NVARCHAR(100))
Address (NVARCHAR(255))
Email (NVARCHAR(100))
Phone (VARCHAR(15))
CreatedDate (DATETIME, Default: GETDATE())
TABLE: ACCOUNTS
AccountID (INT, Primary Key)
CustomerID (INT, Foreign Key → Customers.CustomerID)
AccountType (NVARCHAR(50))
Balance (DECIMAL(18,2), Default: 0.00)
Status (NVARCHAR(20), Default: Active)
CreatedDate (DATETIME, Default: GETDATE())
TABLE: TRANSACTIONS
TransactionID (INT, Primary Key)
AccountID (INT, Foreign Key → Accounts.AccountID)
TransactionType (NVARCHAR(50))
Amount (DECIMAL(18,2))
TransactionDate (DATETIME, Default: GETDATE())
Remarks (NVARCHAR(255))

STORED PROCEDURES:-
CreateCustomer → Registers a new customer.
OpenAccount → Opens an account for a customer.
DepositMoney → Deposits funds into an account and records the transaction.
WithdrawMoney → Withdraws funds (checks for sufficient balance).
TransferAmount → Transfers funds between accounts using transactions for consistency.
ViewTransactionHistory → Displays all transactions for a specific account.

SETUP AND EXECUTION:-
Open SQL Server Management Studio (SSMS)
Connect to your SQL Server instance.
Run the Script
Copy the contents of BankingSystem_full_workflow.sql
Execute it (press F5 or click "Run")

The script automatically:
• Creates the database
• Generates tables and stored procedures
• Inserts sample customer and account data
• Executes sample operations (Deposit, Withdraw, Transfer)

View Results
Use:
SELECT * FROM Customers;
SELECT * FROM Accounts;
SELECT * FROM Transactions;

Or:
EXEC ViewTransactionHistory @AccountID = 1;

SAMPLE WORKFLOW EXECUTED

EXEC CreateCustomer 'Vishant Kumar', 'Panchkula, Haryana', 'vk@gmail.com
', '9646084535';
EXEC OpenAccount @CustomerID = 1, @AccountType = 'Savings';
EXEC OpenAccount @CustomerID = 1, @AccountType = 'Current';
EXEC DepositMoney @AccountID = 1, @Amount = 5000, @Remarks = 'Initial Deposit';
EXEC WithdrawMoney @AccountID = 1, @Amount = 1000, @Remarks = 'ATM Withdrawal';
EXEC TransferAmount @FromAccountID = 1, @ToAccountID = 2, @Amount = 2000, @Remarks = 'Bill Payment';
EXEC ViewTransactionHistory @AccountID = 1;

FEATURES:-
Full workflow automation via stored procedures
Realistic banking operations (Deposit, Withdraw, Transfer)
Error handling and transaction safety (TRY...CATCH, ROLLBACK)
Automatically generated sample data
Easy to extend for UI or backend integration
FUTURE ENHANCEMENTS
Add authentication for customers and staff
Integrate with front-end dashboard (ASP.NET, React, etc.)
Generate monthly statements
Implement interest calculation for savings accounts
Include audit logs and user roles
