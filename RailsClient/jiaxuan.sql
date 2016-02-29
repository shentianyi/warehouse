-- MySQL dump 10.13  Distrib 5.5.43, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: vmi_jiaxuandb
-- ------------------------------------------------------
-- Server version	5.5.43-0ubuntu0.12.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `api_logs`
--

DROP TABLE IF EXISTS `api_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_logs` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `targetable_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `targetable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `action` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `action_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `result` tinyint(1) DEFAULT NULL,
  `message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_api_logs_on_id` (`id`),
  KEY `index_api_logs_on_user_id` (`user_id`),
  KEY `index_api_logs_on_targetable_id` (`targetable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_logs`
--

LOCK TABLES `api_logs` WRITE;
/*!40000 ALTER TABLE `api_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `api_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attachments`
--

DROP TABLE IF EXISTS `attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attachments` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `size` float DEFAULT NULL,
  `path_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attachable_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attachable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `version` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `md5` text COLLATE utf8_unicode_ci,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_attachments_on_attachable_id` (`attachable_id`),
  KEY `index_attachments_on_attachable_type` (`attachable_type`),
  KEY `index_attachments_on_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attachments`
--

LOCK TABLES `attachments` WRITE;
/*!40000 ALTER TABLE `attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `containers`
--

DROP TABLE IF EXISTS `containers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `containers` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `custom_id` varchar(36) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `quantity` float DEFAULT NULL,
  `state` int(11) DEFAULT NULL,
  `location_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `current_positionable_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `current_positionable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fifo_time` datetime DEFAULT NULL,
  `remark` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `part_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `part_id_display` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `quantity_display` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fifo_time_display` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extra_800_no` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extra_cz_part_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extra_sh_part_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extra_unit` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extra_batch` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_containers_on_id` (`id`),
  KEY `index_containers_on_custom_id` (`custom_id`),
  KEY `index_containers_on_location_id` (`location_id`),
  KEY `index_containers_on_current_positionable_id` (`current_positionable_id`),
  KEY `index_containers_on_current_positionable_type` (`current_positionable_type`),
  KEY `index_containers_on_user_id` (`user_id`),
  KEY `index_containers_on_type` (`type`),
  KEY `index_containers_on_is_delete` (`is_delete`),
  KEY `index_containers_on_part_id` (`part_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `containers`
--

LOCK TABLES `containers` WRITE;
/*!40000 ALTER TABLE `containers` DISABLE KEYS */;
INSERT INTO `containers` VALUES ('51050474181',NULL,1,3200,1,'ac42b1e0-8917-4259-8d8e-0b5a13689bfa','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',NULL,NULL,NULL,NULL,'f8080ad5-cacd-4ab0-bac9-c89897323d58',0,1,1,'2016-02-29 03:18:42','2016-02-29 03:18:42',NULL,NULL,NULL,'803134861','clent_part1_1','clent_part1','M','7879543'),('51050815271',NULL,2,NULL,NULL,'ac42b1e0-8917-4259-8d8e-0b5a13689bfa','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',NULL,NULL,NULL,NULL,NULL,0,1,1,'2016-02-29 03:18:42','2016-02-29 03:18:42',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('D1456715922346',NULL,3,NULL,NULL,'ac42b1e0-8917-4259-8d8e-0b5a13689bfa','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',NULL,NULL,NULL,'常州莱尼发运数据',NULL,0,1,1,'2016-02-29 03:18:42','2016-02-29 03:18:42',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `containers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deliveries`
--

DROP TABLE IF EXISTS `deliveries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deliveries` (
  `uuid` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `state` int(11) NOT NULL DEFAULT '0',
  `delivery_date` datetime DEFAULT NULL,
  `received_date` datetime DEFAULT NULL,
  `receiver_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `source_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `destination_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remark` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_deliveries_on_uuid` (`uuid`),
  KEY `index_deliveries_on_user_id` (`user_id`),
  KEY `index_deliveries_on_id` (`id`),
  KEY `index_deliveries_on_source_id` (`source_id`),
  KEY `index_deliveries_on_destination_id` (`destination_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deliveries`
--

LOCK TABLES `deliveries` WRITE;
/*!40000 ALTER TABLE `deliveries` DISABLE KEYS */;
/*!40000 ALTER TABLE `deliveries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forklifts`
--

DROP TABLE IF EXISTS `forklifts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forklifts` (
  `uuid` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `state` int(11) NOT NULL DEFAULT '0',
  `delivery_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remark` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `stocker_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `whouse_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_forklifts_on_uuid` (`uuid`),
  KEY `index_forklifts_on_delivery_id` (`delivery_id`),
  KEY `index_forklifts_on_id` (`id`),
  KEY `index_forklifts_on_stocker_id` (`stocker_id`),
  KEY `index_forklifts_on_user_id` (`user_id`),
  KEY `index_forklifts_on_whouse_id` (`whouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forklifts`
--

LOCK TABLES `forklifts` WRITE;
/*!40000 ALTER TABLE `forklifts` DISABLE KEYS */;
/*!40000 ALTER TABLE `forklifts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_list_items`
--

DROP TABLE IF EXISTS `inventory_list_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inventory_list_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `package_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `unique_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `part_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `qty` decimal(20,10) DEFAULT NULL,
  `position` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `current_whouse` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `current_position` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `in_store` tinyint(1) DEFAULT '0',
  `inventory_list_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `whouse_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fifo` datetime DEFAULT NULL,
  `part_wire_mark` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `part_form_mark` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `origin_qty` decimal(20,10) DEFAULT NULL,
  `need_convert` tinyint(1) DEFAULT '0',
  `locked` tinyint(1) DEFAULT '0',
  `in_stored` tinyint(1) DEFAULT '0',
  `remark` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_list_items`
--

LOCK TABLES `inventory_list_items` WRITE;
/*!40000 ALTER TABLE `inventory_list_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_list_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_lists`
--

DROP TABLE IF EXISTS `inventory_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inventory_lists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` int(11) DEFAULT '100',
  `whouse_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_lists`
--

LOCK TABLES `inventory_lists` WRITE;
/*!40000 ALTER TABLE `inventory_lists` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_lists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `led_states`
--

DROP TABLE IF EXISTS `led_states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `led_states` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `state` int(11) DEFAULT NULL,
  `rgb` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `led_code` int(11) DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `led_states`
--

LOCK TABLES `led_states` WRITE;
/*!40000 ALTER TABLE `led_states` DISABLE KEYS */;
/*!40000 ALTER TABLE `led_states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leds`
--

DROP TABLE IF EXISTS `leds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `leds` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `signal_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `current_state` int(11) DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `modem_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `position` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `mac` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_leds_on_id` (`id`),
  KEY `index_leds_on_signal_id` (`signal_id`),
  KEY `index_leds_on_modem_id` (`modem_id`),
  KEY `index_leds_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leds`
--

LOCK TABLES `leds` WRITE;
/*!40000 ALTER TABLE `leds` DISABLE KEYS */;
/*!40000 ALTER TABLE `leds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `location_container_hierarchies`
--

DROP TABLE IF EXISTS `location_container_hierarchies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `location_container_hierarchies` (
  `ancestor_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `descendant_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `generations` int(11) NOT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  UNIQUE KEY `anc_desc_idx` (`ancestor_id`,`descendant_id`,`generations`),
  KEY `desc_idx` (`descendant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location_container_hierarchies`
--

LOCK TABLES `location_container_hierarchies` WRITE;
/*!40000 ALTER TABLE `location_container_hierarchies` DISABLE KEYS */;
/*!40000 ALTER TABLE `location_container_hierarchies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `location_containers`
--

DROP TABLE IF EXISTS `location_containers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `location_containers` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `source_location_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `des_location_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `container_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remark` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `state` int(11) DEFAULT '0',
  `destinationable_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `destinationable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ancestry` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_location_containers_on_id` (`id`),
  KEY `index_location_containers_on_source_location_id` (`source_location_id`),
  KEY `index_location_containers_on_des_location_id` (`des_location_id`),
  KEY `index_location_containers_on_container_id` (`container_id`),
  KEY `index_location_containers_on_destinationable_id` (`destinationable_id`),
  KEY `index_location_containers_on_destinationable_type` (`destinationable_type`),
  KEY `index_location_containers_on_ancestry` (`ancestry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location_containers`
--

LOCK TABLES `location_containers` WRITE;
/*!40000 ALTER TABLE `location_containers` DISABLE KEYS */;
INSERT INTO `location_containers` VALUES ('337f264d-c6f3-47bc-a94c-83dd3362b860','ac42b1e0-8917-4259-8d8e-0b5a13689bfa','596f7217-a62c-4354-ac41-8b5339fe1a8c','0de379bf-8f89-4f03-aa9f-c27749c3aaf9','51050815271',NULL,1,0,1,1,'2016-02-29 03:18:42','2016-02-29 03:18:42',1,'596f7217-a62c-4354-ac41-8b5339fe1a8c','Location','771689d6-a9d6-42db-8fdf-13b875918094'),('771689d6-a9d6-42db-8fdf-13b875918094','ac42b1e0-8917-4259-8d8e-0b5a13689bfa','596f7217-a62c-4354-ac41-8b5339fe1a8c','0de379bf-8f89-4f03-aa9f-c27749c3aaf9','D1456715922346','常州莱尼发运数据',1,0,1,1,'2016-02-29 03:18:42','2016-02-29 03:18:42',1,'596f7217-a62c-4354-ac41-8b5339fe1a8c','Location',NULL),('ffae0efe-4448-4ab6-b84c-2bf52d53fed3','ac42b1e0-8917-4259-8d8e-0b5a13689bfa','596f7217-a62c-4354-ac41-8b5339fe1a8c','0de379bf-8f89-4f03-aa9f-c27749c3aaf9','51050474181',NULL,1,0,1,1,'2016-02-29 03:18:42','2016-02-29 03:18:42',1,'596f7217-a62c-4354-ac41-8b5339fe1a8c','Location','771689d6-a9d6-42db-8fdf-13b875918094/337f264d-c6f3-47bc-a94c-83dd3362b860');
/*!40000 ALTER TABLE `location_containers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `location_destinations`
--

DROP TABLE IF EXISTS `location_destinations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `location_destinations` (
  `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `location_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `destination_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_default` tinyint(1) DEFAULT '0',
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_location_destinations_on_id` (`id`),
  KEY `index_location_destinations_on_location_id` (`location_id`),
  KEY `index_location_destinations_on_destination_id` (`destination_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location_destinations`
--

LOCK TABLES `location_destinations` WRITE;
/*!40000 ALTER TABLE `location_destinations` DISABLE KEYS */;
/*!40000 ALTER TABLE `location_destinations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locations` (
  `uuid` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tel` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_base` tinyint(1) DEFAULT '0',
  `destination_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT '0',
  `remark` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `tenant_id` int(11) DEFAULT NULL,
  `nr` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_locations_on_uuid` (`uuid`),
  KEY `index_locations_on_id` (`id`),
  KEY `index_locations_on_destination_id` (`destination_id`),
  KEY `index_locations_on_parent_id` (`parent_id`),
  KEY `index_locations_on_tenant_id` (`tenant_id`),
  KEY `index_locations_on_nr` (`nr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locations`
--

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
INSERT INTO `locations` VALUES ('bb96d149-6c4a-4d27-8bc5-3c57532eb1bf','236fc029-8468-4402-88f2-a17f8855cfdb','Default Location',0,1,1,'2016-02-26 11:34:25','2016-02-26 11:34:25',NULL,NULL,1,NULL,NULL,0,'',5,'Default'),('4436c543-d2d6-4bd3-8d8a-b00cbe04a09d','596f7217-a62c-4354-ac41-8b5339fe1a8c','佳轩仓库',0,1,1,'2016-02-26 09:08:44','2016-02-26 09:08:44','','',0,NULL,NULL,0,'',NULL,'jiaxuan'),('432afd25-e82b-46d3-bec5-82beb2f8398b','ac42b1e0-8917-4259-8d8e-0b5a13689bfa','常州莱尼',0,1,1,'2016-02-26 09:04:02','2016-02-26 09:04:02','','',0,NULL,NULL,0,'',NULL,'cz-leoni'),('0cd9d2d3-cad5-4b1b-8a32-93c25cb57273','c51ec557-0a12-4c09-8479-50e5bd24d467','Default Location',0,1,1,'2016-02-26 08:42:29','2016-02-26 08:42:29',NULL,NULL,1,NULL,NULL,0,'',1,'Default'),('24101931-5c71-4697-876a-3f84dbafe748','c8553111-895d-45e1-9777-be688013f313','上海莱尼',0,1,1,'2016-02-26 09:03:28','2016-02-26 09:03:28','','',0,NULL,NULL,0,'',NULL,'sh-leoni'),('d6138305-ed69-43ab-9023-c9a9ea04ad2f','cc7e4c84-3748-4bb5-9e67-00cbf36c7754','Default Location',0,1,1,'2016-02-26 10:35:38','2016-02-26 10:35:38',NULL,NULL,1,NULL,NULL,0,'',2,'Default');
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `modems`
--

DROP TABLE IF EXISTS `modems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modems` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_modems_on_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modems`
--

LOCK TABLES `modems` WRITE;
/*!40000 ALTER TABLE `modems` DISABLE KEYS */;
/*!40000 ALTER TABLE `modems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `move_types`
--

DROP TABLE IF EXISTS `move_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `move_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `typeId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `short_desc` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `long_desc` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `move_types`
--

LOCK TABLES `move_types` WRITE;
/*!40000 ALTER TABLE `move_types` DISABLE KEYS */;
INSERT INTO `move_types` VALUES (1,'MOVE','move type',NULL,'2016-02-26 08:42:29','2016-02-26 08:42:29'),(2,'ENTRY','entey',NULL,'2016-02-26 08:42:29','2016-02-26 08:42:29'),(3,'MOVE','move type',NULL,'2016-02-26 10:35:38','2016-02-26 10:35:38'),(4,'ENTRY','entey',NULL,'2016-02-26 10:35:38','2016-02-26 10:35:38'),(5,'MOVE','move type',NULL,'2016-02-26 11:34:25','2016-02-26 11:34:25'),(6,'ENTRY','entey',NULL,'2016-02-26 11:34:25','2016-02-26 11:34:25');
/*!40000 ALTER TABLE `move_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movement_lists`
--

DROP TABLE IF EXISTS `movement_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movement_lists` (
  `uuid` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT '100',
  `builder` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remarks` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_movement_lists_on_uuid` (`uuid`),
  KEY `index_movement_lists_on_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movement_lists`
--

LOCK TABLES `movement_lists` WRITE;
/*!40000 ALTER TABLE `movement_lists` DISABLE KEYS */;
/*!40000 ALTER TABLE `movement_lists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movement_sources`
--

DROP TABLE IF EXISTS `movement_sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movement_sources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `movement_list_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fromWh` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fromPosition` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `packageId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `partNr` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `qty` float DEFAULT NULL,
  `fifo` datetime DEFAULT NULL,
  `toWh` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `toPosition` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `employee_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remarks` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movement_sources`
--

LOCK TABLES `movement_sources` WRITE;
/*!40000 ALTER TABLE `movement_sources` DISABLE KEYS */;
/*!40000 ALTER TABLE `movement_sources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movements`
--

DROP TABLE IF EXISTS `movements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `partNr` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fifo` datetime DEFAULT NULL,
  `qty` decimal(20,10) DEFAULT NULL,
  `from_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fromPosition` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `to_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `toPosition` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `packageId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `uniqueId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `remark` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remarks` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `employee_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `movement_list_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_id_unique` (`uniqueId`),
  KEY `index_movements_on_type_id` (`type_id`),
  KEY `package_id_index` (`packageId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movements`
--

LOCK TABLES `movements` WRITE;
/*!40000 ALTER TABLE `movements` DISABLE KEYS */;
/*!40000 ALTER TABLE `movements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `n_locations`
--

DROP TABLE IF EXISTS `n_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `n_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `locationId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remark` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `status` int(11) DEFAULT '0',
  `parent_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `location_id_unique` (`locationId`),
  KEY `index_n_locations_on_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `n_locations`
--

LOCK TABLES `n_locations` WRITE;
/*!40000 ALTER TABLE `n_locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `n_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `n_storages`
--

DROP TABLE IF EXISTS `n_storages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `n_storages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `storageId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `partNr` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fifo` datetime DEFAULT NULL,
  `qty` decimal(20,10) DEFAULT NULL,
  `position` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `packageId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `uniqueId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ware_house_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `locked` tinyint(1) DEFAULT '0',
  `remarks` text COLLATE utf8_unicode_ci,
  `lock_user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lock_remark` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lock_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `storage_id_unique` (`storageId`),
  UNIQUE KEY `unique_id_unique` (`uniqueId`),
  KEY `index_n_storages_on_ware_house_id` (`ware_house_id`),
  KEY `package_id_index` (`packageId`),
  KEY `index_n_storages_on_locked` (`locked`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `n_storages`
--

LOCK TABLES `n_storages` WRITE;
/*!40000 ALTER TABLE `n_storages` DISABLE KEYS */;
/*!40000 ALTER TABLE `n_storages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operation_logs`
--

DROP TABLE IF EXISTS `operation_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `operation_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `item_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `event` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `whodunnit` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `object` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operation_logs`
--

LOCK TABLES `operation_logs` WRITE;
/*!40000 ALTER TABLE `operation_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `operation_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_items` (
  `uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `quantity` float DEFAULT NULL,
  `box_quantity` int(11) DEFAULT '0',
  `order_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `whouse_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `part_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `part_type_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remark` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_emergency` tinyint(1) NOT NULL DEFAULT '0',
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_finished` tinyint(1) DEFAULT '0',
  `out_of_stock` tinyint(1) DEFAULT '0',
  `handled` tinyint(1) DEFAULT '0',
  `state` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_order_items_on_uuid` (`uuid`),
  KEY `index_order_items_on_id` (`id`),
  KEY `index_order_items_on_order_id` (`order_id`),
  KEY `index_order_items_on_location_id` (`location_id`),
  KEY `index_order_items_on_whouse_id` (`whouse_id`),
  KEY `index_order_items_on_user_id` (`user_id`),
  KEY `index_order_items_on_part_id` (`part_id`),
  KEY `index_order_items_on_part_type_id` (`part_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `uuid` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `handled` tinyint(1) DEFAULT '0',
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `source_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` int(11) DEFAULT '0',
  `remark` text COLLATE utf8_unicode_ci,
  `source_location_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_orders_on_uuid` (`uuid`),
  KEY `index_orders_on_id` (`id`),
  KEY `index_orders_on_user_id` (`user_id`),
  KEY `index_orders_on_source_id` (`source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `package_positions`
--

DROP TABLE IF EXISTS `package_positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `package_positions` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `position_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `package_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_package_positions_on_id` (`id`),
  KEY `index_package_positions_on_position_id` (`position_id`),
  KEY `index_package_positions_on_package_id` (`package_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `package_positions`
--

LOCK TABLES `package_positions` WRITE;
/*!40000 ALTER TABLE `package_positions` DISABLE KEYS */;
/*!40000 ALTER TABLE `package_positions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `packages`
--

DROP TABLE IF EXISTS `packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `packages` (
  `uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `part_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `quantity` float DEFAULT '0',
  `state` int(11) NOT NULL DEFAULT '0',
  `location_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `forklift_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `quantity_str` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `check_in_time` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `positionable_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `positionable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_packages_on_uuid` (`uuid`),
  KEY `index_packages_on_id` (`id`),
  KEY `index_packages_on_location_id` (`location_id`),
  KEY `index_packages_on_part_id` (`part_id`),
  KEY `index_packages_on_user_id` (`user_id`),
  KEY `index_packages_on_forklift_id` (`forklift_id`),
  KEY `index_packages_on_positionable_id` (`positionable_id`),
  KEY `index_packages_on_positionable_type` (`positionable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packages`
--

LOCK TABLES `packages` WRITE;
/*!40000 ALTER TABLE `packages` DISABLE KEYS */;
/*!40000 ALTER TABLE `packages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `part_clients`
--

DROP TABLE IF EXISTS `part_clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `part_clients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `part_id` varchar(36) COLLATE utf8_unicode_ci DEFAULT NULL,
  `client_part_nr` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `client_tenant_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_part_clients_on_part_id` (`part_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `part_clients`
--

LOCK TABLES `part_clients` WRITE;
/*!40000 ALTER TABLE `part_clients` DISABLE KEYS */;
INSERT INTO `part_clients` VALUES (1,'f8080ad5-cacd-4ab0-bac9-c89897323d58','clent_part1',3,'2016-02-29 02:13:25','2016-02-29 02:13:25'),(2,'f8080ad5-cacd-4ab0-bac9-c89897323d58','clent_part1_1',4,'2016-02-29 02:54:39','2016-02-29 02:54:39'),(3,'e5261737-a047-42d0-a346-d0ae69d74487','clent_part2_2',4,'2016-02-29 02:55:01','2016-02-29 02:55:01');
/*!40000 ALTER TABLE `part_clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `part_positions`
--

DROP TABLE IF EXISTS `part_positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `part_positions` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `part_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `position_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `sourceable_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sourceable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_part_positions_on_id` (`id`),
  KEY `index_part_positions_on_position_id` (`position_id`),
  KEY `index_part_positions_on_part_id` (`part_id`),
  KEY `index_part_positions_on_sourceable_id` (`sourceable_id`),
  KEY `index_part_positions_on_sourceable_type` (`sourceable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `part_positions`
--

LOCK TABLES `part_positions` WRITE;
/*!40000 ALTER TABLE `part_positions` DISABLE KEYS */;
/*!40000 ALTER TABLE `part_positions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `part_types`
--

DROP TABLE IF EXISTS `part_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `part_types` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `nr` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_part_types_on_id` (`id`),
  KEY `index_part_types_on_nr` (`nr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `part_types`
--

LOCK TABLES `part_types` WRITE;
/*!40000 ALTER TABLE `part_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `part_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parts`
--

DROP TABLE IF EXISTS `parts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `parts` (
  `uuid` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `customernum` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `unit_pack` float DEFAULT NULL,
  `part_type_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `convert_unit` decimal(20,10) DEFAULT '1.0000000000',
  `unit` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nr` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_parts_on_uuid` (`uuid`),
  KEY `index_parts_on_id` (`id`),
  KEY `index_parts_on_user_id` (`user_id`),
  KEY `index_parts_on_part_type_id` (`part_type_id`),
  KEY `index_parts_on_nr` (`nr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parts`
--

LOCK TABLES `parts` WRITE;
/*!40000 ALTER TABLE `parts` DISABLE KEYS */;
INSERT INTO `parts` VALUES ('03f90357-8f32-43c2-9864-36477179c342','e5261737-a047-42d0-a346-d0ae69d74487',NULL,'0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,1,1,'2016-02-29 02:54:05','2016-02-29 02:54:05',NULL,'',1.0000000000,'m','part2',''),('aeabe4b8-a6c4-4ab4-b4a2-a9882b45321d','f8080ad5-cacd-4ab0-bac9-c89897323d58',NULL,'0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,1,1,'2016-02-29 02:13:09','2016-02-29 02:13:09',10,'',1.0000000000,'m','part1','');
/*!40000 ALTER TABLE `parts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission_group_items`
--

DROP TABLE IF EXISTS `permission_group_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permission_group_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permission_id` int(11) DEFAULT NULL,
  `permission_group_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_permission_group_items_on_permission_id` (`permission_id`),
  KEY `index_permission_group_items_on_permission_group_id` (`permission_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission_group_items`
--

LOCK TABLES `permission_group_items` WRITE;
/*!40000 ALTER TABLE `permission_group_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `permission_group_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission_groups`
--

DROP TABLE IF EXISTS `permission_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permission_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission_groups`
--

LOCK TABLES `permission_groups` WRITE;
/*!40000 ALTER TABLE `permission_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `permission_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pick_item_filters`
--

DROP TABLE IF EXISTS `pick_item_filters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pick_item_filters` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `filterable_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `filterable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pick_item_filters_on_id` (`id`),
  KEY `index_pick_item_filters_on_user_id` (`user_id`),
  KEY `index_pick_item_filters_on_filterable_id` (`filterable_id`),
  KEY `index_pick_item_filters_on_filterable_type` (`filterable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pick_item_filters`
--

LOCK TABLES `pick_item_filters` WRITE;
/*!40000 ALTER TABLE `pick_item_filters` DISABLE KEYS */;
/*!40000 ALTER TABLE `pick_item_filters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pick_items`
--

DROP TABLE IF EXISTS `pick_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pick_items` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `pick_list_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `quantity` float DEFAULT '0',
  `box_quantity` int(11) DEFAULT '0',
  `destination_whouse_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `part_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `part_type_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remark` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_emergency` tinyint(1) NOT NULL DEFAULT '0',
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `order_item_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_pick_items_on_id` (`id`),
  KEY `index_pick_items_on_pick_list_id` (`pick_list_id`),
  KEY `index_pick_items_on_destination_whouse_id` (`destination_whouse_id`),
  KEY `index_pick_items_on_order_item_id` (`order_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pick_items`
--

LOCK TABLES `pick_items` WRITE;
/*!40000 ALTER TABLE `pick_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `pick_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pick_lists`
--

DROP TABLE IF EXISTS `pick_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pick_lists` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` int(11) DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `order_ids` text COLLATE utf8_unicode_ci,
  `remark` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `index_pick_lists_on_id` (`id`),
  KEY `index_pick_lists_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pick_lists`
--

LOCK TABLES `pick_lists` WRITE;
/*!40000 ALTER TABLE `pick_lists` DISABLE KEYS */;
/*!40000 ALTER TABLE `pick_lists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `positions`
--

DROP TABLE IF EXISTS `positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `positions` (
  `uuid` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `whouse_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `detail` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `nr` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_positions_on_uuid` (`uuid`),
  KEY `index_positions_on_id` (`id`),
  KEY `index_positions_on_whouse_id` (`whouse_id`),
  KEY `index_positions_on_nr` (`nr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `positions`
--

LOCK TABLES `positions` WRITE;
/*!40000 ALTER TABLE `positions` DISABLE KEYS */;
/*!40000 ALTER TABLE `positions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `records`
--

DROP TABLE IF EXISTS `records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `records` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `recordable_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `recordable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `impl_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `impl_user_type` int(11) DEFAULT NULL,
  `impl_action` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `impl_time` datetime DEFAULT NULL,
  `destinationable_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `destinationable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_records_on_id` (`id`),
  KEY `index_records_on_impl_id` (`impl_id`),
  KEY `index_records_on_recordable_id` (`recordable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `records`
--

LOCK TABLES `records` WRITE;
/*!40000 ALTER TABLE `records` DISABLE KEYS */;
INSERT INTO `records` VALUES ('005c0896-3e07-49b8-b610-9b6eb5bd560a','910bea3e-3561-47bf-8668-92e5f3d033e2','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('00a5f29e-47f2-4329-8973-c6e796b737e4','147bec72-5c83-4ecc-a66c-c3c683c5eeba','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('00e0d70d-5d7e-4a7e-9165-90d0994b17c8','9514f246-1e02-4ee0-8e04-d555bf072b65','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('010e07ff-f0cd-433d-a8e4-1f89a4933b48','71a9bfcf-cd97-4c00-9036-b4de9a484b57','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('01a01a36-a9da-4ec4-8aa4-f10c9102f755','757281d8-c248-4316-8525-1bd7c58ad4ab','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('01df49e7-3589-42ac-a4d4-30f2485e69e4','8a14f620-872f-4da2-ba1a-8eeda29f4344','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('0276b3ca-4539-4cfc-86d2-f805213dda9c','71702a0d-6d60-41a8-a51e-3e832b528c8e','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('02b33ff5-e832-4eff-bdd7-8a2b212ba17a','4d46e3fe-b89b-4f72-b79c-f9e33a003f71','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('036398f5-7e75-4b07-8290-69d46c5c338d','88f47370-faa2-4d35-854c-fec92d59ac43','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('03c43694-8c8e-4c58-926b-09cc9a0223ce','808b2c03-76b2-474d-becb-9fe4d53af45f','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('05db254b-5bb4-4071-9c7f-f28492b4aded','2c020f37-3009-4d89-a1a4-ac51f8905441','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:50','2016-02-26 11:02:50'),('06e3a0d9-8d04-460b-b965-cc1a50cd1e79','e5e433f5-0c71-467b-9575-73b6d4788e94','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:22','2016-02-26 11:01:22'),('071808ea-9eb4-4fbc-be6c-c24b6c527adb','3f7946a8-816e-47c5-a5cc-9092d4836a08','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('07af3a90-2e15-42ce-a363-2f2de10e9f2d','626d863a-7402-494c-8b66-4049622177bf','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:44','2016-02-26 11:09:44'),('0878f356-df76-4314-bdfe-f394bb55e1c5','c185b64f-51ff-4a94-ad8e-b5f3db555b75','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('08b08517-bd89-41bc-809f-a4ac15c56d13','47bde750-08e8-420a-80e4-ad5ea93ecafa','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('08df4bfc-eb5f-4c87-b300-09cc389362d1','31471d17-30e8-463e-bcd6-7a7e1580abc1','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('0974163a-8167-4ba0-9ad5-b2bc50133042','12f22b5e-e354-4858-b96d-4a2c8cc507f8','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('097a1875-a8ef-4dfa-a91e-f736df477c26','f5cd2ab8-9557-43e8-8143-70319adcd50e','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('09c72e10-dd59-49ff-873f-ede28e45dd46','93e46502-0296-4314-8bc1-cbb04e9ae183','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:22','2016-02-26 11:01:22'),('0ab4d397-518f-493f-8c9d-7daaea1965b5','407bc313-d202-409a-800c-0297332ca5f0','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('0b6c4d5b-940f-4fe6-a789-91e5c05fd4ff','f7c516fd-996c-49eb-a0a8-7e7b960220d5','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('0d5e2ab7-0f34-4641-abe5-a53f5441594b','43fe24e0-a58b-4981-8f68-84172326b27e','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('0d6071d4-0c7f-4947-b071-99bf0bf2a715','c72cf2ce-b715-40e6-8fee-aef125b34eb6','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('0d8f3eee-b0f0-418b-9b37-8511426039b5','a51b490d-4e83-4cb8-af21-e6777b389d26','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('0dfb1fdb-7831-4dfb-8677-8bf804e151b5','41eb92c7-fc31-47fa-9ba1-a780db15f3cb','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('0f0d9c9f-112a-4b50-b6b3-b403a263ff92','717f2b7d-5ddc-4f59-84b2-01e705f44855','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('0f313aa4-1df5-456f-8fee-8c5c9a960195','36ae73e2-10c4-4657-9ca4-aa3cf9e479a8','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('0f8f3ab2-2662-49c4-b2f4-7c613a13c68b','67a96695-b495-4572-a845-8fc1994cee9e','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('0f91f3b3-2d3e-462a-8aab-d741eff0fbdc','4d64c8a7-b9fe-4d08-ada4-5ac3724f9125','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('0fb8e8b2-be35-48fa-a84e-8f20e759b022','f96bbab6-1900-40fb-9fe1-f769faaedfca','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('0fe07a06-5618-4fa6-bd6a-06688551902c','43a92767-c2c9-4727-b460-21060f825787','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:22','2016-02-26 11:01:22'),('108afc7b-d5bb-4ce8-a912-4d4360b37626','9cb48285-a34b-42ec-882e-26cad4db42a3','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('110c569c-864e-45d5-a969-103c6ea7abea','893929a3-a0a3-427a-b90f-9f19bb82ed09','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('1112d0ba-650f-4e62-a0d9-5acfaf943291','03a7dd2e-f24a-4711-ae2f-f32b31cd76d0','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('11f8a8bf-8b84-43f8-862a-4aa85ecbd8b9','433eddd6-721b-4f9f-95d2-2c85dfe3edfe','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('1316b061-6de3-4b52-8c4c-b9c753386ee2','162f4ba7-c76d-4f67-904c-e2f733c57a83','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 09:41:15',NULL,NULL,0,1,1,'2016-02-26 09:41:15','2016-02-26 09:41:15'),('157e07ff-6a37-41ec-9b13-010861f44c9f','970759d6-3d87-439c-8cb3-d50979dcbf0b','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('160a8292-ff54-4e6f-854f-f8db3b5a5234','bba27ae8-201e-449d-a788-89488cbe3ca3','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('16ed13a3-e0fa-4146-a0dc-7e13b6110a3a','87e69fc2-7d95-47fc-a744-c67928187ae6','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('17eeda68-f290-4423-a5f9-ccdb0fd52343','2dd6bbc2-0a40-431b-9d2e-8346e380fcfb','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('17fab8d1-b04e-47d6-a3f0-db0baa2826c6','ce036c9f-44d1-4931-b46f-1060306e7f15','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:22','2016-02-26 11:01:22'),('18ed420d-4975-4c88-a406-ca9414be1352','4adb51e9-71e6-4af4-a038-d165f9604ce3','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('192c9676-b50d-4d2f-91f4-eca7d3f23128','081cd865-acbf-497c-96a0-98da76aef69b','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('1a50d526-e9ec-48a5-8a7f-9f0d4b01a373','85b93a01-b16b-47d7-9be8-fa68c1186fdb','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('1aff1191-0e66-4e0a-a4c6-b95f14df9b0e','8c932a40-9866-4816-a877-e3490efaae57','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:22','2016-02-26 11:01:22'),('1b07bea8-0a32-4ff3-876c-c551f1e26915','a6255fa8-275e-4d85-b4fa-114e989c2e81','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('1b53f245-ae13-42d5-b6f2-e37ab93f80f7','337a8481-3a30-403c-ab09-f5fbeb0f04f3','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('1b84912f-7890-4d44-9f0c-a5a91d8435e0','bb32af6a-a1b8-4159-9baa-5d5a384a7beb','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('1b8bf612-4ef6-48cb-a4c1-84cf82c2c3d5','f4a8d373-0914-470c-aa2c-60798685243b','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('1bbcf8b2-73b4-4436-a1fc-e5f69593330a','b1514bfb-3321-49e7-9b95-3311ae447bda','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:26','2016-02-26 11:01:26'),('1bc6e90c-fe52-4ae0-b432-c615fe58924e','2f211c11-ae38-471c-a381-fd6fd5e31a38','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('1c9a8c3f-5b43-4c4d-bf03-fb24d6e886d6','8d9d86e7-cb59-43aa-8a07-663c53116047','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('1d271020-ea3f-4228-8c79-a50dd62ec23e','8d326d41-b7ef-47d7-a0c5-a74122362ea8','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('1dced7ea-751f-4022-993a-4696ab536818','f895c66f-9bf9-49ef-9cae-96ffefddec76','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('1e3ba703-7714-44fb-a61f-9da48de44f48','70c9ffa8-cb8b-4dc9-97f8-1afebc30a580','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 09:39:43',NULL,NULL,0,1,1,'2016-02-26 09:39:43','2016-02-26 09:39:43'),('1ec2a3f0-2fbf-465a-98fb-cb4892d1f5a2','c04c57d5-f7cf-4e94-bd8f-ca3c20918070','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 09:11:04',NULL,NULL,0,1,1,'2016-02-26 09:11:04','2016-02-26 09:11:04'),('1fb432e8-f56d-47c6-afae-5ffb4a1021d1','86b0a5dc-07d6-4c8c-ba49-c66eee7404b2','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('200060e3-f1d5-4c33-b20b-6e5fa7441ce9','32c3ee68-a649-4145-83fc-0e031e1a230d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('200cdb29-3f4c-494b-a76d-00d8d7d9523c','57d6a95b-d282-463d-a5c7-15641c7adbbe','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('2011391c-f2fd-4fbb-9c83-6fee9d7b767e','f39d05d7-ca16-4bb4-bffd-6731f08c007a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('21c8407e-00dd-4675-9f4b-9e0515887151','fc52e4c9-a4b0-4406-a838-f0f958e5ce59','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('224f118a-aba3-4869-ac12-40b1ea1da5dd','0a4d4618-48cc-49bf-9c9f-d1d741cbd298','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('228efe15-9f37-45bc-827e-5580d2c2626e','ffae0efe-4448-4ab6-b84c-2bf52d53fed3','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-29 03:18:42',NULL,NULL,0,1,1,'2016-02-29 03:18:42','2016-02-29 03:18:42'),('22b6eec5-78fb-40f1-9bb4-c0acb56a0836','4c40aa4e-4142-48da-9bf6-f57c50067339','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('24b6b11f-0e61-4b6d-892d-6845b9449e83','0cd9a3a2-4932-481e-b209-cdface143ce6','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('2580e899-7d6c-4ac8-b672-6ea94c73330d','31a17c8e-04a1-41e5-ae72-5937f8e5f66a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:50','2016-02-26 11:02:50'),('258658c0-1b6a-4e9f-bece-022496dcd075','8756a5c1-da45-438a-84dc-f9293c04c30c','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('261adae9-468b-47cd-a042-00b0d66ffedc','f7906d08-e3ad-40fb-ade0-89226829a3f6','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('2747e1c9-0aba-4f3e-8c88-e9655e777d4a','f2471885-b565-4081-9163-39ffbb13be64','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('280ad8dd-2a85-44f8-bd94-5795b5f8f9a5','60af0717-9c88-40f3-b0ca-2715b4973337','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('28bb3584-8196-4c02-8575-63a16e64954f','1a633d33-a0b0-475d-9e0b-27a054274630','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('28ce0320-6f7d-4381-a3ff-0e7b7d165c43','cc7858ca-7580-4d66-9f13-3e3574adec7f','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('2992750b-6ecd-439d-99a3-e68823425c6c','8bac0794-8f50-47a8-8e1d-67b8b79f6338','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('29c148fb-c86d-43f8-b8fc-a96bcc7753dc','f89a331f-cf54-45d3-8387-5f6cd3885c06','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('29e5636c-d524-4f4c-a7eb-035bef79bd45','f72bb57e-7ff8-45e1-a8f0-5348ac541bff','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('2a5debe1-58ac-4fa3-be7b-96176051ca98','478cee3d-8164-442e-ba1a-a402f292ff48','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('2aa17a13-f039-4494-8d16-507b3b0dc516','dc7fdf53-d59c-4650-b650-9882ab00b734','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('2b49e747-7139-4406-b56e-a1e4b262433a','1bd839b6-7496-44be-ab2d-deb68c88ab9a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('2b833ca0-8590-4e52-8f3b-1b5ca31e9c7f','c077cab0-c450-4d3c-a012-56b831d926f6','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('2d0661a4-56ae-402e-ab61-1f4b1caaec69','0246bdd4-70b7-43cc-9d17-e553f24845f1','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('2d6ff260-88bc-49a7-aabf-bdc1a1d3929c','714e9d10-d9fb-4ed2-8600-54b645e051c8','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('2dcb9f95-5646-4237-86b0-1f3718be0652','d46a7ebb-fe78-47fe-8ddf-9145b556c11f','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:44','2016-02-26 11:09:44'),('2e6bca7b-5a2b-442a-b511-e3eb92c1bc67','06015706-c5a9-4559-a0a4-5790b22087a2','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('2eeddc84-865c-4309-9858-998a0ed3fa94','5782ff4b-248a-4c1a-92e4-988f094b8eee','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('2f4a502b-b9da-46d6-a59d-d46735a93709','b0c35cdb-3f70-431f-bb23-e65fbe54947a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('2fc2f801-b356-4147-8f38-0d26acdc0854','5cd95794-d0a3-4333-bb54-6823118e3c05','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('2ff2333d-7648-45ab-b3d4-2f818e1a02d6','8496cee4-89b5-48f0-a9a6-5e033ebef97a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('31034e90-90b7-472d-a7bc-9a6816178129','18d007d5-5e29-4f22-91d6-b540b2d2ad76','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('31186e4a-7306-4b1d-889e-d0ab106405bc','6e3ea068-9e14-4301-9844-6ad914fda6e3','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('315bd34d-7567-47eb-a24d-cc7b3e159a53','054da1db-46ee-4053-8ebd-dd8049a1395a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('31fc30c9-a444-4c71-8a19-ba7836abf0a6','fc7b1079-75ea-4874-b0ae-5fffcb4fa758','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('3334fc79-4a21-4ab7-a033-f7040f2d37f8','02f9a45c-11af-4bb1-8b5e-fcf79acba43e','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('33e99a24-013c-4387-916b-638fac2a31fc','801f0e64-f9a2-4da2-88b0-30ce0c4ffc0b','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('34d0bbf4-988d-419a-bf7e-818d1ff24426','11af42c3-d219-44e1-a98a-a631e24b11c2','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('34dff6ad-b24c-472d-b7bd-bad57100132d','1922f82d-8709-40ab-975f-edac5d486d3b','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('352e5d69-2ea2-414a-a2f0-7f593918acdb','c81da455-8676-43cc-bc8b-7168aa9593ff','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('35e38647-58d4-4588-9294-6042826d723c','b64d0aee-2021-42fc-a549-44bab747d2c8','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:44','2016-02-26 11:09:44'),('365d26f0-bcc2-44c2-8bc9-b859a171eaf9','be1d7319-8645-4a67-a126-9415d838c5b8','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('36a90b34-5e77-4aab-87bf-0a3a862bdec1','b929f129-f303-4bc2-9d05-9b6df4fa7c87','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:50','2016-02-26 11:02:50'),('371c168f-3093-4351-8a9b-9eb86e666e2f','19f22805-d015-4c5e-999d-fa3ccd06cf1a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('3735c686-86b0-4e71-896b-972829589cf9','f780e77b-addc-4415-bdf2-f830b483b268','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('374ac5e8-fc40-4b38-9a96-828ef75b594e','80eaf4bf-893b-472f-a2f2-0bd41cfa984a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('3813b8c4-a9ad-4316-ad8c-8756661b3a44','0cae9b82-a3c0-42e8-90ff-cddf55f1c511','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('38901462-90ca-4c39-a377-abee25a908a2','706e2ddc-f401-4cb9-bcfd-08fc1f47a55d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('3917d693-ecc0-43a6-be50-2470f8afbaff','a7d6ac32-64a9-45a5-9fc4-0fa96fde7357','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:04','2016-02-26 10:03:04'),('39938432-7ee3-4d67-9a9e-566813a7a04d','0a5b5bc5-eb28-4e2e-94ad-56c40b183427','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('399f892a-e5ff-4a74-ab4a-234669e06fd0','6928d10f-e93a-495f-8739-f71e05265301','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('3aa6064a-2f70-4972-aa89-1d3e4e4ed2d1','7dd936f8-3de8-4f49-8c91-bb6428fb5fa2','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('3b5d3391-cbe8-44ce-869e-2d4d42e78d0c','7b63fe1d-641c-4c35-8147-59291597be2f','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('3b958a8c-a96a-49e6-aa98-ede10c5b55c9','82433b7a-7981-487f-af7e-65272ddb5bb9','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:51','2016-02-26 11:02:51'),('3c7a44c9-40b4-4317-bb8c-ed0c6374692b','937307b7-77a1-4c18-b39d-52497ce04325','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('3d1b5e8a-1022-4bdc-91dd-91e467e48e4b','81e09c1d-5582-4f0c-904f-7040d61a8065','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('3d91f3d5-019f-4949-b3af-2f4184224efc','4ab4dbcf-808c-40dc-8c83-4cdd485cb824','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('3da1a9ba-a7b1-4cb7-8e44-a7762573eb9a','18e97a03-bd4e-4c8d-b371-caf2aa519c4a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('3dd9be81-4573-4684-9a52-b6a07e00715b','c53a5482-4ee2-4594-b493-51ee1647f326','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('3dddfba8-80bc-487f-9bad-17f1c4c93800','a3b6dff9-fa3c-400b-a400-c7e4752daa5f','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('3e5a2f8a-ba9a-46ae-a810-bb6690e796b2','ec4a3599-7dc3-4c40-899c-2107783d5b56','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:22','2016-02-26 11:01:22'),('3ec899e2-2edd-482a-b351-39211e6f0696','d91bebac-42ab-44e7-ab1b-53b2233bbf0d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:44','2016-02-26 11:09:44'),('3edffe25-a25a-4049-b003-293093580376','fb451be9-2960-47a8-915c-cbf6d1ecf310','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('3f05229e-dbdd-4d90-8294-6ce60e50964f','06f6eedc-94d9-491b-b1fa-6aee4daabb61','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('3f079813-b240-43be-b9d8-e11410ce4ec8','05e227c8-b114-44f3-afb4-40e22fc9657c','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('3ffee768-7958-4c53-a9d2-1fb42575b450','d2d0d579-c000-4d84-b023-7fe3b4c50ff0','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('4231c2f2-5665-4d0a-931d-f5f0ae3b200f','1cc9c89c-b244-427a-b2d4-0a303d6ffed8','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('4237e0fb-abd0-4712-bfe7-04c4a0fe0038','cb1a6b73-6ede-48f7-b489-13910b2aa693','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('435d179c-4379-4a02-9a81-06fffa6e8a78','b7c5736e-ee3d-416a-87bb-acbed2c08945','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('435f650d-8a1c-40b0-a983-8a19da557fa0','f8bb6ea9-bd05-4ec2-b170-7b5acb4b3f20','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('43d78cae-1e89-4bd1-9e4d-6e1705457071','f552f643-757c-4917-b4be-edb956b5a03f','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('44143354-73f3-4446-b317-c3a665c7f63d','d850de98-5183-4def-ae98-6dbbd7e4c0af','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('4417817a-7532-43bf-be22-50e98961db4d','870647a1-b3b4-4ab4-8985-64c49d7a7c32','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:26','2016-02-26 11:01:26'),('447599a1-5fe8-4791-989f-0c3fb45706ec','b129a6d5-fce4-460e-8897-ba04b05cce8e','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('4594c728-3e49-42c8-b747-540614652a85','44c27617-356a-4ab7-a4d9-13336c0d6723','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('45bda3b9-968d-4f83-8016-815671f263de','707c9a98-9932-475a-9cba-0e858ba403c4','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('46638c93-37ce-46a6-bb26-6c7072a73c38','83a0c8c5-a3b4-48df-ae02-8307de8b011f','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('47caf4b0-4869-4796-aab5-c16b0c29d8d8','4a11eea1-c9de-4166-8cca-35c352d988c9','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('47ef2975-8032-4594-9a85-5cd85651cd2d','201cedc1-eb34-4a5f-a9d0-757528b31b55','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('4831c209-189f-474e-b2f5-f75c939519ff','6dfa0f72-3b4e-4d6b-bb28-fba28c8cf281','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:44','2016-02-26 11:09:44'),('48601d0a-5621-49b8-a256-a204c9101c7e','3b8dc94d-5aed-4661-afae-12c215ff4c3b','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('48744136-be61-42a8-a575-2685cf8d4724','337f264d-c6f3-47bc-a94c-83dd3362b860','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-29 03:18:42',NULL,NULL,0,1,1,'2016-02-29 03:18:42','2016-02-29 03:18:42'),('488a44f4-b2c6-4b22-8a53-43529a995c0c','fee5b020-97ab-4650-a940-2864431fd24e','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('489d96f5-8c02-4eaf-a674-63edbdf93542','bed49f42-d388-4aa5-a5be-ad11e03027aa','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('48db4d76-e2ee-4c88-a0c5-d79bc91bdb2a','dd748113-4369-44a3-b96e-cc5de5b2f2d2','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('497cec44-5500-412f-b65c-d7e25aed4007','d4d26cce-81d3-496e-adf5-6f8f2ba06d15','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('4a9fe071-a123-4bf9-833b-e7129dadbbbe','b5a39731-003c-498d-8fd1-b7af98db0f63','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('4b3877a5-abda-46ba-8d32-f042913ff79a','232fbcc3-ff66-4cf9-8efa-803f6a2bf3f8','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('4b64fb32-d5c1-484f-b4d6-679a08ea048a','a7e145db-e002-478d-bb37-74f2acb10881','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('4c004a44-5520-4024-b9c2-0aa82e4680aa','045fb830-8e13-4ae5-81de-625a8a73aa3e','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('4c43bc85-71b5-45c9-bc9d-837eff9c4e3a','8d3411e0-f9b1-417a-941d-91584965754b','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('4c57005e-1e6d-456a-9a22-7123d3cc9ae1','88a7d54a-9f2c-4d41-beae-98d39f42280a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:04','2016-02-26 10:03:04'),('4caa2c3f-5a96-4ea3-93ee-b127e6a1b455','bfc900ba-4886-4ee9-afe1-92fc1dc53f28','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('4d060eb1-4c96-4782-be25-990ab33d02a8','4a1a4ea5-6384-4132-959d-013a84b91179','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('4d0d9f7e-b980-487e-b5e9-872f804c8c15','46f3dd17-f830-4a6b-a2f6-e4180e4e743a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('4d5d3384-5f4e-467b-8e07-c999039592a6','05961d2a-6b09-4dec-baab-4db5e91d4042','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('4d8827dc-5b27-4bed-adbb-d7d9df2760b9','07cecae4-09f7-4602-a5e5-046ddbc296c0','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('4dadee28-3b6b-4edd-88a0-4584dd569eba','08753c42-f6ff-4539-8fbf-b763b63a00cd','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('4e62a299-7fa6-4fe3-85fe-dee042e6464f','a9ed8e74-0d5b-4741-a4dc-5a871c5a7f89','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 09:41:15',NULL,NULL,0,1,1,'2016-02-26 09:41:15','2016-02-26 09:41:15'),('4e9a781c-1eb5-4459-a252-a6a214c05b2a','7c6320c5-0175-4450-9042-9b3dd805e32c','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('4ea0767c-6384-4b77-82a3-fcec31c45594','02d0598b-4c86-4255-a7aa-00dc107f8020','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('4f18271c-df46-440a-bd66-662419f41d32','028237bc-afdb-4ac0-8cf0-b5d4cb2ef77e','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('4f71b9c7-eca6-42b8-a091-103381e6f040','228cfec6-d59d-4232-8c5b-ac4b5c0bdb19','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('4f8123e4-ebd4-4470-8860-449ecd41adac','4eb11d2f-dacf-4051-82ba-d3e205dc5484','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('513c9cd1-6e44-4295-bc4c-5ba3bb0b2717','8249b242-65dd-4b8f-9816-149bc835c5bf','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('5265b4a1-5479-408a-b128-4a7c6a685bb9','054be186-5b08-4c28-b794-765710558546','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('52b99a30-af4f-4747-815b-7d2681ea7fcb','028698aa-0b0a-43a4-82c9-7e596340eda5','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('53f6f5f9-805f-4ff4-a4e6-06167392cea4','e25348eb-2499-403d-bd7f-235fef4bef03','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('54081666-8e4b-47ab-9613-ac8e9cf92ea2','54b79f03-eacb-4118-bae5-c705b4b43444','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('55d1c4a1-61ad-48ed-b4fa-7be4477eb125','091aab29-2e9e-4f54-9fa3-0d27322027b7','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:22','2016-02-26 11:01:22'),('55ebbf3d-3fc8-40a6-bfe0-8ee6580a6034','ce9d096a-43f0-47e3-8481-97a58e6c4dec','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('56370ab8-1abf-4fcf-921b-6607b003ab32','0abd25fe-d5b5-430f-9e2b-a89c3078299c','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('578c954e-d72e-4e39-a977-d9304e5a03dd','9f186cf1-c06a-43e5-81d6-c0844d8f2a06','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('57c5774a-77dc-4bf9-9598-c8ec28bb188a','8fc84d0d-db62-4327-bc60-b0d5cbc32c18','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('58d8577f-6403-4d41-95e3-eab5b48b16aa','51d17432-13a3-4847-a1b2-e10ba5d5ffb7','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('58f49cd2-2af7-422a-a175-1da1176b5f00','9363e9e0-b022-44a0-8b03-9c2787449753','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('5a45bd1f-8a71-4d21-bf22-d1a6d4af92bc','08472042-46a7-4b64-9fde-be8f8fc9c1cc','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('5a4ebc5a-54ee-4d2d-95c9-bce31927f082','502a54e0-8dd7-4d77-b0c3-a480a86a0a81','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('5a5735a5-563d-452b-89de-6b752e332982','1f134a42-eb31-496e-908a-82d0dca9cfd3','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('5a576d1a-1cbc-4f36-986c-bf7aa6107e8d','08d82ae5-56ac-4c8b-bf7f-f8851d64ff1e','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('5b635215-4438-473a-818e-4a149f37fe4f','b3d0feb4-1efe-45cc-9cf9-c85ff7078631','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:22','2016-02-26 11:01:22'),('5c8fbf43-9729-4ba8-a1d2-0dac3c2ab239','740333fe-54f8-4651-ae6c-9882d9459285','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('5d1d4c4a-6659-4505-89f6-56bfb60a76f1','ed5291f9-a5d7-461b-87ff-218241246290','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('5d4b8552-9712-4582-9656-4e5b207f1a7b','0aa53042-affa-4ae8-a76e-e86532138578','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:04','2016-02-26 10:03:04'),('5d6c2837-3978-4714-88ba-14ce44ff15da','a3498054-25f2-4d8e-99f5-0a6944eb93dc','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 09:41:15',NULL,NULL,0,1,1,'2016-02-26 09:41:15','2016-02-26 09:41:15'),('5e2bcd73-2ad0-42eb-9c26-098a9014c0fd','ccc2ea8b-3248-490a-8a55-65dd4f4e4529','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('5e84290b-cfd5-45f9-a52c-3f379737450b','d424720c-f44f-4a66-9315-de60750dc985','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('5eb52190-499c-4390-a677-3d16d3f0216e','fe0bd226-dcda-4657-b5f6-0698ee2a69ea','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('5f7c8ad2-dc84-4e46-babb-e1a8dc23fa35','a3f6d8ae-639f-4a82-8af1-21123a324e60','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('6019e951-5ab8-48ae-b189-105cd86a96ee','04ce68fa-f2f7-4b6a-92a1-a097ffa6b590','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('6041cc93-cb52-49d9-a32d-5810830beac2','8525281a-2194-4050-9d05-6e6299c96897','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('604ae1a8-f7e6-4aff-9b0e-719d64b33bb4','fb7678b5-d8cc-44c1-a843-c64ca81896d5','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:50','2016-02-26 11:02:50'),('60cebd2c-7168-44dd-a82e-1f97239a725c','51821fd1-cdec-4718-92a5-efc126cc640c','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('60f78826-667b-4dbe-8ffb-ffffe1fa5312','e24f971e-220f-42b4-96f4-636e6958cec6','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('628e7ddb-1736-4c4e-8871-f3a6b88e7e4b','7dd31e1d-aa8a-4a18-95d2-bb0657fd4de8','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('6318a5d1-f35b-48d7-a90c-a3503ca849a8','f2aad934-0f61-403b-8497-bde25aa95a33','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('63d230b6-5e41-49f8-8a34-4ce21c861522','2b0ee4cc-9817-4f44-9284-07a74a05fd11','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('63d96662-b333-477d-b85d-9acf2e381b40','64a6ac15-1db9-472a-8c1b-773b1d776333','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('63f7db7d-bb02-4a57-a9e4-2361d52f1e39','620847ac-23f8-4e51-ac9a-a7c261c64694','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('644ed944-337d-418b-9a5c-e6e1d29c6d43','46d19983-a7dd-45be-93c0-12075697b7cc','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('645843f0-0dd4-4bf0-8b38-7273b39bf254','0a4330cc-61e6-4498-9727-679801b05a5a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('6598b4bf-1b13-4d74-bbc4-9b325bc33adc','7d0946d3-bc70-477c-884c-af0b2b5ae4d4','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:50','2016-02-26 11:02:50'),('65bab760-fab5-4590-b594-14c47a5b792f','83ec0be8-7d1b-4123-b869-09d6ec3e5a5d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('65f63336-04ff-4036-a75c-657778d052b6','c870cd47-aba0-4c08-82f1-f9297b0e5883','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:44','2016-02-26 11:09:44'),('6650540e-dac3-4da2-be66-d458ceef47b0','b0b4cc6a-f5d8-4542-8a96-b62e9285499c','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('6666979b-1240-45a8-85ea-6452418e40ea','4e266dbc-ed97-40b9-a0bc-e2f7d0250497','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('66c44696-d9f5-4faf-ad4f-ae201800513e','c1a94232-c515-4e62-82f0-bc1a3fb91ac4','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('67172c30-f22c-4dcf-8556-81c12a576bc2','e0d758ce-c4ca-4f27-b49e-b04d592ab815','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 09:39:43',NULL,NULL,0,1,1,'2016-02-26 09:39:43','2016-02-26 09:39:43'),('6799cc39-f083-4cb4-aad4-0899223c5279','4e2c8b50-c8a2-44c6-819f-f6a3d05ca3de','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:44','2016-02-26 11:09:44'),('685abd3d-a134-4c44-9cb3-95ff54ed4d8d','50f1af17-e815-4ae7-98c0-9a6aacbe5a2c','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:50','2016-02-26 11:02:50'),('6870cb3e-0b76-4de3-aea2-daef0586f1f7','d80e2572-fe2f-4635-b724-3f03d719cca6','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-29 03:14:18',NULL,NULL,0,1,1,'2016-02-29 03:14:18','2016-02-29 03:14:18'),('688b8866-cc89-4100-912d-531812724bf1','2bec5738-b6dc-4efe-8cdd-cb7aca9cb9c8','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('6972f52e-6d7e-4545-81a8-1eb68afe68c0','7435c215-45e7-437f-8f3f-d0a71dab5b61','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('697ffd4f-5ede-44e1-97e1-159ef43822e0','c4d02dcb-e58c-41df-89f4-694c273a6519','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('69abcc3e-4d74-4197-8c79-ddf7f0e01bcc','a56b7525-b12b-4cb7-a33f-0e332537d12a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('6a05529b-87bf-46c3-9536-4898ec378cd1','6d55b88e-56b5-428c-9a25-b0cd639d11a0','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:26','2016-02-26 11:01:26'),('6a05a780-2f39-4116-b7d4-e88e0edf5692','5c1f6392-fb07-427e-b0d8-a90d128ab11c','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('6ac5e2db-6d35-4a54-a654-13b32c213b64','3de4a517-6a90-4bd6-af03-a5ff9462b89a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('6ae61226-74c7-46ff-9e24-f305dbbc9ef9','7010232f-64f9-40dd-8c2d-ec4ca3d91bb6','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('6b319487-8291-4688-8116-0028e77b085d','2f9e5d47-58dc-48d9-ae77-7fcc7257f0e9','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('6b756b4b-f60d-42f1-a5bf-8182be3938ee','de97dfa1-cd27-470f-9803-e382c6d30d4a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:44','2016-02-26 11:09:44'),('6c9df665-b1d7-49a5-a4c9-91670d264c15','c5effce0-b261-46be-9d4d-10cf555ee8b6','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('6cb8dc87-b043-4486-af74-e49eafa634a2','05fcf3c5-61cc-4dfd-a33e-7299b4d1ab11','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('6cf83020-a488-4c52-aaad-94bc3cacc878','e8ba83d6-a2ef-49f4-8deb-45ccd06a5a58','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:40','2016-02-26 11:09:40'),('6db45a4c-659f-4fd5-b525-561811ab44a2','6a80ca2e-17b8-4932-9635-c7577158b37c','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('6e1cbbc4-e147-45bb-baf2-01af705ecb2d','42203ff1-6309-4e41-932e-28db9b8dac53','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('6e69d751-c326-439a-b11e-72b68ef1a691','862886ba-41b3-44a6-ab9f-a63d53fdc162','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('6f1576e6-404d-4e52-a626-ab3e5358fc74','fdeef4a4-9bbb-4193-8ecf-34ab4f403fe0','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('6fbb49ee-759b-47a4-806a-ed9dd1d7e383','4f2e12ac-b249-484e-bf7d-d8d47f653d1d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('700ca70d-0716-417f-9c7c-4138107b88de','5a3e6dcf-1a19-493e-87d2-c4c74bb1eabf','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('70455a30-6ecc-4e15-b4d8-7e2b6f0df507','56ae331c-a8f4-40eb-8d15-929852e1b710','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:04','2016-02-26 10:03:04'),('70594ea4-90ed-4e4d-a91e-8bcc7c63defe','8534789d-365c-4d34-8394-fb26907c4dc6','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('70991bc2-8fd6-4881-9acd-677bed139e57','d28bc51d-b53f-46d7-9a66-df1378d1d269','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:04','2016-02-26 10:03:04'),('7126b08b-8389-4253-8cb1-6d5a8cd9a9b5','0a454099-58d2-401e-95f8-97aa53fd9be2','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('717db0a4-9667-42a5-b9ce-ea3cf54d1e28','ac54ed3f-c09b-4c22-bb50-537b9d8969af','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:04','2016-02-26 10:03:04'),('71b7a253-fb1e-48f3-8f4e-57adcf2b9259','337ffbe5-7061-41a8-99c6-8197fadbf1a4','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('71c01bc7-b22e-4249-9fd9-b5937b6c65c4','aa648470-a492-42ad-83fd-90afd12102fb','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('72069146-f735-4352-b462-339a56e8f803','58447913-487c-46f6-92ac-0242dcd39ba1','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:40','2016-02-26 11:09:40'),('723e258b-192b-4182-9802-8d90baa372e5','0dafea7a-c72a-44d6-a86f-bd4ecbbc1691','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('725788bc-fc44-42af-9c21-e1b5aec7fb57','a57da593-fc2b-4acb-ba8c-4282edebc9a2','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('725a7346-2a59-4ace-99aa-2bf04ebd6e52','b8fc2624-8d60-481f-8f1a-b0e531a0b6f5','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('72716f4f-2656-450a-b22f-8e135a781b60','581a59bc-0e52-4d6c-a9d4-65a199279f2e','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('72f6fdc4-ac45-438c-9985-d129a0dfe76c','2920ce48-8d64-4f5d-8509-915185271942','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('73567cd6-3524-4a2a-ac9a-82239e51a352','918ef821-890d-4b5c-9f0b-01fef89342b5','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('73f76c95-40dc-4dff-8bf6-69da25ba3e95','6830e6f4-6711-4b50-b8a9-c5a4a84c3c6d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('7480d971-ac9b-46c0-a8c1-673c408cea23','99caccae-13f8-4994-ad68-3ad928fa950e','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('748f4ec0-1cf6-432e-abbc-d0c306db5ff2','72cd9057-6368-4621-b009-f1e47e501d5a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('74db7d30-df78-4364-bd54-d283bdc3e5f9','f0ea8e0d-e48e-4947-8dc5-9d25d71f9c39','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('75080af2-5dd5-46cd-8c65-1e3a32dbae2f','e45b5949-5b5d-403a-b6b6-3c5746ccdccb','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('75bc688a-876b-4eab-ae9e-2ca874016c2e','abad2671-0a32-4294-8d99-59915bf08ea0','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('75c71ee0-b648-4287-994c-f96b045a206a','e6425c1b-c115-4481-b29d-2a8389d49a23','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('75d4935d-bfbf-4f23-bb30-5593183d02d5','594ec22b-be2d-4765-973a-2d15b1517614','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('766b8a03-94af-463f-af70-a0618e1f311d','4fa5d4de-fc76-46aa-8328-1da7ecfd3d76','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:44','2016-02-26 11:09:44'),('767fdab5-1551-4fcf-be34-cc8574f7ebf4','78611270-015a-4466-af83-2b4bae24223d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('7758559a-38a0-4150-89cc-a92beadbde92','df7e57f2-f27d-468f-b7f5-5bf3db7adefa','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('786e501f-592d-4f22-b750-927d5aba7c5b','33571289-0b4d-49c5-9ad5-06ef01922f9a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('789f7d85-a5b5-411c-a96a-f678c0668d9e','0edf5866-a46d-4a60-b0b4-6410ef34921f','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('78a0c7a1-c352-41a4-a34d-09af4e489bcb','e9c3fc71-623e-4580-b097-60286b28a9f6','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('78f8d590-d216-460c-a5d9-b3eadb0e58dd','4c761795-06fa-4a0c-b8c4-af8c81400bba','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:57','2016-02-26 10:14:57'),('796a0383-0179-486a-b710-e0f3a1079538','ea0cae64-b733-49f6-8f18-99e1c0006782','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('7a76a630-b437-432c-b822-0517d299cebc','7fc0f6ef-aece-4ef2-b86b-2d495a94c6f9','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('7a7a54bb-ee7f-4c38-b696-2fe5d859e089','c12a3ea5-11a3-43b6-92c3-e065c34f4f02','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:04','2016-02-26 10:03:04'),('7a964a9b-8154-4e30-aa3c-9ef91c2842df','7251b4a2-ebc6-45d1-9ca2-4cd51f1f1dd6','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('7aaface3-291c-4179-bda3-dd93390026ec','966dabf2-73f7-4db7-ac7e-5163691551a2','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('7ac319ba-712a-47cf-b26f-6fa54f22262d','111d24a3-6cd1-4280-9caa-54271d5758d1','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('7ad05980-e26c-4c68-b997-39dfd1d15859','b56cf923-8242-45c2-842b-222cf4647259','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('7b1c7670-9a33-44b1-a574-3ee8a7878ab4','f3070f48-263e-40d5-a29b-c1d1796b70b0','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('7b511cef-a7c7-4d4b-aa34-ed6a1e51eaea','9b2d5625-c702-47b1-8a6f-aba01d1cdbc1','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('7b592874-efd2-4ca1-a4e7-72bebfb41a1a','b2c8e848-9c2b-48ac-829d-1513071bf2ba','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('7b82bf46-9b12-4269-b329-e193d1e52fe7','1ed3c8af-2484-498c-81d0-75baf0be6888','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('7cedf7ce-1fd3-483e-aa50-f062a81aa37f','20f29380-499c-47e7-8e63-60f0446d8676','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('7d335169-2328-499d-b357-de04e7af80a0','afd27814-2c9e-44d0-8cd1-23c40043c83f','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:51','2016-02-26 11:02:51'),('7d63e2af-a9e5-404f-beb4-12cfd45c94af','d56441d3-ef5b-486d-a558-19ea7988f2ec','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('7d7d5adf-321c-4bfb-9f8e-22e74bf552cf','fa0f3d39-3f52-4fde-9146-685801c78c9a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('7dc57a38-8aef-4155-8067-59d6ddc47098','e2833c1c-9017-405e-8385-d1b9eaa1af1f','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('7de6cc02-23c9-45e6-90f3-9f3a23249e42','bfd86766-46dc-4550-8cad-78d52c409aa1','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('7e152f95-a181-4b22-8137-e66768f5397e','b8a8ddb8-989b-4e24-9b06-639c43795305','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:04','2016-02-26 10:03:04'),('7e5f7b2f-4746-41de-a1e6-d71118a49e11','963a6504-8fa0-4f2f-9909-1bb65d8e555b','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('7ed6f85d-d0e2-4f09-a7df-ec7f3d89dc6b','8e713f06-46d7-4d8d-ac28-3ae5193d0d04','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('7f3ff8e8-9606-43d9-973e-24cb9ca4c440','4f66a982-5131-48d8-86e4-fab472e65f86','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('7fdd063b-23c3-43e9-97f8-df08fbcd755a','d64cfd24-0984-4b3d-ba25-b81e71ca4084','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('801be11c-d5f8-4a6d-a8dd-c117f27b2c9e','f859cb7e-0330-4fb3-9f89-946974d36484','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('8044bde6-03fb-4bdd-97ff-b9c2251f1b6f','00c1bc07-f052-4153-a656-ce31f511f96f','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('807568c2-2f5c-40f5-af63-63afe31c33dd','9f40d4c7-ba48-4850-8914-d0072abbf0bc','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('809af5b7-c7dc-4a5c-a28c-54ca7eec3268','5af8af8d-7f51-47e2-8fe2-b33228e8e363','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('8106493b-3e84-4758-81c7-4442ab437142','e45e3977-909e-4e4e-8f79-48c480566e54','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('8131d84f-b241-4695-ad97-11fd6d0d8413','9550dfac-1ade-43b1-a267-0faf3b8b5d2c','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('8165006a-734a-49e8-add5-39f34f4b8cec','4bdfdc65-fde8-40e0-80e6-5e45cfa20e79','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('821be1c6-e15f-4928-ab1d-0961a2e1b109','bda5391a-8ceb-486f-bdd1-08bcfb5f65d1','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('82f9a423-52cd-4381-b74f-4eefb9e86671','99384f49-7fed-413a-81b3-d696df2cc2b5','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('8368c4c9-f8e5-4f93-aad3-f90bfea42cb7','2b22077f-6d2a-4642-992c-4122fa88e557','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:40','2016-02-26 11:09:40'),('83f843d7-d393-4cd6-b20d-71e6c9eb6fda','be69791f-0166-40de-a19c-2dfd410eab06','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('8426944e-6631-47db-843b-e0e0c3ed8fca','bca8b062-2362-4271-a66c-9a48e2cb68e3','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 09:39:43',NULL,NULL,0,1,1,'2016-02-26 09:39:43','2016-02-26 09:39:43'),('8501bf4d-ec35-4422-a679-0146f6fab8c6','4bbf4100-59ff-4d33-b0ce-1d2aa2551106','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('8506bd47-a425-466c-ad22-8692bf2d5484','eae316da-f95c-47d8-97b9-27f093c2be7a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('85580159-c52f-46b3-be34-93e955dc2038','9170abce-b4a3-43ba-8326-b8e2ff7554cb','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('855f64ae-88a5-4d9c-9849-2c869df3591b','f4d4afa5-9eeb-434b-8072-e45ad6fb5fb9','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('8729e948-7a0a-448c-bb75-e883fe5349dd','dcc91079-9794-496c-9418-4c6a241cd1c0','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('8784a7cc-fe82-4203-9e74-351b628d0110','9f45ffc8-4faa-46f5-9b0d-7d01b3ca1a68','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('8813f53e-0390-4491-8192-285044aae9fb','e9380219-4550-46cb-924a-fc35a08309a9','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('88c3984a-b962-401b-81da-c6c7d786cc89','22572808-daf7-44fc-9d65-a4dfaf77fb61','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('88c5fac1-f670-4671-8e0e-edbee4222554','489dca8c-05ff-493a-9bc3-38c87bdf7fce','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('8951c90f-dfd5-4bf7-897f-2c4d6c45a7f0','47f51b7c-e955-458f-a24b-ed51c5ef8e33','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('897deebd-f70d-4d79-ae51-d92e0a04dd71','a012815f-c92e-49f7-a2e2-0b382bd7956f','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:44','2016-02-26 11:09:44'),('8a12f048-ef95-49b5-8e77-46c14fd2c82e','8aff7f21-6f44-40dd-b8b6-45e0f7dcf193','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('8a69cb57-a057-4edc-bc30-60ecb05730db','219f7f61-7143-4c4d-9fce-c5492ffbcf1d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('8bb1bad4-54ce-4c6e-9ca5-a26dc32eccc3','3c117e0c-0215-4471-a2cb-26d128f9be69','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:04','2016-02-26 10:03:04'),('8c023b51-84ea-4d42-8186-450694cb5624','5fcebce4-f04e-422d-920f-843628e1dc6d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:22','2016-02-26 11:01:22'),('8cca5e78-f2d9-4e4c-b844-96c640d78943','194fd54b-98f3-4c95-b077-1ac72388ecf6','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:04','2016-02-26 10:03:04'),('8e01dc5a-eaf7-4c0c-a2b7-494de8b63647','b116eb01-df7d-460f-96f6-c753d4279309','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('8f0d707e-bef3-44bc-abba-3daa52061ac4','91aa80e3-3f72-44b5-8ab0-8e76fc7694d6','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 09:11:04',NULL,NULL,0,1,1,'2016-02-26 09:11:04','2016-02-26 09:11:04'),('8f14d062-122f-4158-b4f8-bd5a5eb468f6','66480ef0-90af-454b-bced-914c6bd08563','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('902f87a0-f2c3-433b-aae8-bc566309d61b','f9dabf7b-fc7d-45c4-9288-93ddbb8dc198','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('909ac8fd-23f6-46b5-a15c-b219f7038335','e3cb8dc2-61cc-466d-8b9c-39d39260c4be','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('91c135b9-7432-44b2-9eff-5d1441d53799','55f83da0-13a8-47fc-9093-6c98d1cd4b0b','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('91f5348c-3ab2-4c8e-a5c1-73e8a5059fde','46c31642-bb35-4211-8d86-640b45d60904','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('93bfe9ad-56c8-49b1-bc38-427ceb153813','bdf61cda-b27f-4a40-9d1a-b9c6de0874bb','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('95a57538-28a1-449b-98d4-5dfd369e1ecd','1ab48346-6bea-4e77-abdf-def4b72ed356','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('96d06f27-44d9-44b2-bb4e-fc98cca07a00','bb4ded90-f2b4-4ed0-828d-66eb9e37b8a2','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('96e87317-23f8-4056-be86-ab928de341c9','9c7f6606-1dd4-424b-a34a-34d665bf6bd0','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('97ff82b4-f070-47aa-a365-effbbc65695f','e73317b2-806d-4fa1-aa9f-ce6bd0ad6b59','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('991e4b65-815f-4d41-88ce-0fc8cc720466','a30c487e-06d9-4c42-9e17-da230c53d20b','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:44','2016-02-26 11:09:44'),('99ff8462-080d-46cc-bea9-a65dcdc8c17a','41d5efe5-51f6-45b2-9cf2-255bb56c5609','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('9a3f7694-3c66-4db5-91c6-bfaa32093418','5ee92bf8-8bbc-4d7c-93f4-119d4dabf33a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('9ba88139-7b97-4ba7-9952-fce01c3f0ab5','293a5112-4531-4d6e-b5e1-e24119bd9af0','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('9c5ea703-68d9-4d8a-8423-9be775d7d5f5','8fa0b111-6163-405b-b1a1-413108fbd09a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('9cb582bd-0b0a-466a-9db0-b8745bc80a1d','a8d57637-aebc-40d7-a8e3-61879b2f5929','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('9cf65add-55f1-4550-a752-b084ec370441','66223c2f-42b5-4164-8a16-da0376bbb514','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('9d036f99-7525-4797-90a5-3830e9f918c7','cc7dae36-0138-426e-ab5d-5624548f387d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('9de00e14-27d1-41b6-a4e5-78926f4eb97c','e151da04-2b85-47ac-a991-f4c244b7e4fc','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:04','2016-02-26 10:03:04'),('9e123529-671b-4203-a8c7-7aa43c3d2f2a','b3ee7302-a1a2-4c38-8a5e-98d6ed66bc88','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('9f74e812-abce-4a8e-94a4-f802cd528d23','32f93285-bdfa-493a-81a7-090d4788d78d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('a094073d-f68f-494d-8182-22546de1a7f9','4b773a3f-1937-472f-8b05-46c243847cbd','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('a119095b-5ef4-4815-9510-0c4cef961a9f','383079ec-509a-4058-9d19-60e3bbf0ff47','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('a1e364d4-225e-4390-8f01-dd1f8d6dc227','29c3ec5f-bcb5-4193-b21d-2563bbf04a76','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('a38238d9-70c4-48b7-bf0e-9d3fd225f5e7','09f0e7cb-5051-4751-adb1-7ef0c086d5ce','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('a397f444-506f-47ab-8019-42e0536130aa','8459fdd8-0040-4164-ad9d-878875ea4a28','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:22','2016-02-26 11:01:22'),('a3f2706f-1a24-4dbf-a56f-3df3aed9ad10','fe01defc-2a2e-43e3-a546-56d6847b9cca','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-29 03:14:18',NULL,NULL,0,1,1,'2016-02-29 03:14:18','2016-02-29 03:14:18'),('a4e746d3-015e-4721-b807-5f2c79ae8655','404bdc51-ab29-4d3c-bcf9-a0835a17719d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('a4f268f5-337f-4b77-bacb-08c8530bdb53','ca9ebb4b-63a3-4894-8e59-e51d6631c4e1','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('a688e832-2ed8-46de-aa9c-c23d5f9c34d0','6baf23d1-ac85-4d13-bf14-7cb79f12a103','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('a6cb405d-36f3-45c8-a357-6b3968b3ea7f','b3067020-f212-488b-b9c9-f32baf3adce7','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('a7aec17d-75f2-48a8-9f68-91f82eb0b7ba','5b35e39e-5fb3-45aa-a993-aceb72520e17','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:50','2016-02-26 11:02:50'),('a7d0cec5-a546-463d-bd75-4df0f68c0d3c','2f19dc33-ad88-4aa6-80ab-d0ad0f7aea14','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('a84c029b-b2be-450b-9b20-967e38cf77e3','55d6eacc-07a5-44b4-be33-22f81d8003f3','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:44','2016-02-26 11:09:44'),('a8c0b941-dec3-4527-82fa-9655c5630865','1fe143cd-6b24-4302-811f-546e9b80a1d8','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('a911bb28-8721-46b6-a06d-1365558e310f','e5356016-2ea3-40a8-8081-72f641d31d07','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('a9645039-eda7-4cb6-8c3d-f5d3d6040ba6','71f479c2-b8ad-44ea-a4cb-93ce46696fbf','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('a9731369-9d7d-430f-95db-2252a2349ac4','8cb73872-eead-450a-bd30-679a81aeb253','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('a9a14459-ef06-4209-8e43-bb5976451922','9b0d6c0d-4d91-4c2b-ba44-45ce599df730','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('aabd011e-80e0-469e-8087-09de1b3dad86','096e3e3c-0eed-4cbd-a365-2dcb8842d855','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('ab014182-1b8b-4850-b3ce-17cccb7f816b','44948e48-b1ca-4df1-b1d9-d92a079ad572','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('ab43234b-acaa-4f07-8850-af9d2d43fe36','d1561924-c525-4a51-8efe-39b3754962cf','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('abe42e39-cd5a-4dd1-bb9d-40c1ede0256d','49ce20b8-0bea-406a-8088-6a1acc6dc2b4','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('abf9dd05-5d3a-4fbd-8ce1-7a83012433d2','dc96f595-fefc-4916-9854-91edafdb5554','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('ad724968-1d1e-455d-af4f-47f18e9e83c2','a37dc041-736a-450e-b49e-8be978e1d659','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('ae0a0d8b-a393-4884-ba34-6f0c25651a5b','3ddbc15d-0e73-43ba-b411-0ba2d6087489','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('ae891154-827c-4443-a8fc-ef7ab0c79466','8ee70443-8197-4470-a31c-527162d30b3f','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('aefd471a-1d24-48c5-92b6-6c39da73b993','13b1cb1c-adc3-4725-89dc-2f7e510e107c','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('af952867-db08-4d89-bcac-07aab3439658','e709a1c4-117c-4652-9e1b-afc6e9261643','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('af95c23c-55aa-459d-8702-c2b199a822d5','2884dd9e-b0d5-4d1e-9ea6-7ab25315d07b','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('b00029e8-5694-4053-a78e-a85be12b6796','551adcd3-4b2c-424b-a42f-f7228e1ee380','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('b0b9a19a-913c-4c70-980b-e0c568baff63','3a931102-c905-4f4a-8de2-0b09bf0d03e9','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:51','2016-02-26 11:02:51'),('b15b8742-7c46-4414-9298-8aa306482f91','42c7d403-32ca-4f41-bc24-57a47f0ed8cd','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('b1f358a2-2ac2-4d79-9de3-9e8e344be607','29eaae6d-6975-4405-bb6b-bea3afa280d3','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('b2362f99-d2b7-42aa-b6f6-3eed21de3acc','2088dcca-5f71-402e-b0f6-10dcef326726','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('b33be77f-5c05-4589-a385-cf4e1fdb3ff1','defcabd2-46e2-4c57-9766-71e45a161126','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('b46f3c18-9bf9-4411-967d-9297dac7e83c','771689d6-a9d6-42db-8fdf-13b875918094','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-29 03:18:42',NULL,NULL,0,1,1,'2016-02-29 03:18:42','2016-02-29 03:18:42'),('b5825a54-1b7e-48de-a74b-aec339468801','2421891a-186e-44cf-9dc9-5d1c1aa0d708','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('b583c03b-9393-4560-be53-54b69a320ac5','03f89100-5d4e-4693-94a6-1c8d3924c4ae','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:40','2016-02-26 11:09:40'),('b59c19a7-a7de-4112-9835-93761a956c55','8f2ea9dd-7f7c-4908-a701-db16a35d7ef1','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('b65a85e0-fecc-4afa-95ab-62fa9cca8732','192afa5c-31de-4886-8034-dd1286d941f3','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:44','2016-02-26 11:09:44'),('b6a8ec22-a9f9-42a2-a6ca-696568be4d9c','eff19474-1bbb-4457-8b6d-97627268e09a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('b724433e-2e4c-418c-9778-d68ff6b0d8ad','e2e653cb-4e35-49a3-9948-4eb41695ef19','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('b74470ea-782a-4777-a531-e64e768514bc','e971985a-76c4-4aa2-894e-a09b3556de7a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('b7ae18c2-108d-43ef-acf3-84c6a98c23ec','c24d4e7f-76c1-47db-a1e7-e39bdc881f4a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('b859bbd1-6b68-49ab-a0fb-89a88ecb2cb9','a7986e1f-d748-44e8-8ef4-f319299235b7','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:50','2016-02-26 11:02:50'),('b88a0322-7b6d-4cb2-9a4d-a9319086b479','dbfe5b06-1ea0-4e1c-9d53-5584f8c929ca','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('b95592d4-cfbb-43c2-94c8-7ad4e91adbb8','7252658e-e449-4bac-b058-c34331320e89','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('b9875551-f941-4853-beaa-db2a111f5117','b41e272a-0426-4c67-a447-d76cfb68535d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('b99d16b4-27c2-468b-a3f7-a3caf0857b59','1f90f222-6dc8-4a7e-9e94-3db65a85e7d4','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 09:11:04',NULL,NULL,0,1,1,'2016-02-26 09:11:04','2016-02-26 09:11:04'),('ba3021ee-5b7f-4fbc-8ee3-c9b0806354f8','aa0f4276-1dfe-4065-8cff-3977334159e9','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('bad215a3-9621-4d3f-861a-c38a07d2630a','fe40de21-8fce-4964-9e1a-708e5f12e873','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('bb2ed4fa-60f2-400e-b289-7be700d2a5eb','b8caf237-1f75-4a53-b69d-e6a546b0ded5','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('bbc8de42-1b4f-406c-8fd5-140ebbe3d49a','b5cdb860-f562-4b3c-a177-2cc43e73b9a1','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('bc5641d8-921c-4d5e-8cb1-968db525d7c8','c673a3c4-351c-4280-8f60-c851c2bdc772','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('bdb7d8ca-0bbd-4acb-8d70-899954553718','b45fb1cd-f01a-424c-9b20-b069c7b8e2d7','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('bdbd2243-316f-41d4-ad66-3bc7428eaa02','9c5a8300-2898-4ac7-a8f7-89d92145fe92','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:26','2016-02-26 11:01:26'),('bdd10cc3-4c43-49b2-96ba-5cc188c30dfe','fcae0623-18be-4d8c-9a2b-1ee2c9c640af','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('beb71b11-bee8-4950-8bd9-b73c1c4dc4aa','7a10d2fb-1d30-48ff-b4be-d5012379d173','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('bfd9e363-e8c9-4b86-b11d-40e24112fc2d','07dc21db-f9e3-48b3-8040-ec58f6a795ce','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('c018257d-833c-4dec-830d-04ef0cb20c41','51c24f38-634c-4964-a9a0-12e3fad7bba5','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('c0ce94c3-99a1-4dbe-8db1-e73195e311b0','61337c91-2a8b-46d8-94f6-3df2559a446a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('c225af3d-b34b-4d4d-824e-bf0fe5e9ca9f','f6acbb42-b9b7-4a51-b328-2653303ee409','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('c24970b8-3836-4b55-9b45-d87f923d07dc','f97e0cb4-7d3e-4d7f-bf8d-efd84abad541','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('c333cc93-41bc-4d7c-bcf8-fc2b65ac94f2','ad2fd747-09e1-4ad9-9414-e733811edaa0','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('c3bbacda-17dd-40c9-b5f0-a426dd4b6717','00c72094-f3ee-48c9-80d5-5eecdf11602d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('c3ea89d5-9789-4cf5-901b-b3ed4133af6e','be70b37f-69a7-4c68-9950-461432250d8b','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('c501ee77-eb55-4177-8920-5a229fcc2300','d12c984f-a1ce-41bb-beca-0d907d5cf21c','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('c5a3d3ef-53da-4b4e-983a-be1c2fd47403','e5e64ad5-344e-4a43-ba76-3e8aa4e28cfb','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('c5b5c31e-89ba-41a2-a40e-40812794cfdf','d42c3ae3-588b-45d6-806e-2eb64d57efbc','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('c5f6a5ce-4e8a-4deb-a90c-2b47995f80f7','7b4c7569-c7e7-4ce9-9876-034026229159','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('c7017e9a-49c7-4c17-bfe0-9d9a7975331f','9427a7b4-a6e8-474f-b06a-7cec4071d953','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:04','2016-02-26 10:03:04'),('c74708c7-58c8-40f8-8f06-5bf3a776f6b8','eae8fcf9-3281-446b-b0a6-c332b963feac','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('c77e0ff0-1f3f-4856-9b60-e62abaa8e29f','05716f13-7d34-49b3-9795-cf56573c0fb1','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:04','2016-02-26 10:03:04'),('c7ca74d9-46e6-4fe6-95d5-77c699ca7543','9ad1ff9a-54a1-4285-a3b0-dd4d4374ddb5','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('c82a4cb6-4608-46b5-82ba-30809c2bf74f','53bf7883-4871-4502-95a7-30f79a12c89b','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('c854e4c9-96b5-40c0-b581-f3e024ac754a','0c174d38-9e91-455c-a98d-36266b22d165','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('c983b2be-5b2a-4e7c-8367-911f33fb35f9','be12dbe1-a9bb-4e8a-9a7d-2740bda284a5','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('c9a44cd7-d5f8-44ff-b477-1edf0eb7b17a','d27b6458-9108-424a-b7f2-da7366752b00','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:50','2016-02-26 11:02:50'),('c9be2f6e-e42c-4e81-84a1-7cfee9a47acb','7dbe873b-ebf6-4f73-9b9f-fd31fbf857dd','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('c9ee1635-d895-4db7-8cf6-10c055ee5aff','7c9d6eb9-f10f-4781-9871-4a1c40863629','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('ca589ee2-d069-49e5-a32c-4e82b08a4c85','83a62298-58d4-4f96-94b4-7f76007ab24b','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('ca5cc364-0a46-465b-89bb-4e0c1a001fe7','08362d2f-087e-46d8-805d-2e6daf1fa77c','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('cb651b2a-6936-4d16-afbc-55dce7e4340f','13cc1130-bec6-448c-81ad-06dd6c998e60','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('cb81a98b-c3d3-4bd1-bd67-162ef8328df3','f05b8f9d-6ab3-44c3-bfa2-2251769d3917','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:44','2016-02-26 11:09:44'),('cc548d6a-0be2-4a71-94ef-359703c1a156','2761faf2-a501-4805-a3a7-c4671311c070','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:50','2016-02-26 11:02:50'),('cd124bfb-3987-494c-83f3-2a41ec2b598b','0dc386e9-0468-4682-be26-589080a110f3','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('ce6e0b8c-81a7-40b5-9685-b5bf4fa256fa','adcede0a-19f7-45a0-bb0c-21c3f40fc6ae','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-29 03:14:18',NULL,NULL,0,1,1,'2016-02-29 03:14:18','2016-02-29 03:14:18'),('cea9fa5a-0df5-4367-a182-db1c29c42d9c','c4d18c19-bd2a-4797-a62b-69c377fef8cb','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:51','2016-02-26 11:02:51'),('cfd7eee5-410b-42b2-add1-f8f4272dd596','e9c5ca9f-c774-4e43-ba17-a3ea0d25fbeb','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('cffaf6f2-5721-4936-a309-ab44f7fe723b','5014229f-482f-4bd4-a524-dad56853d69f','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('d04628c1-3112-4125-8f99-d27828d47df5','57d55912-2841-48e9-9017-71f1e8dd1f49','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('d099acf6-7f75-48d2-8f57-488b8d0fd22a','b8c6616d-0cdb-41c2-a836-41d4f432d5f0','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:51','2016-02-26 11:02:51'),('d0e54d8a-b480-4317-925b-2d2353dd08f7','0bcd5bae-8902-41ae-96ba-a47d5d615460','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('d0f3f9af-daa6-4fdc-9674-b14f64554525','c628e195-0f68-4591-9b13-b5f6f56ffc63','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('d1c98047-fb48-4d96-aee8-16c954b1b68b','9ad8a380-9a17-40ff-8eb2-022bc2715faf','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('d2164069-6e85-4429-835f-6f60c8ea2078','69dca5be-5319-49aa-929e-a74f38f10077','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('d323dfdd-6acf-40e5-afa0-289cb9be10d3','3d143d45-794b-403d-91e5-2520fd4901dd','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('d35bb45a-5bc0-4261-84f9-d9f65c511f34','fcfa2662-8e3e-49e0-bf8a-773a909af519','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('d3d2c0c6-69cd-4ec8-9e4b-81697c67bc5e','8de0e525-c4e2-424d-9cb1-210491afaa0f','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('d5483ffb-f131-48fd-8671-cf21a1487d2b','fc09afac-8588-4907-bfd2-510f987e5f4f','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('d746166b-e102-4833-add0-9386c7793083','50891452-a93d-42c0-a6e2-165abea0da39','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('d826b0b1-933e-4d40-beb5-903878b47058','dd527d9e-9dce-49be-9b6c-0cf7df0fb85d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('d84835f3-550d-4298-b49b-06bbd9e8c68f','903d1227-5e5b-4723-91f9-3ac9e99952d1','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('d9154eae-6074-4f4a-ac2b-087c6286c7ed','40f0a42f-806f-4f2f-8174-66f6fe3962b5','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('da1e79d1-f8ea-45a4-8698-fab44fcdf132','11348b2f-e005-41a1-b484-d8af865eed03','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('dad3d0ab-42da-4e1b-a385-58de20d8e815','69d5c572-8444-40ee-9949-81377111fc87','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('dbe82a3b-515c-403a-9a9b-f9d84799c360','30a22137-ff4f-4032-967b-7bb0e06657a8','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('dbeba773-e5f8-4848-afab-144ddeaac9ab','93ad25ab-aee0-4e22-b6b0-f2ea05fe5019','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('dcf8b959-669a-40c6-8d8f-25a3aa2c4fec','17fe0d74-a4c9-4210-98ed-24f3b36d1d64','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('dd545c28-6880-4352-a41a-dc66265a15e5','bc0528a4-de6d-4684-89b4-fe2116828f53','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:44','2016-02-26 11:09:44'),('dd60db5b-9866-42e5-a70f-c78cfd9ccb4a','afd37a3a-2865-4b22-9532-b1118300ee71','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('dd8d6435-9650-4d62-b1da-d791addd46dd','08a04346-eff4-4da8-8fd6-8b73ffb35b09','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('dd99c79f-005a-42d7-8d04-0220c5ddfa35','f91bec52-7e06-4e81-98ee-5c56993be12d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('ddb9e722-7c14-468c-b79e-9a9d55be0ed1','c2a58cee-1d22-492d-8466-0cf25f951a8e','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('ddcd6eb6-6d80-45e6-9d1d-5e77c91636c2','87b4ba1d-a94d-4850-a213-7124c4bd79a1','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('ddf445a6-1e42-4ebc-b71d-9db4c219862b','96b1759a-2584-4e43-9095-2a2d287f6cc3','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:50','2016-02-26 11:02:50'),('de29850b-72cc-43bd-a226-5528dff0a127','f0ace790-70dc-40d6-a992-102d9beea85a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('df314c6b-f283-4397-bc5b-7abbf21a3ea3','5f648014-6907-4c88-b7b9-859c3bee4bac','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('df74ec8e-d253-4953-a2f6-4fc62805cbd0','713d3bd0-d7fe-419d-b79c-65c112ffeb39','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('df7f20ea-0a96-48e0-9dae-490f88a3e93a','00a5c12d-c675-4024-bb18-f1114a5f5c99','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('e0f3fdc2-810f-4e86-a0d6-01b5d09dbc07','525c10bf-1067-4349-868e-1032b9be599d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:06','2016-02-26 10:03:06'),('e20b5c37-96cc-43be-91f2-3c4ff73de333','d83bc3ff-0d3c-4654-bb79-a59254dac877','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:04','2016-02-26 10:03:04'),('e2f0ef3a-e897-4c6f-ace9-7d32b523452a','8dacf006-0e26-41f7-b074-b0bf80d2115b','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('e3182e43-0964-4449-b9c8-e1f057861af4','e37ff5a6-80ec-4c9e-ad41-fc1b0401febd','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('e32965c4-0a43-46f5-a96c-a74f3ee322cb','1b33ecc2-51cb-4c54-9a6f-52ed38d5de71','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('e33b467c-f62d-450b-a4c2-69dabc750bcc','33a95858-9fd7-4739-98fd-c4f7961aec38','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('e367328c-2278-4290-b456-803545af5dde','203475c1-df46-4c9e-8bf6-b564321a517b','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('e4b6d17f-bb27-4c84-b459-39f57036c58f','9365cdf0-c604-4a6f-b0ea-06d11573b5b9','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('e505c5a2-5d8d-4fdd-9b6e-9225c2ceab66','12adf2c3-c846-49ea-9cf0-44d568a25a5c','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('e50b7da1-a881-447a-b226-466787f19be6','51e2ab01-ce10-4e33-bb22-9d1ded79c23b','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('e55c848e-c6d1-48de-b465-2116ac39e475','7119087b-b12e-4a61-8735-d874aa96b59d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('e562914d-419f-4a90-8b9a-395f6dd550b2','d964c003-e5be-4219-83d7-790e647b2d3d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:56','2016-02-26 10:14:56'),('e61ee465-08fa-45ea-9877-b7b84b522109','60dfe47a-6a38-4136-91d0-4ee96383fe0e','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('e674fb0d-c80f-41ce-8fe3-0c42e097b396','7f6f6985-c8c7-4201-af36-0a9136b40b58','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:04','2016-02-26 10:03:04'),('e751b37c-0b33-48fe-ab84-261d6d0f350a','94306276-6dfd-4b0b-9248-449bb988d247','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('e782eb6b-df91-4e29-b1db-27cb67062e3e','ba8c2868-0b29-4e76-9257-72ec4961cbc2','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('e8ec63fe-7d86-47be-ac71-eaab4d80d5db','3eed83d7-d067-41e7-9898-7bdcab00f565','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('e8fabaa4-0276-4efe-8b69-4aa933559e5c','97c4174a-26d3-426a-b613-c7e660aa5519','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:44','2016-02-26 11:09:44'),('e94b369d-4e1b-4318-9e98-ac5ca66cdeb1','60246c40-8efa-4f17-9414-d27a15d270e1','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('e97e3025-f581-485a-b251-9d7cc7119fee','bc3b9a1e-b292-44a8-bec4-5bf5adee7d15','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:50','2016-02-26 11:02:50'),('e9cf7095-6fd5-43a8-9da8-84ea93d0e976','9ca1c2cf-9486-4fba-8435-39d6c3b5f41f','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('eb697040-f0b4-4cf6-9f10-278ec777b20b','c3e3caac-a564-494c-ace1-4f55ba0de335','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('ebcae88f-b589-497a-9d78-ea810406919b','dd5b4ee2-973c-4f4b-8d3a-69c92244656a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:44','2016-02-26 11:09:44'),('ec9319c1-dae4-4fcd-9d30-9752ebc02f30','96c90568-ade8-4efb-8678-9d7bb8dd1b2d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('ed533515-1fbc-44cb-af65-1a04f8ad6cbd','dd44c8d3-a495-48a5-a040-9d742f6d4d72','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('ed757137-a56a-4a20-bb3b-beeec2dc23a6','9e245868-81ba-4aaa-b0b9-38f1ba1cb208','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:50','2016-02-26 11:02:50'),('ede38f65-3b27-4063-b7d2-e52e4b0ab66f','3b1e84be-9f28-4fe0-a2d6-e66ccc8be99c','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('ef2212fa-1633-4bc1-b82d-af8dfa34d6bf','e1b42dd1-11db-45d7-9590-a9c288427582','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('ef82fe2c-69ee-4d82-aa73-dac4adab0f5f','560fc7bb-edc2-4142-a631-0df456d9660d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('f033f935-74d0-45f8-8eb3-3f89f3c6429a','98dbaf9f-54d7-4a94-9bc4-6d34d8ea303f','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('f0eb5f18-31a5-412d-afc8-3898455f18ed','3d7588cd-0e73-43be-801d-95dece83c8ce','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('f17aec15-9564-454f-b0fd-66c82e833506','05deecd9-5d5a-4876-885c-00b9c1611768','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('f1e267fe-9d59-41cd-a862-c789d36d4b75','d994615f-3a60-400b-b7c4-8d4854072a33','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('f21e5246-9b5f-4d2d-a068-586fe29072bf','8d23c033-7f3d-4516-8527-51616c00a2dd','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:44','2016-02-26 11:09:44'),('f25ba48a-81f8-4e02-bed0-904f4b346aff','c6f499b8-0eff-4d8c-a32b-e8737bfd9bee','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('f2ccf302-e223-49e4-a86f-6c155ee9bbce','3cb77ec2-bd67-4ebb-be9f-c2e5a085fe3e','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:08','2016-02-26 10:03:08'),('f2ef96b0-7efb-4659-bd9d-95f6f7588908','628e4afb-65df-4bfb-abf2-3e6f01724fd1','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:50','2016-02-26 11:02:50'),('f3a13257-91bf-4bbe-bdc7-24d0f5510cc4','c74d5e89-bf08-410c-9586-4a827708098a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:26','2016-02-26 11:01:26'),('f4b15244-8276-4f0a-982e-c971fd7d0ef9','49745c44-c9f7-4630-be78-93e68c6051f7','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:44','2016-02-26 11:09:44'),('f4f87aeb-0431-48b4-b23f-96c5dcaed777','3daacbb8-6586-4d8a-9679-64e6f093f773','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:54','2016-02-26 10:14:54'),('f51cda1c-4254-47a0-acaa-fc431a6c0a69','17480fbd-3336-4942-b8f6-36b4ac2e61d0','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:50','2016-02-26 11:02:50'),('f53f832c-42a6-4141-994f-6421f689fde8','00bce189-78a9-4869-893e-1cbaace55c90','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('f556ad4d-234c-4b4a-9177-46c49ab29bdf','bce23cbb-703b-456b-a1f9-6dc8f1da91e3','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('f5980ba1-b101-4351-a519-a7109d076a08','8289e02d-8dcf-4920-889c-b5ff459988a1','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:26','2016-02-26 11:01:26'),('f79674d3-34d2-465e-9485-2de03c2c1f7a','831ba59a-54dc-465d-bf7c-de3e7a4e9171','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('f833a8b7-3905-429e-a16d-457864d1994a','c3fa6d8c-b47e-44db-88ec-cc96d4839a99','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('f8a36982-2792-4cb0-80f6-42850b301485','cfc2c48e-74fc-47a3-a647-d79aea6b5d8c','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:05','2016-02-26 10:03:05'),('f8dace7a-e25f-42eb-bd4b-999dec473108','0845b9a6-83de-42e2-87d1-b33cfe6f1fb3','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:02:50',NULL,NULL,0,1,1,'2016-02-26 11:02:50','2016-02-26 11:02:50'),('f8e61026-4b71-430c-9f20-7d8f6e741f63','bd949052-9a0b-4b01-988a-44ed491d3db5','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('f8ec7917-a81a-4e65-bf8d-2108f4ddb6ef','2f2f6f08-81a5-44d7-b18e-c4c70f9001de','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:41','2016-02-26 11:09:41'),('f9650e9f-f664-4cdc-830c-3ab582e61120','f0573ae6-1dc2-4628-bb50-bfcbd927de54','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:03:04',NULL,NULL,0,1,1,'2016-02-26 10:03:07','2016-02-26 10:03:07'),('f9adef98-d2c6-4d88-9fbe-26a0c356ef81','3729d62c-ea18-49b5-998e-42c6d646c0f2','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25'),('fa28b7a5-8f68-4319-b152-1ebe52190762','f03e7f2e-27ae-49ac-8e27-3c9ef64d96e9','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:24','2016-02-26 11:01:24'),('fb867e5b-54b2-4dcc-8dce-4fcd0aea8ea2','c54aecc5-8865-4374-98c9-57d87170768d','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:55','2016-02-26 10:14:55'),('fb8a5a6b-63ef-468e-aee5-1fbdce9c6d5e','406717e6-b245-401a-a921-e0690f25e448','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('fc0ed39d-27f6-4a20-8fc4-952750b59236','44696a07-d053-4c00-b09f-e1dcdcb937bc','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('fc1dcf20-0ff9-4ab6-a50d-862496ab5222','c6d0bebd-3a46-40ce-84d2-ac7bcc7c2209','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('fd468bed-af81-4299-9b51-081de19d328b','d14b5294-ae06-4281-abf6-a0934d607d1a','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:23','2016-02-26 11:01:23'),('fe18486b-02c7-4e92-9ea4-ccded4a5b68e','43561945-ce2f-43b8-a8fa-1ba1d88f9656','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:43','2016-02-26 11:09:43'),('fed90953-394f-4a94-8728-d1802f4b6383','00402d79-0474-4266-a9d1-7b800c9f8193','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:09:40',NULL,NULL,0,1,1,'2016-02-26 11:09:42','2016-02-26 11:09:42'),('ffbb3126-eecd-4367-9018-e2522f90d36e','24206b0b-ef7a-4e30-ae24-00abe1729ff9','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 10:14:53',NULL,NULL,0,1,1,'2016-02-26 10:14:53','2016-02-26 10:14:53'),('ffc3e132-8727-4217-862a-c7d2b4480672','7d3dcc9f-7680-4c39-8cdf-07f34b846adf','LocationContainer','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,'dispatch','2016-02-26 11:01:22',NULL,NULL,0,1,1,'2016-02-26 11:01:25','2016-02-26 11:01:25');
/*!40000 ALTER TABLE `records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regex_categories`
--

DROP TABLE IF EXISTS `regex_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `regex_categories` (
  `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `desc` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `match_value` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_regex_categories_on_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regex_categories`
--

LOCK TABLES `regex_categories` WRITE;
/*!40000 ALTER TABLE `regex_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `regex_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regexes`
--

DROP TABLE IF EXISTS `regexes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `regexes` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `code` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `prefix_length` int(11) DEFAULT '0',
  `prefix_string` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `suffix_length` int(11) DEFAULT '0',
  `suffix_string` int(11) DEFAULT NULL,
  `regex_string` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `regexable_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `regexable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remark` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_sys_default` tinyint(1) DEFAULT '0',
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `regex_category_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_regexes_on_id` (`id`),
  KEY `index_regexes_on_regexable_id` (`regexable_id`),
  KEY `index_regexes_on_regexable_type` (`regexable_type`),
  KEY `index_regexes_on_regex_category_id` (`regex_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regexes`
--

LOCK TABLES `regexes` WRITE;
/*!40000 ALTER TABLE `regexes` DISABLE KEYS */;
INSERT INTO `regexes` VALUES ('01b318d0-2cdd-4933-bf89-28bddb984c99','零件号','PART',1,'P',100,0,NULL,'^P\\w+',NULL,NULL,NULL,0,0,1,1,'2016-02-26 08:42:29','2016-02-26 08:42:29',NULL),('1aa676db-dfc6-4618-9c83-cd6e5cf52323','唯一码','UNIQ',2,'WI',100,0,NULL,'^WI\\w+',NULL,NULL,NULL,0,0,1,1,'2016-02-26 08:42:29','2016-02-26 08:42:29',NULL),('339bb38d-b9f7-429e-aef9-9c232187bbba','数量','QUANTITY',1,'Q',100,0,NULL,'^Q\\d+\\.?\\d*$',NULL,NULL,NULL,0,0,1,1,'2016-02-26 08:42:29','2016-02-26 08:42:29',NULL),('3aa9c400-68d9-46fa-b2b1-9bf215bbb5cc','需求单零件号','ORDERITEM_PART',1,'P',200,0,NULL,'^P\\w+',NULL,NULL,NULL,0,0,1,1,'2016-02-26 08:42:29','2016-02-26 08:42:29',NULL),('42041291-4486-497d-b24b-073d42700040','入库时间','DATE',3,'W  ',100,0,NULL,'^W\\s*\\S+',NULL,NULL,'W后有两个空格，请认真检测标签',0,0,1,1,'2016-02-26 08:42:29','2016-02-26 08:42:29',NULL),('a3163dd8-df9c-4d34-b6f9-136351181f5f','需求部门','ORDERITEM_DEPARTMENT',2,'LO',200,0,NULL,'^LO\\w+',NULL,NULL,NULL,0,0,1,1,'2016-02-26 08:42:29','2016-02-26 08:42:29',NULL),('e8d73c87-2992-4d45-9378-bc82b72b7694','需求单数量','ORDERITEM_QTY',1,'Q',200,0,NULL,'^Q\\d+\\.?\\d*$',NULL,NULL,NULL,0,0,1,1,'2016-02-26 08:42:29','2016-02-26 08:42:29',NULL);
/*!40000 ALTER TABLE `regexes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20140609031427'),('20140609041806'),('20140609053459'),('20140609055552'),('20140609060702'),('20140609061824'),('20140609062701'),('20140609065039'),('20140609071003'),('20140609071957'),('20140609073543'),('20140609081845'),('20140610091106'),('20140610180353'),('20140611060537'),('20140611063003'),('20140612025358'),('20140612103217'),('20140613021641'),('20140613034212'),('20140613072407'),('20140616062912'),('20140616083045'),('20140617083323'),('20140618023742'),('20140618083942'),('20140618095707'),('20140619064359'),('20140620071250'),('20140623025158'),('20140714101037'),('20140720123422'),('20140720155446'),('20140720160044'),('20140720161032'),('20140721030406'),('20140721031508'),('20140721032044'),('20140721062708'),('20140727154505'),('20140727172304'),('20140803173457'),('20140805143741'),('20140808020311'),('20140808061718'),('20140821085247'),('20140823020342'),('20140823030424'),('20140825033530'),('20140922063617'),('20140922064233'),('20140922083728'),('20140924021337'),('20140924051814'),('20140925071100'),('20140929040203'),('20140929041418'),('20141102041854'),('20141103105230'),('20141104092557'),('20141107024539'),('20141110100356'),('20141110110437'),('20141111074243'),('20141111075329'),('20141112030007'),('20141112052934'),('20141112094835'),('20141117062022'),('20141124025806'),('20141126082819'),('20141127075539'),('20141128030735'),('20141128031440'),('20141128090900'),('20141225122324'),('20150112024343'),('20150112055758'),('20150120071344'),('20150511074630'),('20150511080832'),('20150511081617'),('20150511082731'),('20150511083014'),('20150514173606'),('20150514174106'),('20150518004113'),('20150604164854'),('20150605082618'),('20150611100102'),('20150612032219'),('20150623194524'),('20150623201029'),('20150624032200'),('20150625025418'),('20150625032200'),('20150625052200'),('20150625100022'),('20150625125257'),('20150625220405'),('20150626121510'),('20150627014446'),('20150629025042'),('20150706063549'),('20151105055058'),('20151110055750'),('20151110060229'),('20151118075745'),('20151119023720'),('20151123032226'),('20151126075233'),('20151210022142'),('20151212051417'),('20151212092157'),('20160223030405'),('20160223031057'),('20160223033417'),('20160223033528'),('20160223033632'),('20160223033723'),('20160223041006'),('20160224015438'),('20160224015806'),('20160224021414'),('20160224022940'),('20160224075925'),('20160226041533'),('20160226082611');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scrap_list_items`
--

DROP TABLE IF EXISTS `scrap_list_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scrap_list_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `scrap_list_id` int(11) DEFAULT NULL,
  `part_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `product_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `quantity` decimal(20,10) DEFAULT NULL,
  `IU` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `state` int(11) DEFAULT '100',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scrap_list_items`
--

LOCK TABLES `scrap_list_items` WRITE;
/*!40000 ALTER TABLE `scrap_list_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `scrap_list_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scrap_lists`
--

DROP TABLE IF EXISTS `scrap_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scrap_lists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `src_warehouse` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dse_warehouse` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `builder` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scrap_lists`
--

LOCK TABLES `scrap_lists` WRITE;
/*!40000 ALTER TABLE `scrap_lists` DISABLE KEYS */;
/*!40000 ALTER TABLE `scrap_lists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `state_logs`
--

DROP TABLE IF EXISTS `state_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `state_logs` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `stateable_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `stateable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `state_before` int(11) DEFAULT NULL,
  `state_after` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_state_logs_on_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `state_logs`
--

LOCK TABLES `state_logs` WRITE;
/*!40000 ALTER TABLE `state_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `state_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `storage_operation_records`
--

DROP TABLE IF EXISTS `storage_operation_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `storage_operation_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `partNr` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `qty` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fromWh` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fromPosition` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `toWh` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `toPosition` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `packageId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remarks` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `employee_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fifo` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `storage_operation_records`
--

LOCK TABLES `storage_operation_records` WRITE;
/*!40000 ALTER TABLE `storage_operation_records` DISABLE KEYS */;
/*!40000 ALTER TABLE `storage_operation_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `storages`
--

DROP TABLE IF EXISTS `storages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `storages` (
  `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `location_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `part_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `quantity` float DEFAULT NULL,
  `fifo_time` datetime DEFAULT NULL,
  `storable_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `storable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_storages_on_id` (`id`),
  KEY `index_storages_on_location_id` (`location_id`),
  KEY `index_storages_on_part_id` (`part_id`),
  KEY `index_storages_on_storable_id` (`storable_id`),
  KEY `index_storages_on_storable_type` (`storable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `storages`
--

LOCK TABLES `storages` WRITE;
/*!40000 ALTER TABLE `storages` DISABLE KEYS */;
/*!40000 ALTER TABLE `storages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sync_logs`
--

DROP TABLE IF EXISTS `sync_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sync_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `table_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sync` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_logs`
--

LOCK TABLES `sync_logs` WRITE;
/*!40000 ALTER TABLE `sync_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `sync_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sync_pools`
--

DROP TABLE IF EXISTS `sync_pools`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sync_pools` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `table_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `locked` tinyint(1) DEFAULT '1',
  `client_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_pools`
--

LOCK TABLES `sync_pools` WRITE;
/*!40000 ALTER TABLE `sync_pools` DISABLE KEYS */;
/*!40000 ALTER TABLE `sync_pools` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_configs`
--

DROP TABLE IF EXISTS `sys_configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_configs` (
  `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remark` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `category` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `index` int(11) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sys_configs_on_id` (`id`),
  KEY `index_sys_configs_on_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_configs`
--

LOCK TABLES `sys_configs` WRITE;
/*!40000 ALTER TABLE `sys_configs` DISABLE KEYS */;
INSERT INTO `sys_configs` VALUES ('27e2a105-6d49-432a-97de-11ac4021a8a3','JIAXUAN_EXTRA_CZ_CUSTOM','cz_custom','常州客户编码',NULL,0,1,1,'2016-02-26 11:34:25','2016-02-26 11:34:25','佳轩扩展配置',1300,NULL),('2c18139f-7e5c-491e-af3f-6f68c80dcdc3','JIAXUAN_EXTRA_SOURCE','cz-leoni','发运地址',NULL,0,1,1,'2016-02-26 10:35:38','2016-02-26 10:55:46','佳轩扩展配置',1200,NULL),('4e3d24a2-77f5-423f-97a6-1e47f038e599','INVENTORY_ENABLE','false','是否开启盘点模式',NULL,0,1,1,'2016-02-26 08:42:29','2016-02-26 08:42:29','盘点配置',900,NULL),('79aff148-ccbf-4c94-8049-bb53976a30fa','HIDE_FINISHED_INVENTORY','true','是否隐藏结束的盘点单',NULL,0,1,1,'2016-02-26 08:42:29','2016-02-26 08:42:29','盘点配置',900,NULL),('a9698693-b516-4165-933a-03fed8380298','PRINT_SERVER','http://192.168.8.77:9000','打印服务器地址',NULL,0,1,1,'2016-02-26 08:42:29','2016-02-26 08:42:29','打印服务配置',1000,NULL),('d8b911b8-38f4-4dda-9589-16bb69d30c25','WEB_SHOW_CLIENT_PART_NR','SHL','网页显示客户零件号',NULL,0,1,1,'2016-02-26 08:42:29','2016-02-26 08:42:29','数据配置',300,'填写客户编码，多个以英文字逗号分隔'),('efdb74d4-4e3f-4352-b538-42b070d1ecd8','JIAXUAN_EXTRA_SH_CUSTOM','sh_custom','上海客户编码',NULL,0,1,1,'2016-02-26 11:34:25','2016-02-26 11:34:25','佳轩扩展配置',1300,NULL),('fa301774-27d5-47ae-a2d2-3097101c197b','JIAXUAN_EXTRA_DESTINATION','jiaxuan','接收地址',NULL,0,1,1,'2016-02-26 10:35:38','2016-02-26 10:55:59','佳轩扩展配置',1200,NULL);
/*!40000 ALTER TABLE `sys_configs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tenants`
--

DROP TABLE IF EXISTS `tenants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tenants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tel` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `website` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` int(11) DEFAULT '300',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `short_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tenants`
--

LOCK TABLES `tenants` WRITE;
/*!40000 ALTER TABLE `tenants` DISABLE KEYS */;
INSERT INTO `tenants` VALUES (1,'上海佳轩物流有限公司','SHJX',NULL,NULL,NULL,NULL,100,'2016-02-26 08:42:29','2016-02-26 08:42:29','简称'),(2,'上海佳轩物流有限公司','SHJX',NULL,NULL,NULL,NULL,100,'2016-02-26 10:35:38','2016-02-26 10:35:38','简称'),(3,'上海客户','sh_custom','','','','',300,'2016-02-26 11:28:02','2016-02-26 11:28:02',''),(4,'常州客户','cz_custom','','','','',300,'2016-02-26 11:30:06','2016-02-26 11:30:06',''),(5,'上海佳轩物流有限公司','SHJX',NULL,NULL,NULL,NULL,100,'2016-02-26 11:34:25','2016-02-26 11:34:25','简称');
/*!40000 ALTER TABLE `tenants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_permission_groups`
--

DROP TABLE IF EXISTS `user_permission_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_permission_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `permission_group_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_user_permission_groups_on_user_id` (`user_id`),
  KEY `index_user_permission_groups_on_permission_group_id` (`permission_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_permission_groups`
--

LOCK TABLES `user_permission_groups` WRITE;
/*!40000 ALTER TABLE `user_permission_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_permission_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `uuid` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tel` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) NOT NULL DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `location_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `authentication_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `role_id` int(11) NOT NULL DEFAULT '100',
  `is_sys` tinyint(1) DEFAULT '0',
  `nr` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `operation_mode` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`),
  UNIQUE KEY `index_users_on_authentication_token` (`authentication_token`),
  KEY `index_users_on_uuid` (`uuid`),
  KEY `index_users_on_email` (`email`),
  KEY `index_users_on_id` (`id`),
  KEY `index_users_on_location_id` (`location_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('e6ad3c77-9bb8-48b2-b6fa-9acab724952f','0de379bf-8f89-4f03-aa9f-c27749c3aaf9',0,1,1,'Admin',NULL,NULL,'$2a$10$L0y4s9rOTq..ErT4viW/fOjYlKCZy3AONLkXthd4QrFb0BiH5wym2',NULL,NULL,NULL,1,'2016-02-26 08:42:38','2016-02-26 08:42:38','127.0.0.1','127.0.0.1','2016-02-26 08:42:29','2016-02-26 08:42:38','c51ec557-0a12-4c09-8479-50e5bd24d467','bUN6dpcEq7TaesBJ9hCF',100,1,'admin',0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `versions`
--

DROP TABLE IF EXISTS `versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `item_id` int(11) NOT NULL,
  `event` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `whodunnit` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `object` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_versions_on_item_type_and_item_id` (`item_type`,`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `versions`
--

LOCK TABLES `versions` WRITE;
/*!40000 ALTER TABLE `versions` DISABLE KEYS */;
/*!40000 ALTER TABLE `versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ware_houses`
--

DROP TABLE IF EXISTS `ware_houses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ware_houses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `whId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `positionPattern` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `wh_id_unique` (`whId`),
  KEY `index_ware_houses_on_location_id` (`location_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ware_houses`
--

LOCK TABLES `ware_houses` WRITE;
/*!40000 ALTER TABLE `ware_houses` DISABLE KEYS */;
/*!40000 ALTER TABLE `ware_houses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `whouses`
--

DROP TABLE IF EXISTS `whouses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `whouses` (
  `uuid` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_dirty` tinyint(1) DEFAULT '1',
  `is_new` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `position_pattern` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `nr` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_whouses_on_uuid` (`uuid`),
  KEY `index_whouses_on_location_id` (`location_id`),
  KEY `index_whouses_on_id` (`id`),
  KEY `index_whouses_on_nr` (`nr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `whouses`
--

LOCK TABLES `whouses` WRITE;
/*!40000 ALTER TABLE `whouses` DISABLE KEYS */;
INSERT INTO `whouses` VALUES ('21f89dd2-e602-4912-9a98-38a7f4ddf83e','a2129627-2fee-45cf-ab29-dd32713f7d0a','常州发运处','ac42b1e0-8917-4259-8d8e-0b5a13689bfa',0,1,1,'2016-02-26 09:05:52','2016-02-26 09:09:26','','cz-delivery'),('6a48e32e-8656-45c5-aea4-d7ecf7b474e5','a44ab0a8-d1ed-4c8c-a7e2-4f738c91ee00','佳轩接收处','596f7217-a62c-4354-ac41-8b5339fe1a8c',0,1,1,'2016-02-26 09:04:53','2016-02-26 09:10:12','','jiaxuan');
/*!40000 ALTER TABLE `whouses` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-02-29 15:39:57
