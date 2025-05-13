-- Top 5 Most Borrowed Books
SELECT Books.Title, COUNT(Borrowing.BorrowID) AS TimesBorrowed
FROM Borrowing
JOIN Books ON Borrowing.BookID = Books.BookID
GROUP BY Books.BookID
ORDER BY TimesBorrowed DESC
LIMIT 5;

-- Add member
INSERT INTO Members (FirstName, LastName, Email, PhoneNumber, Address, JoinedDate)
VALUES ('Jacob', 'Williams', 'jacobwilliams@example.com', '214-456-7390', '217 Main St', CURDATE());
