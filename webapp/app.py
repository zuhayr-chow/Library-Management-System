
from flask import Flask, render_template, request, redirect
import mysql.connector

app = Flask(__name__)

# Database connection
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="itss4380",
    database="LibraryDB"
)
cursor = db.cursor(dictionary=True)

from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017/")
mongo_db = client["LibraryNoSQL"]
reviews_collection = mongo_db["BookReviews"]


@app.route('/')
def home():
    return render_template('home.html')

@app.route('/books')
def books():
    cursor.execute("SELECT * FROM Books")
    books = cursor.fetchall()
    return render_template('books.html', books=books)

@app.route('/borrowed')
def borrowed():
    cursor.execute("""
        SELECT Borrowing.BorrowID, Members.FirstName, Books.Title, Borrowing.BorrowDate, Borrowing.DueDate, Borrowing.Status
        FROM Borrowing
        JOIN Members ON Borrowing.MemberID = Members.MemberID
        JOIN Books ON Borrowing.BookID = Books.BookID
        WHERE Borrowing.Status = 'borrowed'
    """)
    borrowed = cursor.fetchall()
    from datetime import date
    return render_template('borrowed.html', borrowed=borrowed, now=date.today())

@app.route('/borrow', methods=['GET', 'POST'])
def borrow():
    if request.method == 'POST':
        member_id = request.form['member_id']
        book_id = request.form['book_id']

        cursor.execute("SELECT AvailableCopies FROM Books WHERE BookID = %s", (book_id,))
        book = cursor.fetchone()

        if book['AvailableCopies'] <= 0:
            return "<h2>ERROR: No copies available for this book. Someone else has borrowed it.</h2><br><a href='/borrow'>Go Back</a>"

        cursor.execute("SELECT * FROM Borrowing WHERE MemberID = %s AND BookID = %s AND Status = 'borrowed'", (member_id, book_id))
        existing_borrow = cursor.fetchone()

        if existing_borrow:
            return "<h2>ERROR: This member has already borrowed this book and has not returned it yet.</h2><br><a href='/borrow'>Go Back</a>"

        cursor.execute("INSERT INTO Borrowing (MemberID, BookID, BorrowDate, DueDate, Status) VALUES (%s, %s, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'borrowed')", (member_id, book_id))
        cursor.execute("UPDATE Books SET AvailableCopies = AvailableCopies - 1 WHERE BookID = %s", (book_id,))
        db.commit()
        return redirect('/borrowed')

    cursor.execute("SELECT * FROM Members")
    members = cursor.fetchall()
    cursor.execute("SELECT * FROM Books")
    books = cursor.fetchall()
    return render_template('borrow.html', members=members, books=books)

@app.route('/return', methods=['GET', 'POST'])
def return_book():
    if request.method == 'POST':
        borrow_id = request.form['borrow_id']

        cursor.execute("UPDATE Borrowing SET ReturnDate = CURDATE(), Status = 'returned' WHERE BorrowID = %s", (borrow_id,))
        cursor.execute("SELECT BookID FROM Borrowing WHERE BorrowID = %s", (borrow_id,))
        book = cursor.fetchone()
        cursor.execute("UPDATE Books SET AvailableCopies = AvailableCopies + 1 WHERE BookID = %s", (book['BookID'],))
        db.commit()
        return "<h2>✅ Book successfully returned!</h2><br><a href='/borrowed'>Back to Borrowed Books</a>"

    cursor.execute("""
        SELECT Borrowing.BorrowID, Members.FirstName, Members.LastName, Books.Title
        FROM Borrowing
        JOIN Members ON Borrowing.MemberID = Members.MemberID
        JOIN Books ON Borrowing.BookID = Books.BookID
        WHERE Borrowing.Status = 'borrowed'
    """)
    borrowed = cursor.fetchall()
    return render_template('return.html', borrowed=borrowed)

@app.route('/add_member', methods=['GET', 'POST'])
def add_member():
    if request.method == 'POST':
        first = request.form['first_name']
        last = request.form['last_name']
        email = request.form['email']
        phone = request.form['phone']
        address = request.form['address']

        cursor.execute("INSERT INTO Members (FirstName, LastName, Email, PhoneNumber, Address, JoinedDate) VALUES (%s, %s, %s, %s, %s, CURDATE())", (first, last, email, phone, address))
        db.commit()
        return redirect('/books')

    return render_template('add_member.html')


