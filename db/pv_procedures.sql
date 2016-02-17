drop procedure spPVPolarPlot;
drop procedure if exists spPVPolarSummary;

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE  PROCEDURE spPVPolarPlot(
testid INT,
freqparm decimal(40,20),
typ varchar(5), -- H HP,V VP,B HP&VP,P Pitch,R Roll ,Y Yaw
vdatatype varchar(5), -- Azimuth,Elevation
serialid INT,
prec int
)
BEGIN


# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'spPVPolarPlot';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;
DECLARE ampl decimal(40,20) default 0;
DECLARE vampl decimal(40,20) default 0;
declare lgampl decimal(40,20) default 0;
declare strmaxvalue varchar(50);
declare strminvalue varchar(50);
declare cnt int default 0;
declare unt varchar(10) default 'MHz';
declare freq decimal(40,20) default 1000.0;


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
        SET @details = CONCAT("Test id : ", testid, ", Frequency : ",freq, ", typ : ",typ,",serialid : ",serialid);
		call debug(l_proc_id, @details,'I','I');
        
         RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
	end if;
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in spGetPolarPlot','I','I');
 end if;


-- select nprecision into prec from fwk_company;

select frequnit into unt from pv_testdata where test_id=testid;


set freq=freqparm;
set cnt=0;
if unt='GHz' then
set freq=freqparm*1000;
end if;

if typ='H' then
	if cnt=0 then
			select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM pv_hdata HD 
			where HD.Frequency= freq and HD.Prodserial_id=serialid and datatype=vdatatype;
			select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM pv_hdata HD 
			where HD.Frequency=freq and HD.Prodserial_id=serialid and datatype=vdatatype;
	end if;
      SELECT HD.Angle,HD.Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Prodserial_id,strmaxvalue,strminvalue FROM pv_hdata HD 
		where HD.Frequency=freq and HD.Prodserial_id=serialid and datatype=vdatatype;

end if;
if typ='V' then
	if cnt=0 then
			select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM pv_vdata HD 
			where HD.Frequency=freq and HD.Prodserial_id=serialid and datatype=vdatatype;
			select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM pv_vdata HD 
			where HD.Frequency=freq and HD.Prodserial_id=serialid and datatype=vdatatype;
	end if;
		SELECT HD.Angle,HD.Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Prodserial_id,strmaxvalue,strminvalue FROM pv_vdata HD 
		where HD.Frequency=freq and HD.Prodserial_id=serialid and datatype=vdatatype;

end if;
if typ='C' then
		if cnt=0 then
				select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM pv_cpdata HD 
				where HD.Frequency=freq and HD.Prodserial_id=serialid and datatype=vdatatype;
				select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM pv_cpdata HD 
				where HD.Frequency=freq and HD.Prodserial_id=serialid and datatype=vdatatype;
		end if;
		SELECT HD.Angle,HD.Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Prodserial_id,strmaxvalue,strminvalue FROM pv_cpdata HD 
		where HD.Frequency=freq and HD.Prodserial_id=serialid and datatype=vdatatype;
