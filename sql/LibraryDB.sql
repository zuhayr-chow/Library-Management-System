CREATE DATABASE  IF NOT EXISTS `librarydb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `librarydb`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: librarydb
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bookcategories`
--

DROP TABLE IF EXISTS `bookcategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookcategories` (
  `BookID` int NOT NULL,
  `CategoryID` int NOT NULL,
  PRIMARY KEY (`BookID`,`CategoryID`),
  KEY `CategoryID` (`CategoryID`),
  CONSTRAINT `bookcategories_ibfk_1` FOREIGN KEY (`BookID`) REFERENCES `books` (`BookID`) ON DELETE CASCADE,
  CONSTRAINT `bookcategories_ibfk_2` FOREIGN KEY (`CategoryID`) REFERENCES `categories` (`CategoryID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookcategories`
--

LOCK TABLES `bookcategories` WRITE;
/*!40000 ALTER TABLE `bookcategories` DISABLE KEYS */;
INSERT INTO `bookcategories` VALUES (11,1),(12,1),(13,1),(14,1),(17,2),(18,2),(6,3),(15,3),(16,3),(1,4),(2,4),(3,4),(7,4),(8,4),(4,5),(5,5),(9,5),(10,5),(19,5);
/*!40000 ALTER TABLE `bookcategories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `BookID` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) DEFAULT NULL,
  `Author` varchar(100) DEFAULT NULL,
  `Publisher` varchar(100) DEFAULT NULL,
  `ISBN` varchar(20) DEFAULT NULL,
  `YearPublished` year DEFAULT NULL,
  `AvailableCopies` int DEFAULT NULL,
  PRIMARY KEY (`BookID`),
  UNIQUE KEY `ISBN` (`ISBN`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (1,'Vagabond Vol. 1','Takehiko Inoue','Viz Media','9781421500594',2004,4),(2,'One Piece Vol. 1','Eiichiro Oda','Viz Media','9781569319017',1997,7),(3,'Naruto Vol. 1','Masashi Kishimoto','Viz Media','9781569319000',1999,6),(4,'Batman: Year One','Frank Miller','DC Comics','9781401207526',1987,4),(5,'Superman: Red Son','Mark Millar','DC Comics','9781401201913',2003,3),(6,'Sapiens','Yuval Noah Harari','Harper','9780062316097',2011,5),(7,'Demon Slayer Vol. 1','Koyoharu Gotouge','Viz Media','9781974700523',2016,10),(8,'Jujutsu Kaisen Vol. 1','Gege Akutami','Viz Media','9781974710027',2018,8),(9,'Spider-Man: Blue','Jeph Loeb','Marvel','9780785110713',2002,5),(10,'Watchmen','Alan Moore','DC Comics','9780930289232',1986,4),(11,'1984','George Orwell','Signet Classics','9780451524935',1949,7),(12,'To Kill a Mockingbird','Harper Lee','J.B. Lippincott & Co.','9780061120084',1960,6),(13,'The Catcher in the Rye','J.D. Salinger','Little, Brown and Company','9780316769488',1951,3),(14,'The Great Gatsby','F. Scott Fitzgerald','Scribner','9780743273565',1925,5),(15,'The Diary of a Young Girl','Anne Frank','Contact Publishing','9780553296983',1947,3),(16,'Guns, Germs, and Steel','Jared Diamond','W. W. Norton & Company','9780393317558',1997,4),(17,'The Selfish Gene','Richard Dawkins','Oxford University Press','9780192860927',1976,6),(18,'Astrophysics for People in a Hurry','Neil deGrasse Tyson','W. W. Norton & Company','9780393609394',2017,7),(19,'The Flash: Born to Run','Mark Waid','DC Comics','9781563891953',1993,3);
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `borrowing`
--

DROP TABLE IF EXISTS `borrowing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `borrowing` (
  `BorrowID` int NOT NULL AUTO_INCREMENT,
  `MemberID` int DEFAULT NULL,
  `BookID` int DEFAULT NULL,
  `BorrowDate` date DEFAULT NULL,
  `DueDate` date DEFAULT NULL,
  `ReturnDate` date DEFAULT NULL,
  `Status` enum('borrowed','returned','overdue') DEFAULT 'borrowed',
  PRIMARY KEY (`BorrowID`),
  KEY `MemberID` (`MemberID`),
  KEY `BookID` (`BookID`),
  CONSTRAINT `borrowing_ibfk_1` FOREIGN KEY (`MemberID`) REFERENCES `members` (`MemberID`),
  CONSTRAINT `borrowing_ibfk_2` FOREIGN KEY (`BookID`) REFERENCES `books` (`BookID`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `borrowing`
--

LOCK TABLES `borrowing` WRITE;
/*!40000 ALTER TABLE `borrowing` DISABLE KEYS */;
INSERT INTO `borrowing` VALUES (1,6,1,'2025-04-20','2025-05-20',NULL,'borrowed'),(2,2,6,'2025-04-10','2025-05-10','2025-04-25','returned'),(12,2,3,'2025-05-01','2025-05-31',NULL,'borrowed'),(13,3,4,'2025-05-01','2025-05-31',NULL,'borrowed'),(14,4,5,'2025-05-01','2025-05-31',NULL,'borrowed'),(15,5,7,'2025-05-01','2025-05-31',NULL,'borrowed'),(16,14,13,'2025-05-01','2025-05-31',NULL,'borrowed'),(17,1,1,'2025-05-01','2025-05-31',NULL,'borrowed');
/*!40000 ALTER TABLE `borrowing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `CategoryID` int NOT NULL AUTO_INCREMENT,
  `CategoryName` varchar(100) DEFAULT NULL,
  `Description` text,
  PRIMARY KEY (`CategoryID`),
  UNIQUE KEY `CategoryName` (`CategoryName`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Fiction','Fictional Books'),(2,'Science','Science and Technology Books'),(3,'History','Historical Books'),(4,'Manga','Japanese comics and graphic novels'),(5,'Comics','Western comics and graphic novels');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `members` (
  `MemberID` int NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(50) DEFAULT NULL,
  `LastName` varchar(50) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `PhoneNumber` varchar(20) DEFAULT NULL,
  `Address` text,
  `JoinedDate` date DEFAULT NULL,
  PRIMARY KEY (`MemberID`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES (1,'Grant','Latham','grant.latham@example.com','111-222-3333','123 Group St','2025-03-01'),(2,'Alex','Beltran','alex.beltran@example.com','222-333-4444','456 Team Rd','2025-03-02'),(3,'Amelia','Conley','amelia.conley@example.com','333-444-5555','789 Dev Ln','2025-03-03'),(4,'Hamza','Ahmed','hamza.ahmed@example.com','444-555-6666','101 Test Ave','2025-03-04'),(5,'Soumya','Dhulipala','soumya.dhulipala@example.com','555-666-7777','202 Project Blvd','2025-03-05'),(6,'Zuhayr','Chowdhury','zuhayr.chowdhury@example.com','666-777-8888','303 Final St','2025-03-06'),(13,'Lisa','Morris','lisa.morris@example.com','111-444-9999','111 River St','2025-03-07'),(14,'Tom','Holland','tom.holland@example.com','333-222-7777','222 Park Ave','2025-03-08'),(15,'Natalie','Portman','natalie.portman@example.com','999-555-3333','333 Galaxy Blvd','2025-03-09'),(16,'Bruce','Wayne','bruce.wayne@example.com','000-000-0000','Wayne Manor','2025-03-10');
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `overduefines`
--

DROP TABLE IF EXISTS `overduefines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `overduefines` (
  `FineID` int NOT NULL AUTO_INCREMENT,
  `BorrowID` int DEFAULT NULL,
  `FineAmount` decimal(6,2) DEFAULT NULL,
  `IssueDate` date DEFAULT NULL,
  `PaymentDate` date DEFAULT NULL,
  PRIMARY KEY (`FineID`),
  KEY `BorrowID` (`BorrowID`),
  CONSTRAINT `overduefines_ibfk_1` FOREIGN KEY (`BorrowID`) REFERENCES `borrowing` (`BorrowID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `overduefines`
--

LOCK TABLES `overduefines` WRITE;
/*!40000 ALTER TABLE `overduefines` DISABLE KEYS */;
INSERT INTO `overduefines` VALUES (1,1,5.00,'2025-05-21',NULL);
/*!40000 ALTER TABLE `overduefines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `PaymentID` int NOT NULL AUTO_INCREMENT,
  `MemberID` int DEFAULT NULL,
  `Amount` decimal(8,2) DEFAULT NULL,
  `PaymentDate` date DEFAULT NULL,
  `PaymentMethod` enum('cash','credit_card','online') DEFAULT NULL,
  PRIMARY KEY (`PaymentID`),
  KEY `MemberID` (`MemberID`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`MemberID`) REFERENCES `members` (`MemberID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,6,5.00,'2025-04-26','cash'),(2,2,10.00,'2025-04-27','credit_card');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservations`
--

DROP TABLE IF EXISTS `reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservations` (
  `ReservationID` int NOT NULL AUTO_INCREMENT,
  `MemberID` int DEFAULT NULL,
  `BookID` int DEFAULT NULL,
  `ReservationDate` date DEFAULT NULL,
  `Status` enum('active','fulfilled','cancelled') DEFAULT 'active',
  PRIMARY KEY (`ReservationID`),
  KEY `MemberID` (`MemberID`),
  KEY `BookID` (`BookID`),
  CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`MemberID`) REFERENCES `members` (`MemberID`),
  CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`BookID`) REFERENCES `books` (`BookID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservations`
--

LOCK TABLES `reservations` WRITE;
/*!40000 ALTER TABLE `reservations` DISABLE KEYS */;
INSERT INTO `reservations` VALUES (1,4,1,'2025-04-22','active');
/*!40000 ALTER TABLE `reservations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `ReviewID` int NOT NULL AUTO_INCREMENT,
  `MemberID` int DEFAULT NULL,
  `BookID` int DEFAULT NULL,
  `Rating` int DEFAULT NULL,
  `ReviewText` text,
  `ReviewDate` date DEFAULT NULL,
  PRIMARY KEY (`ReviewID`),
  UNIQUE KEY `MemberID` (`MemberID`,`BookID`),
  KEY `BookID` (`BookID`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`MemberID`) REFERENCES `members` (`MemberID`),
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`BookID`) REFERENCES `books` (`BookID`),
  CONSTRAINT `reviews_chk_1` CHECK (((`Rating` >= 1) and (`Rating` <= 5)))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,6,1,5,'Vagabond is a masterpiece. Loved it.','2025-04-25'),(2,2,6,4,'Sapiens is very insightful.','2025-04-28');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `TransactionID` int NOT NULL AUTO_INCREMENT,
  `MemberID` int DEFAULT NULL,
  `Amount` decimal(8,2) DEFAULT NULL,
  `TransactionDate` date DEFAULT NULL,
  `TransactionType` enum('fine','payment') DEFAULT NULL,
  `PaymentMethod` enum('cash','credit_card','online') DEFAULT NULL,
  PRIMARY KEY (`TransactionID`),
  KEY `MemberID` (`MemberID`),
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`MemberID`) REFERENCES `members` (`MemberID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES (1,6,5.00,'2025-04-25','fine','cash'),(2,2,10.00,'2025-04-26','payment','credit_card');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-01  3:37:54
