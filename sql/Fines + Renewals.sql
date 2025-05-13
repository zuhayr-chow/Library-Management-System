-- Check for overdue books
SELECT Borrowing.BorrowID, Members.FirstName, Books.Title, Borrowing.DueDate, Borrowing.ReturnDate,
CASE
    WHEN Borrowing.ReturnDate IS NULL THEN DATEDIFF(CURDATE(), Borrowing.DueDate)
    ELSE DATEDIFF(Borrowing.ReturnDate, Borrowing.DueDate)
END AS OverdueDays
FROM Borrowing
JOIN Members ON Borrowing.MemberID = Members.MemberID
JOIN Books ON Borrowing.BookID = Books.BookID
WHERE Borrowing.DueDate < CURDATE();

-- Renew Book
UPDATE Borrowing
SET DueDate = DATE_ADD(DueDate, INTERVAL 15 DAY)
WHERE BorrowID = 1;