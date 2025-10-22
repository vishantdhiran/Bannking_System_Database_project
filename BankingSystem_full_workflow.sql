USE master;
GO

IF DB_ID('BankingSystem') IS NOT NULL
BEGIN
    ALTER DATABASE BankingSystem SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BankingSystem;
END
GO

CREATE DATABASE BankingSystem;
GO
USE BankingSystem;
GO

IF OBJECT_ID('Transactions', 'U') IS NOT NULL DROP TABLE Transactions;
IF OBJECT_ID('Accounts', 'U') IS NOT NULL DROP TABLE Accounts;
IF OBJECT_ID('Customers', 'U') IS NOT NULL DROP TABLE Customers;
GO

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100),
    Address NVARCHAR(255),
    Email NVARCHAR(100),
    Phone VARCHAR(15),
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY IDENTITY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    AccountType NVARCHAR(50),
    Balance DECIMAL(18,2) DEFAULT 0.00,
    Status NVARCHAR(20) DEFAULT 'Active',
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY IDENTITY,
    AccountID INT FOREIGN KEY REFERENCES Accounts(AccountID),
    TransactionType NVARCHAR(50),
    Amount DECIMAL(18,2),
    TransactionDate DATETIME DEFAULT GETDATE(),
    Remarks NVARCHAR(255)
);
GO

IF OBJECT_ID('CreateCustomer', 'P') IS NOT NULL DROP PROCEDURE CreateCustomer;
IF OBJECT_ID('OpenAccount', 'P') IS NOT NULL DROP PROCEDURE OpenAccount;
IF OBJECT_ID('DepositMoney', 'P') IS NOT NULL DROP PROCEDURE DepositMoney;
IF OBJECT_ID('WithdrawMoney', 'P') IS NOT NULL DROP PROCEDURE WithdrawMoney;
IF OBJECT_ID('TransferAmount', 'P') IS NOT NULL DROP PROCEDURE TransferAmount;
IF OBJECT_ID('ViewTransactionHistory', 'P') IS NOT NULL DROP PROCEDURE ViewTransactionHistory;
GO

CREATE PROCEDURE CreateCustomer
    @Name NVARCHAR(100),
    @Address NVARCHAR(255),
    @Email NVARCHAR(100),
    @Phone VARCHAR(15)
AS
BEGIN
    INSERT INTO Customers (Name, Address, Email, Phone)
    VALUES (@Name, @Address, @Email, @Phone);
END;
GO

CREATE PROCEDURE OpenAccount
    @CustomerID INT,
    @AccountType NVARCHAR(50)
AS
BEGIN
    INSERT INTO Accounts (CustomerID, AccountType)
    VALUES (@CustomerID, @AccountType);
END;
GO

CREATE PROCEDURE DepositMoney
    @AccountID INT,
    @Amount DECIMAL(18,2),
    @Remarks NVARCHAR(255)
AS
BEGIN
    UPDATE Accounts
    SET Balance = Balance + @Amount
    WHERE AccountID = @AccountID;

    INSERT INTO Transactions (AccountID, TransactionType, Amount, Remarks)
    VALUES (@AccountID, 'Deposit', @Amount, @Remarks);
END;
GO

CREATE PROCEDURE WithdrawMoney
    @AccountID INT,
    @Amount DECIMAL(18,2),
    @Remarks NVARCHAR(255)
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM Accounts WHERE AccountID = @AccountID AND Balance >= @Amount
    )
    BEGIN
        UPDATE Accounts
        SET Balance = Balance - @Amount
        WHERE AccountID = @AccountID;

        INSERT INTO Transactions (AccountID, TransactionType, Amount, Remarks)
        VALUES (@AccountID, 'Withdraw', @Amount, @Remarks);
    END
    ELSE
    BEGIN
        RAISERROR('Insufficient balance in account.', 16, 1);
    END
END;
GO

CREATE PROCEDURE TransferAmount
    @FromAccountID INT,
    @ToAccountID INT,
    @Amount DECIMAL(18,2),
    @Remarks NVARCHAR(255)
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        IF NOT EXISTS (
            SELECT 1 FROM Accounts
            WHERE AccountID = @FromAccountID AND Balance >= @Amount
        )
        BEGIN
            RAISERROR('Insufficient balance in source account.', 16, 1);
            ROLLBACK;
            RETURN;
        END

        UPDATE Accounts
        SET Balance = Balance - @Amount
        WHERE AccountID = @FromAccountID;

        UPDATE Accounts
        SET Balance = Balance + @Amount
        WHERE AccountID = @ToAccountID;

        INSERT INTO Transactions (AccountID, TransactionType, Amount, Remarks)
        VALUES 
            (@FromAccountID, 'Transfer Out', @Amount, @Remarks),
            (@ToAccountID, 'Transfer In', @Amount, @Remarks);

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
GO

CREATE PROCEDURE ViewTransactionHistory
    @AccountID INT
AS
BEGIN
    SELECT 
        TransactionID,
        AccountID,
        TransactionType,
        Amount,
        TransactionDate,
        Remarks
    FROM Transactions
    WHERE AccountID = @AccountID
    ORDER BY TransactionDate DESC;
END;
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

EXEC DepositMoney @AccountID = 1, @Amount = 5000, @Remarks = 'Initial Deposit';
GO

EXEC WithdrawMoney @AccountID = 1, @Amount = 1000, @Remarks = 'ATM Withdrawal';
GO

EXEC TransferAmount @FromAccountID = 1, @ToAccountID = 2, @Amount = 2000, @Remarks = 'Bill Payment';
GO

EXEC ViewTransactionHistory @AccountID = 1;
EXEC ViewTransactionHistory @AccountID = 2;
GO
