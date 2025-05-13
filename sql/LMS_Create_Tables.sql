CREATE DATABASE IF NOT EXISTS LibraryDB;
USE LibraryDB;

-- Use the database
USE LibraryDB;

-- Members table
CREATE TABLE Members (
    MemberID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(20),
    Address TEXT,
    JoinedDate DATE
);

-- Books table
CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255),
    Author VARCHAR(100),
    Publisher VARCHAR(100),
    ISBN VARCHAR(20) UNIQUE,
    YearPublished YEAR,
    AvailableCopies INT
);

-- Categories table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) UNIQUE,
    Description TEXT
);

-- BookCategories table (Many-to-Many between Books and Categories)
CREATE TABLE BookCategories (
    BookID INT,
    CategoryID INT,
    PRIMARY KEY (BookID, CategoryID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) ON DELETE CASCADE
);

-- Borrowing table
CREATE TABLE Borrowing (
    BorrowID INT PRIMARY KEY AUTO_INCREMENT,
    MemberID INT,
    BookID INT,
    BorrowDate DATE,
    DueDate DATE,
    ReturnDate DATE,
    Status ENUM('borrowed', 'returned', 'overdue') DEFAULT 'borrowed',
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- Reservations table
CREATE TABLE Reservations (
    ReservationID INT PRIMARY KEY AUTO_INCREMENT,
    MemberID INT,
    BookID INT,
    ReservationDate DATE,
    Status ENUM('active', 'fulfilled', 'cancelled') DEFAULT 'active',
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- Transactions table
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    MemberID INT,
    Amount DECIMAL(8,2),
    TransactionDate DATE,
    TransactionType ENUM('fine', 'payment'),
    PaymentMethod ENUM('cash', 'credit_card', 'online'),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

-- Payments table
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    MemberID INT,
    Amount DECIMAL(8,2),
    PaymentDate DATE,
    PaymentMethod ENUM('cash', 'credit_card', 'online'),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

-- OverdueFines table
CREATE TABLE OverdueFines (
    FineID INT PRIMARY KEY AUTO_INCREMENT,
    BorrowID INT,
    FineAmount DECIMAL(6,2),
    IssueDate DATE,
    PaymentDate DATE,
    FOREIGN KEY (BorrowID) REFERENCES Borrowing(BorrowID)
);

-- Reviews table
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY AUTO_INCREMENT,
    MemberID INT,
    BookID INT,
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    ReviewText TEXT,
    ReviewDate DATE,
    UNIQUE(MemberID, BookID), -- Only one review per member/book
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);
