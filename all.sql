SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `tp-db-forum` ;
CREATE SCHEMA IF NOT EXISTS `tp-db-forum` ;
USE `tp-db-forum` ;

-- -----------------------------------------------------
-- Table `tp-db-forum`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tp-db-forum`.`user` ;

CREATE TABLE IF NOT EXISTS `tp-db-forum`.`user` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `username` VARCHAR(64) NOT NULL,
  `about` VARCHAR(255) NOT NULL,
  `isAnonymous` TINYINT(1) NOT NULL,
  `name` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC));


-- -----------------------------------------------------
-- Table `tp-db-forum`.`following`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tp-db-forum`.`following` ;

CREATE TABLE IF NOT EXISTS `tp-db-forum`.`following` (
  `follower` INT(11) NOT NULL,
  `followee` INT(11) NOT NULL,
  INDEX `fk_following_follower` (`follower` ASC),
  INDEX `fk_following_followee` (`followee` ASC),
  CONSTRAINT `fk_following_follower`
    FOREIGN KEY (`follower`)
    REFERENCES `tp-db-forum`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_following_followee`
    FOREIGN KEY (`followee`)
    REFERENCES `tp-db-forum`.`user` (`id`)
    ON DELETE CASCADE);


-- -----------------------------------------------------
-- Table `tp-db-forum`.`forum`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tp-db-forum`.`forum` ;

CREATE TABLE IF NOT EXISTS `tp-db-forum`.`forum` (
  `id` INT NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `shortName` VARCHAR(255) NOT NULL,
  `user` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `shortName_UNIQUE` (`shortName` ASC),
  INDEX `fk_forum_user_idx` (`user` ASC),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  CONSTRAINT `fk_forum_user`
    FOREIGN KEY (`user`)
    REFERENCES `tp-db-forum`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp-db-forum`.`thread`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tp-db-forum`.`thread` ;

CREATE TABLE IF NOT EXISTS `tp-db-forum`.`thread` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `forum` INT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `slug` VARCHAR(255) NOT NULL,
  `message` TEXT NOT NULL,
  `isDeleted` TINYINT(1) NOT NULL DEFAULT 0,
  `isClosed` TINYINT(1) NOT NULL DEFAULT 0,
  `user` INT NOT NULL,
  `date` DATETIME NOT NULL,
  `likes` INT NOT NULL DEFAULT 0,
  `dislikes` INT NOT NULL DEFAULT 0,
  `points` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `fk_thread_forum_idx` (`forum` ASC),
  INDEX `fk_thread_user_idx` (`user` ASC),
  UNIQUE INDEX `slug_UNIQUE` (`slug` ASC),
  CONSTRAINT `fk_thread_forum`
    FOREIGN KEY (`forum`)
    REFERENCES `tp-db-forum`.`forum` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_thread_user`
    FOREIGN KEY (`user`)
    REFERENCES `tp-db-forum`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp-db-forum`.`post`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tp-db-forum`.`post` ;

CREATE TABLE IF NOT EXISTS `tp-db-forum`.`post` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `post` INT NULL,
  `isApproved` TINYINT(1) NOT NULL DEFAULT 0,
  `isHighlighted` TINYINT(1) NOT NULL DEFAULT 0,
  `isEdited` TINYINT(1) NOT NULL DEFAULT 0,
  `isSpam` TINYINT(1) NOT NULL DEFAULT 0,
  `isDeleted` TINYINT(1) NOT NULL DEFAULT 0,
  `date` DATETIME NOT NULL,
  `thread` INT NOT NULL,
  `message` TEXT NOT NULL,
  `user` INT NOT NULL,
  `likes` INT NOT NULL DEFAULT 0,
  `dislikes` INT NOT NULL DEFAULT 0,
  `points` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `fk_post_post_idx` (`post` ASC),
  INDEX `fk_post_user_idx` (`user` ASC),
  CONSTRAINT `fk_post_post`
    FOREIGN KEY (`post`)
    REFERENCES `tp-db-forum`.`post` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_post_user`
    FOREIGN KEY (`user`)
    REFERENCES `tp-db-forum`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
