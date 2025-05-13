USE LibraryDB;

-- Insert Members (Group Members)
INSERT INTO Members (FirstName, LastName, Email, PhoneNumber, Address, JoinedDate)
VALUES 
('Grant', 'Latham', 'grant.latham@example.com', '111-222-3333', '123 Group St', '2025-03-01'),
('Alex', 'Beltran', 'alex.beltran@example.com', '222-333-4444', '456 Team Rd', '2025-03-02'),
('Amelia', 'Conley', 'amelia.conley@example.com', '333-444-5555', '789 Dev Ln', '2025-03-03'),
('Hamza', 'Ahmed', 'hamza.ahmed@example.com', '444-555-6666', '101 Test Ave', '2025-03-04'),
('Soumya', 'Dhulipala', 'soumya.dhulipala@example.com', '555-666-7777', '202 Project Blvd', '2025-03-05'),
('Zuhayr', 'Chowdhury', 'zuhayr.chowdhury@example.com', '666-777-8888', '303 Final St', '2025-03-06');

-- Insert Categories
INSERT INTO Categories (CategoryName, Description)
VALUES 
('Fiction', 'Fictional Books'),
('Science', 'Science and Technology Books'),
('History', 'Historical Books'),
('Manga', 'Japanese comics and graphic novels'),
('Comics', 'Western comics and graphic novels');

-- Insert Books (Manga + Comics + Others)
INSERT INTO Books (Title, Author, Publisher, ISBN, YearPublished, AvailableCopies)
VALUES 
('Vagabond Vol. 1', 'Takehiko Inoue', 'Viz Media', '9781421500594', 2004, 5),
('One Piece Vol. 1', 'Eiichiro Oda', 'Viz Media', '9781569319017', 1997, 7),
('Naruto Vol. 1', 'Masashi Kishimoto', 'Viz Media', '9781569319000', 1999, 6),
('Batman: Year One', 'Frank Miller', 'DC Comics', '9781401207526', 1987, 4),
('Superman: Red Son', 'Mark Millar', 'DC Comics', '9781401201913', 2003, 3),
('Sapiens', 'Yuval Noah Harari', 'Harper', '9780062316097', 2011, 5);

-- Insert BookCategories (Manga and Comics)
INSERT INTO BookCategories (BookID, CategoryID)
VALUES 
(1, 4), -- Vagabond -> Manga
(2, 4), -- One Piece -> Manga
(3, 4), -- Naruto -> Manga
(4, 5), -- Batman Year One -> Comics
(5, 5), -- Superman Red Son -> Comics
(6, 3); -- Sapiens -> History

-- Insert Borrowing
INSERT INTO Borrowing (MemberID, BookID, BorrowDate, DueDate, ReturnDate, Status)
VALUES 
(6, 1, '2025-04-20', '2025-05-20', NULL, 'borrowed'),
(2, 6, '2025-04-10', '2025-05-10', '2025-04-25', 'returned');

-- Insert Reservations
INSERT INTO Reservations (MemberID, BookID, ReservationDate, Status)
VALUES 
(4, 1, '2025-04-22', 'active');

-- Insert Transactions
INSERT INTO Transactions (MemberID, Amount, TransactionDate, TransactionType, PaymentMethod)
VALUES 
(6, 5.00, '2025-04-25', 'fine', 'cash'),
(2, 10.00, '2025-04-26', 'payment', 'credit_card');

-- Insert Payments
INSERT INTO Payments (MemberID, Amount, PaymentDate, PaymentMethod)
VALUES 
(6, 5.00, '2025-04-26', 'cash'),
(2, 10.00, '2025-04-27', 'credit_card');

-- Insert OverdueFines
INSERT INTO OverdueFines (BorrowID, FineAmount, IssueDate, PaymentDate)
VALUES 
(1, 5.00, '2025-05-21', NULL);

-- Insert Reviews
INSERT INTO Reviews (MemberID, BookID, Rating, ReviewText, ReviewDate)
VALUES 
(6, 1, 5, 'Vagabond is a masterpiece. Loved it.', '2025-04-25'),
(2, 6, 4, 'Sapiens is very insightful.', '2025-04-28');
