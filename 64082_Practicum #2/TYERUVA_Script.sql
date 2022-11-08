--Note: putting '--' before a line (such as this one) turns it into a comment line

/* Begin sections of comments with /* 
and end the comment section with:  */ 

/* This method is universal as it can be used for one line. */
--The '--' method is just simpler to type.


--BEGIN PRACTICUM COMMENTS. See main pdf document for directions.

/*
The drop table statements below remove the current copies of these tables so they can be re-created.
If you do not remove previous versions the new CREATE TABLE statement will give you a 'name is already used' type error.

IMPORTANT - These statements will give you an error if run in your database before the tables are created
in your database.  Just ignore these 'table does not exist' errors(arising from these statements only).  
They do no damage and will stop when
you finish your script by inserting the missing create table statements. When you are FINISHED, this script should 
run with no errors - but not until you are finished.  */

/*
If you run this script before creating any other tables it will NOT create any of the four tables
that have the code included.  This is because each of these four tables has a foreign key that is
the primary key of a table that is not included.  For intance the P_INCIDENT table has a foreign key from the P_DOG 
table.  Once you write the code for P_DOG and create it, then P_INCIDENT will be able to be created.
*/

/* 
The drop table and create table statements are in the order they need to be to drop and create properly.
If you change the order, then errors may occur because dropping or creating in a different order may
cause foreign key errors to arise. */

DROP TABLE P_DOG_BREED_PERCENTAGE;
DROP TABLE P_OWNER_DOG_INT;
DROP TABLE P_SERVICE_CERTIFICATIONS;
DROP TABLE P_SERVICE_DOGS;
DROP TABLE P_OWNER;
DROP TABLE P_PET;
DROP TABLE P_PHOTO;
DROP TABLE P_INCIDENT;
DROP TABLE P_DOGBREED;
DROP TABLE P_DOG;

CREATE TABLE P_DOG(
DOG_ID             CHAR(5)                             NOT NULL,
DOG_NAME           VARCHAR2(30)   DEFAULT 'UNKNOWN'    NOT NULL,
DOG_BIRTH_MONTH    NUMBER(2)                         NULL,
DOG_BIRTH_YEAR     NUMBER(4)                         NOT NULL,
SEX                CHAR(1)                             NOT NULL,
SPAYED_OR_NEUTERED CHAR(1)        DEFAULT 'N'          NOT NULL,
CONSTRAINT         P_DOG_PK        PRIMARY KEY (DOG_ID),
CONSTRAINT         DOG_BIRTH_MONTH_CHK  CHECK(DOG_BIRTH_MONTH BETWEEN 1 AND 12),
CONSTRAINT         DOG_BIRTH_YEAR_CHK   CHECK(DOG_BIRTH_YEAR BETWEEN 1980 AND 2030),
CONSTRAINT         DOG_SEX_CHK          CHECK(UPPER(SEX) IN ('M','F')),
CONSTRAINT         DOG_SEX_CHK1         CHECK(LOWER(SEX) IN('m','f'))
);

CREATE TABLE P_DOGBREED (
BREED_ID           CHAR(5)                             NOT NULL,
BREED_COMMON_NAME  VARCHAR2(60)                        NOT NULL,
CONSTRAINT  P_DOGBREED_PK        PRIMARY KEY (BREED_ID),
CONSTRAINT  P_DOGBREED_UK1       UNIQUE(BREED_COMMON_NAME)
);

CREATE TABLE P_DOG_BREED_PERCENTAGE( 
DOG_ID              CHAR(5)                            NOT NULL,
BREED_ID            CHAR(5)                            NOT NULL,
PERCENT             NUMBER(5,2)       DEFAULT '100.00' NOT NULL,
CONSTRAINT   P_DOG_BREED_PERCENTAGE_PK   PRIMARY KEY(DOG_ID,BREED_ID),
CONSTRAINT   P_DOG_BREED_PERCENTAGE_FK FOREIGN KEY(DOG_ID) 
                REFERENCES P_DOG(DOG_ID),
CONSTRAINT   P_DOG_BREED_PERCENTAGE_FK1 FOREIGN KEY(BREED_ID) 
                REFERENCES P_DOGBREED(BREED_ID),
CONSTRAINT      P_DOG_BREED_PERCENTAGE_CHK CHECK(PERCENT BETWEEN 1 AND 100)
);

CREATE TABLE P_INCIDENT (
DOG_ID                      CHAR(5)                                NOT NULL,
INCIDENT_NUM                NUMBER(3,0)     DEFAULT 1              NOT NULL,
INCIDENT_TYPE               VARCHAR2(30)    DEFAULT 'OFF LEASH'    NOT NULL,
DATE_OF_INCIDENT            DATE            DEFAULT SYSDATE        NOT NULL,
HAS_MAJOR_HUMAN_INJURY      CHAR(1)         DEFAULT 'N'            NOT NULL,
INC_DESCRIPTION             VARCHAR2(1000)                         NULL,
CONSTRAINT    P_INCIDENT_PK         PRIMARY KEY (DOG_ID, INCIDENT_NUM),
CONSTRAINT    P_INCIDENT_P_DOG_FK   FOREIGN KEY (DOG_ID)
                    REFERENCES P_DOG (DOG_ID),
CONSTRAINT    P_INCIDENT_HUMAN_INJURY_CHK  CHECK
                  (HAS_MAJOR_HUMAN_INJURY IN ('Y','N'))
);

