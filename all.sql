SET foreign_key_checks = 0;
DROP TABLE IF EXISTS
  `tp-db-forum`.`following`,
  `tp-db-forum`.`user`
;
SET foreign_key_checks = 1;


CREATE TABLE `tp-db-forum`.`user` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `username` VARCHAR(64) NOT NULL,
  `about` VARCHAR(255) NOT NULL,
  `isAnonymous` TINYINT(1) NOT NULL,
  `name` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
;


CREATE TABLE `tp-db-forum`.`following` (
  `follower` INT(11) NOT NULL,
  `followee` INT(11) NOT NULL,
  CONSTRAINT `fk_following_follower` FOREIGN KEY `fk_following_follower` (`follower`) REFERENCES `tp-db-forum`.`user` (`id`) ON DELETE NO ACTION,
  CONSTRAINT `fk_following_followee` FOREIGN KEY `fk_following_followee` (`followee`) REFERENCES `tp-db-forum`.`user` (`id`) ON DELETE NO ACTION
);
