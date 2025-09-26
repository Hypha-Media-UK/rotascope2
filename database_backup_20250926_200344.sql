-- MySQL dump 10.13  Distrib 8.0.43, for Linux (x86_64)
--
-- Host: localhost    Database: rotascope
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `department_hours`
--

DROP TABLE IF EXISTS `department_hours`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department_hours` (
  `id` int NOT NULL AUTO_INCREMENT,
  `department_id` int NOT NULL,
  `day_of_week` tinyint NOT NULL,
  `opens_at` time NOT NULL,
  `closes_at` time NOT NULL,
  `porters_required` int NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_dept_day` (`department_id`,`day_of_week`),
  KEY `idx_department_day` (`department_id`,`day_of_week`),
  CONSTRAINT `department_hours_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_hours`
--

LOCK TABLES `department_hours` WRITE;
/*!40000 ALTER TABLE `department_hours` DISABLE KEYS */;
INSERT INTO `department_hours` VALUES (17,3,1,'08:00:00','18:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(18,3,2,'08:00:00','18:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(19,3,3,'08:00:00','18:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(20,3,4,'08:00:00','18:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(21,3,5,'08:00:00','18:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(22,3,6,'08:00:00','16:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(23,4,1,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(24,4,2,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(25,4,3,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(26,4,4,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(27,4,5,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(28,5,1,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(29,5,2,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(30,5,3,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(31,5,4,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(32,5,5,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(33,6,1,'08:00:00','20:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(34,6,2,'08:00:00','20:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(35,6,3,'08:00:00','20:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(36,6,4,'08:00:00','20:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(37,6,5,'08:00:00','20:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(38,6,6,'08:00:00','16:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(39,7,1,'08:00:00','17:00:00',2,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(40,7,2,'08:00:00','17:00:00',2,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(41,7,3,'08:00:00','17:00:00',2,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(42,7,4,'08:00:00','17:00:00',2,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(43,7,5,'08:00:00','17:00:00',2,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(44,8,1,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(45,8,2,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(46,8,3,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(47,8,4,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(48,8,5,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42');
/*!40000 ALTER TABLE `department_hours` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `is_24_7` tinyint(1) DEFAULT '0',
  `porters_required` int NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,'ED (A+E)',1,2,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(2,'AMU',1,1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(3,'CT Scan',0,1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(4,'Xray (Ground Floor)',0,1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(5,'Xray (Lower Ground Floor)',0,1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(6,'MRI',0,1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(7,'PTS (Patient Transport)',0,2,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(8,'Pharmacy',0,1,'2025-09-26 17:54:42','2025-09-26 17:54:42');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `porter_absences`
--

DROP TABLE IF EXISTS `porter_absences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `porter_absences` (
  `id` int NOT NULL AUTO_INCREMENT,
  `porter_id` int NOT NULL,
  `start_datetime` datetime NOT NULL,
  `end_datetime` datetime NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_porter_datetime` (`porter_id`,`start_datetime`,`end_datetime`),
  CONSTRAINT `porter_absences_ibfk_1` FOREIGN KEY (`porter_id`) REFERENCES `porters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `porter_absences`
--

LOCK TABLES `porter_absences` WRITE;
/*!40000 ALTER TABLE `porter_absences` DISABLE KEYS */;
/*!40000 ALTER TABLE `porter_absences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `porter_annual_leave`
--

DROP TABLE IF EXISTS `porter_annual_leave`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `porter_annual_leave` (
  `id` int NOT NULL AUTO_INCREMENT,
  `porter_id` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_porter_dates` (`porter_id`,`start_date`,`end_date`),
  CONSTRAINT `porter_annual_leave_ibfk_1` FOREIGN KEY (`porter_id`) REFERENCES `porters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `porter_annual_leave`
--

LOCK TABLES `porter_annual_leave` WRITE;
/*!40000 ALTER TABLE `porter_annual_leave` DISABLE KEYS */;
/*!40000 ALTER TABLE `porter_annual_leave` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `porter_assignments`
--

DROP TABLE IF EXISTS `porter_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `porter_assignments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `porter_id` int NOT NULL,
  `department_id` int NOT NULL,
  `service_id` int DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `assignment_type` enum('PERMANENT','TEMPORARY','RELIEF') DEFAULT 'PERMANENT',
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_porter_dates` (`porter_id`,`start_date`,`end_date`),
  KEY `idx_department_dates` (`department_id`,`start_date`,`end_date`),
  KEY `idx_assignment_type` (`assignment_type`),
  KEY `service_id` (`service_id`),
  CONSTRAINT `porter_assignments_ibfk_1` FOREIGN KEY (`porter_id`) REFERENCES `porters` (`id`) ON DELETE CASCADE,
  CONSTRAINT `porter_assignments_ibfk_2` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `porter_assignments_ibfk_3` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_assignment_type` CHECK ((((`department_id` is not null) and (`service_id` is null)) or ((`department_id` is null) and (`service_id` is not null))))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `porter_assignments`
--

LOCK TABLES `porter_assignments` WRITE;
/*!40000 ALTER TABLE `porter_assignments` DISABLE KEYS */;
/*!40000 ALTER TABLE `porter_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `porter_hours`
--

DROP TABLE IF EXISTS `porter_hours`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `porter_hours` (
  `id` int NOT NULL AUTO_INCREMENT,
  `porter_id` int NOT NULL,
  `day_of_week` tinyint NOT NULL,
  `starts_at` time NOT NULL,
  `ends_at` time NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_porter_day` (`porter_id`,`day_of_week`),
  KEY `idx_porter_day` (`porter_id`,`day_of_week`),
  CONSTRAINT `porter_hours_ibfk_1` FOREIGN KEY (`porter_id`) REFERENCES `porters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `porter_hours`
--

LOCK TABLES `porter_hours` WRITE;
/*!40000 ALTER TABLE `porter_hours` DISABLE KEYS */;
/*!40000 ALTER TABLE `porter_hours` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `porter_sickness`
--

DROP TABLE IF EXISTS `porter_sickness`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `porter_sickness` (
  `id` int NOT NULL AUTO_INCREMENT,
  `porter_id` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_porter_dates` (`porter_id`,`start_date`,`end_date`),
  CONSTRAINT `porter_sickness_ibfk_1` FOREIGN KEY (`porter_id`) REFERENCES `porters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `porter_sickness`
--

LOCK TABLES `porter_sickness` WRITE;
/*!40000 ALTER TABLE `porter_sickness` DISABLE KEYS */;
/*!40000 ALTER TABLE `porter_sickness` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `porters`
--

DROP TABLE IF EXISTS `porters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `porters` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `porter_type` enum('PORTER','SUPERVISOR') DEFAULT 'PORTER',
  `contracted_hours_type` enum('SHIFT','CUSTOM','RELIEF') NOT NULL,
  `shift_id` int DEFAULT NULL,
  `shift_offset` int DEFAULT '0',
  `regular_department_id` int DEFAULT NULL,
  `is_floor_staff` tinyint(1) DEFAULT '0',
  `weekly_hours` decimal(4,2) DEFAULT '37.50',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`),
  KEY `idx_porter_type` (`porter_type`),
  KEY `idx_contracted_type` (`contracted_hours_type`),
  KEY `idx_shift` (`shift_id`),
  KEY `idx_department` (`regular_department_id`),
  CONSTRAINT `porters_ibfk_1` FOREIGN KEY (`shift_id`) REFERENCES `shifts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `porters_ibfk_2` FOREIGN KEY (`regular_department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `porters`
--

LOCK TABLES `porters` WRITE;
/*!40000 ALTER TABLE `porters` DISABLE KEYS */;
INSERT INTO `porters` VALUES (1,'Rob Mcpartland','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(2,'John Evans','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(3,'Charlotte Rimmer','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(4,'Carla Barton','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(5,'Andrew Trudgeon','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(6,'Stephen Bowater','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(7,'Matthew Bennett','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(8,'Stephen Scarsbrook','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(9,'Jordon Fish','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(10,'Steven Richardson','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(11,'Chris Roach','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(12,'Simon Collins','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(13,'Mark Walton','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(14,'Allen Butler','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(15,'Darren Flowers','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(16,'Brian Cassidy','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(17,'Karen Blackett','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(18,'James Mitchell','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(19,'Alan Kelly','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(20,'Tomas Konkol','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(21,'Kyle Blackshaw','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(22,'David Sykes','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(23,'Stuart Ford','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(24,'Lee Stafford','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(25,'Nicola Benger','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(26,'Jeff Robinson','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(27,'Dean Pickering','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(28,'Colin Bromley','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(29,'Gary Booth','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(30,'Ian Moss','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(31,'Paul Fisher','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(32,'Stephen Kirk','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(33,'Ian Speakes','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(34,'Stuart Lomas','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(35,'Stephen Cooper','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(36,'Darren Milhench','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(37,'Darren Mycroft','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(38,'Kevin Gaskell','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(39,'Merv Permalloo','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(40,'Regan Stringer','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(41,'Matthew Cope','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(42,'AJ','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(43,'Michael Shaw','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(44,'James Bennett','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(45,'Martin Hobson','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(46,'Martin Kenyon','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(47,'Scott Cartledge','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(48,'Tony Batters','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(49,'Lewis Yearsley','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(50,'Mark Lloyd','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(51,'Stephen Burke','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(52,'Julie Greenough','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(53,'Edward Collier','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(54,'Phil Hollinshead','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(55,'Kevin Tomlinson','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(56,'Soloman Offei','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(57,'Lynne Warner','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(58,'Roy Harris','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(59,'Kyle Sanderson','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(60,'Peter Moss','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(61,'Chris Wardle','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(62,'Eloisa Andrew','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(63,'Gary Bromley','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(64,'Mike Brennan','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(65,'Lucy Redfearn','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(66,'Mark Dickinson','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(67,'Paul Berry','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(68,'Robert Frost','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(69,'Andrew Gibson','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(70,'Nigel Beesley','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(71,'Andy Clayton','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(72,'Matthew Rushton','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(73,'Mark Haughton','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(74,'Graham Brown','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(75,'Chris Huckaby','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(76,'Jason Newton','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(77,'Joe Redfearn','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(78,'Paul Flowers','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(79,'Jake Moran','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(80,'Gavin Marsden','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(81,'Andrew Hassall','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(82,'Alan Clark','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(83,'Duane Kulikowski','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(84,'Craig Butler','PORTER','RELIEF',NULL,0,NULL,1,37.50,'2025-09-26 17:54:43','2025-09-26 17:54:43');
/*!40000 ALTER TABLE `porters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_hours`
--

DROP TABLE IF EXISTS `service_hours`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_hours` (
  `id` int NOT NULL AUTO_INCREMENT,
  `service_id` int NOT NULL,
  `day_of_week` int NOT NULL,
  `opens_at` time NOT NULL,
  `closes_at` time NOT NULL,
  `porters_required` int DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_service_day` (`service_id`,`day_of_week`),
  KEY `idx_service_hours_service_day` (`service_id`,`day_of_week`),
  CONSTRAINT `service_hours_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_hours`
--

LOCK TABLES `service_hours` WRITE;
/*!40000 ALTER TABLE `service_hours` DISABLE KEYS */;
INSERT INTO `service_hours` VALUES (1,7,1,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(2,7,2,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(3,7,3,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(4,7,4,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(5,7,5,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(6,4,1,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(7,4,2,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(8,4,3,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(9,4,4,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(10,4,5,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(11,6,1,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(12,6,2,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(13,6,3,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(14,6,4,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(15,6,5,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(16,8,1,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(17,8,2,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(18,8,3,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(19,8,4,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(20,8,5,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(21,9,1,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(22,9,2,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(23,9,3,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(24,9,4,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(25,9,5,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(26,5,1,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(27,5,2,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(28,5,3,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(29,5,4,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(30,5,5,'08:00:00','17:00:00',1,'2025-09-26 17:54:43','2025-09-26 17:54:43'),(31,2,1,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(32,2,2,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(33,2,3,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(34,2,4,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(35,2,5,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(36,1,1,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(37,1,2,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(38,1,3,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(39,1,4,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(40,1,5,'08:00:00','17:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(41,3,1,'09:00:00','16:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(42,3,2,'09:00:00','16:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(43,3,3,'09:00:00','16:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(44,3,4,'09:00:00','16:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42'),(45,3,5,'09:00:00','16:00:00',1,'2025-09-26 17:54:42','2025-09-26 17:54:42');
/*!40000 ALTER TABLE `service_hours` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `is_24_7` tinyint(1) DEFAULT '0',
  `porters_required` int DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_services_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (1,'Post',0,1,'2025-09-26 17:54:42','2025-09-26 17:54:50'),(2,'Medical Records',0,1,'2025-09-26 17:54:42','2025-09-26 17:54:50'),(3,'Sharps',0,1,'2025-09-26 17:54:42','2025-09-26 17:54:50'),(4,'Blood Drivers',0,1,'2025-09-26 17:54:42','2025-09-26 17:54:50'),(5,'Laundry',0,1,'2025-09-26 17:54:42','2025-09-26 17:54:50'),(6,'District Drivers',0,1,'2025-09-26 17:54:42','2025-09-26 17:54:50'),(7,'Ad-Hoc',0,1,'2025-09-26 17:54:42','2025-09-26 17:54:50'),(8,'External Waste',0,1,'2025-09-26 17:54:42','2025-09-26 17:54:50'),(9,'Helpdesk',0,1,'2025-09-26 17:54:42','2025-09-26 17:54:50');
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shifts`
--

DROP TABLE IF EXISTS `shifts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shifts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `shift_type` enum('DAY','NIGHT') NOT NULL,
  `shift_ident` enum('A','B','C','D') NOT NULL,
  `starts_at` time NOT NULL,
  `ends_at` time NOT NULL,
  `days_on` int NOT NULL DEFAULT '1',
  `days_off` int NOT NULL DEFAULT '1',
  `shift_offset` int NOT NULL DEFAULT '0',
  `ground_zero` date NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_type_ident` (`shift_type`,`shift_ident`),
  KEY `idx_shift_type` (`shift_type`),
  KEY `idx_shift_ident` (`shift_ident`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shifts`
--

LOCK TABLES `shifts` WRITE;
/*!40000 ALTER TABLE `shifts` DISABLE KEYS */;
INSERT INTO `shifts` VALUES (1,'Day Shift A','DAY','A','08:00:00','20:00:00',4,4,0,'2025-01-01','2025-09-26 17:54:43','2025-09-26 17:54:43'),(2,'Day Shift B','DAY','B','08:00:00','20:00:00',4,4,4,'2025-01-01','2025-09-26 17:54:43','2025-09-26 17:54:43'),(3,'Night Shift A','NIGHT','A','20:00:00','08:00:00',4,4,0,'2025-01-01','2025-09-26 17:54:43','2025-09-26 17:54:43'),(4,'Night Shift B','NIGHT','B','20:00:00','08:00:00',4,4,4,'2025-01-01','2025-09-26 17:54:43','2025-09-26 17:54:43');
/*!40000 ALTER TABLE `shifts` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-26 19:03:45
