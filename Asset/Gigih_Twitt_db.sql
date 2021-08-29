CREATE SCHEMA gigih_twitt_db;

CREATE TABLE gigih_twitt_db.tbl_user (
	user_id              int  NOT NULL  AUTO_INCREMENT  PRIMARY KEY,
	user_name            varchar(50)  NOT NULL    ,
	user_email           varchar(50)  NOT NULL    ,
	user_password        varchar(50)  NOT NULL    ,
	user_bio             date  NOT NULL    ,
	user_timestamp       timestamp   DEFAULT CURRENT_TIMESTAMP
 ) engine=InnoDB;

CREATE TABLE gigih_twitt_db.tbl_collections (
	collection_id        int  NOT NULL  AUTO_INCREMENT  PRIMARY KEY,
	user_id              int  NOT NULL    ,
	collection_timestamp timestamp   DEFAULT CURRENT_TIMESTAMP   ,
	collection_messages  varchar(1000)      ,
	collection_picture   blob      ,
	collection_video     blob      ,
	collection_file      blob      ,
	CONSTRAINT fk_tbl_collections_tbl_user FOREIGN KEY ( user_id ) REFERENCES gigih_twitt_db.tbl_user( user_id ) ON DELETE CASCADE ON UPDATE CASCADE
 ) engine=InnoDB;

CREATE TABLE gigih_twitt_db.tbl_comments (
	comment_id           int  NOT NULL  AUTO_INCREMENT  PRIMARY KEY,
	post_id              int      ,
	comment_text         varchar(1000)      ,
	comment_flag         varchar(7)      ,
	user_id              int  NOT NULL    ,
	comment_timestamp    timestamp   DEFAULT CURRENT_TIMESTAMP   ,
	CONSTRAINT fk_tbl_comments FOREIGN KEY ( post_id ) REFERENCES gigih_twitt_db.tbl_collections( collection_id ) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_tbl_comments_tbl_user FOREIGN KEY ( user_id ) REFERENCES gigih_twitt_db.tbl_user( user_id ) ON DELETE CASCADE ON UPDATE CASCADE
 ) engine=InnoDB;

CREATE TABLE gigih_twitt_db.tbl_hashtag (
	hash_id              int  NOT NULL  AUTO_INCREMENT  PRIMARY KEY,
	post_id              int      ,
	comment_id           int      ,
	hash_text            varchar(500)      ,
	hash_timestamp       timestamp      ,
	CONSTRAINT fk_tbl_hashtag_tbl_collections FOREIGN KEY ( post_id ) REFERENCES gigih_twitt_db.tbl_collections( collection_id ) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_tbl_hashtag_tbl_comments FOREIGN KEY ( comment_id ) REFERENCES gigih_twitt_db.tbl_comments( comment_id ) ON DELETE CASCADE ON UPDATE CASCADE
 ) engine=InnoDB;
