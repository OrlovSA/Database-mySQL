-- MySQL dump 10.13  Distrib 8.0.22, for Win64 (x86_64)
--
-- Host: localhost    Database: mysql
-- ------------------------------------------------------
-- Server version	8.0.22

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
-- Table structure for table `help_keyword`
--

DROP TABLE IF EXISTS `help_keyword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `help_keyword` (
  `help_keyword_id` int unsigned NOT NULL,
  `name` char(64) NOT NULL,
  PRIMARY KEY (`help_keyword_id`),
  UNIQUE KEY `name` (`name`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='help keywords';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `help_keyword`
--
-- WHERE:  true limit 100

LOCK TABLES `help_keyword` WRITE;
/*!40000 ALTER TABLE `help_keyword` DISABLE KEYS */;
INSERT INTO `help_keyword` VALUES (108,'%'),(264,'&'),(416,'(JSON'),(86,'*'),(84,'+'),(85,'-'),(417,'->'),(419,'->>'),(87,'/'),(75,':='),(59,'<'),(266,'<<'),(58,'<='),(56,'<=>'),(57,'<>'),(55,'='),(61,'>'),(60,'>='),(267,'>>'),(90,'ABS'),(844,'ACCOUNT'),(91,'ACOS'),(650,'ACTION'),(49,'ADD'),(120,'ADDDATE'),(121,'ADDTIME'),(870,'ADMIN'),(270,'AES_DECRYPT'),(271,'AES_ENCRYPT'),(573,'AFTER'),(247,'AGAINST'),(891,'AGGREGATE'),(574,'ALGORITHM'),(713,'ALL'),(50,'ALTER'),(575,'ANALYZE'),(62,'AND'),(520,'ANY_VALUE'),(651,'ARCHIVE'),(254,'ARRAY'),(714,'AS'),(458,'ASC'),(185,'ASCII'),(92,'ASIN'),(6,'ASYMMETRIC_DECRYPT'),(7,'ASYMMETRIC_DERIVE'),(8,'ASYMMETRIC_ENCRYPT'),(9,'ASYMMETRIC_SIGN'),(10,'ASYMMETRIC_VERIFY'),(634,'AT'),(93,'ATAN'),(94,'ATAN2'),(845,'ATTRIBUTE'),(735,'AUTOCOMMIT'),(673,'AUTOEXTEND_SIZE'),(576,'AUTO_INCREMENT'),(452,'AVG'),(577,'AVG_ROW_LENGTH'),(747,'BACKUP'),(761,'BEFORE'),(736,'BEGIN'),(288,'BENCHMARK'),(63,'BETWEEN'),(186,'BIN'),(253,'BINARY'),(556,'BINLOG'),(521,'BIN_TO_UUID'),(454,'BIT_AND'),(269,'BIT_COUNT'),(187,'BIT_LENGTH'),(455,'BIT_OR'),(456,'BIT_XOR'),(17,'BOOL'),(18,'BOOLEAN'),(230,'BOTH'),(638,'BTREE'),(459,'BY'),(42,'BYTE'),(925,'CACHE'),(681,'CALL'),(491,'CAN_ACCESS_COLUMN'),(492,'CAN_ACCESS_DATABASE'),(493,'CAN_ACCESS_TABLE'),(494,'CAN_ACCESS_USER'),(495,'CAN_ACCESS_VIEW'),(652,'CASCADE'),(76,'CASE'),(255,'CAST'),(825,'CATALOG_NAME'),(95,'CEIL'),(96,'CEILING'),(737,'CHAIN'),(578,'CHANGE'),(557,'CHANNEL'),(43,'CHAR'),(39,'CHARACTER'),(189,'CHARACTER_LENGTH'),(289,'CHARSET'),(188,'CHAR_LENGTH'),(579,'CHECK');
/*!40000 ALTER TABLE `help_keyword` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-11-02 21:21:36