@app.route('/member_history', methods=['GET', 'POST'])
def member_history():
    if request.method == 'POST':
        member_id = request.form['member_id']

        cursor.execute("""
            SELECT Borrowing.BorrowID, Books.Title, Borrowing.BorrowDate, Borrowing.DueDate, Borrowing.ReturnDate, Borrowing.Status
            FROM Borrowing
            JOIN Books ON Borrowing.BookID = Books.BookID
            WHERE Borrowing.MemberID = %s
        """, (member_id,))
        history = cursor.fetchall()

        cursor.execute("SELECT * FROM Members")
        members = cursor.fetchall()

        return render_template('member_history.html', history=history, members=members, selected_member=member_id)

    cursor.execute("SELECT * FROM Members")
    members = cursor.fetchall()
    return render_template('member_history.html', history=None, members=members, selected_member=None)

@app.route('/reserve', methods=['GET', 'POST'])
def reserve():
    if request.method == 'POST':
        member_id = request.form['member_id']
        book_id = request.form['book_id']

        cursor.execute("INSERT INTO Reservations (MemberID, BookID, ReservationDate, Status) VALUES (%s, %s, CURDATE(), 'active')", (member_id, book_id))
        db.commit()
        return "<h2>✅ Book reserved successfully!</h2><br><a href='/reserve'>Back to Reservations</a>"

    # Only show books with no available copies
    cursor.execute("SELECT * FROM Books WHERE AvailableCopies = 0")
    books = cursor.fetchall()

    cursor.execute("SELECT * FROM Members")
    members = cursor.fetchall()

    return render_template('reserve.html', books=books, members=members)

@app.route('/fines', methods=['GET', 'POST'])
def fines():
    if request.method == 'POST':
        borrow_id = request.form['borrow_id']

        # Mark as paid (for demo)
        cursor.execute("INSERT INTO Payments (BorrowID, PaymentDate, Amount, PaymentMethod) VALUES (%s, CURDATE(), 0, 'Cash')", (borrow_id,))
        db.commit()
        return "<h2>✅ Fine marked as paid.</h2><br><a href='/fines'>Back to Fines</a>"

    # Find overdue books not returned or returned late
    cursor.execute("""
        SELECT Borrowing.BorrowID, Members.FirstName, Books.Title, Borrowing.DueDate, Borrowing.ReturnDate,
        CASE
            WHEN Borrowing.ReturnDate IS NULL THEN DATEDIFF(CURDATE(), Borrowing.DueDate)
            ELSE DATEDIFF(Borrowing.ReturnDate, Borrowing.DueDate)
        END AS OverdueDays
        FROM Borrowing
        JOIN Members ON Borrowing.MemberID = Members.MemberID
        JOIN Books ON Borrowing.BookID = Books.BookID
        WHERE 
        (
            (Borrowing.ReturnDate IS NULL AND Borrowing.DueDate < CURDATE()) 
            OR 
            (Borrowing.ReturnDate IS NOT NULL AND Borrowing.ReturnDate > Borrowing.DueDate)
        )
        AND Borrowing.BorrowID NOT IN (SELECT BorrowID FROM Payments)
    """)
    fines = cursor.fetchall()

    return render_template('fines.html', fines=fines)

@app.route('/manage_books', methods=['GET', 'POST'])
def manage_books():
    if request.method == 'POST':
        action = request.form['action']

        if action == 'add':
            title = request.form['title']
            author = request.form['author']
            available_copies = request.form['available_copies']
            cursor.execute("INSERT INTO Books (Title, Author, AvailableCopies) VALUES (%s, %s, %s)", (title, author, available_copies))
            db.commit()

        elif action == 'edit':
            book_id = request.form['book_id']
            title = request.form['title']
            author = request.form['author']
            available_copies = request.form['available_copies']
            cursor.execute("UPDATE Books SET Title = %s, Author = %s, AvailableCopies = %s WHERE BookID = %s", (title, author, available_copies, book_id))
            db.commit()

        elif action == 'delete':
            book_id = request.form['book_id']
            cursor.execute("DELETE FROM Books WHERE BookID = %s", (book_id,))
            db.commit()

        return redirect('/manage_books')

    cursor.execute("SELECT * FROM Books")
    books = cursor.fetchall()
    return render_template('manage_books.html', books=books)