CREATE TABLE P_OWNER (
OWNER_ID             CHAR(5)                                 NOT NULL,
OWNER_FNAME          VARCHAR2(40)                            NULL,
OWNER_LNAME          VARCHAR2(60)                            NOT NULL,
STREETADDRESS1       VARCHAR2(60)                            NULL,
STREETADDRESS2       VARCHAR2(60)                            NULL,
CITY                 VARCHAR2(60)    DEFAULT'LARKSVILLE'     NULL,
STATE                CHAR(2)         DEFAULT'PA'             NULL,
ZIP                  CHAR(5)         DEFAULT'18704'          NULL,
TIMESTAMP            TIMESTAMP(2)    DEFAULT SYSDATE         NOT NULL,
PHONE                CHAR(10)                                NULL,
EMAIL                VARCHAR2(40)                            NULL,
CONSTRAINT   P_OWNER_PK                 PRIMARY KEY(OWNER_ID),
CONSTRAINT   P_OWNER_UK  UNIQUE(OWNER_FNAME,OWNER_LNAME,STREETADDRESS1,STREETADDRESS2,ZIP),
CONSTRAINT     P_OWNER_ZIP_CHK CHECK(ZIP IN ('18704','18708','18651')),
CONSTRAINT    P_OWMER_EMAIL_CHK   CHECK(EMAIL LIKE ('%_@_%.%_'))
);


CREATE TABLE P_OWNER_DOG_INT (
OWNER_ID            CHAR(5)                                  NOT NULL,
DOG_ID              CHAR(5)                                  NOT NULL,
CONSTRAINT       P_OWNER_DOG_INT_PK       PRIMARY KEY(OWNER_ID,DOG_ID),
CONSTRAINT      P_OWNER_DOG_INT_FK    FOREIGN KEY(OWNER_ID)
                REFERENCES P_OWNER(OWNER_ID),
CONSTRAINT      P_OWNER_DOG_INT_FK1    FOREIGN KEY(DOG_ID)
                REFERENCES P_DOG(DOG_ID)
);

CREATE TABLE P_PET (
DOG_ID                          CHAR (5)                              NOT NULL,
PET_DOG_LICENSE_NUM             CHAR(10)      DEFAULT 'UNLICENSED'    NOT NULL,
DATE_OF_LAST_PAYMENT            DATE          DEFAULT SYSDATE         NULL,
TOTAL_FEES_CURRENT_YEAR         NUMBER(5,2)   DEFAULT 25              NOT NULL,
TOTAL_PAYMENTS_CURRENT_YEAR     NUMBER(5,2)   DEFAULT 0               NOT NULL,
BALANCE_DUE_CURRENT_YEAR        NUMBER (5,2)                          NULL,
CONSTRAINT      P_PET_PK          PRIMARY KEY (DOG_ID),
CONSTRAINT      P_PET_UK1         UNIQUE(PET_DOG_LICENSE_NUM),
CONSTRAINT      P_PET_P_DOG_FK          FOREIGN KEY (DOG_ID)
                   REFERENCES P_DOG(DOG_ID)
);


CREATE TABLE P_PHOTO (
PHOTO_ID                CHAR(5)                                      NOT NULL,
PHOTO_FILENAME          VARCHAR2(60)        DEFAULT 'NOIMAGE.JPG'    NOT NULL,
PHOTO_TIMESTAMP         TIMESTAMP(2)        DEFAULT SYSDATE          NOT NULL,
DOG_ID                  CHAR(5)                                      NOT NULL,
CONSTRAINT     P_PHOTO_PK         PRIMARY KEY (PHOTO_ID),
CONSTRAINT     P_PHOTO_P_DOG_FK    FOREIGN KEY (DOG_ID)
                 REFERENCES P_DOG(DOG_ID),
CONSTRAINT     P_PHOTO_CHK        CHECK (UPPER(PHOTO_FILENAME) LIKE '%.JPG')                                    
);

CREATE TABLE P_SERVICE_DOGS ( 
DOG_ID                      CHAR(5)              NOT NULL,
SERVICE_DOG_LICENSE_NUM     VARCHAR(20)          NOT NULL,
OWNER_ID_ASSIGNED         CHAR(5)                        NULL,
CONSTRAINT     P_SERVICE_DOGS_PK           PRIMARY KEY(DOG_ID),
CONSTRAINT     P_SERVICE_DOGS_UK           UNIQUE(SERVICE_DOG_LICENSE_NUM),
CONSTRAINT     P_SERVICE_DOGS_FK           FOREIGN KEY(OWNER_ID_ASSIGNED)
            REFERENCES P_OWNER(OWNER_ID),
CONSTRAINT   P_SERVICE_DOGS_FK1         FOREIGN KEY(DOG_ID)
            REFERENCES P_DOG(DOG_ID)
            
);


CREATE TABLE P_SERVICE_CERTIFICATIONS (
CERT_ID                     CHAR(5)               NOT NULL,
CERTIFICATION               VARCHAR2(40)          NOT NULL,
ORIGINATION_DATE            DATE                  NULL,
MOST_RECENT_RENEWAL_DATE    DATE                  NULL,
CERT_EXPIRATION_DATE        DATE                  NULL,
DOG_ID                      CHAR(5)               NOT NULL,
CONSTRAINT    P_SERVICE_CERTIFICATIONS_PK           PRIMARY KEY (CERT_ID),
CONSTRAINT    P_SERVICE_CERTIFICATIONS_UK1           UNIQUE (CERTIFICATION,DOG_ID),
CONSTRAINT    P_SERVICE_CERT_P_SERVICE_DOGS_FK      FOREIGN KEY (DOG_ID)
                     REFERENCES P_SERVICE_DOGS(DOG_ID)
);


