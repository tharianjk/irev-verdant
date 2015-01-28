USE `Verdant` ;

-- -----------------------------------------------------
-- Schema Verdant
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Verdant` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `Verdant` ;

drop procedure if exists calc_MaxDiffAxialRatio;
drop procedure if exists calc_XdB_BW_BS;
drop procedure if exists calculate;
drop procedure if exists Calculate_params;
drop procedure if exists convert_to_CP;
drop procedure if exists spGetPolarPlot;
drop procedure if exists spCalCPGain;
drop procedure if exists calc_CP;
drop procedure if exists calc_Linear_Azimuth;
drop procedure if exists calc_Linear_Elevation;
drop procedure if exists calc_MaxDiffAxialRatio;
drop procedure if exists calc_Slant_Azimuth;
drop procedure if exists calc_Slant_Elevation;
drop procedure if exists convert_to_CP;

drop function if exists calc_AxialRatio;
drop function if exists calc_backlobe;
drop function if exists calc_cpdata;
drop function if exists calc_cpgain;
drop function if exists calc_omni;

drop view if exists axialratio_view;
drop view if exists vw_polardata;
drop view if exists vw_ampphase;



drop table IF  EXISTS phasedata;
drop table IF  EXISTS amplitudedata;
drop table IF  EXISTS PitchData;
drop table IF  EXISTS rollData;
drop table IF  EXISTS yawdata;
drop table IF  EXISTS pitchcalculated;
drop table IF  EXISTS rollcalculated;
drop table IF  EXISTS yawcalculated;
 Drop table IF EXISTS VDATA cascade;
 Drop table IF EXISTS HDATA cascade;
 Drop table IF EXISTS CPDATA cascade;
 Drop table IF EXISTS VCalculated cascade;
 Drop table IF EXISTS HCalculated cascade;
 Drop table IF EXISTS CPCalculated cascade;
 Drop table IF EXISTS ARCalculated cascade;
 Drop table IF EXISTS testFreq cascade;
 Drop table IF EXISTS testFiles cascade;
 Drop table IF EXISTS testData cascade;
 Drop table IF EXISTS fwk_user_favorite cascade;
 Drop table IF EXISTS FWK_USER_ROLE cascade;
 Drop table IF EXISTS FWK_ROLE cascade;
 Drop table IF EXISTS FWK_USER cascade;
 Drop table IF EXISTS FWK_COMPANY cascade; 
 Drop table IF EXISTS product_serial cascade;
 Drop table IF EXISTS product cascade;

-- ------------------ ------------------ ------------------ ------------------ ---------------------- 
--  FWK_ROLE: For storing role names. Used in user authorization 
--
-- ------------------ ------------------ ------------------ ------------------ ----------------------
CREATE TABLE IF NOT EXISTS `Verdant`.FWK_ROLE (
	ROLE_ID INTEGER AUTO_INCREMENT PRIMARY KEY,
	ROLENAME VARCHAR(50) NOT NULL,
	company_id int,	
	b_reports varchar(6) default 'false',
	b_events varchar(6) default 'false',
	b_tools varchar(6) default 'false',
	b_settings varchar(6) default 'false'
);

-- ------------------ ------------------ ------------------ ------------------ ---------------------- 
--  FWK_USER: For storing user details. Uses in user authentication 
--
-- ------------------ ------------------ ------------------ ------------------ ----------------------
CREATE TABLE IF NOT EXISTS `Verdant`.FWK_USER (
  USER_ID INTEGER AUTO_INCREMENT PRIMARY KEY,
  USERNAME  varchar(45) NOT NULL ,
  PASSWORD varchar(45),
  B_ENABLED varchar(6) DEFAULT 'TRUE' ,
  EMAIL varchar(100) null,
  MobilNo  varchar(20) null,
  DT_LASTLOGIN DATETIME 
);

-- ------------------ ------------------ ------------------ ------------------ ---------------------- 
--  FWK_USER_ROLE: Contains roles assigned to user 
--
-- ------------------ ------------------ ------------------ ------------------ ----------------------
CREATE TABLE IF NOT EXISTS `Verdant`.FWK_USER_ROLE (
  USER_ROLE_ID integer AUTO_INCREMENT PRIMARY KEY,  
  USER_ID  INTEGER NOT NULL,
  ROLE_ID INTEGER  NOT NULL
);
-- ------------------ ------------------ ------------------ ------------------ ---------------------- 
--  FWK_USER_FAVORITE: option to set filter for Section useful for a user
--
-- ------------------ ------------------ ------------------ ------------------ ----------------------
CREATE TABLE FWK_USER_FAVORITE (
	USER_ID INTEGER,	
	FAVOPERATION  VARCHAR(200),	
	bln_showtip varchar(10) default 'TRUE'
);
-- ------------------ ------------------ ------------------ ------------------ ---------------------- 
--  FWK_COMPANY: 
--
-- ------------------ ------------------ ------------------ ------------------ ----------------------
CREATE TABLE IF NOT EXISTS `Verdant`.FWK_COMPANY(
	COMPANY_ID INTEGER NOT NULL,
	COMPANYNAME varchar(50) NOT NULL,
	ADDRESS  VARCHAR(300) NULL,	
expirydate varchar(100),
 	PRIMARY KEY (COMPANY_ID));
-- -----------------------------------------------------
-- Table `Verdant`.`Product`
-- ---------------------------------------product--------------
CREATE TABLE IF NOT EXISTS `Verdant`.`Product` (
  `Product_id` int AUTO_INCREMENT,
  `Productname` VARCHAR(45) NULL,
  `Version` VARCHAR(45) NULL,
  `PType` VARCHAR(45) NULL,
  `ImageFileName` VARCHAR(100) NULL,
  b_withcp boolean default false,
  PRIMARY KEY (`Product_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Verdant`.`Product_serial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Verdant`.`Product_serial` (
  `Prodserial_id` int AUTO_INCREMENT,
  `Product_id` INT NULL,
  `SerialNo` VARCHAR(45) NULL,
  rptheader varchar(200),
  rptfooter varchar(200),
  INDEX `Product_id_idx` (`Product_id` ASC),
  PRIMARY KEY (`Prodserial_id`),
  CONSTRAINT `Product_id`
    FOREIGN KEY (`Product_id`)
    REFERENCES `Verdant`.`Product` (`Product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Verdant`.`TestData`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS TestData(Test_id int AUTO_INCREMENT PRIMARY KEY,
TestName varchar(50),
TestDesc varchar(100),
ProdSerial_id int,
TestDate datetime,
frequnit varchar(5) default 'MHz',
testcenter varchar(100),
instruments varchar(100),
Calibration varchar(100),
testproc varchar(100),
testtype varchar(10));

-- -----------------------------------------------------
-- Table `Verdant`.`TestFreq
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS TestFreq(freq_id int AUTO_INCREMENT PRIMARY KEY,Test_id INT,Frequency DECIMAL(20,10),lineargain decimal(20,10));
-- -----------------------------------------------------
-- Table `Verdant`.`VData`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Verdant`.`VData` (
  `VData_id` INT AUTO_INCREMENT NOT NULL,
  `Test_id` INT NULL,
   Frequency DECIMAL(20,10),
  `Angle` DECIMAL(12,2) NULL,
  `Amplitude` DECIMAL(12,8) NULL,  
  PRIMARY KEY (`VData_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Verdant`.`HData`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Verdant`.`HData` (
  `HData_id` INT AUTO_INCREMENT,
  `Test_id` INT NULL,
  Frequency DECIMAL(20,10),
  `Angle` DECIMAL(12,2) NULL,
  `Amplitude` DECIMAL(12,8) NULL,
  PRIMARY KEY (`HData_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Verdant`.`CPData`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Verdant`.`CPData` (
  `CPData_id` INT  AUTO_INCREMENT,
  `Test_id` INT NULL,
  Frequency DECIMAL(20,10),
  `Angle` DECIMAL(12,2) NULL,
  `Amplitude` DECIMAL(12,8) NULL,  
  PRIMARY KEY (`CPData_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Verdant`.`VCalculated`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Verdant`.`VCalculated` (
  `VCalculated_Id` INT AUTO_INCREMENT,
  `Test_id` INT NULL,
  `Frequency` DECIMAL(20,10) NULL,
  `TestDate` DATETIME NULL,
  `OmniDeviation` DECIMAL(20,10) NULL, -- omni deviation
  `3Db_BW_BMax` DECIMAL(20,10) NULL, -- 3db Beam width from Beam Max
  `3Db_BW_0` DECIMAL(20,10) NULL, -- 3db Beam width from 0 degree
  `3Db_BW_90` DECIMAL(20,10) NULL, -- 3db Beam width from 90 degree
  `3Db_BS_BMax` DECIMAL(20,10) NULL, -- 3db Beam squint from Beam Max
  `3Db_BS_0` DECIMAL(20,10) NULL, -- 3db Beam squint from 0 degree
  `3Db_BS_90` DECIMAL(20,10) NULL, -- 3db Beam squint from 90 degree
  `10Db_BW_BMax` DECIMAL(20,10) NULL, -- 10db Beam width from Beam Max
  `10Db_BW_0` DECIMAL(20,10) NULL, -- 10db Beam width from 0 degree
  `10Db_BW_90` DECIMAL(20,10) NULL, -- 10db Beam width from 90 degree
  `10Db_BS_BMax` DECIMAL(20,10) NULL, -- 10db Beam squint from Beam Max
  `10Db_BS_0` DECIMAL(20,10) NULL, -- 10db Beam squint from 0 degree
  `10Db_BS_90` DECIMAL(20,10) NULL, -- 10db Beam squint from 90 degree
  `BackLobe` DECIMAL(20,10) NULL, -- Back Lobe level
    
  PRIMARY KEY (`VCalculated_Id`))
ENGINE = InnoDB;
  
-- -----------------------------------------------------
-- Table `Verdant`.`HCalculated`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Verdant`.`HCalculated` (
  `HCalculated_Id` INT AUTO_INCREMENT,
  `Test_id` INT NULL,
  `Frequency` DECIMAL(20,10) NULL,
  `TestDate` DATETIME NULL,
  `OmniDeviation` DECIMAL(20,10) NULL, -- omni deviation
  `3Db_BW_BMax` DECIMAL(20,10) NULL, -- 3db Beam width from Beam Max
  `3Db_BW_0` DECIMAL(20,10) NULL, -- 3db Beam width from 0 degree
  `3Db_BW_90` DECIMAL(20,10) NULL, -- 3db Beam width from 90 degree
  `3Db_BS_BMax` DECIMAL(20,10) NULL, -- 3db Beam squint from Beam Max
  `3Db_BS_0` DECIMAL(20,10) NULL, -- 3db Beam squint from 0 degree
  `3Db_BS_90` DECIMAL(20,10) NULL, -- 3db Beam squint from 90 degree
  `10Db_BW_BMax` DECIMAL(20,10) NULL, -- 10db Beam width from Beam Max
  `10Db_BW_0` DECIMAL(20,10) NULL, -- 10db Beam width from 0 degree
  `10Db_BW_90` DECIMAL(20,10) NULL, -- 10db Beam width from 90 degree
  `10Db_BS_BMax` DECIMAL(20,10) NULL, -- 10db Beam squint from Beam Max
  `10Db_BS_0` DECIMAL(20,10) NULL, -- 10db Beam squint from 0 degree
  `10Db_BS_90` DECIMAL(20,10) NULL, -- 10db Beam squint from 90 degree
  `BackLobe` DECIMAL(20,10) NULL, -- Back Lobe level
  PRIMARY KEY (`HCalculated_Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Verdant`.`CPCalculated`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Verdant`.`CPCalculated` (
  `CPCalculated_Id` INT AUTO_INCREMENT,
  `Test_id` INT NULL,
  `Frequency` DECIMAL(20,10) NULL,
  `TestDate` DATETIME NULL,
  `3Db_BW_BMax` DECIMAL(20,10) NULL, -- 3db Beam width from Beam Max
  `3Db_BW_0` DECIMAL(20,10) NULL, -- 3db Beam width from 0 degree
  `3Db_BW_90` DECIMAL(20,10) NULL, -- 3db Beam width from 90 degree
  `3Db_BS_BMax` DECIMAL(20,10) NULL, -- 3db Beam squint from Beam Max
  `3Db_BS_0` DECIMAL(20,10) NULL, -- 3db Beam squint from 0 degree
  `3Db_BS_90` DECIMAL(20,10) NULL, -- 3db Beam squint from 90 degree
  `10Db_BW_BMax` DECIMAL(20,10) NULL, -- 10db Beam width from Beam Max
  `10Db_BW_0` DECIMAL(20,10) NULL, -- 10db Beam width from 0 degree
  `10Db_BW_90` DECIMAL(20,10) NULL, -- 10db Beam width from 90 degree
  `10Db_BS_BMax` DECIMAL(20,10) NULL, -- 10db Beam squint from Beam Max
  `10Db_BS_0` DECIMAL(20,10) NULL, -- 10db Beam squint from 0 degree
  `10Db_BS_90` DECIMAL(20,10) NULL, -- 10db Beam squint from 90 degree
  `BackLobe` DECIMAL(20,10) NULL, -- Back Lobe level
  `CPGain` DECIMAL(20,10) NULL, -- CP Gain from linear gain
  PRIMARY KEY (`CPCalculated_Id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Verdant`.`ARCalculated`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Verdant`.`ARCalculated` (
  `ARCalculated_Id` INT AUTO_INCREMENT,
  `Test_id` INT NULL,
  `Frequency` DECIMAL(20,10) NULL,
  `TestDate` DATETIME NULL,
  `AR_0` DECIMAL(20,10) NULL, -- Axial ratio at 0 degree
  `AR_P45` DECIMAL(20,10) NULL, -- Axial ratio at +45
  `AR_M45` DECIMAL(20,10) NULL, -- Axial ratio at -45
  `MaxAR_P_Ratio` DECIMAL(20,10) NULL, -- Max Axial Ratio from 0 to +45 
  `MaxAR_P_Angle` DECIMAL(20,10) NULL, -- Angle corresp to Max Axial Ratio from 0 to +45 
  `MaxAR_M_Ratio` DECIMAL(20,10) NULL, -- Max Axial Ratio from 0 to -45 
  `MaxAR_M_Angle` DECIMAL(20,10) NULL, -- Angle corresp to Max Axial Ratio from 0 to -45 
  PRIMARY KEY (`ARCalculated_Id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Verdant`.`PitchData`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PitchData (
  `pitchData_id` INT  AUTO_INCREMENT,
  `Test_id` INT NULL,
   Frequency DECIMAL(20,10),
  `Angle` DECIMAL(12,2) NULL,
  `Amplitude` DECIMAL(12,8) NULL,   
  PRIMARY KEY (`pitchData_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Verdant`.`rollData`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS rollData (
  `rollData_id` INT  AUTO_INCREMENT,
  `Test_id` INT NULL,
  Frequency DECIMAL(20,10),
  `Angle` DECIMAL(12,2) NULL,
  `Amplitude` DECIMAL(12,8) NULL,  
  PRIMARY KEY (`rollData_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Verdant`.`yawData`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS yawData (
  `yawData_id` INT  AUTO_INCREMENT,
  `Test_id` INT NULL,
  Frequency DECIMAL(20,10),
  `Angle` DECIMAL(12,2) NULL,
  `Amplitude` DECIMAL(12,8) NULL,  
  PRIMARY KEY (`yawData_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Verdant`.`pitchCalculated`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Verdant`.`PitchCalculated` (
  pitchCalculated_Id INT AUTO_INCREMENT,
  `Test_id` INT NULL,
  `Frequency` DECIMAL(20,10) NULL,
  `TestDate` DATETIME NULL,
  `3Db_BW_BMax` DECIMAL(20,10) NULL, -- 3db Beam width from Beam Max
  `3Db_BW_0` DECIMAL(20,10) NULL, -- 3db Beam width from 0 degree
  `3Db_BW_90` DECIMAL(20,10) NULL, -- 3db Beam width from 90 degree
  `10Db_BW_BMax` DECIMAL(20,10) NULL, -- 10db Beam width from Beam Max
  `10Db_BW_0` DECIMAL(20,10) NULL, -- 10db Beam width from 0 degree
  `10Db_BW_90` DECIMAL(20,10) NULL, -- 10db Beam width from 90 degree

  PRIMARY KEY (`pitchCalculated_Id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Verdant`.`rollCalculated`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Verdant`.`rollCalculated` (
  rollCalculated_Id INT AUTO_INCREMENT,
  `Test_id` INT NULL,
  `Frequency` DECIMAL(20,10) NULL,
  `TestDate` DATETIME NULL,
  `3Db_BW_BMax` DECIMAL(20,10) NULL, -- 3db Beam width from Beam Max
  `3Db_BW_0` DECIMAL(20,10) NULL, -- 3db Beam width from 0 degree
  `3Db_BW_90` DECIMAL(20,10) NULL, -- 3db Beam width from 90 degree
  `10Db_BW_BMax` DECIMAL(20,10) NULL, -- 10db Beam width from Beam Max
  `10Db_BW_0` DECIMAL(20,10) NULL, -- 10db Beam width from 0 degree
  `10Db_BW_90` DECIMAL(20,10) NULL, -- 10db Beam width from 90 degree
      
  PRIMARY KEY (`rollCalculated_Id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Verdant`.`yawCalculated`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Verdant`.`yawCalculated` (
  yawCalculated_Id INT AUTO_INCREMENT,
  `Test_id` INT NULL,
  `Frequency` DECIMAL(20,10) NULL,
  `TestDate` DATETIME NULL,
  `OmniDeviation` DECIMAL(20,10) NULL, -- omni deviation
 
 PRIMARY KEY (`yawCalculated_Id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- View for Polar Plot
-- -----------------------------------------------------

create view vw_polardata as
SELECT hp.test_id,case t.frequnit when 'GHz' then hp.frequency/1000 else hp.frequency end frequency ,hp.angle,hp.amplitude hamplitude, 0 vamplitude, 0 camplitude, 0 pamplitude, 0 ramplitude, 0 yamplitude
FROM hdata hp inner join testdata t on hp.test_id=t.test_id 
UNION All
SELECT hp.test_id,case t.frequnit when 'GHz' then hp.frequency/1000 else hp.frequency end frequency,hp.angle,0 hamplitude,hp.amplitude vamplitude, 0 camplitude, 0 pamplitude, 0 ramplitude, 0 yamplitude
FROM vdata hp inner join testdata t on hp.test_id=t.test_id;


-- -----------------------------------------------------
-- Table `Verdant`.`amplitudedata`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Verdant`.`amplitudedata` (  
  `prodserial_id` INT NULL,
   `frequency` DECIMAL(20,10),  
  `ampvalue` DECIMAL(12,8) NULL,  
  testname varchar(50),
  PRIMARY KEY (prodserial_id,frequency,testname))
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `Verdant`.`phasedata`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Verdant`.`phasedata` (  
  `prodserial_id` INT NULL,
   `frequency` DECIMAL(20,10),  
  `phasevalue` DECIMAL(12,8) NULL,  
  testname varchar(50),
  PRIMARY KEY (prodserial_id,frequency,testname))
ENGINE = InnoDB;


-- Create View axialratio_view

CREATE 
    ALGORITHM = UNDEFINED 
    SQL SECURITY DEFINER
VIEW `axialratio_view` AS
    SELECT 
        `h`.`Test_id` AS `test_id`,
        `h`.`Frequency` AS `Frequency`,
        `h`.`Angle` AS `angle`,
        (`h`.`Amplitude` - `v`.`Amplitude`) AS `axialRatio`
    FROM
        (`hdata` `h`
        JOIN `vdata` `v` ON (((`h`.`Test_id` = `v`.`Test_id`)
            AND (`h`.`Frequency` = `v`.`Frequency`)
            AND (`h`.`Angle` = `v`.`Angle`))));
            
            
create view vw_ampphase as select distinct a.frequency,a.prodserial_id,a.ampvalue amplitude, 'A' typ
,p.productname,a.testname SerialNo from amplitudedata a
inner join product_serial s on a.prodserial_id=s.Prodserial_id inner join product p on s.Product_id=p.Product_id
union select distinct a.frequency,a.prodserial_id,a.phasevalue amplitude, 'P' typ,p.productname,a.testname SerialNo from phasedata a
inner join product_serial s on a.prodserial_id=s.Prodserial_id inner join product p on s.Product_id=p.Product_id;            

alter table FWK_ROLE add constraint fk_role_company foreign key (company_id) references fwk_company(company_id);
alter table fwk_user_role add constraint FK_ROLE_User foreign key (role_id) references FWK_ROLE(role_id);
alter table fwk_user_role add constraint FK_ROLE_User_R foreign key (user_id) references fwk_user(user_id);
alter table testdata add constraint FK_testdata_prd foreign key (Prodserial_id) references Product_serial(Prodserial_id);
alter table cpcalculated add constraint FK_cpcalculated_prd foreign key (Test_id) references testdata(Test_id);
alter table Vcalculated add constraint FK_vcalculated_prd foreign key (Test_id) references testdata(Test_id);
alter table hcalculated add constraint FK_hpcalculated_prd foreign key (Test_id) references testdata(Test_id);
alter table ARCalculated add constraint FK_arcalculated_prd foreign key (Test_id) references testdata(Test_id);
alter table cpdata add constraint FK_cpdata_test foreign key (Test_id) references testdata(Test_id);
alter table vdata add constraint FK_vdata_test foreign key (Test_id) references testdata(Test_id);
alter table hdata add constraint FK_hdata_test foreign key (Test_id) references testdata(Test_id);
alter table FWK_USER_FAVORITE add constraint FK_UseFav_user foreign key (USER_ID) references FWK_USER(USER_ID);
alter table amplitudedata add constraint fk_amplitudedata foreign key (prodserial_id) references product_serial(prodserial_id);
alter table phasedata add constraint fk_phasedata foreign key (prodserial_id) references product_serial(prodserial_id);

create index testid_freq_angle_hp on hdata(Test_id, Frequency, angle,Amplitude);
create index testid_freq_angle_vp on vdata(Test_id, Frequency, angle,Amplitude);
create index testid_freq_angle_cp on cpdata(Test_id, Frequency, angle,Amplitude);

alter table product add constraint uk_prodname unique (productname);

ALTER TABLE `verdant`.`pitchdata` 
ADD INDEX `test_freq_angle_ampl_pitch` (`Test_id` ASC, `Frequency` ASC, `Angle` ASC, `Amplitude` ASC);
ALTER TABLE `verdant`.`rolldata`
ADD INDEX `test_freq_angle_ampl_pitch` (`Test_id` ASC, `Frequency` ASC, `Angle` ASC, `Amplitude` ASC);
ALTER TABLE `verdant`.`yawdata`
ADD INDEX `test_freq_angle_ampl_pitch` (`Test_id` ASC, `Frequency` ASC, `Angle` ASC, `Amplitude` ASC);

INSERT INTO FWK_COMPANY (COMPANY_ID, COMPANYNAME, ADDRESS,expirydate ) VALUES (1 , 'Verdant', 'VERDANT TELEMETRY & ANTENNA SYSTEMS PVT. LTD.
REGD. OFFICE: 26/411A KONTHURUTHY, COCHIN- 682 013, INDIA. TEL: 91-484-2663104 FAX: 91-484-2663576
e mail: info@verdanttelemetry.com www.verdanttelemetry.com','UnjFek91rgXOrSxtnQ54Rg==');

INSERT INTO fwk_user(user_id,username, password, b_enabled) values(1,'admin', 'admin', true);
INSERT INTO FWK_ROLE(ROLE_ID, ROLENAME,COMPANY_ID,b_reports,b_events,b_tools,b_settings) values(1,'ROLE_USER',1,'true','true','true','true');
INSERT INTO FWK_ROLE(ROLE_ID, ROLENAME,COMPANY_ID,b_reports,b_events,b_tools,b_settings) values(2,'ROLE_ADMIN',1,'true','true','true','true');
INSERT INTO fwk_user_role (user_id, role_id) VALUES (1, 1);
INSERT INTO fwk_user_role (user_id, role_id) VALUES (1, 2);