end if;
if typ='B' then
	if cnt=0 then
			select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM pv_hdata HD 
			where HD.Frequency=freq and HD.Prodserial_id=serialid and datatype=vdatatype;
			select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM pv_hdata HD 
			where HD.Frequency=freq and HD.Prodserial_id=serialid and datatype=vdatatype;
	end if;	
		select test_id, case unt when 'GHz' then concat(RPAD(round(Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(Frequency,prec),10,' '),unt) end frequency,Angle,sum(hamplitude) hamplitude,sum(vamplitude) vamplitude,strmaxvalue,strminvalue 
		from (
		SELECT hp.Prodserial_id, frequency ,hp.angle,hp.amplitude hamplitude, 0 vamplitude, 0 camplitude, 0 pamplitude, 0 ramplitude, 0 yamplitude,t.frequnit
		FROM pv_hdata hp inner join pv_prodserial t on hp.Prodserial_id=t.Prodserial_id where Frequency  =freq and t.Prodserial_id=serialid and datatype=vdatatype
		UNION All
		SELECT hp.Prodserial_id, frequency,hp.angle,0 hamplitude,hp.amplitude vamplitude, 0 camplitude, 0 pamplitude, 0 ramplitude, 0 yamplitude,t.frequnit
		FROM pv_vdata hp inner join pv_prodserial t on hp.Prodserial_id=t.Prodserial_id where Frequency  =freq and hp.Prodserial_id=serialid and datatype=vdatatype ) as tab
		group by Prodserial_id,frequency,angle,strmaxvalue,strminvalue;
end if;

END$$


-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE `spPVPolarSummary`(
testid INT,
freqparm decimal(40,10),
typ varchar(5), -- H HP,V VP,B HP&VP
vdatatype varchar(5), -- Azimuth,Elevation
serialid INT,
prec int
)
BEGIn
# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'spPVPolarSummary';

# 2. declare variable to store debug flag
declare isDebug INT default 0;
declare unt varchar(10) default 'MHz';
declare freq decimal(40,20) default 1000.00;
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
        SET @details = CONCAT("Test id : ", testid, ", Frequency : ",freq, ", typ : ",typ);
		call debug(l_proc_id, @details,'I','I');
        
     
	end if;
        RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in spPVPolarSummary','I','I');
 end if;

set prec=1;
if freqparm >0 then
	select frequnit into unt from pv_testdata where test_id=testid;

	set freq=freqparm;

	if unt='GHz' then
		set freq=freqparm*1000;
	end if;

	if typ='C' then
		select round(sum(3Db_BW_BMax),prec) 3Db_BW_BMax,round(sum(3Db_BS_BMax),prec) 3Db_BS_BMax,round(sum(10Db_BW_BMax),prec) 10Db_BW_BMax,round(sum(10Db_BS_BMax),prec) 10Db_BS_BMax,round(sum(BackLobe),prec) BackLobe,round(sum(CPGain),prec) CPGain,round(sum(AR_0),prec) AR_0 ,round(sum(OmniDeviation),prec) OmniDeviation from (
		select 3Db_BW_BMax,3Db_BS_BMax,10Db_BW_BMax,10Db_BS_BMax,BackLobe,CPGain,0 AR_0,0 OmniDeviation from pv_cpcalculated h inner join pv_prodserial p on h.Prodserial_id=p.Prodserial_id where p.Test_id=testid and Frequency=freq
		union select 0 3Db_BW_BMax,0 3Db_BS_BMax, 0 10Db_BW_BMax,0 10Db_BS_BMax,0 BackLobe, 0 CPGain,AR_0,0 OmniDeviation from pv_arcalculated h inner join pv_prodserial p on h.Prodserial_id=p.Prodserial_id where p.Test_id=testid and Frequency=freq) as tab;
	end if;
	if typ='H' then
		select round(sum(3Db_BW_BMax),prec) 3Db_BW_BMax,round(sum(3Db_BS_BMax),prec) 3Db_BS_BMax,round(sum(10Db_BW_BMax),prec) 10Db_BW_BMax,round(sum(10Db_BS_BMax),prec) 10Db_BS_BMax,round(sum(BackLobe),prec) BackLobe,round(sum(CPGain),prec) CPGain,round(sum(AR_0),prec) AR_0 ,round(sum(OmniDeviation),prec) OmniDeviation from (
		select 3Db_BW_BMax,3Db_BS_BMax,10Db_BW_BMax,10Db_BS_BMax,BackLobe,0 CPGain,0 AR_0, OmniDeviation from pv_hcalculated h inner join pv_prodserial p on h.Prodserial_id=p.Prodserial_id where p.Test_id=testid and Frequency=freq
		union select 0 3Db_BW_BMax,0 3Db_BS_BMax, 0 10Db_BW_BMax,0 10Db_BS_BMax,0 BackLobe, 0 CPGain,AR_0,0 OmniDeviation from pv_arcalculated h inner join pv_prodserial p on h.Prodserial_id=p.Prodserial_id where p.Test_id=testid and Frequency=freq) as tab;
	end if;
	if typ='V' then
		select round(sum(3Db_BW_BMax),prec) 3Db_BW_BMax,round(sum(3Db_BS_BMax),prec) 3Db_BS_BMax,round(sum(10Db_BW_BMax),prec) 10Db_BW_BMax,round(sum(10Db_BS_BMax),prec) 10Db_BS_BMax,round(sum(BackLobe),prec) BackLobe,round(sum(CPGain),prec) CPGain,round(sum(AR_0),prec) AR_0 ,round(sum(OmniDeviation),prec) OmniDeviation from (
		select 3Db_BW_BMax,3Db_BS_BMax,10Db_BW_BMax,10Db_BS_BMax,BackLobe,0 CPGain,0 AR_0, OmniDeviation from pv_vcalculated h inner join pv_prodserial p on h.Prodserial_id=p.Prodserial_id where p.Test_id=testid and Frequency=freq
		union select 0 3Db_BW_BMax,0 3Db_BS_BMax, 0 10Db_BW_BMax,0 10Db_BS_BMax,0 BackLobe, 0 CPGain,AR_0,0 OmniDeviation from pv_arcalculated h inner join pv_prodserial p on h.Prodserial_id=p.Prodserial_id where p.Test_id=testid and Frequency=freq) as tab;
	end if;
		
	if typ='B' then
		select ptype, round(sum(3Db_BW_BMax),prec) 3Db_BW_BMax,round(sum(3Db_BS_BMax),prec) 3Db_BS_BMax,round(sum(10Db_BW_BMax),prec) 10Db_BW_BMax,round(sum(10Db_BS_BMax),prec) 10Db_BS_BMax,round(sum(BackLobe),prec) BackLobe,round(sum(CPGain),prec) CPGain,round(sum(AR_0),prec) AR_0 ,round(sum(OmniDeviation),prec) OmniDeviation from (
		select 'HP' ptype,3Db_BW_BMax,3Db_BS_BMax,10Db_BW_BMax,10Db_BS_BMax,BackLobe,0 CPGain,0 AR_0, OmniDeviation from pv_hcalculated h inner join pv_prodserial p on h.Prodserial_id=p.Prodserial_id where p.Test_id=testid and Frequency=freq
		union select 'HP' ptype,0 3Db_BW_BMax,0 3Db_BS_BMax, 0 10Db_BW_BMax,0 10Db_BS_BMax,0 BackLobe, 0 CPGain,AR_0,0 OmniDeviation from pv_arcalculated h inner join pv_prodserial p on h.Prodserial_id=p.Prodserial_id where p.Test_id=testid and Frequency=freq
		union
		select 'VP' ptype,3Db_BW_BMax,3Db_BS_BMax,10Db_BW_BMax,10Db_BS_BMax,BackLobe,0 CPGain,0 AR_0, OmniDeviation from pv_vcalculated where Test_id=testid and Frequency=freq 
		union select 'VP' ptype,0 3Db_BW_BMax,0 3Db_BS_BMax, 0 10Db_BW_BMax,0 10Db_BS_BMax,0 BackLobe, 0 CPGain,AR_0,0 OmniDeviation from pv_arcalculated h inner join pv_prodserial p on h.Prodserial_id=p.Prodserial_id where p.Test_id=testid and Frequency=freq
		) as tab
		group by ptype;
	end if;	
   	
end if;     
END