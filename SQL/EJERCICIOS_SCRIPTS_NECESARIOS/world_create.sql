CREATE TABLE country (
  Code varchar2(3) NOT NULL PRIMARY KEY,
  Name varchar2(52) NOT NULL,
  Continent varchar2(20) NOT NULL,
  Region varchar2(26) NOT NULL ,
  SurfaceArea number(10,2) NOT NULL,
  IndepYear number(9) DEFAULT NULL,
  Population number(12) NOT NULL,
  LifeExpectancy number(3,1) DEFAULT NULL,
  GNP number(10,2) DEFAULT NULL,
  GNPOld number(10,2) DEFAULT NULL,
  LocalName varchar2(45) NOT NULL,
  GovernmentForm varchar2(45) NOT NULL,
  HeadOfState varchar2(60) DEFAULT NULL,
  Capital number(9) DEFAULT NULL,
  Code2 varchar2(2) NOT NULL );

CREATE TABLE city (
  ID number(9) NOT NULL PRIMARY KEY ,
  Name varchar2(35) NOT NULL,
  CountryCode varchar2(3) NOT NULL,
  District varchar2(40),
  Population int NOT NULL,
  CONSTRAINT city_ibfk_1 FOREIGN KEY (CountryCode) REFERENCES country (Code)
);

CREATE TABLE countrylanguage (
  CountryCode varchar2(3) NOT NULL,
  Language varchar2(30) NOT NULL,
  IsOfficial varchar2(1) NOT NULL,
  Percentage number(4,1) NOT NULL,
  PRIMARY KEY (CountryCode,Language),
  CONSTRAINT countryLanguage_ibfk_1 FOREIGN KEY (CountryCode) REFERENCES country (Code)
) ;