@app.route('/renew', methods=['GET', 'POST'])
def renew():
    if request.method == 'POST':
        borrow_id = request.form['borrow_id']

        # Extend due date by 15 days
        cursor.execute("UPDATE Borrowing SET DueDate = DATE_ADD(DueDate, INTERVAL 15 DAY) WHERE BorrowID = %s", (borrow_id,))
        db.commit()

        return "<h2>✅ Book renewed successfully! Due date extended by 15 days.</h2><br><a href='/renew'>Back to Renew</a>"

    # Show only borrowed books (Status = borrowed)
    cursor.execute("""
        SELECT Borrowing.BorrowID, Members.FirstName, Members.LastName, Books.Title, Borrowing.DueDate
        FROM Borrowing
        JOIN Members ON Borrowing.MemberID = Members.MemberID
        JOIN Books ON Borrowing.BookID = Books.BookID
        WHERE Borrowing.Status = 'borrowed'
    """)
    borrowed = cursor.fetchall()

    return render_template('renew.html', borrowed=borrowed)

@app.route('/search_books', methods=['GET', 'POST'])
def search_books():
    books = []

    if request.method == 'POST':
        keyword = request.form['keyword']
        cursor.execute("SELECT * FROM Books WHERE Title LIKE %s OR Author LIKE %s", ('%' + keyword + '%', '%' + keyword + '%'))
        books = cursor.fetchall()

    return render_template('search_books.html', books=books)

@app.route('/reports')
def reports():
    # Most Borrowed Books
    cursor.execute("""
        SELECT Books.Title, COUNT(Borrowing.BorrowID) AS TimesBorrowed
        FROM Borrowing
        JOIN Books ON Borrowing.BookID = Books.BookID
        GROUP BY Books.BookID
        ORDER BY TimesBorrowed DESC
        LIMIT 5
    """)
    popular_books = cursor.fetchall()

    # Total unpaid fines (Overdue only, unpaid)
    cursor.execute("""
        SELECT SUM(
            CASE
                WHEN Borrowing.ReturnDate IS NULL THEN DATEDIFF(CURDATE(), Borrowing.DueDate)
                ELSE DATEDIFF(Borrowing.ReturnDate, Borrowing.DueDate)
            END
        ) AS TotalOverdueDays
        FROM Borrowing
        WHERE 
        (
            (Borrowing.ReturnDate IS NULL AND Borrowing.DueDate < CURDATE())
            OR
            (Borrowing.ReturnDate IS NOT NULL AND Borrowing.ReturnDate > Borrowing.DueDate)
        )
        AND Borrowing.BorrowID NOT IN (SELECT BorrowID FROM Payments)
    """)
    unpaid_fines = cursor.fetchone()['TotalOverdueDays'] or 0

    # Currently borrowed books
    cursor.execute("SELECT COUNT(*) AS CurrentlyBorrowed FROM Borrowing WHERE Status = 'borrowed'")
    borrowed_books = cursor.fetchone()['CurrentlyBorrowed']

    return render_template('reports.html', popular_books=popular_books, unpaid_fines=unpaid_fines, borrowed_books=borrowed_books)

@app.route('/add_review', methods=['GET', 'POST'])
def add_review():
    if request.method == 'POST':
        book_title = request.form['title']
        reviewer = request.form['reviewer']
        rating = int(request.form['rating'])
        comment = request.form['comment']

        reviews_collection.insert_one({
            "title": book_title,
            "reviewer": reviewer,
            "rating": rating,
            "comment": comment
        })

        return "<h2>✅ Review added successfully!</h2><br><a href='/view_reviews'>View Reviews</a>"

    cursor.execute("SELECT Title FROM Books")
    books = cursor.fetchall()
    return render_template('add_review.html', books=books)

@app.route('/view_reviews')
def view_reviews():
    reviews = reviews_collection.find()
    return render_template('view_reviews.html', reviews=reviews)

if __name__ == '__main__':
    app.run(debug=True)


