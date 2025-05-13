-- Borrow book (simulate borrowing)
INSERT INTO Borrowing (MemberID, BookID, BorrowDate, DueDate, Status)
VALUES (1, 2, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'borrowed');

-- Update book available copies
UPDATE Books
SET AvailableCopies = AvailableCopies - 1
WHERE BookID = 2;

-- View Borrowed Books
SELECT Borrowing.BorrowID, Members.FirstName, Books.Title, Borrowing.BorrowDate, Borrowing.Status
FROM Borrowing
JOIN Members ON Borrowing.MemberID = Members.MemberID
JOIN Books ON Borrowing.BookID = Books.BookID
WHERE Borrowing.Status = 'borrowed';

-- Return Book (simulate returning)
UPDATE Borrowing
SET ReturnDate = CURDATE(), Status = 'returned'
WHERE BorrowID = 1;

-- Update available copies
UPDATE Books
SET AvailableCopies = AvailableCopies + 1
WHERE BookID = 2;
