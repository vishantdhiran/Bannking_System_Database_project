USE BankingSystem;
GO

DELETE FROM Transactions;
DELETE FROM Accounts;
DELETE FROM Customers;
DBCC CHECKIDENT ('Transactions', RESEED, 0);
DBCC CHECKIDENT ('Accounts', RESEED, 0);
DBCC CHECKIDENT ('Customers', RESEED, 0);
GO

EXEC CreateCustomer 
    @Name = 'Vishant Kumar',
    @Address = 'Panchkula, Haryana',
    @Email = 'vk@gmail.com',
    @Phone = '9646084535';
GO

EXEC OpenAccount @CustomerID = 1, @AccountType = 'Savings';
EXEC OpenAccount @CustomerID = 1, @AccountType = 'Current';
GO

EXEC DepositMoney 
    @AccountID = 1,
    @Amount = 5000,
    @Remarks = 'Initial Deposit';
GO

EXEC WithdrawMoney 
    @AccountID = 1,
    @Amount = 1000,
    @Remarks = 'ATM Withdrawal';
GO

EXEC TransferAmount 
    @FromAccountID = 1,
    @ToAccountID = 2,
    @Amount = 2000,
    @Remarks = 'Transfer to current account';
GO

EXEC ViewTransactionHistory @AccountID = 1;
EXEC ViewTransactionHistory @AccountID = 2;
GO
