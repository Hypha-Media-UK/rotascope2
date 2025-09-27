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
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `table_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `record_id` int unsigned NOT NULL,
  `action` enum('INSERT','UPDATE','DELETE') COLLATE utf8mb4_unicode_ci NOT NULL,
  `old_values` json DEFAULT NULL,
  `new_values` json DEFAULT NULL,
  `changed_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `idx_audit_table_record` (`table_name`,`record_id`),
  KEY `idx_audit_action` (`action`),
  KEY `idx_audit_changed_at` (`changed_at`),
  KEY `idx_audit_changed_by` (`changed_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_log`
--

LOCK TABLES `audit_log` WRITE;
/*!40000 ALTER TABLE `audit_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_hours`
--

DROP TABLE IF EXISTS `department_hours`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department_hours` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `department_id` int unsigned NOT NULL,
  `day_of_week` tinyint unsigned NOT NULL,
  `opens_at` time NOT NULL,
  `closes_at` time NOT NULL,
  `porters_required` int unsigned NOT NULL DEFAULT '1',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_dept_hours_day` (`department_id`,`day_of_week`),
  KEY `idx_dept_hours_day` (`day_of_week`),
  KEY `idx_dept_hours_active` (`is_active`),
  CONSTRAINT `department_hours_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_dept_hours_day` CHECK ((`day_of_week` between 1 and 7)),
  CONSTRAINT `chk_dept_hours_porters` CHECK ((`porters_required` > 0)),
  CONSTRAINT `chk_dept_hours_times` CHECK ((`opens_at` < `closes_at`))
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_hours`
--

LOCK TABLES `department_hours` WRITE;
/*!40000 ALTER TABLE `department_hours` DISABLE KEYS */;
INSERT INTO `department_hours` VALUES (1,3,1,'08:00:00','18:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(2,3,2,'08:00:00','18:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(3,3,3,'08:00:00','18:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(4,3,4,'08:00:00','18:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(5,3,5,'08:00:00','18:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(6,3,6,'08:00:00','16:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(7,4,1,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(8,4,2,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(9,4,3,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(10,4,4,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(11,4,5,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(12,5,1,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(13,5,2,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(14,5,3,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(15,5,4,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(16,5,5,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(17,6,1,'08:00:00','20:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(18,6,2,'08:00:00','20:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(19,6,3,'08:00:00','20:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(20,6,4,'08:00:00','20:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(21,6,5,'08:00:00','20:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(22,6,6,'08:00:00','16:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(23,7,1,'08:00:00','17:00:00',2,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(24,7,2,'08:00:00','17:00:00',2,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(25,7,3,'08:00:00','17:00:00',2,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(26,7,4,'08:00:00','17:00:00',2,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(27,7,5,'08:00:00','17:00:00',2,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(28,8,1,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(29,8,2,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(30,8,3,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(31,8,4,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(32,8,5,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38');
/*!40000 ALTER TABLE `department_hours` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_24_7` tinyint(1) NOT NULL DEFAULT '0',
  `porters_required_day` int unsigned NOT NULL DEFAULT '1',
  `porters_required_night` int unsigned NOT NULL DEFAULT '1',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_dept_name` (`name`),
  UNIQUE KEY `uk_dept_code` (`code`),
  KEY `idx_dept_active` (`is_active`),
  KEY `idx_dept_24_7` (`is_24_7`),
  CONSTRAINT `chk_dept_code_length` CHECK ((char_length(`code`) >= 2)),
  CONSTRAINT `chk_dept_name_length` CHECK ((char_length(`name`) >= 2)),
  CONSTRAINT `chk_dept_porters_day` CHECK ((`porters_required_day` > 0)),
  CONSTRAINT `chk_dept_porters_night` CHECK ((`porters_required_night` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,'ED - Emergency Department (A&E)','ED',1,2,2,1,'2025-09-26 19:09:38','2025-09-27 07:45:41'),(2,'Acute Medical Unit - Test Update','AMU',1,4,2,1,'2025-09-26 19:09:38','2025-09-27 06:53:50'),(3,'CT Scan','CT',0,1,1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(4,'X-ray (Ground Floor)','XR-GF',0,1,1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(5,'X-ray (Lower Ground Floor)','XR-LGF',0,1,1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(6,'MRI','MRI',0,1,1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(7,'Patient Transport Service','PTS',0,2,1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(8,'Pharmacy','PHARM',0,1,1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(9,'Test Department','TESTDEPARTMENT',0,1,1,0,'2025-09-26 20:17:28','2025-09-26 20:17:36');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `porter_annual_leave`
--

DROP TABLE IF EXISTS `porter_annual_leave`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `porter_annual_leave` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `porter_id` int unsigned NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `days_requested` decimal(3,1) NOT NULL,
  `days_approved` decimal(3,1) DEFAULT NULL,
  `status` enum('PENDING','APPROVED','REJECTED','CANCELLED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `request_date` date NOT NULL,
  `approved_date` date DEFAULT NULL,
  `approved_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_leave_porter` (`porter_id`),
  KEY `idx_leave_dates` (`start_date`,`end_date`),
  KEY `idx_leave_status` (`status`),
  KEY `idx_leave_request_date` (`request_date`),
  CONSTRAINT `porter_annual_leave_ibfk_1` FOREIGN KEY (`porter_id`) REFERENCES `porters` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_leave_dates` CHECK ((`start_date` <= `end_date`)),
  CONSTRAINT `chk_leave_days_approved` CHECK (((`days_approved` is null) or ((`days_approved` > 0) and (`days_approved` <= `days_requested`)))),
  CONSTRAINT `chk_leave_days_requested` CHECK (((`days_requested` > 0) and (`days_requested` <= 365))),
  CONSTRAINT `chk_leave_request_date` CHECK ((`request_date` <= `start_date`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `porter_id` int unsigned NOT NULL,
  `department_id` int unsigned DEFAULT NULL,
  `service_id` int unsigned DEFAULT NULL,
  `assignment_type` enum('PERMANENT','TEMPORARY','RELIEF','OVERTIME') COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `priority` tinyint unsigned NOT NULL DEFAULT '1',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_assignment_porter` (`porter_id`),
  KEY `idx_assignment_department` (`department_id`),
  KEY `idx_assignment_service` (`service_id`),
  KEY `idx_assignment_dates` (`start_date`,`end_date`),
  KEY `idx_assignment_type` (`assignment_type`),
  KEY `idx_assignment_active` (`is_active`),
  CONSTRAINT `porter_assignments_ibfk_1` FOREIGN KEY (`porter_id`) REFERENCES `porters` (`id`) ON DELETE CASCADE,
  CONSTRAINT `porter_assignments_ibfk_2` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `porter_assignments_ibfk_3` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_assignment_dates` CHECK (((`end_date` is null) or (`start_date` <= `end_date`))),
  CONSTRAINT `chk_assignment_priority` CHECK ((`priority` between 1 and 5)),
  CONSTRAINT `chk_assignment_target` CHECK ((((`department_id` is not null) and (`service_id` is null)) or ((`department_id` is null) and (`service_id` is not null))))
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `porter_assignments`
--

LOCK TABLES `porter_assignments` WRITE;
/*!40000 ALTER TABLE `porter_assignments` DISABLE KEYS */;
INSERT INTO `porter_assignments` VALUES (1,1,1,NULL,'PERMANENT','2020-01-15',NULL,1,'Supervisor for ED day shift',1,NULL,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(2,2,1,NULL,'PERMANENT','2019-03-20',NULL,2,'ED day shift porter',1,NULL,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(3,3,2,NULL,'PERMANENT','2021-06-10',NULL,2,'AMU day shift porter',1,NULL,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(4,4,3,NULL,'PERMANENT','2020-09-05',NULL,2,'CT Scan day shift porter',1,NULL,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(5,5,1,NULL,'PERMANENT','2018-11-12',NULL,2,'ED night shift porter',1,NULL,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(6,6,2,NULL,'PERMANENT','2019-07-08',NULL,2,'AMU night shift porter',1,NULL,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(7,7,1,NULL,'PERMANENT','2020-02-14',NULL,2,'ED night shift porter',1,NULL,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(8,8,3,NULL,'PERMANENT','2021-01-20',NULL,2,'CT Scan night shift porter',1,NULL,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(9,24,7,NULL,'PERMANENT','2017-05-10',NULL,1,'Senior porter for PTS',1,NULL,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(10,25,8,NULL,'PERMANENT','2018-01-25',NULL,1,'Senior porter for Pharmacy',1,NULL,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(11,21,4,NULL,'PERMANENT','2020-10-05',NULL,3,'Part-time X-ray GF porter',1,NULL,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(12,22,5,NULL,'PERMANENT','2019-08-18',NULL,3,'Part-time X-ray LGF porter',1,NULL,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(13,23,6,NULL,'PERMANENT','2021-03-22',NULL,3,'Part-time MRI porter',1,NULL,'2025-09-26 19:09:47','2025-09-26 19:09:47');
/*!40000 ALTER TABLE `porter_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `porter_custom_hours`
--

DROP TABLE IF EXISTS `porter_custom_hours`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `porter_custom_hours` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `porter_id` int unsigned NOT NULL,
  `day_of_week` tinyint unsigned NOT NULL,
  `starts_at` time NOT NULL,
  `ends_at` time NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_porter_custom_day` (`porter_id`,`day_of_week`),
  KEY `idx_custom_hours_day` (`day_of_week`),
  KEY `idx_custom_hours_active` (`is_active`),
  CONSTRAINT `porter_custom_hours_ibfk_1` FOREIGN KEY (`porter_id`) REFERENCES `porters` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_custom_hours_day` CHECK ((`day_of_week` between 1 and 7)),
  CONSTRAINT `chk_custom_hours_times` CHECK ((`starts_at` < `ends_at`))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `porter_custom_hours`
--

LOCK TABLES `porter_custom_hours` WRITE;
/*!40000 ALTER TABLE `porter_custom_hours` DISABLE KEYS */;
INSERT INTO `porter_custom_hours` VALUES (1,21,1,'08:00:00','12:00:00',1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(2,21,3,'08:00:00','12:00:00',1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(3,21,5,'08:00:00','12:00:00',1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(4,22,2,'13:00:00','18:00:00',1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(5,22,4,'13:00:00','18:00:00',1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(6,23,1,'09:00:00','17:00:00',1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(7,23,2,'09:00:00','17:00:00',1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(8,23,3,'09:00:00','17:00:00',1,'2025-09-26 19:09:47','2025-09-26 19:09:47');
/*!40000 ALTER TABLE `porter_custom_hours` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `porter_other_absences`
--

DROP TABLE IF EXISTS `porter_other_absences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `porter_other_absences` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `porter_id` int unsigned NOT NULL,
  `absence_type` enum('TRAINING','MEETING','DISCIPLINARY','SUSPENSION','OTHER') COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `is_paid` tinyint(1) NOT NULL DEFAULT '1',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_other_absence_porter` (`porter_id`),
  KEY `idx_other_absence_dates` (`start_date`,`end_date`),
  KEY `idx_other_absence_type` (`absence_type`),
  CONSTRAINT `porter_other_absences_ibfk_1` FOREIGN KEY (`porter_id`) REFERENCES `porters` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_other_absence_dates` CHECK ((`start_date` <= `end_date`)),
  CONSTRAINT `chk_other_absence_description` CHECK ((char_length(`description`) >= 3)),
  CONSTRAINT `chk_other_absence_times` CHECK ((((`start_time` is null) and (`end_time` is null)) or ((`start_time` is not null) and (`end_time` is not null) and (`start_time` < `end_time`))))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `porter_other_absences`
--

LOCK TABLES `porter_other_absences` WRITE;
/*!40000 ALTER TABLE `porter_other_absences` DISABLE KEYS */;
/*!40000 ALTER TABLE `porter_other_absences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `porter_sickness`
--

DROP TABLE IF EXISTS `porter_sickness`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `porter_sickness` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `porter_id` int unsigned NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `days_count` decimal(3,1) DEFAULT NULL,
  `sickness_type` enum('SELF_CERTIFIED','MEDICAL_CERTIFICATE','OCCUPATIONAL_HEALTH') COLLATE utf8mb4_unicode_ci NOT NULL,
  `return_to_work_interview` tinyint(1) NOT NULL DEFAULT '0',
  `fit_note_required` tinyint(1) NOT NULL DEFAULT '0',
  `fit_note_received` tinyint(1) NOT NULL DEFAULT '0',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_sickness_porter` (`porter_id`),
  KEY `idx_sickness_dates` (`start_date`,`end_date`),
  KEY `idx_sickness_type` (`sickness_type`),
  KEY `idx_sickness_ongoing` (`end_date`),
  CONSTRAINT `porter_sickness_ibfk_1` FOREIGN KEY (`porter_id`) REFERENCES `porters` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_sickness_dates` CHECK (((`end_date` is null) or (`start_date` <= `end_date`))),
  CONSTRAINT `chk_sickness_days` CHECK (((`days_count` is null) or (`days_count` > 0)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `porter_type` enum('PORTER','SUPERVISOR','SENIOR_PORTER') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PORTER',
  `contracted_hours_type` enum('SHIFT','RELIEF','CUSTOM','PART_TIME') COLLATE utf8mb4_unicode_ci NOT NULL,
  `weekly_contracted_hours` decimal(4,2) NOT NULL DEFAULT '37.50',
  `shift_id` int unsigned DEFAULT NULL,
  `regular_department_id` int unsigned DEFAULT NULL,
  `is_floor_staff` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_porter_employee_id` (`employee_id`),
  UNIQUE KEY `uk_porter_email` (`email`),
  KEY `idx_porter_name` (`name`),
  KEY `idx_porter_type` (`porter_type`),
  KEY `idx_porter_contract_type` (`contracted_hours_type`),
  KEY `idx_porter_active` (`is_active`),
  KEY `idx_porter_shift` (`shift_id`),
  KEY `idx_porter_department` (`regular_department_id`),
  CONSTRAINT `porters_ibfk_1` FOREIGN KEY (`shift_id`) REFERENCES `shifts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `porters_ibfk_2` FOREIGN KEY (`regular_department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `chk_porter_email_format` CHECK (((`email` is null) or regexp_like(`email`,_utf8mb4'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'))),
  CONSTRAINT `chk_porter_hours` CHECK ((`weekly_contracted_hours` between 0.00 and 60.00)),
  CONSTRAINT `chk_porter_name_length` CHECK ((char_length(`name`) >= 2))
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `porters`
--

LOCK TABLES `porters` WRITE;
/*!40000 ALTER TABLE `porters` DISABLE KEYS */;
INSERT INTO `porters` VALUES (1,'EMP001','Rob Mcpartland','rob.mcpartland@hospital.nhs.uk',NULL,'SUPERVISOR','SHIFT',37.50,1,1,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(2,'EMP002','John Evans','john.evans@hospital.nhs.uk',NULL,'PORTER','SHIFT',37.50,1,1,0,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(3,'EMP003','Charlotte Rimmer','charlotte.rimmer@hospital.nhs.uk',NULL,'PORTER','SHIFT',37.50,2,2,0,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(4,'EMP004','Carla Barton','carla.barton@hospital.nhs.uk',NULL,'PORTER','SHIFT',37.50,2,3,0,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(5,'EMP005','Andrew Trudgeon','andrew.trudgeon@hospital.nhs.uk',NULL,'PORTER','SHIFT',37.50,3,1,0,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(6,'EMP006','Stephen Bowater','stephen.bowater@hospital.nhs.uk',NULL,'PORTER','SHIFT',37.50,3,2,0,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(7,'EMP007','Matthew Bennett','matthew.bennett@hospital.nhs.uk',NULL,'PORTER','SHIFT',37.50,4,1,0,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(8,'EMP008','Stephen Scarsbrook','stephen.scarsbrook@hospital.nhs.uk',NULL,'PORTER','SHIFT',37.50,4,3,0,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(9,'EMP009','Jordon Fish','jordon.fish@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(10,'EMP010','Steven Richardson','steven.richardson@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(11,'EMP011','Chris Roach','chris.roach@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(12,'EMP012','Simon Collins','simon.collins@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(13,'EMP013','Mark Walton','mark.walton@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(14,'EMP014','Allen Butler','allen.butler@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(15,'EMP015','Darren Flowers','darren.flowers@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(16,'EMP016','Brian Cassidy','brian.cassidy@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(17,'EMP017','Karen Blackett','karen.blackett@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(18,'EMP018','James Mitchell','james.mitchell@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(19,'EMP019','Alan Kelly','alan.kelly@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(20,'EMP020','Tomas Konkol','tomas.konkol@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(21,'EMP021','Kyle Blackshaw','kyle.blackshaw@hospital.nhs.uk',NULL,'PORTER','PART_TIME',20.00,NULL,4,0,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(22,'EMP022','David Sykes','david.sykes@hospital.nhs.uk',NULL,'PORTER','PART_TIME',25.00,NULL,5,0,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(23,'EMP023','Stuart Ford','stuart.ford@hospital.nhs.uk',NULL,'PORTER','PART_TIME',30.00,NULL,6,0,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(24,'EMP024','Lee Stafford','lee.stafford@hospital.nhs.uk',NULL,'SENIOR_PORTER','SHIFT',37.50,1,7,0,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(25,'EMP025','Nicola Benger','nicola.benger@hospital.nhs.uk',NULL,'SENIOR_PORTER','SHIFT',37.50,2,8,0,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(26,'EMP026','Jeff Robinson','jeff.robinson@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(27,'EMP027','Dean Pickering','dean.pickering@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(28,'EMP028','Colin Bromley','colin.bromley@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(29,'EMP029','Gary Booth','gary.booth@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(30,'EMP030','Ian Moss','ian.moss@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(31,'EMP031','Paul Fisher','paul.fisher@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(32,'EMP032','Stephen Kirk','stephen.kirk@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(33,'EMP033','Ian Speakes','ian.speakes@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(34,'EMP034','Stuart Lomas','stuart.lomas@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(35,'EMP035','Stephen Cooper','stephen.cooper@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(36,'EMP036','Darren Milhench','darren.milhench@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(37,'EMP037','Darren Mycroft','darren.mycroft@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(38,'EMP038','Kevin Gaskell','kevin.gaskell@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(39,'EMP039','Merv Permalloo','merv.permalloo@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(40,'EMP040','Regan Stringer','regan.stringer@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(41,'EMP041','Matthew Cope','matthew.cope@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(42,'EMP042','AJ','aj@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(43,'EMP043','Michael Shaw','michael.shaw@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(44,'EMP044','James Bennett','james.bennett@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(45,'EMP045','Martin Hobson','martin.hobson@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(46,'EMP046','Martin Kenyon','martin.kenyon@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(47,'EMP047','Scott Cartledge','scott.cartledge@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(48,'EMP048','Tony Batters','tony.batters@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(49,'EMP049','Lewis Yearsley','lewis.yearsley@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(50,'EMP050','Mark Lloyd','mark.lloyd@hospital.nhs.uk',NULL,'PORTER','RELIEF',37.50,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47'),(51,NULL,'Updated Test Porter','updated@example.com',NULL,'SENIOR_PORTER','CUSTOM',30.00,NULL,NULL,0,0,'2025-09-27 08:08:45','2025-09-27 08:14:59'),(52,NULL,'Test Porter Clean','test@example.com',NULL,'PORTER','SHIFT',37.50,NULL,NULL,0,0,'2025-09-27 08:30:12','2025-09-27 08:30:37');
/*!40000 ALTER TABLE `porters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_hours`
--

DROP TABLE IF EXISTS `service_hours`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_hours` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `service_id` int unsigned NOT NULL,
  `day_of_week` tinyint unsigned NOT NULL,
  `opens_at` time NOT NULL,
  `closes_at` time NOT NULL,
  `porters_required` int unsigned NOT NULL DEFAULT '1',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_svc_hours_day` (`service_id`,`day_of_week`),
  KEY `idx_svc_hours_day` (`day_of_week`),
  KEY `idx_svc_hours_active` (`is_active`),
  CONSTRAINT `service_hours_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_svc_hours_day` CHECK ((`day_of_week` between 1 and 7)),
  CONSTRAINT `chk_svc_hours_porters` CHECK ((`porters_required` > 0)),
  CONSTRAINT `chk_svc_hours_times` CHECK ((`opens_at` < `closes_at`))
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_hours`
--

LOCK TABLES `service_hours` WRITE;
/*!40000 ALTER TABLE `service_hours` DISABLE KEYS */;
INSERT INTO `service_hours` VALUES (1,1,1,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(2,1,2,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(3,1,3,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(4,1,4,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(5,1,5,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(6,2,1,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(7,2,2,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(8,2,3,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(9,2,4,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(10,2,5,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(11,4,1,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(12,4,2,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(13,4,3,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(14,4,4,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(15,4,5,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(16,5,1,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(17,5,2,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(18,5,3,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(19,5,4,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(20,5,5,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(21,6,1,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(22,6,2,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(23,6,3,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(24,6,4,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(25,6,5,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(26,7,1,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(27,7,2,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(28,7,3,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(29,7,4,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(30,7,5,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(31,8,1,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(32,8,2,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(33,8,3,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(34,8,4,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(35,8,5,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(36,9,1,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(37,9,2,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(38,9,3,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(39,9,4,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(40,9,5,'08:00:00','17:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(41,3,1,'09:00:00','16:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(42,3,2,'09:00:00','16:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(43,3,3,'09:00:00','16:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(44,3,4,'09:00:00','16:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(45,3,5,'09:00:00','16:00:00',1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38');
/*!40000 ALTER TABLE `service_hours` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_24_7` tinyint(1) NOT NULL DEFAULT '0',
  `porters_required_day` int unsigned NOT NULL DEFAULT '1',
  `porters_required_night` int unsigned NOT NULL DEFAULT '1',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_svc_name` (`name`),
  UNIQUE KEY `uk_svc_code` (`code`),
  KEY `idx_svc_active` (`is_active`),
  KEY `idx_svc_24_7` (`is_24_7`),
  CONSTRAINT `chk_svc_code_length` CHECK ((char_length(`code`) >= 2)),
  CONSTRAINT `chk_svc_name_length` CHECK ((char_length(`name`) >= 2)),
  CONSTRAINT `chk_svc_porters_day` CHECK ((`porters_required_day` > 0)),
  CONSTRAINT `chk_svc_porters_night` CHECK ((`porters_required_night` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (1,'Post','POST',0,1,1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(2,'Medical Records','MR',0,1,1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(3,'Sharps Collection','SHARPS',0,1,1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(4,'Blood Drivers','BLOOD',0,1,1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(5,'Laundry','LAUND',0,1,1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(6,'District Drivers','DIST',0,1,1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(7,'Ad-Hoc Services','ADHOC',0,1,1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(8,'External Waste','WASTE',0,1,1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(9,'Helpdesk','HELP',0,1,1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(10,'Test Service Updated','TESTSERVIC',1,3,2,0,'2025-09-27 07:00:12','2025-09-27 07:00:27');
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shift_exceptions`
--

DROP TABLE IF EXISTS `shift_exceptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shift_exceptions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `exception_date` date NOT NULL,
  `exception_type` enum('BANK_HOLIDAY','SPECIAL_EVENT','MAINTENANCE','EMERGENCY') COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `affects_day_shift` tinyint(1) NOT NULL DEFAULT '1',
  `affects_night_shift` tinyint(1) NOT NULL DEFAULT '1',
  `staffing_multiplier` decimal(3,2) NOT NULL DEFAULT '1.00',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_exception_date_type` (`exception_date`,`exception_type`),
  KEY `idx_exception_date` (`exception_date`),
  KEY `idx_exception_type` (`exception_type`),
  KEY `idx_exception_active` (`is_active`),
  CONSTRAINT `chk_exception_description` CHECK ((char_length(`description`) >= 3)),
  CONSTRAINT `chk_exception_multiplier` CHECK ((`staffing_multiplier` between 0.1 and 5.0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shift_exceptions`
--

LOCK TABLES `shift_exceptions` WRITE;
/*!40000 ALTER TABLE `shift_exceptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `shift_exceptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shifts`
--

DROP TABLE IF EXISTS `shifts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shifts` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shift_type` enum('DAY','NIGHT') COLLATE utf8mb4_unicode_ci NOT NULL,
  `shift_identifier` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `starts_at` time NOT NULL,
  `ends_at` time NOT NULL,
  `days_on` tinyint unsigned NOT NULL DEFAULT '1',
  `days_off` tinyint unsigned NOT NULL DEFAULT '1',
  `shift_offset` tinyint unsigned NOT NULL DEFAULT '0',
  `ground_zero_date` date NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_shift_name` (`name`),
  UNIQUE KEY `uk_shift_type_identifier` (`shift_type`,`shift_identifier`),
  KEY `idx_shift_type` (`shift_type`),
  KEY `idx_shift_active` (`is_active`),
  CONSTRAINT `chk_shift_days_off` CHECK ((`days_off` between 1 and 14)),
  CONSTRAINT `chk_shift_days_on` CHECK ((`days_on` between 1 and 14)),
  CONSTRAINT `chk_shift_identifier` CHECK ((`shift_identifier` in (_latin1'A',_latin1'B',_latin1'C',_latin1'D'))),
  CONSTRAINT `chk_shift_name_length` CHECK ((char_length(`name`) >= 3)),
  CONSTRAINT `chk_shift_offset` CHECK ((`shift_offset` <= 13))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shifts`
--

LOCK TABLES `shifts` WRITE;
/*!40000 ALTER TABLE `shifts` DISABLE KEYS */;
INSERT INTO `shifts` VALUES (1,'Day Shift A','DAY','A','08:00:00','20:00:00',4,4,0,'2025-01-01',1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(2,'Day Shift B','DAY','B','08:00:00','20:00:00',4,4,4,'2025-01-01',1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(3,'Night Shift A','NIGHT','A','20:00:00','08:00:00',4,4,0,'2025-01-01',1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(4,'Night Shift B','NIGHT','B','20:00:00','08:00:00',4,4,4,'2025-01-01',1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(5,'Updated Test Shift','NIGHT','C','22:00:00','06:00:00',5,2,1,'2024-01-01',0,'2025-09-27 08:12:57','2025-09-27 08:15:24');
/*!40000 ALTER TABLE `shifts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_config`
--

DROP TABLE IF EXISTS `system_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_config` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `config_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `config_value` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `config_type` enum('STRING','INTEGER','DECIMAL','BOOLEAN','JSON') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'STRING',
  `description` text COLLATE utf8mb4_unicode_ci,
  `is_system` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_config_key` (`config_key`),
  KEY `idx_config_type` (`config_type`),
  KEY `idx_config_system` (`is_system`),
  CONSTRAINT `chk_config_key_length` CHECK ((char_length(`config_key`) >= 3))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_config`
--

LOCK TABLES `system_config` WRITE;
/*!40000 ALTER TABLE `system_config` DISABLE KEYS */;
INSERT INTO `system_config` VALUES (1,'app.name','Porter Tracking System','STRING','Application name',1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(2,'app.version','2.0.0','STRING','Application version',1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(3,'shifts.day_start','08:00:00','STRING','Day shift start time',0,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(4,'shifts.day_end','20:00:00','STRING','Day shift end time',0,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(5,'shifts.night_start','20:00:00','STRING','Night shift start time',0,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(6,'shifts.night_end','08:00:00','STRING','Night shift end time',0,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(7,'leave.max_days_per_request','28','INTEGER','Maximum days per leave request',0,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(8,'leave.advance_notice_days','14','INTEGER','Minimum advance notice for leave requests',0,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(9,'sickness.self_cert_max_days','7','INTEGER','Maximum self-certified sickness days',0,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(10,'staffing.min_porters_per_department','1','INTEGER','Minimum porters required per department',0,'2025-09-26 19:09:38','2025-09-26 19:09:38');
/*!40000 ALTER TABLE `system_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'rotascope'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-27  8:31:27
