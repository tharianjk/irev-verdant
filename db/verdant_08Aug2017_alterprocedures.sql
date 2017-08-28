-- 16-08-2017
use verdant;
-- 08-08-2017
drop table IF EXISTS hdata_phase;
CREATE TABLE IF NOT EXISTS hdata_phase (
  hData_id_p INT AUTO_INCREMENT NOT NULL,
  Test_id INT NULL,
   Frequency decimal(40,20),
  Angle DECIMAL(12,2) NULL,
  Phaseval DECIMAL(12,8) NULL,  
  PRIMARY KEY (hData_id_p))
ENGINE = InnoDB;
alter table hdata_phase add constraint FK_hdata_phase_test foreign key (Test_id) references testdata(Test_id);
create index testid_freq_angle_php on hdata_phase(Test_id, Frequency, angle,Phaseval);

drop table IF EXISTS vdata_phase;
CREATE TABLE IF NOT EXISTS vdata_phase (
  vData_id_p INT AUTO_INCREMENT NOT NULL,
  Test_id INT NULL,
   Frequency decimal(40,20),
  Angle DECIMAL(12,2) NULL,
  Phaseval DECIMAL(12,8) NULL,  
  PRIMARY KEY (vData_id_p))
ENGINE = InnoDB;
alter table vdata_phase add constraint FK_vdata_phase_test foreign key (Test_id) references testdata(Test_id);
create index testid_freq_angle_pvp on vdata_phase(Test_id, Frequency, angle,Phaseval);

drop table IF EXISTS phasecalculated;
CREATE TABLE phasecalculated (
  phCalculated_Id INT AUTO_INCREMENT NOT NULL,
  Test_id INT NULL,
  Frequency decimal(40,20),
  TestDate datetime DEFAULT NULL,
  PD_0 decimal(40,20) DEFAULT NULL,
  PD_P60 decimal(40,20) DEFAULT NULL,
  PD_M60 decimal(40,20) DEFAULT NULL,
  MaxPD_P60_Ratio decimal(40,20) DEFAULT NULL,
  MaxPD_P60_Angle decimal(40,20) DEFAULT NULL,
  MaxPD_M60_Ratio decimal(40,20) DEFAULT NULL,
  MaxPD_M60_Angle decimal(40,20) DEFAULT NULL,
   PRIMARY KEY (phCalculated_Id),
  KEY FK_phCalculated_prd (Test_id),
  CONSTRAINT FK_phCalculated_prd FOREIGN KEY (Test_id) REFERENCES testdata (Test_id)
) ENGINE=InnoDB;

-- 03-08-2017
drop table IF EXISTS fdata;
drop table IF EXISTS fcalculated;

CREATE TABLE IF NOT EXISTS fData (
  FData_id INT AUTO_INCREMENT NOT NULL,
  Test_id INT NULL,
   Frequency decimal(40,20),
  Angle DECIMAL(12,2) NULL,
  Amplitude DECIMAL(12,8) NULL,  
  PRIMARY KEY (FData_id));

 
alter table fdata add constraint FK_fdata_test foreign key (Test_id) references testdata(Test_id);
create index testid_freq_angle_fp on fData(Test_id, Frequency, angle,Amplitude);

CREATE TABLE fcalculated (
  FCalculated_Id int(11) NOT NULL AUTO_INCREMENT,
  Test_id int(11) DEFAULT NULL,
  Frequency decimal(40,20) DEFAULT NULL,
  TestDate datetime DEFAULT NULL,
  OmniDeviation decimal(40,20) DEFAULT NULL,
  3Db_BW_BMax decimal(40,20) DEFAULT NULL,
  3Db_BW_0 decimal(40,20) DEFAULT NULL,
  3Db_BW_90 decimal(40,20) DEFAULT NULL,
  3Db_BS_BMax decimal(40,20) DEFAULT NULL,
  3Db_BS_0 decimal(40,20) DEFAULT NULL,
  3Db_BS_90 decimal(40,20) DEFAULT NULL,
  10Db_BW_BMax decimal(40,20) DEFAULT NULL,
  10Db_BW_0 decimal(40,20) DEFAULT NULL,
  10Db_BW_90 decimal(40,20) DEFAULT NULL,
  10Db_BS_BMax decimal(40,20) DEFAULT NULL,
  10Db_BS_0 decimal(40,20) DEFAULT NULL,
  10Db_BS_90 decimal(40,20) DEFAULT NULL,
  BackLobe decimal(40,20) DEFAULT NULL,
  3Db_BW_270 decimal(40,20) DEFAULT NULL,
  3Db_BS_270 decimal(40,20) DEFAULT NULL,
  10Db_BW_270 decimal(40,20) DEFAULT NULL,
  10Db_BS_270 decimal(40,20) DEFAULT NULL,
  PRIMARY KEY (FCalculated_Id),
  KEY FK_fcalculated_prd (Test_id),
  CONSTRAINT FK_fcalculated_prd FOREIGN KEY (Test_id) REFERENCES testdata (Test_id)
) ;


drop view if exists phasedifference_view;

CREATE    
VIEW phasedifference_view AS
    SELECT 
        h.Test_id AS test_id,
        h.Frequency AS Frequency,
        h.Angle AS angle,
        ABS((v.phaseval - h.phaseval)) AS phasedifference
    FROM
        (hdata_phase h
        JOIN vdata_phase v ON (((h.Test_id = v.Test_id)
            AND (h.Frequency = v.Frequency)
            AND (h.Angle = v.Angle))));



