-- Reserve book
INSERT INTO Reservations (MemberID, BookID, ReservationDate, Status)
VALUES (3, 2, CURDATE(), 'active');

-- Search books by title or author
SELECT * FROM Books
WHERE Title LIKE '%Batman%'
OR Author LIKE '%Frank Miller%';
