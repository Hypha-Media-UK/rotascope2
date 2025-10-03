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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,'ED - Emergency Department (A&E)','ED',1,2,2,1,'2025-09-26 19:09:38','2025-09-27 07:45:41'),(2,'Acute Medical Unit','AMU',1,4,2,1,'2025-09-26 19:09:38','2025-10-02 14:04:57'),(3,'CT Scan','CT',1,2,1,1,'2025-09-26 19:09:38','2025-10-02 13:55:04'),(4,'X-ray (Ground Floor)','XR-GF',0,1,1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(5,'X-ray (Lower Ground Floor)','XR-LGF',0,1,1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(6,'MRI','MRI',0,1,1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(7,'Patient Transport Service','PTS',0,2,1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(8,'Pharmacy','PHARM',0,1,1,1,'2025-09-26 19:09:38','2025-09-26 19:09:38'),(10,'Day Staff A','FLOORSTAFF',1,14,8,0,'2025-10-02 13:16:34','2025-10-02 13:34:16'),(11,'Day Staff B','DAYSTAFFB',1,14,8,0,'2025-10-02 13:32:47','2025-10-02 13:32:56'),(19,'Floor','FLOOR',1,1,1,1,'2025-10-02 15:01:14','2025-10-03 13:45:58'),(25,'Floor Two','FLOORTWO',1,1,1,0,'2025-10-02 15:09:56','2025-10-03 13:45:51');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `frozen_porter_assignments`
--

DROP TABLE IF EXISTS `frozen_porter_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `frozen_porter_assignments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `frozen_schedule_id` int unsigned NOT NULL,
  `porter_id` int unsigned NOT NULL,
  `shift_id` int unsigned NOT NULL,
  `is_active_today` tinyint(1) NOT NULL DEFAULT '0',
  `is_temporarily_assigned` tinyint(1) NOT NULL DEFAULT '0',
  `temp_assignment_location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `frozen_schedule_id` (`frozen_schedule_id`),
  KEY `porter_id` (`porter_id`),
  KEY `shift_id` (`shift_id`),
  CONSTRAINT `frozen_porter_assignments_ibfk_1` FOREIGN KEY (`frozen_schedule_id`) REFERENCES `frozen_schedules` (`id`) ON DELETE CASCADE,
  CONSTRAINT `frozen_porter_assignments_ibfk_2` FOREIGN KEY (`porter_id`) REFERENCES `porters` (`id`) ON DELETE CASCADE,
  CONSTRAINT `frozen_porter_assignments_ibfk_3` FOREIGN KEY (`shift_id`) REFERENCES `shifts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `frozen_porter_assignments`
--

LOCK TABLES `frozen_porter_assignments` WRITE;
/*!40000 ALTER TABLE `frozen_porter_assignments` DISABLE KEYS */;
INSERT INTO `frozen_porter_assignments` VALUES (1,1,3,2,1,0,NULL,'2025-09-27 10:34:39'),(2,1,4,2,0,0,NULL,'2025-09-27 10:34:39'),(3,1,25,2,0,0,NULL,'2025-09-27 10:34:39'),(4,1,7,4,0,0,NULL,'2025-09-27 10:34:39'),(5,1,8,4,1,0,NULL,'2025-09-27 10:34:39'),(6,2,3,2,0,1,'Post','2025-09-28 06:58:59'),(7,2,4,2,0,0,NULL,'2025-09-28 06:58:59'),(8,2,25,2,0,0,NULL,'2025-09-28 06:58:59'),(9,2,42,2,0,1,'MRI','2025-09-28 06:58:59'),(10,2,7,4,0,0,NULL,'2025-09-28 06:58:59'),(11,2,8,4,0,0,NULL,'2025-09-28 06:58:59'),(12,7,3,2,0,1,'Post','2025-09-29 06:58:58'),(13,7,4,2,0,0,NULL,'2025-09-29 06:58:58'),(14,7,25,2,0,0,NULL,'2025-09-29 06:58:58'),(15,7,42,2,0,1,'MRI','2025-09-29 06:58:58'),(16,7,7,4,0,0,NULL,'2025-09-29 06:58:58'),(17,7,8,4,0,0,NULL,'2025-09-29 06:58:58'),(18,12,1,1,1,1,'Pharmacy','2025-10-03 06:58:59'),(19,12,2,1,1,0,NULL,'2025-10-03 06:58:59'),(20,12,19,1,1,0,NULL,'2025-10-03 06:58:59'),(21,12,24,1,1,0,NULL,'2025-10-03 06:58:59'),(22,12,6,3,1,0,NULL,'2025-10-03 06:58:59'),(23,12,28,8,1,0,NULL,'2025-10-03 06:58:59'),(24,12,5,11,0,0,NULL,'2025-10-03 06:58:59');
/*!40000 ALTER TABLE `frozen_porter_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `frozen_schedules`
--

DROP TABLE IF EXISTS `frozen_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `frozen_schedules` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `schedule_data` json NOT NULL,
  `frozen_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `date` (`date`),
  KEY `idx_date` (`date`),
  KEY `idx_frozen_at` (`frozen_at`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `frozen_schedules`
--

LOCK TABLES `frozen_schedules` WRITE;
/*!40000 ALTER TABLE `frozen_schedules` DISABLE KEYS */;
INSERT INTO `frozen_schedules` VALUES (1,'2025-09-27','{\"date\": \"2025-09-27\", \"services\": [{\"id\": 7, \"code\": \"ADHOC\", \"name\": \"Ad-Hoc Services\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 4, \"code\": \"BLOOD\", \"name\": \"Blood Drivers\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 6, \"code\": \"DIST\", \"name\": \"District Drivers\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 8, \"code\": \"WASTE\", \"name\": \"External Waste\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 9, \"code\": \"HELP\", \"name\": \"Helpdesk\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 5, \"code\": \"LAUND\", \"name\": \"Laundry\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 2, \"code\": \"MR\", \"name\": \"Medical Records\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 1, \"code\": \"POST\", \"name\": \"Post\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 3, \"code\": \"SHARPS\", \"name\": \"Sharps Collection\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}], \"frozen_at\": \"2025-09-27T10:34:39.675Z\", \"departments\": [{\"id\": 2, \"code\": \"AMU\", \"name\": \"Acute Medical Unit - Test Update\", \"is_24_7\": 1, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-27T06:53:50.000Z\", \"porters_required_day\": 4, \"porters_required_night\": 2}, {\"id\": 3, \"code\": \"CT\", \"name\": \"CT Scan\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 1, \"code\": \"ED\", \"name\": \"ED - Emergency Department (A&E)\", \"is_24_7\": 1, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-27T07:45:41.000Z\", \"porters_required_day\": 2, \"porters_required_night\": 2}, {\"id\": 6, \"code\": \"MRI\", \"name\": \"MRI\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 7, \"code\": \"PTS\", \"name\": \"Patient Transport Service\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 2, \"porters_required_night\": 1}, {\"id\": 8, \"code\": \"PHARM\", \"name\": \"Pharmacy\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 4, \"code\": \"XR-GF\", \"name\": \"X-ray (Ground Floor)\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 5, \"code\": \"XR-LGF\", \"name\": \"X-ray (Lower Ground Floor)\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}], \"active_shifts\": [{\"shift\": {\"id\": 2, \"name\": \"Day Shift B\", \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-09-26T19:09:38.000Z\", \"shift_type\": \"DAY\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"shift_offset\": 4, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\"}, \"is_active_today\": true, \"assigned_porters\": [{\"porter\": {\"id\": 3, \"name\": \"Charlotte Rimmer\", \"email\": \"charlotte.rimmer@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"shift_id\": 2, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Day Shift B\", \"shift_type\": \"DAY\", \"updated_at\": \"2025-09-27T10:03:55.000Z\", \"employee_id\": \"EMP003\", \"porter_type\": \"REGULAR\", \"shift_offset\": 4, \"porter_offset\": 2, \"is_floor_staff\": 0, \"temp_service_id\": 1, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\", \"temp_service_name\": \"Post\", \"temp_department_id\": null, \"temp_assignment_end\": \"2025-09-30T00:00:00.000Z\", \"temp_department_name\": null, \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": 2, \"temp_assignment_start\": \"2025-09-28T00:00:00.000Z\", \"regular_department_name\": \"Acute Medical Unit - Test Update\", \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": true, \"is_temporarily_assigned\": false, \"temp_assignment_location\": null}, {\"porter\": {\"id\": 4, \"name\": \"Carla Barton\", \"email\": \"carla.barton@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"shift_id\": 2, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Day Shift B\", \"shift_type\": \"DAY\", \"updated_at\": \"2025-09-27T10:03:55.000Z\", \"employee_id\": \"EMP004\", \"porter_type\": \"REGULAR\", \"shift_offset\": 4, \"porter_offset\": 1, \"is_floor_staff\": 0, \"temp_service_id\": null, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\", \"temp_service_name\": null, \"temp_department_id\": null, \"temp_assignment_end\": null, \"temp_department_name\": null, \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": 3, \"temp_assignment_start\": null, \"regular_department_name\": \"CT Scan\", \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": false, \"is_temporarily_assigned\": false, \"temp_assignment_location\": null}, {\"porter\": {\"id\": 25, \"name\": \"Nicola Benger\", \"email\": \"nicola.benger@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"shift_id\": 2, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Day Shift B\", \"shift_type\": \"DAY\", \"updated_at\": \"2025-09-26T19:09:47.000Z\", \"employee_id\": \"EMP025\", \"porter_type\": \"REGULAR\", \"shift_offset\": 4, \"porter_offset\": 0, \"is_floor_staff\": 0, \"temp_service_id\": null, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\", \"temp_service_name\": null, \"temp_department_id\": null, \"temp_assignment_end\": null, \"temp_department_name\": null, \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": 8, \"temp_assignment_start\": null, \"regular_department_name\": \"Pharmacy\", \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": false, \"is_temporarily_assigned\": false, \"temp_assignment_location\": null}]}, {\"shift\": {\"id\": 4, \"name\": \"Night Shift B\", \"days_on\": 4, \"ends_at\": \"08:00:00\", \"days_off\": 4, \"is_active\": 1, \"starts_at\": \"20:00:00\", \"created_at\": \"2025-09-26T19:09:38.000Z\", \"shift_type\": \"NIGHT\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"shift_offset\": 4, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\"}, \"is_active_today\": true, \"assigned_porters\": [{\"porter\": {\"id\": 7, \"name\": \"Matthew Bennett\", \"email\": \"matthew.bennett@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"08:00:00\", \"days_off\": 4, \"shift_id\": 4, \"is_active\": 1, \"starts_at\": \"20:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Night Shift B\", \"shift_type\": \"NIGHT\", \"updated_at\": \"2025-09-27T10:03:55.000Z\", \"employee_id\": \"EMP007\", \"porter_type\": \"REGULAR\", \"shift_offset\": 4, \"porter_offset\": 1, \"is_floor_staff\": 0, \"temp_service_id\": null, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\", \"temp_service_name\": null, \"temp_department_id\": null, \"temp_assignment_end\": null, \"temp_department_name\": null, \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": 1, \"temp_assignment_start\": null, \"regular_department_name\": \"ED - Emergency Department (A&E)\", \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": false, \"is_temporarily_assigned\": false, \"temp_assignment_location\": null}, {\"porter\": {\"id\": 8, \"name\": \"Stephen Scarsbrook\", \"email\": \"stephen.scarsbrook@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"08:00:00\", \"days_off\": 4, \"shift_id\": 4, \"is_active\": 1, \"starts_at\": \"20:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Night Shift B\", \"shift_type\": \"NIGHT\", \"updated_at\": \"2025-09-27T10:03:55.000Z\", \"employee_id\": \"EMP008\", \"porter_type\": \"REGULAR\", \"shift_offset\": 4, \"porter_offset\": 2, \"is_floor_staff\": 0, \"temp_service_id\": null, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\", \"temp_service_name\": null, \"temp_department_id\": null, \"temp_assignment_end\": null, \"temp_department_name\": null, \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": 3, \"temp_assignment_start\": null, \"regular_department_name\": \"CT Scan\", \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": true, \"is_temporarily_assigned\": false, \"temp_assignment_location\": null}]}]}','2025-09-27 10:34:39','2025-09-27 10:34:39','2025-09-27 10:34:39'),(2,'2025-09-28','{\"date\": \"2025-09-28\", \"services\": [{\"id\": 7, \"code\": \"ADHOC\", \"name\": \"Ad-Hoc Services\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 4, \"code\": \"BLOOD\", \"name\": \"Blood Drivers\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 6, \"code\": \"DIST\", \"name\": \"District Drivers\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 8, \"code\": \"WASTE\", \"name\": \"External Waste\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 9, \"code\": \"HELP\", \"name\": \"Helpdesk\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 5, \"code\": \"LAUND\", \"name\": \"Laundry\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 2, \"code\": \"MR\", \"name\": \"Medical Records\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 1, \"code\": \"POST\", \"name\": \"Post\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 3, \"code\": \"SHARPS\", \"name\": \"Sharps Collection\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}], \"frozen_at\": \"2025-09-28T06:58:59.179Z\", \"departments\": [{\"id\": 2, \"code\": \"AMU\", \"name\": \"Acute Medical Unit - Test Update\", \"is_24_7\": 1, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-27T06:53:50.000Z\", \"porters_required_day\": 4, \"porters_required_night\": 2}, {\"id\": 3, \"code\": \"CT\", \"name\": \"CT Scan\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 1, \"code\": \"ED\", \"name\": \"ED - Emergency Department (A&E)\", \"is_24_7\": 1, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-27T07:45:41.000Z\", \"porters_required_day\": 2, \"porters_required_night\": 2}, {\"id\": 6, \"code\": \"MRI\", \"name\": \"MRI\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 7, \"code\": \"PTS\", \"name\": \"Patient Transport Service\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 2, \"porters_required_night\": 1}, {\"id\": 8, \"code\": \"PHARM\", \"name\": \"Pharmacy\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 4, \"code\": \"XR-GF\", \"name\": \"X-ray (Ground Floor)\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 5, \"code\": \"XR-LGF\", \"name\": \"X-ray (Lower Ground Floor)\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}], \"active_shifts\": [{\"shift\": {\"id\": 2, \"name\": \"Day Shift B\", \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-09-26T19:09:38.000Z\", \"shift_type\": \"DAY\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"shift_offset\": 4, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\"}, \"is_active_today\": true, \"assigned_porters\": [{\"porter\": {\"id\": 3, \"name\": \"Charlotte Rimmer\", \"email\": \"charlotte.rimmer@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"shift_id\": 2, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Day Shift B\", \"shift_type\": \"DAY\", \"updated_at\": \"2025-09-27T10:03:55.000Z\", \"employee_id\": \"EMP003\", \"porter_type\": \"REGULAR\", \"shift_offset\": 4, \"porter_offset\": 2, \"is_floor_staff\": 0, \"temp_service_id\": 1, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\", \"temp_service_name\": \"Post\", \"regular_service_id\": null, \"temp_department_id\": null, \"temp_assignment_end\": \"2025-09-30T00:00:00.000Z\", \"temp_department_name\": null, \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": 2, \"temp_assignment_start\": \"2025-09-28T00:00:00.000Z\", \"regular_department_name\": \"Acute Medical Unit - Test Update\", \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": false, \"is_temporarily_assigned\": true, \"temp_assignment_location\": \"Post\"}, {\"porter\": {\"id\": 4, \"name\": \"Carla Barton\", \"email\": \"carla.barton@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"shift_id\": 2, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Day Shift B\", \"shift_type\": \"DAY\", \"updated_at\": \"2025-09-27T10:03:55.000Z\", \"employee_id\": \"EMP004\", \"porter_type\": \"REGULAR\", \"shift_offset\": 4, \"porter_offset\": 1, \"is_floor_staff\": 0, \"temp_service_id\": null, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\", \"temp_service_name\": null, \"regular_service_id\": null, \"temp_department_id\": null, \"temp_assignment_end\": null, \"temp_department_name\": null, \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": 3, \"temp_assignment_start\": null, \"regular_department_name\": \"CT Scan\", \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": false, \"is_temporarily_assigned\": false, \"temp_assignment_location\": null}, {\"porter\": {\"id\": 25, \"name\": \"Nicola Benger\", \"email\": \"nicola.benger@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"shift_id\": 2, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Day Shift B\", \"shift_type\": \"DAY\", \"updated_at\": \"2025-09-26T19:09:47.000Z\", \"employee_id\": \"EMP025\", \"porter_type\": \"REGULAR\", \"shift_offset\": 4, \"porter_offset\": 0, \"is_floor_staff\": 0, \"temp_service_id\": null, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\", \"temp_service_name\": null, \"regular_service_id\": null, \"temp_department_id\": null, \"temp_assignment_end\": null, \"temp_department_name\": null, \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": 8, \"temp_assignment_start\": null, \"regular_department_name\": \"Pharmacy\", \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": false, \"is_temporarily_assigned\": false, \"temp_assignment_location\": null}, {\"porter\": {\"id\": 42, \"name\": \"AJ\", \"email\": \"aj@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"shift_id\": 2, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Day Shift B\", \"shift_type\": \"DAY\", \"updated_at\": \"2025-09-27T15:11:06.000Z\", \"employee_id\": \"EMP042\", \"porter_type\": \"REGULAR\", \"shift_offset\": 4, \"porter_offset\": 0, \"is_floor_staff\": 1, \"temp_service_id\": null, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\", \"temp_service_name\": null, \"regular_service_id\": null, \"temp_department_id\": 6, \"temp_assignment_end\": \"2025-09-29T00:00:00.000Z\", \"temp_department_name\": \"MRI\", \"contracted_hours_type\": \"RELIEF\", \"regular_department_id\": null, \"temp_assignment_start\": \"2025-09-28T00:00:00.000Z\", \"regular_department_name\": null, \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": false, \"is_temporarily_assigned\": true, \"temp_assignment_location\": \"MRI\"}]}, {\"shift\": {\"id\": 4, \"name\": \"Night Shift B\", \"days_on\": 4, \"ends_at\": \"08:00:00\", \"days_off\": 4, \"is_active\": 1, \"starts_at\": \"20:00:00\", \"created_at\": \"2025-09-26T19:09:38.000Z\", \"shift_type\": \"NIGHT\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"shift_offset\": 4, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\"}, \"is_active_today\": true, \"assigned_porters\": [{\"porter\": {\"id\": 7, \"name\": \"Matthew Bennett\", \"email\": \"matthew.bennett@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"08:00:00\", \"days_off\": 4, \"shift_id\": 4, \"is_active\": 1, \"starts_at\": \"20:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Night Shift B\", \"shift_type\": \"NIGHT\", \"updated_at\": \"2025-09-27T10:03:55.000Z\", \"employee_id\": \"EMP007\", \"porter_type\": \"REGULAR\", \"shift_offset\": 4, \"porter_offset\": 1, \"is_floor_staff\": 0, \"temp_service_id\": null, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\", \"temp_service_name\": null, \"regular_service_id\": null, \"temp_department_id\": null, \"temp_assignment_end\": null, \"temp_department_name\": null, \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": 1, \"temp_assignment_start\": null, \"regular_department_name\": \"ED - Emergency Department (A&E)\", \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": false, \"is_temporarily_assigned\": false, \"temp_assignment_location\": null}, {\"porter\": {\"id\": 8, \"name\": \"Stephen Scarsbrook\", \"email\": \"stephen.scarsbrook@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"08:00:00\", \"days_off\": 4, \"shift_id\": 4, \"is_active\": 1, \"starts_at\": \"20:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Night Shift B\", \"shift_type\": \"NIGHT\", \"updated_at\": \"2025-09-27T10:03:55.000Z\", \"employee_id\": \"EMP008\", \"porter_type\": \"REGULAR\", \"shift_offset\": 4, \"porter_offset\": 2, \"is_floor_staff\": 0, \"temp_service_id\": null, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\", \"temp_service_name\": null, \"regular_service_id\": null, \"temp_department_id\": null, \"temp_assignment_end\": null, \"temp_department_name\": null, \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": 3, \"temp_assignment_start\": null, \"regular_department_name\": \"CT Scan\", \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": false, \"is_temporarily_assigned\": false, \"temp_assignment_location\": null}]}]}','2025-09-28 06:58:59','2025-09-28 06:58:59','2025-09-28 06:58:59'),(7,'2025-09-29','{\"date\": \"2025-09-29\", \"services\": [{\"id\": 7, \"code\": \"ADHOC\", \"name\": \"Ad-Hoc Services\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 4, \"code\": \"BLOOD\", \"name\": \"Blood Drivers\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 6, \"code\": \"DIST\", \"name\": \"District Drivers\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 8, \"code\": \"WASTE\", \"name\": \"External Waste\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 9, \"code\": \"HELP\", \"name\": \"Helpdesk\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 5, \"code\": \"LAUND\", \"name\": \"Laundry\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 2, \"code\": \"MR\", \"name\": \"Medical Records\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 1, \"code\": \"POST\", \"name\": \"Post\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 3, \"code\": \"SHARPS\", \"name\": \"Sharps Collection\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}], \"frozen_at\": \"2025-09-29T06:58:58.441Z\", \"departments\": [{\"id\": 2, \"code\": \"AMU\", \"name\": \"Acute Medical Unit - Test Update\", \"is_24_7\": 1, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-27T06:53:50.000Z\", \"porters_required_day\": 4, \"porters_required_night\": 2}, {\"id\": 3, \"code\": \"CT\", \"name\": \"CT Scan\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 1, \"code\": \"ED\", \"name\": \"ED - Emergency Department (A&E)\", \"is_24_7\": 1, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-27T07:45:41.000Z\", \"porters_required_day\": 2, \"porters_required_night\": 2}, {\"id\": 6, \"code\": \"MRI\", \"name\": \"MRI\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 7, \"code\": \"PTS\", \"name\": \"Patient Transport Service\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 2, \"porters_required_night\": 1}, {\"id\": 8, \"code\": \"PHARM\", \"name\": \"Pharmacy\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 4, \"code\": \"XR-GF\", \"name\": \"X-ray (Ground Floor)\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 5, \"code\": \"XR-LGF\", \"name\": \"X-ray (Lower Ground Floor)\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}], \"active_shifts\": [{\"shift\": {\"id\": 2, \"name\": \"Day Shift B\", \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-09-26T19:09:38.000Z\", \"shift_type\": \"DAY\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"shift_offset\": 4, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\"}, \"is_active_today\": true, \"assigned_porters\": [{\"porter\": {\"id\": 3, \"name\": \"Charlotte Rimmer\", \"email\": \"charlotte.rimmer@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"shift_id\": 2, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Day Shift B\", \"shift_type\": \"DAY\", \"updated_at\": \"2025-09-27T10:03:55.000Z\", \"employee_id\": \"EMP003\", \"porter_type\": \"REGULAR\", \"shift_offset\": 4, \"porter_offset\": 2, \"is_floor_staff\": 0, \"temp_service_id\": 1, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\", \"temp_service_name\": \"Post\", \"regular_service_id\": null, \"temp_department_id\": null, \"temp_assignment_end\": \"2025-09-30T00:00:00.000Z\", \"temp_department_name\": null, \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": 2, \"temp_assignment_start\": \"2025-09-28T00:00:00.000Z\", \"regular_department_name\": \"Acute Medical Unit - Test Update\", \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": false, \"is_temporarily_assigned\": true, \"temp_assignment_location\": \"Post\"}, {\"porter\": {\"id\": 4, \"name\": \"Carla Barton\", \"email\": \"carla.barton@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"shift_id\": 2, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Day Shift B\", \"shift_type\": \"DAY\", \"updated_at\": \"2025-09-27T10:03:55.000Z\", \"employee_id\": \"EMP004\", \"porter_type\": \"REGULAR\", \"shift_offset\": 4, \"porter_offset\": 1, \"is_floor_staff\": 0, \"temp_service_id\": null, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\", \"temp_service_name\": null, \"regular_service_id\": null, \"temp_department_id\": null, \"temp_assignment_end\": null, \"temp_department_name\": null, \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": 3, \"temp_assignment_start\": null, \"regular_department_name\": \"CT Scan\", \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": false, \"is_temporarily_assigned\": false, \"temp_assignment_location\": null}, {\"porter\": {\"id\": 25, \"name\": \"Nicola Benger\", \"email\": \"nicola.benger@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"shift_id\": 2, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Day Shift B\", \"shift_type\": \"DAY\", \"updated_at\": \"2025-09-26T19:09:47.000Z\", \"employee_id\": \"EMP025\", \"porter_type\": \"REGULAR\", \"shift_offset\": 4, \"porter_offset\": 0, \"is_floor_staff\": 0, \"temp_service_id\": null, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\", \"temp_service_name\": null, \"regular_service_id\": null, \"temp_department_id\": null, \"temp_assignment_end\": null, \"temp_department_name\": null, \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": 8, \"temp_assignment_start\": null, \"regular_department_name\": \"Pharmacy\", \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": false, \"is_temporarily_assigned\": false, \"temp_assignment_location\": null}, {\"porter\": {\"id\": 42, \"name\": \"AJ\", \"email\": \"aj@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"shift_id\": 2, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Day Shift B\", \"shift_type\": \"DAY\", \"updated_at\": \"2025-09-27T15:11:06.000Z\", \"employee_id\": \"EMP042\", \"porter_type\": \"REGULAR\", \"shift_offset\": 4, \"porter_offset\": 0, \"is_floor_staff\": 1, \"temp_service_id\": null, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\", \"temp_service_name\": null, \"regular_service_id\": null, \"temp_department_id\": 6, \"temp_assignment_end\": \"2025-09-29T00:00:00.000Z\", \"temp_department_name\": \"MRI\", \"contracted_hours_type\": \"RELIEF\", \"regular_department_id\": null, \"temp_assignment_start\": \"2025-09-28T00:00:00.000Z\", \"regular_department_name\": null, \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": false, \"is_temporarily_assigned\": true, \"temp_assignment_location\": \"MRI\"}]}, {\"shift\": {\"id\": 4, \"name\": \"Night Shift B\", \"days_on\": 4, \"ends_at\": \"08:00:00\", \"days_off\": 4, \"is_active\": 1, \"starts_at\": \"20:00:00\", \"created_at\": \"2025-09-26T19:09:38.000Z\", \"shift_type\": \"NIGHT\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"shift_offset\": 4, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\"}, \"is_active_today\": true, \"assigned_porters\": [{\"porter\": {\"id\": 7, \"name\": \"Matthew Bennett\", \"email\": \"matthew.bennett@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"08:00:00\", \"days_off\": 4, \"shift_id\": 4, \"is_active\": 1, \"starts_at\": \"20:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Night Shift B\", \"shift_type\": \"NIGHT\", \"updated_at\": \"2025-09-27T10:03:55.000Z\", \"employee_id\": \"EMP007\", \"porter_type\": \"REGULAR\", \"shift_offset\": 4, \"porter_offset\": 1, \"is_floor_staff\": 0, \"temp_service_id\": null, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\", \"temp_service_name\": null, \"regular_service_id\": null, \"temp_department_id\": null, \"temp_assignment_end\": null, \"temp_department_name\": null, \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": 1, \"temp_assignment_start\": null, \"regular_department_name\": \"ED - Emergency Department (A&E)\", \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": false, \"is_temporarily_assigned\": false, \"temp_assignment_location\": null}, {\"porter\": {\"id\": 8, \"name\": \"Stephen Scarsbrook\", \"email\": \"stephen.scarsbrook@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"08:00:00\", \"days_off\": 4, \"shift_id\": 4, \"is_active\": 1, \"starts_at\": \"20:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Night Shift B\", \"shift_type\": \"NIGHT\", \"updated_at\": \"2025-09-27T10:03:55.000Z\", \"employee_id\": \"EMP008\", \"porter_type\": \"REGULAR\", \"shift_offset\": 4, \"porter_offset\": 2, \"is_floor_staff\": 0, \"temp_service_id\": null, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"shift_identifier\": \"B\", \"temp_service_name\": null, \"regular_service_id\": null, \"temp_department_id\": null, \"temp_assignment_end\": null, \"temp_department_name\": null, \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": 3, \"temp_assignment_start\": null, \"regular_department_name\": \"CT Scan\", \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": false, \"is_temporarily_assigned\": false, \"temp_assignment_location\": null}]}]}','2025-09-29 06:58:58','2025-09-29 06:58:58','2025-09-29 06:58:58'),(12,'2025-10-03','{\"date\": \"2025-10-03\", \"services\": [{\"id\": 7, \"code\": \"ADHOC\", \"name\": \"Ad-Hoc Services\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 4, \"code\": \"BLOOD\", \"name\": \"Blood Drivers\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 6, \"code\": \"DIST\", \"name\": \"District Drivers\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 8, \"code\": \"WASTE\", \"name\": \"External Waste\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 9, \"code\": \"HELP\", \"name\": \"Helpdesk\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 5, \"code\": \"LAUND\", \"name\": \"Laundry\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 2, \"code\": \"MR\", \"name\": \"Medical Records\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 1, \"code\": \"POST\", \"name\": \"Post\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 3, \"code\": \"SHARPS\", \"name\": \"Sharps Collection\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}], \"frozen_at\": \"2025-10-03T06:58:59.214Z\", \"departments\": [{\"id\": 2, \"code\": \"AMU\", \"name\": \"Acute Medical Unit\", \"is_24_7\": 1, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-10-02T14:04:57.000Z\", \"porters_required_day\": 4, \"porters_required_night\": 2}, {\"id\": 3, \"code\": \"CT\", \"name\": \"CT Scan\", \"is_24_7\": 1, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-10-02T13:55:04.000Z\", \"porters_required_day\": 2, \"porters_required_night\": 1}, {\"id\": 1, \"code\": \"ED\", \"name\": \"ED - Emergency Department (A&E)\", \"is_24_7\": 1, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-27T07:45:41.000Z\", \"porters_required_day\": 2, \"porters_required_night\": 2}, {\"id\": 19, \"code\": \"FLOOR\", \"name\": \"Floor\", \"is_24_7\": 1, \"is_active\": 1, \"created_at\": \"2025-10-02T15:01:14.000Z\", \"updated_at\": \"2025-10-02T15:01:14.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 25, \"code\": \"FLOORTWO\", \"name\": \"Floor Two\", \"is_24_7\": 1, \"is_active\": 1, \"created_at\": \"2025-10-02T15:09:56.000Z\", \"updated_at\": \"2025-10-02T15:09:56.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 6, \"code\": \"MRI\", \"name\": \"MRI\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 7, \"code\": \"PTS\", \"name\": \"Patient Transport Service\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 2, \"porters_required_night\": 1}, {\"id\": 8, \"code\": \"PHARM\", \"name\": \"Pharmacy\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 4, \"code\": \"XR-GF\", \"name\": \"X-ray (Ground Floor)\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}, {\"id\": 5, \"code\": \"XR-LGF\", \"name\": \"X-ray (Lower Ground Floor)\", \"is_24_7\": 0, \"is_active\": 1, \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-09-26T19:09:38.000Z\", \"porters_required_day\": 1, \"porters_required_night\": 1}], \"active_shifts\": [{\"shift\": {\"id\": 1, \"name\": \"Day Shift A\", \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-10-02T10:29:00.000Z\", \"shift_offset\": 0, \"shift_type_id\": 1, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\"}, \"is_active_today\": true, \"assigned_porters\": [{\"porter\": {\"id\": 1, \"name\": \"Rob Mcpartland\", \"color\": \"#8be3e9\", \"email\": \"rob.mcpartland@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"shift_id\": 1, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Day Shift A\", \"updated_at\": \"2025-09-27T10:03:55.000Z\", \"employee_id\": \"EMP001\", \"porter_type\": \"REGULAR\", \"display_type\": \"DAY\", \"shift_offset\": 0, \"porter_offset\": 0, \"shift_type_id\": 1, \"is_floor_staff\": 1, \"shift_type_name\": \"Day Shift\", \"temp_service_id\": null, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"temp_service_name\": null, \"regular_service_id\": null, \"temp_department_id\": 8, \"temp_assignment_end\": \"2025-10-05T00:00:00.000Z\", \"temp_department_name\": \"Pharmacy\", \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": 1, \"temp_assignment_start\": \"2025-09-29T00:00:00.000Z\", \"regular_department_name\": \"ED - Emergency Department (A&E)\", \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": true, \"is_temporarily_assigned\": true, \"temp_assignment_location\": \"Pharmacy\"}, {\"porter\": {\"id\": 2, \"name\": \"John Evans\", \"color\": \"#8be3e9\", \"email\": \"john.evans@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"shift_id\": 1, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Day Shift A\", \"updated_at\": \"2025-09-26T19:09:47.000Z\", \"employee_id\": \"EMP002\", \"porter_type\": \"REGULAR\", \"display_type\": \"DAY\", \"shift_offset\": 0, \"porter_offset\": 0, \"shift_type_id\": 1, \"is_floor_staff\": 0, \"shift_type_name\": \"Day Shift\", \"temp_service_id\": null, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"temp_service_name\": null, \"regular_service_id\": null, \"temp_department_id\": null, \"temp_assignment_end\": null, \"temp_department_name\": null, \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": 1, \"temp_assignment_start\": null, \"regular_department_name\": \"ED - Emergency Department (A&E)\", \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": true, \"is_temporarily_assigned\": false, \"temp_assignment_location\": null}, {\"porter\": {\"id\": 19, \"name\": \"Alan Kelly\", \"color\": \"#8be3e9\", \"email\": \"alan.kelly@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"shift_id\": 1, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Day Shift A\", \"updated_at\": \"2025-09-27T15:29:57.000Z\", \"employee_id\": \"EMP019\", \"porter_type\": \"REGULAR\", \"display_type\": \"DAY\", \"shift_offset\": 0, \"porter_offset\": 0, \"shift_type_id\": 1, \"is_floor_staff\": 1, \"shift_type_name\": \"Day Shift\", \"temp_service_id\": null, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"temp_service_name\": null, \"regular_service_id\": null, \"temp_department_id\": 1, \"temp_assignment_end\": \"2025-09-29T00:00:00.000Z\", \"temp_department_name\": \"ED - Emergency Department (A&E)\", \"contracted_hours_type\": \"RELIEF\", \"regular_department_id\": null, \"temp_assignment_start\": \"2025-09-28T00:00:00.000Z\", \"regular_department_name\": null, \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": true, \"is_temporarily_assigned\": false, \"temp_assignment_location\": null}, {\"porter\": {\"id\": 24, \"name\": \"Lee Stafford\", \"color\": \"#8be3e9\", \"email\": \"lee.stafford@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"shift_id\": 1, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Day Shift A\", \"updated_at\": \"2025-09-27T10:03:55.000Z\", \"employee_id\": \"EMP024\", \"porter_type\": \"REGULAR\", \"display_type\": \"DAY\", \"shift_offset\": 0, \"porter_offset\": 1, \"shift_type_id\": 1, \"is_floor_staff\": 0, \"shift_type_name\": \"Day Shift\", \"temp_service_id\": null, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"temp_service_name\": null, \"regular_service_id\": null, \"temp_department_id\": null, \"temp_assignment_end\": null, \"temp_department_name\": null, \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": 7, \"temp_assignment_start\": null, \"regular_department_name\": \"Patient Transport Service\", \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": true, \"is_temporarily_assigned\": false, \"temp_assignment_location\": null}]}, {\"shift\": {\"id\": 3, \"name\": \"Night Shift A\", \"days_on\": 4, \"ends_at\": \"08:00:00\", \"days_off\": 4, \"is_active\": 1, \"starts_at\": \"20:00:00\", \"created_at\": \"2025-09-26T19:09:38.000Z\", \"updated_at\": \"2025-10-02T13:23:49.000Z\", \"shift_offset\": 0, \"shift_type_id\": 4, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\"}, \"is_active_today\": true, \"assigned_porters\": [{\"porter\": {\"id\": 6, \"name\": \"Stephen Bowater\", \"color\": \"#673AB7\", \"email\": \"stephen.bowater@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"08:00:00\", \"days_off\": 4, \"shift_id\": 3, \"is_active\": 1, \"starts_at\": \"20:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Night Shift A\", \"updated_at\": \"2025-09-26T19:09:47.000Z\", \"employee_id\": \"EMP006\", \"porter_type\": \"REGULAR\", \"display_type\": \"NIGHT\", \"shift_offset\": 0, \"porter_offset\": 0, \"shift_type_id\": 4, \"is_floor_staff\": 0, \"shift_type_name\": \"Night Shift\", \"temp_service_id\": null, \"ground_zero_date\": \"2025-01-01T00:00:00.000Z\", \"temp_service_name\": null, \"regular_service_id\": null, \"temp_department_id\": null, \"temp_assignment_end\": null, \"temp_department_name\": null, \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": 2, \"temp_assignment_start\": null, \"regular_department_name\": \"Acute Medical Unit\", \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": true, \"is_temporarily_assigned\": false, \"temp_assignment_location\": null}]}, {\"shift\": {\"id\": 8, \"name\": \"PTS 8-8\", \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-10-02T11:07:13.000Z\", \"updated_at\": \"2025-10-02T11:07:13.000Z\", \"shift_offset\": 0, \"shift_type_id\": 1, \"ground_zero_date\": \"2025-10-02T00:00:00.000Z\"}, \"is_active_today\": true, \"assigned_porters\": [{\"porter\": {\"id\": 28, \"name\": \"Colin Bromley\", \"color\": \"#8be3e9\", \"email\": \"colin.bromley@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"20:00:00\", \"days_off\": 4, \"shift_id\": 8, \"is_active\": 1, \"starts_at\": \"08:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"PTS 8-8\", \"updated_at\": \"2025-10-02T11:31:50.000Z\", \"employee_id\": \"EMP028\", \"porter_type\": \"REGULAR\", \"display_type\": \"DAY\", \"shift_offset\": 0, \"porter_offset\": 0, \"shift_type_id\": 1, \"is_floor_staff\": 1, \"shift_type_name\": \"Day Shift\", \"temp_service_id\": null, \"ground_zero_date\": \"2025-10-02T00:00:00.000Z\", \"temp_service_name\": null, \"regular_service_id\": null, \"temp_department_id\": null, \"temp_assignment_end\": null, \"temp_department_name\": null, \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": 7, \"temp_assignment_start\": null, \"regular_department_name\": \"Patient Transport Service\", \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": true, \"is_temporarily_assigned\": false, \"temp_assignment_location\": null}]}, {\"shift\": {\"id\": 9, \"name\": \"PTS 12-8\", \"days_on\": 5, \"ends_at\": \"20:00:00\", \"days_off\": 2, \"is_active\": 1, \"starts_at\": \"12:00:00\", \"created_at\": \"2025-10-02T11:07:56.000Z\", \"updated_at\": \"2025-10-02T13:24:44.000Z\", \"shift_offset\": 0, \"shift_type_id\": 1, \"ground_zero_date\": \"2025-10-01T00:00:00.000Z\"}, \"is_active_today\": true, \"assigned_porters\": []}, {\"shift\": {\"id\": 10, \"name\": \"PTS 1-1\", \"days_on\": 4, \"ends_at\": \"01:00:00\", \"days_off\": 4, \"is_active\": 1, \"starts_at\": \"13:00:00\", \"created_at\": \"2025-10-02T11:08:29.000Z\", \"updated_at\": \"2025-10-02T13:24:19.000Z\", \"shift_offset\": 0, \"shift_type_id\": 5, \"ground_zero_date\": \"2025-10-01T00:00:00.000Z\"}, \"is_active_today\": true, \"assigned_porters\": []}, {\"shift\": {\"id\": 11, \"name\": \"Day Shift 10-10\", \"days_on\": 4, \"ends_at\": \"22:00:00\", \"days_off\": 4, \"is_active\": 1, \"starts_at\": \"10:00:00\", \"created_at\": \"2025-10-02T11:17:32.000Z\", \"updated_at\": \"2025-10-02T11:17:32.000Z\", \"shift_offset\": 0, \"shift_type_id\": 1, \"ground_zero_date\": \"2025-10-02T00:00:00.000Z\"}, \"is_active_today\": true, \"assigned_porters\": [{\"porter\": {\"id\": 5, \"name\": \"Andrew Trudgeon\", \"color\": \"#8be3e9\", \"email\": \"andrew.trudgeon@hospital.nhs.uk\", \"phone\": null, \"days_on\": 4, \"ends_at\": \"22:00:00\", \"days_off\": 4, \"shift_id\": 11, \"is_active\": 1, \"starts_at\": \"10:00:00\", \"created_at\": \"2025-09-26T19:09:47.000Z\", \"shift_name\": \"Day Shift 10-10\", \"updated_at\": \"2025-10-02T11:18:06.000Z\", \"employee_id\": \"EMP005\", \"porter_type\": \"REGULAR\", \"display_type\": \"DAY\", \"shift_offset\": 0, \"porter_offset\": 3, \"shift_type_id\": 1, \"is_floor_staff\": 0, \"shift_type_name\": \"Day Shift\", \"temp_service_id\": null, \"ground_zero_date\": \"2025-10-02T00:00:00.000Z\", \"temp_service_name\": null, \"regular_service_id\": null, \"temp_department_id\": null, \"temp_assignment_end\": null, \"temp_department_name\": null, \"contracted_hours_type\": \"SHIFT\", \"regular_department_id\": null, \"temp_assignment_start\": null, \"regular_department_name\": null, \"weekly_contracted_hours\": \"37.50\"}, \"is_active_today\": false, \"is_temporarily_assigned\": false, \"temp_assignment_location\": null}]}, {\"shift\": {\"id\": 12, \"name\": \"Weekdays\", \"days_on\": 5, \"ends_at\": \"18:00:00\", \"days_off\": 2, \"is_active\": 1, \"starts_at\": \"07:00:00\", \"created_at\": \"2025-10-02T13:20:48.000Z\", \"updated_at\": \"2025-10-02T13:24:35.000Z\", \"shift_offset\": 0, \"shift_type_id\": 1, \"ground_zero_date\": \"2025-10-01T00:00:00.000Z\"}, \"is_active_today\": true, \"assigned_porters\": []}]}','2025-10-03 06:58:59','2025-10-03 06:58:59','2025-10-03 06:58:59');
/*!40000 ALTER TABLE `frozen_schedules` ENABLE KEYS */;
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
-- Table structure for table `porter_hours`
--

DROP TABLE IF EXISTS `porter_hours`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `porter_hours` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `porter_id` int unsigned NOT NULL,
  `day_of_week` tinyint unsigned NOT NULL COMMENT '0=Sunday, 1=Monday, ..., 6=Saturday',
  `starts_at` time NOT NULL,
  `ends_at` time NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_porter_day` (`porter_id`,`day_of_week`),
  CONSTRAINT `porter_hours_ibfk_1` FOREIGN KEY (`porter_id`) REFERENCES `porters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `porter_hours`
--

LOCK TABLES `porter_hours` WRITE;
/*!40000 ALTER TABLE `porter_hours` DISABLE KEYS */;
INSERT INTO `porter_hours` VALUES (9,14,1,'14:00:00','22:00:00','2025-09-27 15:55:51','2025-09-27 15:55:51'),(10,14,2,'14:00:00','22:00:00','2025-09-27 15:55:51','2025-09-27 15:55:51'),(11,14,3,'14:00:00','22:00:00','2025-09-27 15:55:51','2025-09-27 15:55:51'),(13,28,1,'08:00:00','17:00:00','2025-10-02 11:09:48','2025-10-02 11:09:48');
/*!40000 ALTER TABLE `porter_hours` ENABLE KEYS */;
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
  `weekly_contracted_hours` decimal(4,2) NOT NULL DEFAULT '37.50',
  `has_custom_hours` tinyint(1) NOT NULL DEFAULT '0',
  `shift_id` int unsigned DEFAULT NULL,
  `porter_offset` tinyint unsigned DEFAULT '0',
  `regular_department_id` int unsigned DEFAULT NULL,
  `regular_service_id` int unsigned DEFAULT NULL,
  `temp_department_id` int unsigned DEFAULT NULL,
  `temp_service_id` int unsigned DEFAULT NULL,
  `temp_assignment_start` time DEFAULT NULL COMMENT 'Start time for temporary assignment within current shift',
  `temp_assignment_end` time DEFAULT NULL COMMENT 'End time for temporary assignment within current shift',
  `is_floor_staff` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `porter_type` enum('PORTER','SUPERVISOR','SENIOR_PORTER') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PORTER',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_porter_employee_id` (`employee_id`),
  UNIQUE KEY `uk_porter_email` (`email`),
  KEY `idx_porter_name` (`name`),
  KEY `idx_porter_active` (`is_active`),
  KEY `idx_porter_shift` (`shift_id`),
  KEY `idx_porter_department` (`regular_department_id`),
  KEY `fk_porter_temp_dept` (`temp_department_id`),
  KEY `fk_porter_temp_service` (`temp_service_id`),
  KEY `fk_porter_regular_service` (`regular_service_id`),
  KEY `idx_porter_custom_hours` (`has_custom_hours`),
  CONSTRAINT `fk_porter_regular_service` FOREIGN KEY (`regular_service_id`) REFERENCES `services` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_porter_temp_dept` FOREIGN KEY (`temp_department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_porter_temp_service` FOREIGN KEY (`temp_service_id`) REFERENCES `services` (`id`) ON DELETE SET NULL,
  CONSTRAINT `porters_ibfk_1` FOREIGN KEY (`shift_id`) REFERENCES `shifts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `porters_ibfk_2` FOREIGN KEY (`regular_department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `chk_porter_email_format` CHECK (((`email` is null) or regexp_like(`email`,_utf8mb4'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'))),
  CONSTRAINT `chk_porter_hours` CHECK ((`weekly_contracted_hours` between 0.00 and 60.00)),
  CONSTRAINT `chk_porter_name_length` CHECK ((char_length(`name`) >= 2))
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `porters`
--

LOCK TABLES `porters` WRITE;
/*!40000 ALTER TABLE `porters` DISABLE KEYS */;
INSERT INTO `porters` VALUES (1,'EMP001','Rob Mcpartland','rob.mcpartland@hospital.nhs.uk',NULL,37.50,0,2,0,19,NULL,8,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 14:35:49','SUPERVISOR'),(2,'EMP002','John Evans','john.evans@hospital.nhs.uk',NULL,37.50,0,2,0,19,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(3,'EMP003','Charlotte Rimmer','charlotte.rimmer@hospital.nhs.uk',NULL,37.50,0,2,2,19,NULL,NULL,1,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-10-03 14:35:49','PORTER'),(4,'EMP004','Carla Barton','carla.barton@hospital.nhs.uk',NULL,37.50,0,2,1,19,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(5,'EMP005','Andrew Trudgeon','andrew.trudgeon@hospital.nhs.uk',NULL,37.50,0,11,3,19,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(6,'EMP006','Stephen Bowater','stephen.bowater@hospital.nhs.uk',NULL,37.50,0,10,0,7,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-10-03 14:12:53','PORTER'),(7,'EMP007','Matthew Bennett','matthew.bennett@hospital.nhs.uk',NULL,37.50,0,2,1,19,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(8,'EMP008','Stephen Scarsbrook','stephen.scarsbrook@hospital.nhs.uk',NULL,37.50,0,2,2,19,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(9,'EMP009','Jordon Fish','jordon.fish@hospital.nhs.uk',NULL,37.50,0,2,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(10,'EMP010','Steven Richardson','steven.richardson@hospital.nhs.uk',NULL,37.50,0,1,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(11,'EMP011','Chris Roach','chris.roach@hospital.nhs.uk',NULL,37.50,0,2,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(12,'EMP012','Simon Collins','simon.collins@hospital.nhs.uk',NULL,37.50,0,12,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(13,'EMP013','Mark Walton','mark.walton@hospital.nhs.uk',NULL,37.50,0,12,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(14,'EMP014','Allen Butler','allen.butler@hospital.nhs.uk',NULL,32.00,1,1,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(15,'EMP015','Darren Flowers','darren.flowers@hospital.nhs.uk',NULL,37.50,0,3,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(16,'EMP016','Brian Cassidy','brian.cassidy@hospital.nhs.uk',NULL,37.50,0,3,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(17,'EMP017','Karen Blackett','karen.blackett@hospital.nhs.uk',NULL,37.50,0,3,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(18,'EMP018','James Mitchell','james.mitchell@hospital.nhs.uk',NULL,37.50,0,3,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(19,'EMP019','Alan Kelly','alan.kelly@hospital.nhs.uk',NULL,37.50,0,3,0,19,NULL,1,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 14:35:49','PORTER'),(20,'EMP020','Tomas Konkol','tomas.konkol@hospital.nhs.uk',NULL,37.50,0,3,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(21,'EMP021','Kyle Blackshaw','kyle.blackshaw@hospital.nhs.uk',NULL,20.00,1,12,0,19,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(22,'EMP022','David Sykes','david.sykes@hospital.nhs.uk',NULL,25.00,1,3,0,19,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(23,'EMP023','Stuart Ford','stuart.ford@hospital.nhs.uk',NULL,30.00,1,12,0,1,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-10-03 13:57:45','PORTER'),(24,'EMP024','Lee Stafford','lee.stafford@hospital.nhs.uk',NULL,37.50,0,12,1,1,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-10-03 13:57:45','SENIOR_PORTER'),(25,'EMP025','Nicola Benger','nicola.benger@hospital.nhs.uk',NULL,37.50,0,12,0,1,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-10-03 13:57:45','SENIOR_PORTER'),(26,'EMP026','Jeff Robinson','jeff.robinson@hospital.nhs.uk',NULL,37.50,0,12,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(27,'EMP027','Dean Pickering','dean.pickering@hospital.nhs.uk',NULL,37.50,0,12,0,6,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:57:45','PORTER'),(28,'EMP028','Colin Bromley','colin.bromley@hospital.nhs.uk',NULL,37.50,0,8,0,7,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:57:45','PORTER'),(29,'EMP029','Gary Booth','gary.booth@hospital.nhs.uk',NULL,37.50,0,8,0,7,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:57:45','PORTER'),(30,'EMP030','Ian Moss','ian.moss@hospital.nhs.uk',NULL,37.50,0,10,0,7,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:57:45','PORTER'),(31,'EMP031','Paul Fisher','paul.fisher@hospital.nhs.uk',NULL,37.50,0,8,0,7,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:57:45','PORTER'),(32,'EMP032','Stephen Kirk','stephen.kirk@hospital.nhs.uk',NULL,37.50,0,3,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(33,'EMP033','Ian Speakes','ian.speakes@hospital.nhs.uk',NULL,37.50,0,12,0,NULL,6,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:57:45','PORTER'),(34,'EMP034','Stuart Lomas','stuart.lomas@hospital.nhs.uk',NULL,37.50,0,12,0,8,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:57:45','PORTER'),(35,'EMP035','Stephen Cooper','stephen.cooper@hospital.nhs.uk',NULL,37.50,0,1,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(36,'EMP036','Darren Milhench','darren.milhench@hospital.nhs.uk',NULL,37.50,0,1,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(37,'EMP037','Darren Mycroft','darren.mycroft@hospital.nhs.uk',NULL,37.50,0,1,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(38,'EMP038','Kevin Gaskell','kevin.gaskell@hospital.nhs.uk',NULL,37.50,0,11,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(39,'EMP039','Merv Permalloo','merv.permalloo@hospital.nhs.uk',NULL,37.50,0,1,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(40,'EMP040','Regan Stringer','regan.stringer@hospital.nhs.uk',NULL,37.50,0,1,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(41,'EMP041','Matthew Cope','matthew.cope@hospital.nhs.uk',NULL,37.50,0,1,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(42,'EMP042','AJ','aj@hospital.nhs.uk',NULL,37.50,0,1,0,19,NULL,6,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 14:35:49','PORTER'),(43,'EMP043','Michael Shaw','michael.shaw@hospital.nhs.uk',NULL,37.50,0,1,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(44,'EMP044','James Bennett','james.bennett@hospital.nhs.uk',NULL,37.50,0,12,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(45,'EMP045','Martin Hobson','martin.hobson@hospital.nhs.uk',NULL,37.50,0,4,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(46,'EMP046','Martin Kenyon','martin.kenyon@hospital.nhs.uk',NULL,37.50,0,4,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(47,'EMP047','Scott Cartledge','scott.cartledge@hospital.nhs.uk',NULL,37.50,0,4,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(48,'EMP048','Tony Batters','tony.batters@hospital.nhs.uk',NULL,37.50,0,4,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(49,'EMP049','Lewis Yearsley','lewis.yearsley@hospital.nhs.uk',NULL,37.50,0,4,0,19,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:58:33','PORTER'),(50,'EMP050','Mark Lloyd','mark.lloyd@hospital.nhs.uk',NULL,37.50,0,12,0,4,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-03 13:57:45','PORTER'),(51,NULL,'Updated Test Porter','updated@example.com',NULL,30.00,1,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2025-09-27 08:08:45','2025-10-03 09:58:55','PORTER'),(52,NULL,'Test Porter Clean','test@example.com',NULL,37.50,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2025-09-27 08:30:12','2025-10-03 09:58:55','PORTER'),(53,NULL,'Test Porter','test@hospital.nhs.uk',NULL,37.50,0,1,2,1,1,NULL,NULL,NULL,NULL,0,0,'2025-09-27 15:24:08','2025-10-03 09:58:55','PORTER'),(56,NULL,'Alan Clark',NULL,NULL,37.50,0,8,0,7,NULL,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(57,NULL,'Andrew Gibson',NULL,NULL,37.50,0,12,0,NULL,4,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(58,NULL,'Andrew Hassall',NULL,NULL,37.50,0,10,0,7,NULL,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(59,NULL,'Andy Clayton',NULL,NULL,37.50,0,12,0,19,NULL,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:58:33','PORTER'),(60,NULL,'Chris Huckaby',NULL,NULL,37.50,0,12,0,NULL,7,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(61,NULL,'Chris Wardle',NULL,NULL,37.50,0,12,0,NULL,2,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(62,NULL,'Craig Butler',NULL,NULL,37.50,0,2,0,NULL,NULL,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(63,NULL,'Duane Kulikowski',NULL,NULL,37.50,0,13,0,5,NULL,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(64,NULL,'Edward Collier',NULL,NULL,37.50,0,12,0,3,NULL,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(65,NULL,'Eloisa Andrew',NULL,NULL,37.50,0,12,0,NULL,1,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(66,NULL,'Gary Bromley',NULL,NULL,37.50,0,12,0,NULL,1,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(67,NULL,'Gavin Marsden',NULL,NULL,37.50,0,8,0,7,NULL,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(68,NULL,'Jake Moran',NULL,NULL,37.50,0,12,0,19,NULL,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:58:33','PORTER'),(69,NULL,'Jason Newton',NULL,NULL,37.50,0,12,0,NULL,4,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(70,NULL,'Joe Redfearn',NULL,NULL,37.50,0,3,0,19,NULL,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:58:33','PORTER'),(71,NULL,'Julie Greenough',NULL,NULL,37.50,0,12,0,3,NULL,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(72,NULL,'Kevin Tomlinson',NULL,NULL,37.50,0,12,0,19,NULL,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:58:33','PORTER'),(73,NULL,'Kyle Sanderson',NULL,NULL,37.50,0,12,0,19,NULL,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:58:33','PORTER'),(74,NULL,'Lucy Redfearn',NULL,NULL,37.50,0,2,0,19,NULL,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:58:33','PORTER'),(75,NULL,'Lynne Warner',NULL,NULL,37.50,0,9,0,7,NULL,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(76,NULL,'Mark Dickinson',NULL,NULL,37.50,0,12,0,NULL,6,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(77,NULL,'Mark Haughton',NULL,NULL,37.50,0,12,0,NULL,8,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(78,NULL,'Matthew Rushton',NULL,NULL,37.50,0,1,0,19,NULL,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:58:33','PORTER'),(79,NULL,'Mike Brennan',NULL,NULL,37.50,0,12,0,19,NULL,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:58:33','PORTER'),(80,NULL,'Nigel Beesley',NULL,NULL,37.50,0,12,0,NULL,4,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(81,NULL,'Paul Berry',NULL,NULL,37.50,0,12,0,NULL,4,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(82,NULL,'Paul Flowers',NULL,NULL,37.50,0,12,0,NULL,5,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(83,NULL,'Peter Moss',NULL,NULL,37.50,0,12,0,NULL,2,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(84,NULL,'Phil Hollinshead',NULL,NULL,37.50,0,12,0,5,NULL,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(85,NULL,'Robert Frost',NULL,NULL,37.50,0,12,0,NULL,4,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(86,NULL,'Roy Harris',NULL,NULL,37.50,0,9,0,7,NULL,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER'),(87,NULL,'Soloman Offei',NULL,NULL,37.50,0,NULL,0,19,NULL,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:58:33','PORTER'),(88,NULL,'Stepen Bowater',NULL,NULL,37.50,0,10,0,7,NULL,NULL,NULL,NULL,NULL,0,0,'2025-10-03 13:57:45','2025-10-03 14:12:31','PORTER'),(89,NULL,'Stephen Burke',NULL,NULL,37.50,0,12,0,4,NULL,NULL,NULL,NULL,NULL,0,1,'2025-10-03 13:57:45','2025-10-03 13:57:45','PORTER');
/*!40000 ALTER TABLE `porters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `porters_backup_20251002`
--

DROP TABLE IF EXISTS `porters_backup_20251002`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `porters_backup_20251002` (
  `id` int unsigned NOT NULL DEFAULT '0',
  `employee_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contracted_hours_type` enum('SHIFT','RELIEF','CUSTOM','PART_TIME') COLLATE utf8mb4_unicode_ci NOT NULL,
  `weekly_contracted_hours` decimal(4,2) NOT NULL DEFAULT '37.50',
  `shift_id` int unsigned DEFAULT NULL,
  `porter_offset` tinyint unsigned DEFAULT '0',
  `regular_department_id` int unsigned DEFAULT NULL,
  `regular_service_id` int unsigned DEFAULT NULL,
  `temp_department_id` int unsigned DEFAULT NULL,
  `temp_service_id` int unsigned DEFAULT NULL,
  `temp_assignment_start` date DEFAULT NULL,
  `temp_assignment_end` date DEFAULT NULL,
  `is_floor_staff` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `porter_type` enum('REGULAR','RELIEF') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'REGULAR'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `porters_backup_20251002`
--

LOCK TABLES `porters_backup_20251002` WRITE;
/*!40000 ALTER TABLE `porters_backup_20251002` DISABLE KEYS */;
INSERT INTO `porters_backup_20251002` VALUES (1,'EMP001','Rob Mcpartland','rob.mcpartland@hospital.nhs.uk',NULL,'SHIFT',37.50,1,0,1,NULL,8,NULL,'2025-09-29','2025-10-05',1,1,'2025-09-26 19:09:47','2025-09-27 10:03:55','REGULAR'),(2,'EMP002','John Evans','john.evans@hospital.nhs.uk',NULL,'SHIFT',37.50,1,0,1,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(3,'EMP003','Charlotte Rimmer','charlotte.rimmer@hospital.nhs.uk',NULL,'SHIFT',37.50,2,2,2,NULL,NULL,1,'2025-09-28','2025-09-30',0,1,'2025-09-26 19:09:47','2025-09-27 10:03:55','REGULAR'),(4,'EMP004','Carla Barton','carla.barton@hospital.nhs.uk',NULL,'SHIFT',37.50,2,1,3,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-09-27 10:03:55','REGULAR'),(5,'EMP005','Andrew Trudgeon','andrew.trudgeon@hospital.nhs.uk',NULL,'SHIFT',37.50,11,3,NULL,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-10-02 11:18:06','REGULAR'),(6,'EMP006','Stephen Bowater','stephen.bowater@hospital.nhs.uk',NULL,'SHIFT',37.50,3,0,2,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(7,'EMP007','Matthew Bennett','matthew.bennett@hospital.nhs.uk',NULL,'SHIFT',37.50,4,1,1,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-09-27 10:03:55','REGULAR'),(8,'EMP008','Stephen Scarsbrook','stephen.scarsbrook@hospital.nhs.uk',NULL,'SHIFT',37.50,4,2,3,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-09-27 10:03:55','REGULAR'),(9,'EMP009','Jordon Fish','jordon.fish@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(10,'EMP010','Steven Richardson','steven.richardson@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(11,'EMP011','Chris Roach','chris.roach@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(12,'EMP012','Simon Collins','simon.collins@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(13,'EMP013','Mark Walton','mark.walton@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(14,'EMP014','Allen Butler','allen.butler@hospital.nhs.uk',NULL,'CUSTOM',32.00,NULL,0,NULL,8,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-27 15:55:51','REGULAR'),(15,'EMP015','Darren Flowers','darren.flowers@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(16,'EMP016','Brian Cassidy','brian.cassidy@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(17,'EMP017','Karen Blackett','karen.blackett@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(18,'EMP018','James Mitchell','james.mitchell@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(19,'EMP019','Alan Kelly','alan.kelly@hospital.nhs.uk',NULL,'RELIEF',37.50,1,0,NULL,NULL,1,NULL,'2025-09-28','2025-09-29',1,1,'2025-09-26 19:09:47','2025-09-27 15:29:57','REGULAR'),(20,'EMP020','Tomas Konkol','tomas.konkol@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(21,'EMP021','Kyle Blackshaw','kyle.blackshaw@hospital.nhs.uk',NULL,'PART_TIME',20.00,NULL,0,4,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(22,'EMP022','David Sykes','david.sykes@hospital.nhs.uk',NULL,'PART_TIME',25.00,NULL,0,5,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(23,'EMP023','Stuart Ford','stuart.ford@hospital.nhs.uk',NULL,'PART_TIME',30.00,NULL,0,6,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(24,'EMP024','Lee Stafford','lee.stafford@hospital.nhs.uk',NULL,'SHIFT',37.50,1,1,7,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-09-27 10:03:55','REGULAR'),(25,'EMP025','Nicola Benger','nicola.benger@hospital.nhs.uk',NULL,'SHIFT',37.50,2,0,8,NULL,NULL,NULL,NULL,NULL,0,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(26,'EMP026','Jeff Robinson','jeff.robinson@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(27,'EMP027','Dean Pickering','dean.pickering@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(28,'EMP028','Colin Bromley','colin.bromley@hospital.nhs.uk',NULL,'SHIFT',37.50,8,0,7,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-10-02 11:31:50','REGULAR'),(29,'EMP029','Gary Booth','gary.booth@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(30,'EMP030','Ian Moss','ian.moss@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(31,'EMP031','Paul Fisher','paul.fisher@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(32,'EMP032','Stephen Kirk','stephen.kirk@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(33,'EMP033','Ian Speakes','ian.speakes@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(34,'EMP034','Stuart Lomas','stuart.lomas@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(35,'EMP035','Stephen Cooper','stephen.cooper@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(36,'EMP036','Darren Milhench','darren.milhench@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(37,'EMP037','Darren Mycroft','darren.mycroft@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(38,'EMP038','Kevin Gaskell','kevin.gaskell@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(39,'EMP039','Merv Permalloo','merv.permalloo@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(40,'EMP040','Regan Stringer','regan.stringer@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(41,'EMP041','Matthew Cope','matthew.cope@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(42,'EMP042','AJ','aj@hospital.nhs.uk',NULL,'RELIEF',37.50,2,0,NULL,NULL,6,NULL,'2025-09-28','2025-09-29',1,1,'2025-09-26 19:09:47','2025-09-27 15:11:06','REGULAR'),(43,'EMP043','Michael Shaw','michael.shaw@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(44,'EMP044','James Bennett','james.bennett@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(45,'EMP045','Martin Hobson','martin.hobson@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(46,'EMP046','Martin Kenyon','martin.kenyon@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(47,'EMP047','Scott Cartledge','scott.cartledge@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(48,'EMP048','Tony Batters','tony.batters@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(49,'EMP049','Lewis Yearsley','lewis.yearsley@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(50,'EMP050','Mark Lloyd','mark.lloyd@hospital.nhs.uk',NULL,'RELIEF',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,1,'2025-09-26 19:09:47','2025-09-26 19:09:47','REGULAR'),(51,NULL,'Updated Test Porter','updated@example.com',NULL,'CUSTOM',30.00,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2025-09-27 08:08:45','2025-09-27 08:14:59','REGULAR'),(52,NULL,'Test Porter Clean','test@example.com',NULL,'SHIFT',37.50,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'2025-09-27 08:30:12','2025-09-27 08:30:37','REGULAR'),(53,NULL,'Test Porter','test@hospital.nhs.uk',NULL,'SHIFT',37.50,1,2,1,1,NULL,NULL,NULL,NULL,0,0,'2025-09-27 15:24:08','2025-09-27 15:24:27','REGULAR');
/*!40000 ALTER TABLE `porters_backup_20251002` ENABLE KEYS */;
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
-- Table structure for table `shift_types`
--

DROP TABLE IF EXISTS `shift_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shift_types` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `starts_at` time NOT NULL,
  `ends_at` time NOT NULL,
  `display_type` enum('DAY','NIGHT') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DAY',
  `color` varchar(7) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_shift_type_name` (`name`),
  KEY `idx_shift_type_display` (`display_type`),
  KEY `idx_shift_type_active` (`is_active`),
  CONSTRAINT `chk_shift_type_color` CHECK (((`color` is null) or regexp_like(`color`,_latin1'^#[0-9A-Fa-f]{6}$'))),
  CONSTRAINT `chk_shift_type_name_length` CHECK ((char_length(`name`) >= 3)),
  CONSTRAINT `chk_shift_type_times` CHECK ((`starts_at` <> `ends_at`))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shift_types`
--

LOCK TABLES `shift_types` WRITE;
/*!40000 ALTER TABLE `shift_types` DISABLE KEYS */;
INSERT INTO `shift_types` VALUES (1,'Day Shift','08:00:00','20:00:00','DAY','#8be3e9',1,'2025-10-02 10:29:00','2025-10-02 13:23:12'),(2,'Day Shift B','08:00:00','20:00:00','DAY','#8BC34A',0,'2025-10-02 10:29:00','2025-10-02 13:22:14'),(3,'Night Shift A','20:00:00','08:00:00','NIGHT','#3F51B5',0,'2025-10-02 10:29:00','2025-10-02 13:22:32'),(4,'Night Shift','20:00:00','08:00:00','NIGHT','#673AB7',1,'2025-10-02 10:29:00','2025-10-02 13:22:39'),(5,'Evening Shift','14:00:00','22:00:00','DAY','#c800ff',1,'2025-10-02 10:33:06','2025-10-02 13:23:01');
/*!40000 ALTER TABLE `shift_types` ENABLE KEYS */;
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
  `shift_type_id` int unsigned DEFAULT NULL,
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
  KEY `idx_shift_active` (`is_active`),
  KEY `idx_shift_type_id` (`shift_type_id`),
  CONSTRAINT `fk_shift_type` FOREIGN KEY (`shift_type_id`) REFERENCES `shift_types` (`id`) ON DELETE SET NULL,
  CONSTRAINT `chk_shift_days_off` CHECK ((`days_off` between 1 and 14)),
  CONSTRAINT `chk_shift_days_on` CHECK ((`days_on` between 1 and 14)),
  CONSTRAINT `chk_shift_name_length` CHECK ((char_length(`name`) >= 3)),
  CONSTRAINT `chk_shift_offset` CHECK ((`shift_offset` <= 13))
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shifts`
--

LOCK TABLES `shifts` WRITE;
/*!40000 ALTER TABLE `shifts` DISABLE KEYS */;
INSERT INTO `shifts` VALUES (1,'Day Shift A',1,'08:00:00','20:00:00',4,4,0,'2025-01-01',1,'2025-09-26 19:09:38','2025-10-02 10:29:00'),(2,'Day Shift B',1,'08:00:00','20:00:00',4,4,4,'2025-01-01',1,'2025-09-26 19:09:38','2025-10-02 13:24:00'),(3,'Night Shift A',4,'20:00:00','08:00:00',4,4,0,'2025-01-01',1,'2025-09-26 19:09:38','2025-10-02 13:23:49'),(4,'Night Shift B',4,'20:00:00','08:00:00',4,4,4,'2025-01-01',1,'2025-09-26 19:09:38','2025-10-02 10:29:00'),(5,'Updated Test Shift',NULL,'22:00:00','06:00:00',5,2,1,'2024-01-01',0,'2025-09-27 08:12:57','2025-09-27 08:15:24'),(6,'Evening Shift Test',5,'14:00:00','22:00:00',5,2,0,'2025-01-01',0,'2025-10-02 10:33:17','2025-10-02 11:06:45'),(7,'Custom Relief Shift',5,'10:00:00','18:00:00',3,4,0,'2025-01-01',0,'2025-10-02 10:33:27','2025-10-02 11:06:39'),(8,'PTS 8-8',1,'08:00:00','20:00:00',4,4,0,'2025-10-02',1,'2025-10-02 11:07:13','2025-10-02 11:07:13'),(9,'PTS 12-8',1,'12:00:00','20:00:00',5,2,0,'2025-10-01',1,'2025-10-02 11:07:56','2025-10-02 13:24:44'),(10,'PTS 1-1',5,'13:00:00','01:00:00',4,4,0,'2025-10-01',1,'2025-10-02 11:08:29','2025-10-02 13:24:19'),(11,'Day Shift 10-10',1,'10:00:00','22:00:00',4,4,0,'2025-10-02',1,'2025-10-02 11:17:32','2025-10-02 11:17:32'),(12,'Weekdays',1,'07:00:00','18:00:00',5,2,0,'2025-10-01',1,'2025-10-02 13:20:48','2025-10-02 13:24:35'),(13,'Weekends',1,'06:00:00','18:00:00',2,5,0,'2025-10-01',1,'2025-10-02 13:21:55','2025-10-02 13:25:01');
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

-- Dump completed on 2025-10-03 14:39:51
