-- Add book
INSERT INTO Books (Title, Author, AvailableCopies)
VALUES ('New Sample Book', 'Author Name', 3);

-- Edit book
UPDATE Books
SET Title = 'Updated Book Title', Author = 'Updated Author'
WHERE BookID = 1;

-- Delete book
DELETE FROM Books
WHERE BookID = 10;