drop procedure  if exists spPolarMultiple;
-- call spPolarMultiple('1000.0,2000','0.0001,0.0001',8,'admin','F')
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spPolarMultiple`(strfreq varchar(100),strlg varchar(100),testid int,usr Varchar(20),typ varchar(2))
BEGIN 
declare cnt int; 
declare rint int; 

declare strmaxvalue varchar(50);
declare strminvalue varchar(50);
declare prec int ;
set cnt=0; 
delete from temppolar where user=usr; 
create table if not exists t1 (id integer ,freq decimal(20,10),lg decimal (20,10)); 

truncate table t1; 
select frequnit into @unt from testdata where test_id=testid;
       
SET @String = strfreq; 
SET @Occurrences = LENGTH(@String) - LENGTH(REPLACE(@String, ',', '')); 

        myloop: WHILE (@Occurrences > 0)        
 DO              SET @myValue = SUBSTRING_INDEX(@String, ',', 1); 
            IF (@myValue != '') THEN  
           insert into t1(id,freq) values(cnt,case @unt when 'GHz' then convert(@myValue,decimal)*1000 else convert(@myValue,decimal) end );   
          set cnt=cnt+1;        
     ELSE              
   LEAVE myloop;      
        END IF;    
         SET @Occurrences = LENGTH(@String) - LENGTH(REPLACE(@String, ',', '')); 

       IF (@occurrences = 0) THEN      
            LEAVE myloop;           
   END IF;            
 SET @String = SUBSTRING(@String,LENGTH(SUBSTRING_INDEX(@String, ',', 1))+2);      
   END WHILE;  



 set cnt=0; 
SET @String      = strlg;   
      SET @Occurrences = LENGTH(@String) - LENGTH(REPLACE(@String, ',', ''));   
      myloop: WHILE (@Occurrences > 0)     
    DO        
      SET @myValue = SUBSTRING_INDEX(@String, ',', 1);        
     IF (@myValue != '') THEN       
      update  t1 set lg=convert(@myValue,decimal) where id=cnt ;        
     set cnt=cnt+1;          
   ELSE              
   LEAVE myloop;     
         END IF;     
        SET @Occurrences = LENGTH(@String) - LENGTH(REPLACE(@String, ',', ''));       
      IF (@occurrences = 0) THEN             
     LEAVE myloop;       
       END IF;           
  SET @String = SUBSTRING(@String,LENGTH(SUBSTRING_INDEX(@String, ',', 1))+2);   
      END WHILE; 
 select count(*) into @cnt from t1; 

if @cnt=0 then
insert into t1(id,freq,lg) values(1,case @unt when 'GHz' then convert(strfreq,decimal)*1000 else convert(strfreq,decimal) end,convert(strlg,decimal));
set @cnt=1;
 end if;
set rint=0; 
set @acnt=0;

select count(*) into @acnt from scaling s inner join product_serial ps on s.product_id=ps.product_id inner join testdata t on ps.prodserial_id=t.prodserial_id
where t.test_id=testid and s.frequency in (select  freq from t1);
if @acnt > 0 then
select distinct convert(floor(max(maxscale)),char(30)) ,convert(round(min(minscale),0),char(30))  into strmaxvalue,strminvalue from scaling s inner join product_serial ps on s.product_id=ps.product_id inner join testdata t on ps.prodserial_id=t.prodserial_id
where t.test_id=testid and s.frequency in (select  freq from t1);
end if;

if typ='H' then 
set @tab= 'hdata';
if @acnt = 0 then
       select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM hdata HD 
		where HD.Frequency in (select  freq from t1) and HD.Test_id=testid;
		select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM hdata HD 
		where HD.Frequency in (select  freq from t1) and HD.Test_id=testid;
end if;

end if;
  if typ='V' then 
set @tab= 'vdata';
if @acnt = 0 then
       select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM vdata HD 
		where HD.Frequency in (select distinct freq from t1) and HD.Test_id=testid;
		select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM vdata HD 
		where HD.Frequency in (select distinct freq from t1) and HD.Test_id=testid;
end if;
end if;
  if typ='C' then 
set @tab= 'cpdata';
if @acnt = 0 then
       select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM cpdata HD 
		where HD.Frequency in (select distinct freq from t1) and HD.Test_id=testid;
		select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM cpdata HD 
		where HD.Frequency in (select distinct freq from t1) and HD.Test_id=testid;
end if;
end if;
  if typ='P' then 
set @tab= 'pitchdata';
if @acnt = 0 then
       select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM pitchdata HD 
		where HD.Frequency in (select distinct freq from t1) and HD.Test_id=testid;
		select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM pitchdata HD 
		where HD.Frequency in (select distinct freq from t1) and HD.Test_id=testid;
end if;
end if; 
 if typ='R' then 
set @tab= 'rolldata'; 
if @acnt = 0 then
       select convert(floor(max(distinct Amplitude))+1,char(30)) into strmaxvalue FROM rolldata HD 
		where HD.Frequency in (select distinct freq from t1) and HD.Test_id=testid;
		select convert(round(min(distinct Amplitude),0),char(30)) into strminvalue FROM rolldata HD 
		where HD.Frequency in (select distinct freq from t1) and HD.Test_id=testid;
end if;
end if;
 if typ='Y' then 
set @tab= 'yawdata'; 
if @acnt = 0 then
       select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM yawdata HD 
		where HD.Frequency in (select distinct freq from t1) and HD.Test_id=testid;
		select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM yawdata HD 
		where HD.Frequency in (select distinct freq from t1) and HD.Test_id=testid;
end if;
end if;
if typ='F' then 
set @tab= 'fdata'; 
if @acnt = 0 then
       select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM fdata HD 
		where HD.Frequency in (select distinct freq from t1) and HD.Test_id=testid;
		select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM fdata HD 
		where HD.Frequency in (select distinct freq from t1) and HD.Test_id=testid;
end if;
end if;

myloop: WHILE (rint<@cnt)      
   DO  

select freq into @freq from t1 where id=rint; 
 
SET @sql1 = CONCAT('insert into temppolar(user,test_id,angle,amp',rint+1,',frequency)'); 
set @sql2= CONCAT('SELECT ''',usr,''', HD.Test_id,HD.Angle,HD.Amplitude,HD.Frequency FROM ',@tab,' HD where HD.Frequency=',@freq,' and HD.Test_id=',testid);  
set @s=CONCAT(@sql1,@sql2);  
        
PREPARE stmt1 FROM @s;  
EXECUTE stmt1;  
DEALLOCATE PREPARE stmt1;  
  set rint=rint+1;    
END WHILE;        
    drop table t1; 
 
 

  select test_id TestId,Angle,sum(amp1) Amplitude1, frequency,sum(amp2) Amplitude2,
sum(amp3) Amplitude3,sum(amp4) Amplitude4,sum(amp5) Amplitude5 ,sum(amp6) Amplitude6,sum(amp7) Amplitude7,
sum(amp8) Amplitude8,sum(amp9) Amplitude9,sum(amp10) Amplitude10 ,sum(amp11) Amplitude11,sum(amp12) Amplitude12,
sum(amp13) Amplitude13,sum(amp14) Amplitude14,sum(amp15) Amplitude15, sum(amp16) Amplitude16,sum(amp17) Amplitude17,
sum(amp18) Amplitude18,sum(amp19) Amplitude19,sum(amp20) Amplitude20,strmaxvalue,strminvalue,@unt frequnit
 from temppolar where user=usr group by test_id,angle,frequency  ,strmaxvalue,strminvalue, frequnit
order by test_id,frequency,angle;  
END$$


drop procedure if exists spGetPolarPlot ;

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE  PROCEDURE `spGetPolarPlot`(
testid INT,
freqparm decimal(40,20),
typ varchar(5), 
lg decimal(40,20)
)
BEGIN



	declare l_proc_id varchar(100) default 'spGetPolarPlot';


    declare isDebug INT default 0;
DECLARE ampl decimal(40,20) default 0;
DECLARE vampl decimal(40,20) default 0;
declare lgampl decimal(40,20) default 0;
declare strmaxvalue varchar(50);
declare strminvalue varchar(50);
declare prec int ;
declare cnt int ;
declare unt varchar(10);
declare freq decimal(40,20);

 
 

 DECLARE EXIT HANDLER FOR SQLEXCEPTION 
 begin
	if isDebug > 0 then
		GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
		@errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
		SET @full_error = CONCAT("SQLException ", @errno, " (", @sqlstate, "): ", @text);
		call debug(l_proc_id, @full_error,'F','I');
        SET @details = CONCAT("Test id : ", testid, ", Frequency : ",freq, ", typ : ",typ,",linear gain : ",lg);
		call debug(l_proc_id, @details,'I','I');
        
         RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
	end if;
 end;


select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in spGetPolarPlot','I','I');
 end if;


select nprecision into prec from fwk_company;

select frequnit into unt from testdata where test_id=testid;

set freq=freqparm;

if unt='GHz' then
set freq=freqparm*1000;
end if;

select count(*) into cnt from scaling s inner join product_serial ps on s.product_id=ps.product_id inner join testdata t on ps.prodserial_id=t.prodserial_id
where t.test_id=testid and s.frequency=freq;
if cnt > 0 then
select distinct convert(maxscale,char(10)),convert(minscale,char(10)) into strmaxvalue,strminvalue from scaling s inner join product_serial ps on s.product_id=ps.product_id inner join testdata t on ps.prodserial_id=t.prodserial_id
where t.test_id=testid and s.frequency=freq;
end if;


if lg=0.0001 then
		if typ='H' then
			if cnt=0 then
					select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM hdata HD 
					where HD.Frequency= freq and HD.Test_id=testid;
					select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM hdata HD 
					where HD.Frequency=freq and HD.Test_id=testid;
			end if;
        SELECT HD.Angle,HD.Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM hdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;

end if;
if typ='V' then
			if cnt=0 then
					select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM vdata HD 
					where HD.Frequency=freq and HD.Test_id=testid;
					select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM vdata HD 
					where HD.Frequency=freq and HD.Test_id=testid;
			end if;
		SELECT HD.Angle,HD.Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM vdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;

		end if;
		if typ='C' then
			if cnt=0 then
					select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM cpdata HD 
					where HD.Frequency=freq and HD.Test_id=testid;
					select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM cpdata HD 
					where HD.Frequency=freq and HD.Test_id=testid;
			end if;
		SELECT HD.Angle,HD.Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM cpdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		end if;

-- new 45 

if typ='F' then
			if cnt=0 then
					select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM fdata HD 
					where HD.Frequency=freq and HD.Test_id=testid;
					select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM fdata HD 
					where HD.Frequency=freq and HD.Test_id=testid;
			end if;
		SELECT HD.Angle,HD.Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM fdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		end if;

if typ='B' then
				if cnt=0 then
						select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM hdata HD 
						where HD.Frequency=freq and HD.Test_id=testid ;
						select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM hdata HD 
						where HD.Frequency=freq and HD.Test_id=testid ;
				end if;	
			select test_id, case unt when 'GHz' then concat(RPAD(round(Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(Frequency,prec),10,' '),unt) end frequency,Angle,sum(hamplitude) hamplitude,sum(vamplitude) vamplitude,strmaxvalue,strminvalue 
			from (
			SELECT hp.test_id, frequency ,hp.angle,hp.amplitude hamplitude, 0 vamplitude, 0 camplitude, 0 pamplitude, 0 ramplitude, 0 yamplitude,t.frequnit
			FROM hdata hp inner join testdata t on hp.test_id=t.test_id where Frequency  =freq and hp.Test_id=testid
			UNION All
			SELECT hp.test_id, frequency,hp.angle,0 hamplitude,hp.amplitude vamplitude, 0 camplitude, 0 pamplitude, 0 ramplitude, 0 yamplitude,t.frequnit
			FROM vdata hp inner join testdata t on hp.test_id=t.test_id where Frequency  =freq and hp.Test_id=testid ) as tab
			group by test_id,frequency,angle,strmaxvalue,strminvalue;
		end if;
		if  typ='P' then
			if cnt=0 then
					select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM pitchdata HD 
					where HD.Frequency=freq and HD.Test_id=testid;
					select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM pitchdata HD 
					where HD.Frequency=freq and HD.Test_id=testid;
			end if;
		SELECT HD.Angle,HD.Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM pitchdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		end if;
		if typ='R' then
			if cnt=0 then
					select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM rolldata HD 
					where HD.Frequency=freq and HD.Test_id=testid;
					select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM rolldata HD 
					where HD.Frequency=freq and HD.Test_id=testid;
			end if;
		SELECT HD.Angle,HD.Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM rolldata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		end if;
		if typ='Y' then 
			if cnt=0 then
					select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM yawdata HD 
					where HD.Frequency=freq and HD.Test_id=testid;
					select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM yawdata HD 
					where HD.Frequency=freq and HD.Test_id=testid;
			end if;
		SELECT HD.Angle,HD.Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM yawdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		end if;
end if;
 if lg!=0.0001 then
		if typ='H' then
		SELECT HD.Amplitude into ampl FROM hdata HD 
		where HD.Frequency=freq and HD.Test_id=testid and angle=0;
				if cnt=0 then
						select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue from(
						SELECT HD.Amplitude-ampl+lg Amplitude FROM hdata HD 
						where HD.Frequency=freq and HD.Test_id=testid) as tab;

						select convert(round(min(Amplitude),0),char(30)) into strminvalue from(
						SELECT HD.Amplitude-ampl+lg Amplitude FROM hdata HD 
						where HD.Frequency=freq and HD.Test_id=testid) as tab;
				end if;
		SELECT HD.Angle,HD.Amplitude-ampl+lg Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM hdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		end if;
		
   if typ='V' then
        SELECT HD.Amplitude into ampl FROM vdata HD 
		where HD.Frequency=freq and HD.Test_id=testid and angle=0;
			if cnt=0 then
					select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue from(
					SELECT HD.Amplitude-ampl+lg Amplitude FROM vdata HD 
					where HD.Frequency=freq and HD.Test_id=testid) as tab;

					select convert(round(min(Amplitude),0),char(30)) into strminvalue from(
					SELECT HD.Amplitude-ampl+lg Amplitude FROM vdata HD 
					where HD.Frequency=freq and HD.Test_id=testid) as tab;
			end if;
		SELECT HD.Angle,HD.Amplitude-ampl+lg Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM vdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
	end if;
       
	if typ='C' then

				select calc_cpgain(testid,testid,lg) into lgampl;
				
				SELECT HD.Amplitude into ampl FROM cpdata HD 
				where HD.Frequency=freq and HD.Test_id=testid and angle=0;
						if cnt=0 then
								select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue from(
								SELECT HD.Amplitude-ampl+lgampl Amplitude FROM cpdata HD 
								where HD.Frequency=freq and HD.Test_id=testid) as tab;

								select convert(round(min(Amplitude),0),char(30)) into strminvalue from(
								SELECT HD.Amplitude-ampl+lgampl Amplitude FROM cpdata HD 
								where HD.Frequency=freq and HD.Test_id=testid) as tab;
						end if;
				
				SELECT HD.Angle,HD.Amplitude-ampl+lgampl Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM cpdata HD 
				where HD.Frequency=testid and HD.Test_id=testid;
		end if;

-- new 45
if typ='F' then
        SELECT HD.Amplitude into ampl FROM fdata HD 
		where HD.Frequency=freq and HD.Test_id=testid and angle=0;
			if cnt=0 then
					select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue from(
					SELECT HD.Amplitude-ampl+lg Amplitude FROM fdata HD 
					where HD.Frequency=freq and HD.Test_id=testid) as tab;

					select convert(round(min(Amplitude),0),char(30)) into strminvalue from(
					SELECT HD.Amplitude-ampl+lg Amplitude FROM fdata HD 
					where HD.Frequency=freq and HD.Test_id=testid) as tab;
			end if;
		SELECT HD.Angle,HD.Amplitude-ampl+lg Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM fdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
	end if;



		if typ='B' then
				SELECT HD.Amplitude into ampl FROM hdata HD 
				where HD.Frequency=freq and HD.Test_id=testid and angle=0;
				SELECT HD.Amplitude into vampl FROM vdata HD 
				where HD.Frequency=freq and HD.Test_id=testid and angle=0;
				if cnt=0 then
						select convert(round(max(Amplitude-ampl+lg),0)+1,char(30)) into strmaxvalue from hdata HD 
						where HD.Frequency=freq and HD.Test_id=testid ;
						
						select convert(round(min(Amplitude-ampl+lg),0),char(30)) into strminvalue from hdata HD 
						where HD.Frequency=freq and HD.Test_id=testid ;
				   end if;     
			   


				select test_id, case unt when 'GHz' then concat(RPAD(round(Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(Frequency,prec),10,' '),unt) end frequency,Angle,sum(hamplitude)-ampl+lg hamplitude,sum(vamplitude)-vampl+lg vamplitude,strmaxvalue,strminvalue 
				from (
				SELECT hp.test_id, frequency ,hp.angle,hp.amplitude hamplitude, 0 vamplitude, 0 camplitude, 0 pamplitude, 0 ramplitude, 0 yamplitude,t.frequnit
				FROM hdata hp inner join testdata t on hp.test_id=t.test_id where Frequency  =freq and hp.Test_id=testid
				UNION All
				SELECT hp.test_id, frequency,hp.angle,0 hamplitude,hp.amplitude vamplitude, 0 camplitude, 0 pamplitude, 0 ramplitude, 0 yamplitude,t.frequnit
				FROM vdata hp inner join testdata t on hp.test_id=t.test_id where Frequency  =freq and hp.Test_id=testid ) as tab group by test_id,frequency,angle,strmaxvalue,strminvalue;


end if;		

		if  typ='P' then
		SELECT HD.Amplitude into ampl FROM pitchdata HD 
		where HD.Frequency=freq and HD.Test_id=testid and angle=0;
if cnt=0 then
        select convert(floor(max(Amplitude)),char(30)) into strmaxvalue from(
        SELECT HD.Amplitude-ampl+lg Amplitude FROM pitchdata HD 
		where HD.Frequency=freq and HD.Test_id=testid) as tab;

        select convert(round(min(Amplitude),0),char(30)) into strminvalue from(
        SELECT HD.Amplitude-ampl+lg Amplitude FROM pitchdata HD 
		where HD.Frequency=freq and HD.Test_id=testid) as tab;
end if;
		SELECT HD.Angle,HD.Amplitude-ampl+lg Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM pitchdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		end if;
		if typ='R' then
		SELECT HD.Amplitude into ampl FROM rolldata HD 
		where HD.Frequency=freq and HD.Test_id=testid and angle=0;
if cnt=0 then
        select convert(floor(max(Amplitude)),char(30)) into strmaxvalue from(
        SELECT HD.Amplitude-ampl+lg Amplitude FROM rolldata HD 
		where HD.Frequency=freq and HD.Test_id=testid) as tab;

        select convert(round(min(Amplitude),0),char(30)) into strminvalue from(
        SELECT HD.Amplitude-ampl+lg Amplitude FROM rolldata HD 
		where HD.Frequency=freq and HD.Test_id=testid) as tab;
end if;
		SELECT HD.Angle,HD.Amplitude-ampl+lg Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM rolldata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		end if;
		if typ='Y' then
		SELECT HD.Amplitude into ampl FROM yawdata HD 
		where HD.Frequency=freq and HD.Test_id=testid and angle=0;
if cnt=0 then
        select convert(floor(max(Amplitude)),char(30)) into strmaxvalue from(
        SELECT HD.Amplitude-ampl+lg Amplitude FROM yawdata HD 
		where HD.Frequency=freq and HD.Test_id=testid) as tab;

        select convert(round(min(Amplitude),0),char(30)) into strminvalue from(
        SELECT HD.Amplitude-ampl+lg Amplitude FROM yawdata HD 
		where HD.Frequency=freq and HD.Test_id=testid) as tab;
end if;
		 SELECT HD.Angle,HD.Amplitude-ampl+lg Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM yawdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		end if;

end if;



END$$



DROP procedure IF EXISTS `Calculate_params`;

DELIMITER $$

CREATE  PROCEDURE `Calculate_params`(
myTestId INT,
-- myFreqUnit char(1), -- 'M' = MHz, 'G' = GHz
myPoltype char(2) -- 'L'=linear, 'C'= circular
)
BEGIN

# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'Calculate_params';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;

declare myfreq decimal(40,20);
declare myTestDate datetime;
DECLARE myTestType char(4);

 -- for the cursor
DECLARE done INT DEFAULT 0;

 #declare cursor
 DECLARE cur CURSOR FOR 
 select Frequency -- , lineargain
 from testfreq t
 where t.Test_id = myTestId;

 #declare handle 
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  
# 3. declare continue/exit handlers for logging SQL exceptions/errors :
-- write handlers for specific known error codes which are likely to occur here    
-- eg : DECLARE CONTINUE HANDLER FOR 1062
-- begin 
-- 	if isDebug > 0 then
-- 		call debug(l_proc_id, 'Duplicate keys error encountered','E','I');
-- 	end if;
-- end;

-- write handlers for sql states which occur due to one or more sql errors here
-- eg : DECLARE EXIT HANDLER FOR SQLSTATE '23000' 
 -- begin
-- 	if isDebug > 0 then
-- 		call debug(l_proc_id, 'SQLSTATE 23000','F','I');
-- 	end if;
-- end;
 
 -- write handlers for generic SQL exception which occurs due to one or more SQL states

 DECLARE EXIT HANDLER FOR SQLEXCEPTION 
 begin
	if isDebug > 0 then
		GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
		@errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
		SET @full_error = CONCAT("SQLException ", @errno, " (", @sqlstate, "): ", @text);
		call debug(l_proc_id, @full_error,'F','I');
        SET @infoText = CONCAT("Test Id : ", myTestId, ", Polarization Type : ",myPolType,", Test Type : ", myTestType);
		call debug(l_proc_id,@infoText,'I','I');
        
        
	end if;
    
    -- rollback all calculations
    delete from hcalculated where test_id = myTestId;
    delete from vcalculated where test_id = myTestId;
    delete from arcalculated where test_id = myTestId;
    delete from cpcalculated where test_id = myTestId;
    delete from pitchcalculated where test_id = myTestId;
    delete from rollcalculated where test_id = myTestId;
    delete from yawcalculated where test_id = myTestId;
    -- for 45 deg pol
    delete from fcalculated where test_id = myTestId;
    -- for phase diff
	delete from phasecalculated where test_id = myTestId;


    -- raise exception
	RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'Debug logging is ON. Calculations begin ...','I','I');
 end if;


# Declarations -end

select TestDate,testType into myTestDate,myTestType 
from testdata where test_id = myTestId;

if isDebug > 0 then
	SET @infoText = CONCAT("Test Id : ", myTestId, ", Polarization Type : ",myPolType,", Test Type : ", myTestType);
	call debug(l_proc_id,@infoText,'I','I');
 end if;
 
#open cursor
  OPEN cur;
  
  #starts the loop
  the_loop: LOOP
  
 FETCH cur INTO myfreq; -- ,mylinear_Gain;
IF done = 1 THEN
	if isDebug > 0 then
		SET @infoText = "Done looping through spot frequencies";
		call debug(l_proc_id,@infoText,'I','I');
	end if;
LEAVE the_loop;
END IF;
   
    -- call calculate(myTestId,myPolType,myfreq,mylinear_Gain,myTestDate,myFreqUnit);
   
-- conv GHz to MHz - REMOVED AS IT IS NOT REQUIRED, only M supported
-- if myFreqUnit = 'G' then
-- set myfreq = myfreq*1000;
-- end if;
        call sanity_check(myTestId,myFreq,myPolType,myTestType);
#calculations - begin
-- Linear Azimuth
  IF ( myPolType = 'L' and myTestType = 'A') THEN
	if isDebug > 0 then
		SET @infoText = CONCAT("invoking Linear-Azimuth calculations for frequency : ",myfreq);
		call debug(l_proc_id,@infoText,'I','I');
	end if;
	call calc_Linear_Azimuth(myTestId,myfreq,myTestDate);
-- Linear Elevation
  elseif ( myPolType = 'L' and myTestType = 'E') THEN
	if isDebug > 0 then
		SET @infoText = CONCAT("invoking Linear-Elevation calculations for frequency : ",myfreq);
		call debug(l_proc_id,@infoText,'I','I');
	end if;
	call calc_Linear_Elevation(myTestId,myfreq,myTestDate);
-- Slant Azimuth
  elseif ( myPolType = 'S' and myTestType = 'A') THEN
	if isDebug > 0 then
		SET @infoText = CONCAT("invoking Slant-Azimuth calculations for frequency : ",myfreq);
		call debug(l_proc_id,@infoText,'I','I');
	end if;
	call calc_Slant_Azimuth(myTestId,myfreq,myTestDate);
-- Slant Elevation
  elseif ( myPolType = 'S' and myTestType = 'E') THEN
	if isDebug > 0 then
		SET @infoText = CONCAT("invoking Slant-Elevation calculations for frequency : ",myfreq);
		call debug(l_proc_id,@infoText,'I','I');
	end if;
	call calc_Slant_Elevation(myTestId,myfreq,myTestDate);
-- Circular - No conversion
  elseif ( myPolType = 'C' and myTestType = 'NCP') THEN
	if isDebug > 0 then
		SET @infoText = CONCAT("invoking Circular-NCP calculations for frequency : ",myfreq);
		call debug(l_proc_id,@infoText,'I','I');
	end if;
	-- reports of NCP and Slant-Elevation are the same
	call calc_Circular_NCP(myTestId,myfreq,myTestDate);
-- Circular - phase difference
  elseif ( myPolType = 'C' and myTestType = 'PD') THEN
	if isDebug > 0 then
		SET @infoText = CONCAT("invoking Circular-PD calculations for frequency : ",myfreq);
		call debug(l_proc_id,@infoText,'I','I');
	end if;
	call calc_Circular_PD(myTestId,myfreq,myTestDate);
  -- Circular - CP with conversion / Direct-CP
  else -- Polarization_type = 'C' and testType = 'DCP'/'CP'
	if isDebug > 0 then
		SET @infoText = CONCAT("invoking Circular-CP/DCP calculations for frequency : ",myfreq);
		call debug(l_proc_id,@infoText,'I','I');
	end if;
	call calc_CP(myTestId,myfreq,myTestDate,myTestType);
 END IF;
  #Calculations - end
    
    END LOOP the_loop;
 
  CLOSE cur;
    
if isDebug > 0 then
	call debug(l_proc_id,'Calculations end','I','I');
 end if;
 
END$$

DELIMITER ;


DROP procedure IF EXISTS `calc_Circular_NCP`;

DELIMITER $$

CREATE  PROCEDURE `calc_Circular_NCP`(
cncpTestId INT,
cncpFreq decimal(40,20),
cncpTestDate datetime
)
BEGIN

# Declarations -begin

# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'calc_Circular_NCP for C-NCP';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;
    
DECLARE _3dB_BW_HP_BM, _3dB_BW_VP_BM decimal(40,20);
DECLARE _3dB_BW_HP_0, _3dB_BW_VP_0 decimal(40,20);
DECLARE _3dB_BW_HP_90, _3dB_BW_VP_90 decimal(40,20);
DECLARE _3dB_BW_HP_270, _3dB_BW_VP_270 decimal(40,20);
DECLARE _10dB_BW_HP_BM, _10dB_BW_VP_BM decimal(40,20);
DECLARE _10dB_BW_HP_0, _10dB_BW_VP_0 decimal(40,20);
DECLARE _10dB_BW_HP_90, _10dB_BW_VP_90 decimal(40,20);
DECLARE _10dB_BW_HP_270, _10dB_BW_VP_270 decimal(40,20);
DECLARE _3dB_BS_HP_BM, _3dB_BS_VP_BM decimal(40,20);
DECLARE _3dB_BS_HP_0, _3dB_BS_VP_0 decimal(40,20);
DECLARE _3dB_BS_HP_90, _3dB_BS_VP_90 decimal(40,20);
DECLARE _3dB_BS_HP_270, _3dB_BS_VP_270 decimal(40,20);
DECLARE _10dB_BS_HP_BM, _10dB_BS_VP_BM decimal(40,20);
DECLARE _10dB_BS_HP_0, _10dB_BS_VP_0 decimal(40,20);
DECLARE _10dB_BS_HP_90, _10dB_BS_VP_90 decimal(40,20);
DECLARE _10dB_BS_HP_270, _10dB_BS_VP_270 decimal(40,20);
DECLARE backlobe_HP,backlobe_VP decimal(40,20);
DECLARE axial_0,axial_P45,axial_M45,AR_Maxdiff_P, AR_Maxdiff_M decimal(40,20);
DECLARE angle_Maxdiff_P, angle_Maxdiff_M decimal(40,20);
-- 24-Jul-2017 - new params
DECLARE axial_P30,axial_M30,axial_P60,axial_M60,AR_Maxdiff_P30, 
AR_Maxdiff_M30,AR_Maxdiff_P60, AR_Maxdiff_M60 decimal(40,20);
DECLARE angle_Maxdiff_P30, angle_Maxdiff_M30,
angle_Maxdiff_P60, angle_Maxdiff_M60 decimal(40,20);

-- 08-AUg-2017 - for 45 deg pol
DECLARE _3dB_BW_FP_BM,_3dB_BW_FP_0,_3dB_BW_FP_90 decimal(40,20);
DECLARE _10dB_BW_FP_BM,_10dB_BW_FP_0,_10dB_BW_FP_90 decimal(40,20);
DECLARE _3dB_BS_FP_BM,_3dB_BS_FP_0,_3dB_BS_FP_90 decimal(40,20);
DECLARE _10dB_BS_FP_BM,_10dB_BS_FP_0,_10dB_BS_FP_90 decimal(40,20);
DECLARE backlobe_FP decimal(40,20);

DECLARE hDataPresent INT default 0;
DECLARE vDataPresent INT default 0;

DECLARE fDataPresent INT default 0;

# 3. declare continue/exit handlers for logging SQL exceptions/errors :
-- write handlers for specific known error codes which are likely to occur here    
-- eg : DECLARE CONTINUE HANDLER FOR 1062
-- begin 
-- 	if isDebug > 0 then
-- 		call debug(l_proc_id, 'Duplicate keys error encountered','E','I');
-- 	end if;
-- end;

-- write handlers for sql states which occur due to one or more sql errors here
-- eg : DECLARE EXIT HANDLER FOR SQLSTATE '23000' 
 -- begin
-- 	if isDebug > 0 then
-- 		call debug(l_proc_id, 'SQLSTATE 23000','F','I');
-- 	end if;
-- end;
 
 -- write handlers for generic SQL exception which occurs due to one or more SQL states

 DECLARE EXIT HANDLER FOR SQLEXCEPTION 
 begin
 
	if isDebug > 0 then
		GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
		@errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
		SET @full_error = CONCAT("SQLException ", @errno, " (", @sqlstate, "): ", @text);
		call debug(l_proc_id, @full_error,'F','I');
        SET @details = CONCAT("Test id : ",cncpTestId,",Frequency : ",cncpFreq);
		call debug(l_proc_id, @details,'I','I');
           
         
	end if;
    RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in calc_Circular_NCP','I','I');
 end if;


# Declarations -end

select count(*) into hDataPresent from hdata where test_id = cncpTestId and Frequency = cncpFreq;
select count(*) into vDataPresent from vdata where test_id = cncpTestId and Frequency = cncpFreq;
select count(*) into fDataPresent from fdata where test_id = cncpTestId and Frequency = cncpFreq;

-- h data calculations	
if hDataPresent > 0 then
			
            if isDebug > 0 then
				SET @infoText = "HP data present"; 
				call debug(l_proc_id,@infoText,'I','I');
			end if;
            
             if isDebug > 0 then
				SET @infoText = "invoking 3 db BW and BS calculations ..."; 
				call debug(l_proc_id,@infoText,'I','I');
			end if;
		-- calculate 3 db and 10 db BW & BS
			 -- Calculate 3dB Beam Width, Beam Squint for hp data for Beam Max and store
		    call calc_XdB_BW_BS(cncpTestId,cncpFreq,3,'HP','BM',_3dB_BW_HP_BM,_3dB_BS_HP_BM );
           
		   -- Calculate 3dB Beam Width, Beam Squint for hp data for 0 degree and store
		   call calc_XdB_BW_BS(cncpTestId,cncpFreq,3,'HP','0',_3dB_BW_HP_0,_3dB_BS_HP_0 );
           
		   -- Calculate 3dB Beam Width, Beam Squint for pitch data for 90 degree
		    call calc_XdB_BW_BS(cncpTestId,cncpFreq,3,'HP','90', _3dB_BW_HP_90, _3dB_BS_HP_90);
            
            -- new req
             -- Calculate 3dB Beam Width, Beam Squint for pitch data for 90 degree
		    call calc_XdB_BW_BS(cncpTestId,cncpFreq,3,'HP','270', _3dB_BW_HP_270, _3dB_BS_HP_270);
           
			 if isDebug > 0 then
				SET @infoText = "invoking 10 db BW and BS calculations ..."; 
				call debug(l_proc_id,@infoText,'I','I');
			end if;
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for Beam Max
		    call calc_XdB_BW_BS(cncpTestId,cncpFreq,10,'HP','BM', _10dB_BW_HP_BM, _10dB_BS_HP_BM);
            
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for 0 degree
		    call calc_XdB_BW_BS(cncpTestId,cncpFreq,10,'HP','0', _10dB_BW_HP_0, _10dB_BS_HP_0);
            
		   -- Calculate 10dB Beam Width, Beam Squint for Pitch data for 90 degree
		     call calc_XdB_BW_BS(cncpTestId,cncpFreq,10,'HP','90', _10dB_BW_HP_90, _10dB_BS_HP_90);
             
             -- new req
              -- Calculate 10dB Beam Width, Beam Squint for Pitch data for 270 degree
		     call calc_XdB_BW_BS(cncpTestId,cncpFreq,10,'HP','270', _10dB_BW_HP_270, _10dB_BS_HP_270);
            
		 if isDebug > 0 then
				SET @infoText = "invoking Backlobe calculations ..."; 
				call debug(l_proc_id,@infoText,'I','I');
			end if;
		  -- Calculate Back Lobe for HP data
			  select calc_Backlobe(cncpTestId,cncpFreq,'HP') into backlobe_HP;
		   
         
            
		-- insert into pitchCalculated table
             delete from hcalculated where Test_id =cncpTestId and Frequency = cncpFreq;
			 insert into hcalculated(Test_id,Frequency,TestDate
								,3Db_BW_BMax,3Db_BW_0,3Db_BW_90,3Db_BW_270
                                ,10Db_BW_BMax,10Db_BW_0,10Db_BW_90,10Db_BW_270
                                ,3Db_BS_BMax,3Db_BS_0,3Db_BS_90,3Db_BS_270
                                ,10Db_BS_BMax,10Db_BS_0,10Db_BS_90,10Db_BS_270
                                ,BackLobe)
		   select cncpTestId,cncpFreq,cncpTestDate,
				_3dB_BW_HP_BM,_3dB_BW_HP_0,_3dB_BW_HP_90,_3dB_BW_HP_270,
				_10dB_BW_HP_BM,_10dB_BW_HP_0,_10dB_BW_HP_90,_10dB_BW_HP_270,
                _3dB_BS_HP_BM,_3dB_BS_HP_0,_3dB_BS_HP_90,_3dB_BS_HP_270,
				_10dB_BS_HP_BM,_10dB_BS_HP_0,_10dB_BS_HP_90,_10dB_BS_HP_270,
                backlobe_HP;
                
		 if isDebug > 0 then
				SET @infoText = "Calculated data saved successfully into hcalculated";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
end if;

-- v data calculations	
if vDataPresent > 0 then
		 if isDebug > 0 then
				SET @infoText = "VP data present"; 
				call debug(l_proc_id,@infoText,'I','I');
			end if;
		-- calculate 3 db and 10 db BW & BS
        
        if isDebug > 0 then
				SET @infoText = "invoking 3dB BW and BS calculations ..."; 
				call debug(l_proc_id,@infoText,'I','I');
			end if;
			 -- Calculate 3dB Beam Width, Beam Squint for hp data for Beam Max and store
		    call calc_XdB_BW_BS(cncpTestId,cncpFreq,3,'VP','BM',_3dB_BW_VP_BM,_3dB_BS_VP_BM );
           
		   -- Calculate 3dB Beam Width, Beam Squint for hp data for 0 degree and store
		   call calc_XdB_BW_BS(cncpTestId,cncpFreq,3,'VP','0',_3dB_BW_VP_0,_3dB_BS_VP_0 );
           
		   -- Calculate 3dB Beam Width, Beam Squint for pitch data for 90 degree
		    call calc_XdB_BW_BS(cncpTestId,cncpFreq,3,'VP','90', _3dB_BW_VP_90, _3dB_BS_VP_90);
            
             -- Calculate 3dB Beam Width, Beam Squint for pitch data for 90 degree
		    call calc_XdB_BW_BS(cncpTestId,cncpFreq,3,'VP','270', _3dB_BW_VP_270, _3dB_BS_VP_270);
           
		     
            if isDebug > 0 then
				SET @infoText = "invoking 10dB BW and BS calculations ..."; 
				call debug(l_proc_id,@infoText,'I','I');
			end if; 
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for Beam Max
		    call calc_XdB_BW_BS(cncpTestId,cncpFreq,10,'VP','BM', _10dB_BW_VP_BM, _10dB_BS_VP_BM);
            
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for 0 degree
		    call calc_XdB_BW_BS(cncpTestId,cncpFreq,10,'VP','0', _10dB_BW_VP_0, _10dB_BS_VP_0);
            
		   -- Calculate 10dB Beam Width, Beam Squint for Pitch data for 90 degree
		     call calc_XdB_BW_BS(cncpTestId,cncpFreq,10,'VP','90', _10dB_BW_VP_90, _10dB_BS_VP_90);
             
             -- Calculate 10dB Beam Width, Beam Squint for Pitch data for 90 degree
		     call calc_XdB_BW_BS(cncpTestId,cncpFreq,10,'VP','270', _10dB_BW_VP_270, _10dB_BS_VP_270);
            
		  if isDebug > 0 then
				SET @infoText = "invoking backlobe calculations ..."; 
				call debug(l_proc_id,@infoText,'I','I');
			end if;
          -- Calculate Back Lobe for HP data
			  select calc_Backlobe(cncpTestId,cncpFreq,'VP') into backlobe_VP;
		   
         
            
		-- insert into vcalculated table
             delete from vcalculated where Test_id =cncpTestId and Frequency = cncpFreq;
			 insert into vcalculated(Test_id,Frequency,TestDate
								,3Db_BW_BMax,3Db_BW_0,3Db_BW_90,3Db_BW_270
                                ,10Db_BW_BMax,10Db_BW_0,10Db_BW_90,10Db_BW_270
                                ,3Db_BS_BMax,3Db_BS_0,3Db_BS_90,3Db_BS_270
                                ,10Db_BS_BMax,10Db_BS_0,10Db_BS_90,10Db_BS_270
                                ,BackLobe)
		   select cncpTestId,cncpFreq,cncpTestDate,
				_3dB_BW_VP_BM,_3dB_BW_VP_0,_3dB_BW_VP_90,_3dB_BW_VP_270,
				_10dB_BW_VP_BM,_10dB_BW_VP_0,_10dB_BW_VP_90,_10dB_BW_VP_270,
                _3dB_BS_VP_BM,_3dB_BS_VP_0,_3dB_BS_VP_90,_3dB_BS_VP_270,
				_10dB_BS_VP_BM,_10dB_BS_VP_0,_10dB_BS_VP_90,_10dB_BS_VP_270,
                backlobe_VP;
                
		  if isDebug > 0 then
				SET @infoText = "Calculated data saved successfully into vcalculated";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
end if;

-- for 45 deg pol
-- f data calculations	
if fDataPresent > 0 then
		 if isDebug > 0 then
				SET @infoText = "FP data present"; 
				call debug(l_proc_id,@infoText,'I','I');
			end if;
		-- calculate 3 db and 10 db BW & BS
        
        if isDebug > 0 then
				SET @infoText = "invoking 3dB BW and BS calculations ..."; 
				call debug(l_proc_id,@infoText,'I','I');
			end if;
			 -- Calculate 3dB Beam Width, Beam Squint for hp data for Beam Max and store
		    call calc_XdB_BW_BS(cncpTestId,cncpFreq,3,'FP','BM',_3dB_BW_FP_BM,_3dB_BS_FP_BM );
           
		   -- Calculate 3dB Beam Width, Beam Squint for hp data for 0 degree and store
		   call calc_XdB_BW_BS(cncpTestId,cncpFreq,3,'FP','0',_3dB_BW_FP_0,_3dB_BS_FP_0 );
           
		   -- Calculate 3dB Beam Width, Beam Squint for pitch data for 90 degree
		    call calc_XdB_BW_BS(cncpTestId,cncpFreq,3,'FP','90', _3dB_BW_FP_90, _3dB_BS_FP_90);
            
            if isDebug > 0 then
				SET @infoText = "invoking 10dB BW and BS calculations ..."; 
				call debug(l_proc_id,@infoText,'I','I');
			end if; 
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for Beam Max
		    call calc_XdB_BW_BS(cncpTestId,cncpFreq,10,'FP','BM', _10dB_BW_FP_BM, _10dB_BS_FP_BM);
            
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for 0 degree
		    call calc_XdB_BW_BS(cncpTestId,cncpFreq,10,'FP','0', _10dB_BW_FP_0, _10dB_BS_FP_0);
            
		   -- Calculate 10dB Beam Width, Beam Squint for Pitch data for 90 degree
		     call calc_XdB_BW_BS(cncpTestId,cncpFreq,10,'FP','90', _10dB_BW_FP_90, _10dB_BS_FP_90);
             
          
		  if isDebug > 0 then
				SET @infoText = "invoking backlobe calculations ..."; 
				call debug(l_proc_id,@infoText,'I','I');
			end if;
          -- Calculate Back Lobe for HP data
			  select calc_Backlobe(cncpTestId,cncpFreq,'FP') into backlobe_FP;
		   
         
            
		-- insert into fcalculated table
             delete from fcalculated where Test_id =cncpTestId and Frequency = cncpFreq;
			 insert into fcalculated(Test_id,Frequency,TestDate
								,3Db_BW_BMax,3Db_BW_0,3Db_BW_90
                                ,10Db_BW_BMax,10Db_BW_0,10Db_BW_90
                                ,3Db_BS_BMax,3Db_BS_0,3Db_BS_90
                                ,10Db_BS_BMax,10Db_BS_0,10Db_BS_90
                                ,BackLobe)
		   select cncpTestId,cncpFreq,cncpTestDate,
				_3dB_BW_FP_BM,_3dB_BW_FP_0,_3dB_BW_FP_90,
				_10dB_BW_FP_BM,_10dB_BW_FP_0,_10dB_BW_FP_90,
                _3dB_BS_FP_BM,_3dB_BS_FP_0,_3dB_BS_FP_90,
				_10dB_BS_FP_BM,_10dB_BS_FP_0,_10dB_BS_FP_90,
                backlobe_FP;
                
		  if isDebug > 0 then
				SET @infoText = "Calculated data saved successfully into fcalculated";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
end if;

-- axial ratio calculations
if hDataPresent > 0 and vDataPresent > 0 then
	  -- Calculate Axial ratio at 0 degree
			  select calc_AxialRatio(cncpTestId,cncpFreq,0) into axial_0;
              
		   -- Calculate Axial ratio at +45 degree
			  select calc_AxialRatio(cncpTestId,cncpFreq,45) into axial_P45;
            
              
		   -- Calculate Axial ratio at  -45 degree
		      select calc_AxialRatio(cncpTestId,cncpFreq,-45) into axial_M45;
           
		   -- Calculate Max-diff Axial ratio from 0 to +45 : Maximum Axial ratio from 0 to +45 degree
			  call calc_MaxDiffAxialRatio(cncpTestId, cncpFreq, 'P', AR_Maxdiff_P, angle_Maxdiff_P);
              
		   -- Calculate Max-diff Axial ratio from 0 to -45 : Maximum Axial ratio from 0 to -45 degree
		      call calc_MaxDiffAxialRatio(cncpTestId, cncpFreq, 'M', AR_Maxdiff_M, angle_Maxdiff_M);
              
           -- 24 Jul 2017 changes- begin
             
             -- 30
		   -- Calculate Axial ratio at +30 degree
			  select calc_AxialRatio(cncpTestId,cncpFreq,30) into axial_P30;
                 
		   -- Calculate Axial ratio at  -30 degree
		      select calc_AxialRatio(cncpTestId,cncpFreq,-30) into axial_M30;
           
		   -- Calculate Max-diff Axial ratio from 0 to +30 : Maximum Axial ratio from 0 to +30 degree
			  call calc_MaxDiffAxialRatio(cncpTestId, cncpFreq, 'P30', AR_Maxdiff_P30, angle_Maxdiff_P30);
              
		   -- Calculate Max-diff Axial ratio from 0 to -30 : Maximum Axial ratio from 0 to -30 degree
		      call calc_MaxDiffAxialRatio(cncpTestId, cncpFreq, 'M30', AR_Maxdiff_M30, angle_Maxdiff_M30);
            
            -- 60
               -- Calculate Axial ratio at +60 degree
			  select calc_AxialRatio(cncpTestId,cncpFreq,60) into axial_P60;
                 
		   -- Calculate Axial ratio at  -60 degree
		      select calc_AxialRatio(cncpTestId,cncpFreq,-60) into axial_M60;
           
		   -- Calculate Max-diff Axial ratio from 0 to +60 : Maximum Axial ratio from 0 to +30 degree
			  call calc_MaxDiffAxialRatio(cncpTestId, cncpFreq, 'P60', AR_Maxdiff_P60, angle_Maxdiff_P60);
              
		   -- Calculate Max-diff Axial ratio from 0 to -60 : Maximum Axial ratio from 0 to -30 degree
		      call calc_MaxDiffAxialRatio(cncpTestId, cncpFreq, 'M60', AR_Maxdiff_M60, angle_Maxdiff_M60);
              
           -- 24 Jul 2017 changes- end   
              
              -- insert into arcalculated
               delete from arcalculated where Test_id = cncpTestId and Frequency = cncpFreq;
				insert into arcalculated(Test_id,Frequency,TestDate,
						AR_0,
                        AR_P45,AR_M45,MaxAR_P_Ratio,MaxAR_P_Angle,MaxAR_M_Ratio,MaxAR_M_Angle,
                        AR_P30,AR_M30,MaxAR_P30_Ratio,MaxAR_P30_Angle,MaxAR_M30_Ratio,MaxAR_M30_Angle,
                        AR_P60,AR_M60,MaxAR_P60_Ratio,MaxAR_P60_Angle,MaxAR_M60_Ratio,MaxAR_M60_Angle)
				select cncpTestId,cncpFreq,cncpTestDate,
				 		axial_0,
                        axial_P45,axial_M45,AR_Maxdiff_P,angle_Maxdiff_P, AR_Maxdiff_M, angle_Maxdiff_M,
                        axial_P30,axial_M30,AR_Maxdiff_P30,angle_Maxdiff_P30, AR_Maxdiff_M30, angle_Maxdiff_M30,
                        axial_P60,axial_M60,AR_Maxdiff_P60,angle_Maxdiff_P60, AR_Maxdiff_M60, angle_Maxdiff_M60; 
        
        
        if isDebug > 0 then
				SET @infoText = "Calculated data saved successfully into arcalculated";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
end if;
END$$

DELIMITER ;



DROP procedure IF EXISTS `calc_XdB_BW_BS`;

DELIMITER $$

CREATE  PROCEDURE `calc_XdB_BW_BS`(
xtest_id INT, freq decimal(40,20), X INT, polType char(2), fromAngle char(3),
out beam_width decimal(40,20), out beam_squint decimal(40,20)
)
BEGIN


# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'calc_XdB_BW_BS';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;

declare C,D,E,AminX,i,j,sum_right,sum_left,E_bs,C_bs,B_bs decimal(40,20);
declare lef,righ decimal(40,20);

# 3. declare continue/exit handlers for logging SQL exceptions/errors :
-- write handlers for specific known error codes which are likely to occur here    
-- eg : DECLARE CONTINUE HANDLER FOR 1062
-- begin 
-- 	if isDebug > 0 then
-- 		call debug(l_proc_id, 'Duplicate keys error encountered','E','I');
-- 	end if;
-- end;

-- write handlers for sql states which occur due to one or more sql errors here
-- eg : DECLARE EXIT HANDLER FOR SQLSTATE '23000' 
 -- begin
-- 	if isDebug > 0 then
-- 		call debug(l_proc_id, 'SQLSTATE 23000','F','I');
-- 	end if;
-- end;
 
 -- write handlers for generic SQL exception which occurs due to one or more SQL states

 DECLARE EXIT HANDLER FOR SQLEXCEPTION 
 begin
	if isDebug > 0 then
		GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
		@errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
		SET @full_error = CONCAT("SQLException ", @errno, " (", @sqlstate, "): ", @text);
		call debug(l_proc_id, @full_error,'F','I');
        SET @details = CONCAT("Test id : ",xtest_id,",Frequency : ",freq,",X : ",X,", Type : ",polType,", fromAngle : ",fromAngle);
		call debug(l_proc_id, @details,'I','I');
        
	end if;
    RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in calc_XdB_BW_BS','I','I');
 end if;



# ************************** HP ******************************
if polType = 'HP' then
set @tab = 'hdata';
elseif polType = 'VP' then
set @tab = 'vdata';
elseif polType = 'P' then
set @tab = 'pitchData';
elseif polType = 'R' then
set @tab = 'rollData';
elseif polType = 'FP' then
set @tab = 'fdata';
else  
set @tab = 'cpdata';
end if;

if fromAngle = 'BM' then
SET @s = CONCAT('select MAX(amplitude) into @A from ', @tab, ' where test_id = ',xtest_id,' and Frequency = ',freq);  
       --  select @s;
        
PREPARE stmt1 FROM @s; 
EXECUTE stmt1; 
DEALLOCATE PREPARE stmt1;
        
        SET @s = CONCAT('select MAX(angle) into @B from ', @tab, ' where test_id = ',xtest_id,' and Frequency = ',freq,' and amplitude = ',@A);  
       --  select @s;
        
PREPARE stmt1 FROM @s; 
EXECUTE stmt1; 
DEALLOCATE PREPARE stmt1;
elseif fromAngle = '0' then
SET @s = CONCAT('select amplitude, angle into @A,@B from ', @tab, 
' where test_id = ',xtest_id,' and Frequency = ',freq,
                        ' and angle = 0');  

PREPARE stmt1 FROM @s; 
EXECUTE stmt1; 
DEALLOCATE PREPARE stmt1;

elseif fromAngle = '270' then
SET @s = CONCAT('select amplitude, angle into @A,@B from ', @tab, 
' where test_id = ',xtest_id,' and Frequency = ',freq,
                        ' and angle = 270');  

PREPARE stmt1 FROM @s; 
EXECUTE stmt1; 
DEALLOCATE PREPARE stmt1;
        
else -- fromAngle = '90' then
        SET @s = CONCAT('select amplitude, angle into @A,@B from ', @tab, 
' where test_id = ',xtest_id,' and Frequency = ',freq,
                        ' and angle = 90');  
         
PREPARE stmt1 FROM @s; 
EXECUTE stmt1; 
DEALLOCATE PREPARE stmt1;
end if;
    
-- A-X to the right
set AminX = @A-X;
  
    -- select @A as 'A';
    -- select AminX as 'A-X';
	-- select @B;
    
    set i = @B+0.1;
   
   set sum_right =0.1;
   
    loop_right : while i <> @B do
        if i = 360 then 
			set i = 0;
            if i = @B then
				-- select 'reached back';
				leave loop_right;
			end if;
		end if;
        
SET @s = CONCAT('select amplitude into @temp from ', @tab, 
' where test_id = ',xtest_id,' and Frequency = ',freq,
                         ' and angle = ',i);  
        
PREPARE stmt1 FROM @s; 
EXECUTE stmt1; 
DEALLOCATE PREPARE stmt1;
        
        
        if @temp <= AminX then
           -- select @temp as 'temp';
           -- select i as 'to_right';
leave loop_right;
end if;
        -- incr loop variable
       	set i=i+0.1;
        set sum_right = sum_right+0.1;
        
end while;
    
    if i <> @B then
		 -- set lef= i;
         set C_bs = i;
        set C = sum_right;
        -- select C as 'C';
	end if;
    
    set j = @B-0.1;
   set sum_left = 0.1;
   
    loop_left : while j <> @B do
        if j=-0.1 then
			set j=359.9;
            if j = @B then
				leave loop_left;
			end if;
		end if;
        
        SET @s = CONCAT('select amplitude into @temp from ', @tab, 
' where test_id = ',xtest_id,' and Frequency = ',freq,
                        ' and angle = ',j);  
         
PREPARE stmt1 FROM @s; 
EXECUTE stmt1; 
DEALLOCATE PREPARE stmt1;
        
        if @temp <= AminX then
			-- select @temp as 'temp_left';
			-- select j as 'to_left';
			leave loop_left;
		end if;
        -- decr loop variable
        set j=j-0.1;
        set sum_left = sum_left+0.1;
end while;
    
    
    if j <> @B then
		 -- set righ= j;
         set E_bs = j;
        set E = sum_left;
	end if;
    
    
    
-- set E = 360-D;
-- select E as 'E';
set beam_width = C+E;

-- select beam_width as 'BW';


-- Beamsquint calculation

if fromAngle = 'BM' then-- for BM 
	if E_bs > 180 and C_bs > 180 then -- both in 4th quad
		set E_bs = 360 - E_bs;
		set C_bs = 360 - C_bs;
		set beam_squint = (-C_bs-E_bs)/2;

	elseif E_bs < 90 and C_bs < 90 then -- both in 1st quad
		set beam_squint = (C_bs+E_bs)/2;

	else -- C_bs and E_bs are in 1st and 4th quad respectively
		set E_bs = 360 - E_bs;
		set beam_squint = (C_bs-E_bs)/2;
	end if;
else -- for 0,90,270
	set beam_squint = (C-E)/2;
end if;


 -- select beam_squint as 'BS';


END$$

DELIMITER ;


DROP function IF EXISTS `calc_backlobe`;

DELIMITER $$

CREATE  FUNCTION `calc_backlobe`(
bTestId INT, bFreq decimal(40,20), bPolType char(2)
) RETURNS decimal(40,20)
BEGIN

# A = Amplitude at 0 degree 
# B = Amplitude at 180 degree 
# Back Lobe = A-B

DECLARE backlobe decimal(40,20) default 0;
DECLARE Amp_0, Amp_180 decimal(40,20);

if bPolType = 'HP' then
	set Amp_0 = (select amplitude 
				from hdata 
				where test_id = bTestId and Frequency = bFreq and angle = 0);
	set Amp_180 =(select amplitude 
					from hdata 
					where test_id = bTestId and Frequency = bFreq and angle = 180);
	 
elseif bPolType = 'VP' then
	set Amp_0 = (select amplitude 
				from vdata 
				where test_id = bTestId and Frequency = bFreq and angle = 0);
	set Amp_180 =(select amplitude 
					from vdata 
					where test_id = bTestId and Frequency = bFreq and angle = 180);
elseif bPolType = 'FP' then
	set Amp_0 = (select amplitude 
				from fdata 
				where test_id = bTestId and Frequency = bFreq and angle = 0);
	set Amp_180 =(select amplitude 
					from fdata 
					where test_id = bTestId and Frequency = bFreq and angle = 180);

else -- polType = 'CP' then
	set Amp_0 = (select amplitude 
				from cpdata 
				where test_id = bTestId and Frequency = bFreq and angle = 0);
	set Amp_180 =(select amplitude 
					from cpdata 
					where test_id = bTestId and Frequency = bFreq and angle = 180);

end if;

set backlobe = Amp_0 - Amp_180;

RETURN backlobe;

END$$

DELIMITER ;



DROP procedure IF EXISTS `sanity_check`;

DELIMITER $$

CREATE  PROCEDURE `sanity_check`(
sanId INT,
sanFreq decimal(40,20),
sanPoltype char(2),
sanTestType char(3)
)
BEGIN


# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'sanity_check';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	SET @infoText = CONCAT("Sanity checking for frequency : ",sanFreq);
		call debug(l_proc_id,@infoText,'I','I');
 end if;
 
 
 IF ( sanPoltype = 'L' and sanTestType = 'A') THEN
	if isDebug > 0 then
		SET @infoText = CONCAT("Linear-Azimuth sanity checks ...");
		call debug(l_proc_id,@infoText,'I','I');
	end if;
	
    
    select count(*) into @countyawdata from yawdata where test_id = sanId and Frequency = sanFreq;
	if @countyawdata > 0  then
		-- yaw data is present
        select count(angle) into @anglecnt from yawdata where test_id = sanId and Frequency = sanFreq;
        if(@anglecnt < 3600) then-- not all angles imported
			 SIGNAL SQLSTATE '88888'
			 set MESSAGE_TEXT = 'Yaw data does not have all angular values';
        end if;
        
        select count(angle) into @anglerr from yawdata where test_id = sanId and Frequency = sanFreq 
        and (angle > 360 or angle < 0) ; 
        if(@anglerr < 0) then-- not all angles imported
			 SIGNAL SQLSTATE '88888'
			 set MESSAGE_TEXT = 'Invalid angle values. Calculation cannot proceed';
        end if;
        
    end if;

    
-- Linear Elevation
  elseif ( sanPoltype = 'L' and sanTestType = 'E') THEN
		
        if isDebug > 0 then
			SET @infoText = CONCAT("Linear-Elevation sanity checks ...");
			call debug(l_proc_id,@infoText,'I','I');
		end if;
		
		
		select count(*) into @countrolldata from rolldata where test_id = sanId and Frequency = sanFreq;
		if @countrolldata > 0  then
			-- roll data is present
			select count(angle) into @anglecnt from rolldata where test_id = sanId and Frequency = sanFreq;
			if(@anglecnt < 3600) then-- not all angles imported
				 SIGNAL SQLSTATE '88888'
				 set MESSAGE_TEXT = 'Roll data does not have all angular values';
			end if;
            
            select count(angle) into @anglerr from rolldata where test_id = sanId and Frequency = sanFreq 
			and (angle > 360 or angle < 0) ; 
			if(@anglerr < 0) then-- not all angles imported
				 SIGNAL SQLSTATE '88888'
				 set MESSAGE_TEXT = 'Invalid angle values. Calculation cannot proceed';
			end if;
            
		end if;
        
        select count(*) into @countpitchdata from pitchdata where test_id = sanId and Frequency = sanFreq;
		if @countpitchdata > 0  then
			-- roll data is present
			select count(angle) into @anglecnt from pitchdata where test_id = sanId and Frequency = sanFreq;
			if(@anglecnt < 3600) then-- not all angles imported
				 SIGNAL SQLSTATE '88888'
				 set MESSAGE_TEXT = 'Pitch data does not have all angular values';
			end if;
            
             select count(angle) into @anglerr from pitchdata where test_id = sanId and Frequency = sanFreq 
			and (angle > 360 or angle < 0) ; 
			if(@anglerr < 0) then-- not all angles imported
				 SIGNAL SQLSTATE '88888'
				 set MESSAGE_TEXT = 'Invalid angle values. Calculation cannot proceed';
			end if;
            
		end if;
        
-- for all other cases
  else -- if ( myPolType = 'S' and (myTestType = 'A' or myTestType = 'E')) THEN
	
		 if isDebug > 0 then
			SET @infoText = CONCAT("Slant/Circular sanity checks ...");
			call debug(l_proc_id,@infoText,'I','I');
		end if;
		
		
		select count(*) into @counthdata from hdata where test_id = sanId and Frequency = sanFreq;
		if @counthdata > 0  then
			-- roll data is present
			select count(angle) into @anglecnt from hdata where test_id = sanId and Frequency = sanFreq;
			if(@anglecnt < 3600) then-- not all angles imported
				 SIGNAL SQLSTATE '88888'
				 set MESSAGE_TEXT = 'HP data does not have all angular values';
			end if;
            
            
            select count(angle) into @anglerr from hdata where test_id = sanId and Frequency = sanFreq 
			and (angle > 360 or angle < 0) ; 
			if(@anglerr < 0) then-- not all angles imported
				 SIGNAL SQLSTATE '88888'
				 set MESSAGE_TEXT = 'HP has Invalid angle values. Calculation cannot proceed';
			end if;
            
		end if;
        
        select count(*) into @countvdata from vdata where test_id = sanId and Frequency = sanFreq;
		if @countvdata > 0  then
			-- roll data is present
			select count(angle) into @anglecnt from vdata where test_id = sanId and Frequency = sanFreq;
			if(@anglecnt < 3600) then-- not all angles imported
				 SIGNAL SQLSTATE '88888'
				 set MESSAGE_TEXT = 'VP data does not have all angular values';
			end if;
            
            select count(angle) into @anglerr from vdata where test_id = sanId and Frequency = sanFreq 
			and (angle > 360 or angle < 0) ; 
			if(@anglerr < 0) then-- not all angles imported
				 SIGNAL SQLSTATE '88888'
				 set MESSAGE_TEXT = 'VP has Invalid angle values. Calculation cannot proceed';
			end if;
            
		end if;
        
        select count(*) into @countcpdata from cpdata where test_id = sanId and Frequency = sanFreq;
		if @countcpdata > 0  then
			-- roll data is present
			select count(angle) into @anglecnt from cpdata where test_id = sanId and Frequency = sanFreq;
			if(@anglecnt < 3600) then-- not all angles imported
				 SIGNAL SQLSTATE '88888'
				 set MESSAGE_TEXT = 'CP data does not have all angular values';
			end if;
            
            select count(angle) into @anglerr from cpdata where test_id = sanId and Frequency = sanFreq 
			and (angle > 360 or angle < 0) ; 
			if(@anglerr < 0) then-- not all angles imported
				 SIGNAL SQLSTATE '88888'
				 set MESSAGE_TEXT = 'CP has Invalid angle values. Calculation cannot proceed';
			end if;
            
		end if;
        
        -- 45 deg pol
        select count(*) into @countfdata from fdata where test_id = sanId and Frequency = sanFreq;
		if @countfdata > 0  then
			-- roll data is present
			select count(angle) into @anglecnt from fdata where test_id = sanId and Frequency = sanFreq;
			if(@anglecnt < 3600) then-- not all angles imported
				 SIGNAL SQLSTATE '88888'
				 set MESSAGE_TEXT = 'FP data does not have all angular values';
			end if;
            
            select count(angle) into @anglerr from fdata where test_id = sanId and Frequency = sanFreq 
			and (angle > 360 or angle < 0) ; 
			if(@anglerr < 0) then-- not all angles imported
				 SIGNAL SQLSTATE '88888'
				 set MESSAGE_TEXT = 'FP has Invalid angle values. Calculation cannot proceed';
			end if;
            
		end if;
        
        -- fpr phase difference
        select count(*) into @counthdata from hdata_phase where test_id = sanId and Frequency = sanFreq;
		if @counthdata > 0  then
			-- roll data is present
			select count(angle) into @anglecnt from hdata_phase where test_id = sanId and Frequency = sanFreq;
			if(@anglecnt < 3600) then-- not all angles imported
				 SIGNAL SQLSTATE '88888'
				 set MESSAGE_TEXT = 'HP phase data does not have all angular values';
			end if;
            
            
            select count(angle) into @anglerr from hdata_phase where test_id = sanId and Frequency = sanFreq 
			and (angle > 360 or angle < 0) ; 
			if(@anglerr < 0) then-- not all angles imported
				 SIGNAL SQLSTATE '88888'
				 set MESSAGE_TEXT = 'HP phase data has Invalid angle values. Calculation cannot proceed';
			end if;
            
		end if;
        
        select count(*) into @countvdata from vdata_phase where test_id = sanId and Frequency = sanFreq;
		if @countvdata > 0  then
			-- roll data is present
			select count(angle) into @anglecnt from vdata_phase where test_id = sanId and Frequency = sanFreq;
			if(@anglecnt < 3600) then-- not all angles imported
				 SIGNAL SQLSTATE '88888'
				 set MESSAGE_TEXT = 'VP phase data does not have all angular values';
			end if;
            
            select count(angle) into @anglerr from vdata_phase where test_id = sanId and Frequency = sanFreq 
			and (angle > 360 or angle < 0) ; 
			if(@anglerr < 0) then-- not all angles imported
				 SIGNAL SQLSTATE '88888'
				 set MESSAGE_TEXT = 'VP phase data has Invalid angle values. Calculation cannot proceed';
			end if;
            
		end if;

 END IF;
 
 if isDebug > 0 then
	SET @infoText = CONCAT("Sanity checks complete");
		call debug(l_proc_id,@infoText,'I','I');
 end if;
 
End$$

DELIMITER ;


DROP procedure IF EXISTS `calc_Circular_PD`;

DELIMITER $$

CREATE  PROCEDURE `calc_Circular_PD`(
cncpTestId INT,
cncpFreq decimal(40,20),
cncpTestDate datetime
)
BEGIN

# Declarations -begin

# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'calc_Circular_PD for C-PD';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;
    

DECLARE pd_0,pd_P60,pd_M60,pd_Maxdiff_P60, pd_Maxdiff_M60 decimal(40,20);
DECLARE angle_Maxdiff_P60, angle_Maxdiff_M60 decimal(40,20);

DECLARE hDataPresent INT default 0;
DECLARE vDataPresent INT default 0;

# 3. declare continue/exit handlers for logging SQL exceptions/errors :
-- write handlers for specific known error codes which are likely to occur here    
-- eg : DECLARE CONTINUE HANDLER FOR 1062
-- begin 
-- 	if isDebug > 0 then
-- 		call debug(l_proc_id, 'Duplicate keys error encountered','E','I');
-- 	end if;
-- end;

-- write handlers for sql states which occur due to one or more sql errors here
-- eg : DECLARE EXIT HANDLER FOR SQLSTATE '23000' 
 -- begin
-- 	if isDebug > 0 then
-- 		call debug(l_proc_id, 'SQLSTATE 23000','F','I');
-- 	end if;
-- end;
 
 -- write handlers for generic SQL exception which occurs due to one or more SQL states

 DECLARE EXIT HANDLER FOR SQLEXCEPTION 
 begin
 
	if isDebug > 0 then
		GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
		@errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
		SET @full_error = CONCAT("SQLException ", @errno, " (", @sqlstate, "): ", @text);
		call debug(l_proc_id, @full_error,'F','I');
        SET @details = CONCAT("Test id : ",cncpTestId,",Frequency : ",cncpFreq);
		call debug(l_proc_id, @details,'I','I');
           
         
	end if;
    RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in calc_Circular_NCP','I','I');
 end if;


# Declarations -end

select count(*) into hDataPresent from hdata_phase where test_id = cncpTestId and Frequency = cncpFreq;
select count(*) into vDataPresent from vdata_phase where test_id = cncpTestId and Frequency = cncpFreq;

-- axial ratio calculations
if hDataPresent > 0 and vDataPresent > 0 then
	  -- Calculate Axial ratio at 0 degree
			  select calc_PhaseDifference(cncpTestId,cncpFreq,0) into pd_0;
              
		   -- Calculate Axial ratio at +45 degree
			  select calc_PhaseDifference(cncpTestId,cncpFreq,60) into pd_P60;
            
              
		   -- Calculate Axial ratio at  -45 degree
		      select calc_PhaseDifference(cncpTestId,cncpFreq,-60) into pd_M60;
           
		   -- Calculate Max-diff Axial ratio from 0 to +45 : Maximum Axial ratio from 0 to +45 degree
			  call calc_MaxDiffPhaseDifference(cncpTestId, cncpFreq, 'P60', pd_Maxdiff_P60, angle_Maxdiff_P60);
              
		   -- Calculate Max-diff Axial ratio from 0 to -45 : Maximum Axial ratio from 0 to -45 degree
		      call calc_MaxDiffPhaseDifference(cncpTestId, cncpFreq, 'M60', pd_Maxdiff_M60, angle_Maxdiff_M60);
              
            
              
              -- insert into arcalculated
               delete from phasecalculated where Test_id = cncpTestId and Frequency = cncpFreq;
				insert into phasecalculated(Test_id,Frequency,TestDate,
						PD_0,
                        PD_P60,PD_M60,MaxPD_P60_Ratio,MaxPD_P60_Angle,MaxPD_M60_Ratio,MaxPD_M60_Angle)
				select cncpTestId,cncpFreq,cncpTestDate,
				 		pd_0,
                        pd_P60,pd_M60,pd_Maxdiff_P60,angle_Maxdiff_P60, pd_Maxdiff_M60, angle_Maxdiff_M60; 
        
        
        if isDebug > 0 then
				SET @infoText = "Calculated data saved successfully into phasecalculated";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
end if;
END$$

DELIMITER ;

DROP function IF EXISTS `calc_PhaseDifference`;

DELIMITER $$
CREATE  FUNCTION `calc_PhaseDifference`(
atest_id INT, freq decimal(40,20), degree INT
) RETURNS decimal(40,20)
BEGIN

# Axial Ratio =( HP – VP) at degree for freq

DECLARE PD decimal(40,20) default 0;

-- if degree = 0 then 
-- 	set degree = 360;
--  else
if degree < 0 then
	set degree = 360 + degree;
end if;

select phasedifference 
into PD
from phasedifference_view
 where test_id = atest_id and Frequency = freq and angle = degree;
 
RETURN PD;
END$$
DELIMITER ;

drop procedure if exists calc_MaxDiffPhaseDifference;

DELIMITER $$
CREATE  PROCEDURE `calc_MaxDiffPhaseDifference`(
mdtest_id INT, freq decimal(40,20), P_or_M char(3),
OUT MaxdiffPD decimal(40,20), 
OUT MaxdiffAngle decimal(40,20)
)
BEGIN

# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'calc_MaxDiffPhaseDifference';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;

Declare i, currAngle, currPD decimal(40,20);

# 3. declare continue/exit handlers for logging SQL exceptions/errors :
-- write handlers for specific known error codes which are likely to occur here    
-- eg : DECLARE CONTINUE HANDLER FOR 1062
-- begin 
-- 	if isDebug > 0 then
-- 		call debug(l_proc_id, 'Duplicate keys error encountered','E','I');
-- 	end if;
-- end;

-- write handlers for sql states which occur due to one or more sql errors here
-- eg : DECLARE EXIT HANDLER FOR SQLSTATE '23000' 
 -- begin
-- 	if isDebug > 0 then
-- 		call debug(l_proc_id, 'SQLSTATE 23000','F','I');
-- 	end if;
-- end;
 
 -- write handlers for generic SQL exception which occurs due to one or more SQL states

 DECLARE EXIT HANDLER FOR SQLEXCEPTION 
 begin
	if isDebug > 0 then
		GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
		@errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
		SET @full_error = CONCAT("SQLException ", @errno, " (", @sqlstate, "): ", @text);
		call debug(l_proc_id, @full_error,'F','I');
        SET @details = CONCAT("Test id : ",mdtest_id,",Frequency : ",freq,",P_or_M : ",P_or_M);
		call debug(l_proc_id, @details,'I','I');
        
         
	end if;
    RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in calc_MaxDiffPhaseDifference','I','I');
 end if;


if P_or_M = 'P60' then
select MAX(phasedifference) 
    into MaxdiffPD
    from phasedifference_view 
    where test_id = mdtest_id and Frequency = freq 
    and (angle >= 0 and angle <=60);
    
    
    select MAX(angle)
    into MaxdiffAngle
    from phasedifference_view 
    where test_id = mdtest_id and Frequency = freq and phasedifference = MaxdiffPD;
end if;    
    -- if MaxdiffAngle = 360 then
-- set MaxdiffAngle = 0;
-- end if;
    
if P_or_M = 'M60' then-- P_or_M ='M'

select MAX(phasedifference) 
    into MaxdiffPD
    from phasedifference_view 
    where test_id = mdtest_id and Frequency = freq 
    and ((angle >= 300 and angle < 360) or (angle = 0));
    
    
    select MAX(angle)
    into MaxdiffAngle
    from phasedifference_view 
    where test_id = mdtest_id and Frequency = freq and phasedifference = MaxdiffPD;
    
    if MaxdiffAngle <> 0 then
set MaxdiffAngle = MaxdiffAngle-360;
    end if;
end if;

END$$
DELIMITER ;


