CREATE SCHEMA gigih_twitt_db;

CREATE TABLE gigih_twitt_db.tbl_user ( 
	user_id              int  NOT NULL  AUTO_INCREMENT  PRIMARY KEY,
	user_name            varchar(50)  NOT NULL    ,
	user_email           varchar(50)  NOT NULL    ,
	user_password        varchar(50)  NOT NULL    ,
	user_bio             date  NOT NULL    ,
	user_timestamp       datetime   DEFAULT CURRENT_TIMESTAMP   
 ) engine=InnoDB;

CREATE TABLE gigih_twitt_db.tbl_collections ( 
	collection_id        int  NOT NULL  AUTO_INCREMENT  PRIMARY KEY,
	user_id              int  NOT NULL    ,
	collection_timestamp timestamp   DEFAULT CURRENT_TIMESTAMP   ,
	collection_messages  varchar(1000)      ,
	collection_picture   blob      ,
	collection_video     blob      ,
	collection_file      blob      ,
	CONSTRAINT fk_tbl_collections_tbl_user FOREIGN KEY ( user_id ) REFERENCES gigih_twitt_db.tbl_user( user_id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) engine=InnoDB;

CREATE TABLE gigih_twitt_db.tbl_comments ( 
	comment_id           int  NOT NULL  AUTO_INCREMENT  PRIMARY KEY,
	post_id              int      ,
	comment_text         varchar(1000)      ,
	comment_flag         varchar(7)      ,
	user_id              int  NOT NULL    ,
	comment_timestamp    datetime   DEFAULT CURRENT_TIMESTAMP   ,
	CONSTRAINT fk_tbl_comments FOREIGN KEY ( post_id ) REFERENCES gigih_twitt_db.tbl_collections( collection_id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_tbl_comments_tbl_user FOREIGN KEY ( user_id ) REFERENCES gigih_twitt_db.tbl_user( user_id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) engine=InnoDB;

CREATE TABLE gigih_twitt_db.tbl_hashtag ( 
	hash_id              int  NOT NULL  AUTO_INCREMENT  PRIMARY KEY,
	post_id              int      ,
	comment_id           int      ,
	hash_text            varchar(500)      ,
	hash_timestamp       datetime      ,
	CONSTRAINT fk_tbl_hashtag_tbl_collections FOREIGN KEY ( post_id ) REFERENCES gigih_twitt_db.tbl_collections( collection_id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_tbl_hashtag_tbl_comments FOREIGN KEY ( comment_id ) REFERENCES gigih_twitt_db.tbl_comments( comment_id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) engine=InnoDB;

INSERT INTO gigih_twitt_db.tbl_user( user_id, user_name, user_email, user_password, user_bio, user_timestamp ) VALUES ( 2, 'Hamid Wiranata', 'Mwira@gmail.com', 'test123', '2000-01-23', '2021-08-24 11.55.27 AM');
INSERT INTO gigih_twitt_db.tbl_user( user_id, user_name, user_email, user_password, user_bio, user_timestamp ) VALUES ( 3, 'Teddy Brown', 'teddy@brownland.net', 'teddy123', '1990-05-24', '2021-08-24 11.55.28 AM');
