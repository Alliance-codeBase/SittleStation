## Module ID: TRAUMA_PUNISHMENT

### Description:

	Добавляет возможность админам заставлять игроков страдать persistently \
	за их ужасные нарушения! Переносится меж раундами.

### TG Proc/File Changes:
	code\modules\admin\topic.dm ln 1220 - 1240
	code\__DEFINES\achievements.dm ln 67-69

	html\admin\brain_trauma_unpanel.css
	html\admin\brain_trauma_panel.js
	html\admin\brain_trauma_panel.css


### Modular Overrides:



### Defines:
	code\__DEFINES\achievements.dm ln 67-69


### TGUI Files:

	tgui\packages\tgui\interfaces\BrainTraumaPunishments.tsx

### Credits:


### OTHER
- Вот этот SQL запрос должен быть применён к базе данных для корректной работы.
- SQL Query for your database, use it to create the required table. Otherwise will throw SQL query errors.
```
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `brain_trauma_punishment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `brain_trauma_punishment` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `server_ip` INT(10) UNSIGNED NOT NULL,
  `server_port` SMALLINT(5) UNSIGNED NOT NULL,
  `round_id` INT(11) UNSIGNED NULL,
  `ckey` VARCHAR(32) NOT NULL,
  `a_ckey` VARCHAR(32) NOT NULL,
  `reason` VARCHAR(2048) NOT NULL,
  `mode` ENUM('exact','category') NOT NULL,
  `trauma_path` VARCHAR(255) NULL DEFAULT NULL,
  `trauma_category` VARCHAR(255) NULL DEFAULT NULL,
  `trauma_count` TINYINT(3) UNSIGNED NOT NULL DEFAULT '1',
  `resilience` TINYINT(3) UNSIGNED NOT NULL DEFAULT '6',
  `expiration_time` DATETIME NULL DEFAULT NULL,
  `removed_datetime` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_brain_trauma_punishment_active` (`ckey`,`removed_datetime`,`expiration_time`),
  KEY `idx_brain_trauma_punishment_expiry` (`removed_datetime`,`expiration_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
```
По понятной причине изменять ``SQL\tgstation_schema.sql`` я не стану.. это того не стоит. Пусть оно лучше лежит здесь.
DROP TABLE IF EXISTS удалит имеющуеся таблицу с активными и прошедшими "наказаниями", учтите это.
