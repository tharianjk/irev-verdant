
drop procedure if exists spPVPolarSummary;
drop procedure if exists pv_calc_Gain_Tracking;
drop procedure if exists pv_Calculate_params;
drop FUNCTION  if exists pv_calc_AxialRatio;
drop procedure if exists pv_calc_Gain_Measurement;
drop FUNCTION  if exists pv_calc_cpdata;
drop procedure if exists spPV_Axial;
drop procedure if exists spPV_BSBL;
drop procedure if exists spPV_DB;
drop procedure if exists spPV_DB_sum;
drop procedure if exists spPVPolarPlot;
drop function if exists pv_calc_cpdata_combi;
drop procedure if exists pv_calc_combination;
drop procedure if exists pv_calc_XdB_BW_BS;
drop procedure if exists pv_calc_backlobelevel;
drop procedure if exists pv_calc_spec;
drop procedure if exists pv_calc_gtcalculated;
drop procedure if exists spPV_GT;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

-- drop procedure if exists spPVPolarPlot;

CREATE  PROCEDURE spPVPolarPlot(
testid INT,
freqparm decimal(40,20),
typ varchar(5), -- C CP,H HP,V VP,B HP&VP
vdatatype varchar(5), -- A Azimuth,E Elevation,T Gain Tracking,M Gain Measurement
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
	if datatype='A' then
			select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM pv_hdata_azimuth HD 
			where HD.Frequency= freq and HD.Prodserial_id=serialid ;
			select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM pv_hdata_azimuth HD 
			where HD.Frequency=freq and HD.Prodserial_id=serialid ;
	end if;
	if datatype='E' then
			select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM pv_hdata_elevation HD 
			where HD.Frequency= freq and HD.Prodserial_id=serialid ;
			select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM pv_hdata_elevation HD 
			where HD.Frequency=freq and HD.Prodserial_id=serialid ;
	end if;
	if datatype='T' then
			select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM pv_hdata_GT HD 
			where HD.Frequency= freq and HD.Prodserial_id=serialid ;
			select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM pv_hdata_GT HD 
			where HD.Frequency=freq and HD.Prodserial_id=serialid ;
	end if;
	end if;
	if datatype='A' then
      SELECT case when HD.Angle >180 then HD.Angle -360 else HD.Angle end Angle ,HD.Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Prodserial_id,strmaxvalue,strminvalue FROM pv_hdata_azimuth HD 
		where HD.Frequency=freq and HD.Prodserial_id=serialid ;
    end if;
	if datatype='E' then
      SELECT case when HD.Angle >180 then HD.Angle -360 else HD.Angle end Angle ,HD.Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Prodserial_id,strmaxvalue,strminvalue FROM pv_hdata_elevation HD 
		where HD.Frequency=freq and HD.Prodserial_id=serialid ;
    end if;
	if datatype='T' then
      SELECT case when HD.Angle >180 then HD.Angle -360 else HD.Angle end Angle ,HD.Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Prodserial_id,strmaxvalue,strminvalue FROM pv_hdata_GT HD 
		where HD.Frequency=freq and HD.Prodserial_id=serialid ;
    end if;
end if;
if typ='V' then
	if cnt=0 then
	if datatype='A' then
			select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM pv_vdata_azimuth HD 
			where HD.Frequency= freq and HD.Prodserial_id=serialid ;
			select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM pv_vdata_azimuth HD 
			where HD.Frequency=freq and HD.Prodserial_id=serialid ;
	end if;
	if datatype='E' then
			select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM pv_vdata_elevation HD 
			where HD.Frequency= freq and HD.Prodserial_id=serialid ;
			select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM pv_vdata_elevation HD 
			where HD.Frequency=freq and HD.Prodserial_id=serialid ;
	end if;
	if datatype='T' then
			select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM pv_vdata_GT HD 
			where HD.Frequency= freq and HD.Prodserial_id=serialid ;
			select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM pv_vdata_GT HD 
			where HD.Frequency=freq and HD.Prodserial_id=serialid ;
	end if;
	end if;
		if datatype='A' then
      SELECT case when HD.Angle >180 then HD.Angle -360 else HD.Angle end Angle ,HD.Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Prodserial_id,strmaxvalue,strminvalue FROM pv_Vdata_azimuth HD 
		where HD.Frequency=freq and HD.Prodserial_id=serialid ;
    end if;
	if datatype='E' then
      SELECT case when HD.Angle >180 then HD.Angle -360 else HD.Angle end Angle ,HD.Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Prodserial_id,strmaxvalue,strminvalue FROM pv_vdata_elevation HD 
		where HD.Frequency=freq and HD.Prodserial_id=serialid ;
    end if;
	if datatype='T' then
      SELECT case when HD.Angle >180 then HD.Angle -360 else HD.Angle end Angle ,HD.Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Prodserial_id,strmaxvalue,strminvalue FROM pv_vdata_GT HD 
		where HD.Frequency=freq and HD.Prodserial_id=serialid ;
    end if;

end if;
if typ='C' then
		if cnt=0 then
				if datatype='A' then
			select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM pv_cpdata_azimuth HD 
			where HD.Frequency= freq and HD.Prodserial_id=serialid ;
			select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM pv_cpdata_azimuth HD 
			where HD.Frequency=freq and HD.Prodserial_id=serialid ;
	end if;
	if datatype='E' then
			select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM pv_cpdata_elevation HD 
			where HD.Frequency= freq and HD.Prodserial_id=serialid ;
			select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM pv_cpdata_elevation HD 
			where HD.Frequency=freq and HD.Prodserial_id=serialid ;
	end if;
	
		end if;
		if datatype='A' then
      SELECT case when HD.Angle >180 then HD.Angle -360 else HD.Angle end Angle ,HD.Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Prodserial_id,strmaxvalue,strminvalue FROM pv_cpdata_azimuth HD 
		where HD.Frequency=freq and HD.Prodserial_id=serialid ;
    end if;
	if datatype='E' then
      SELECT case when HD.Angle >180 then HD.Angle -360 else HD.Angle end Angle ,HD.Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Prodserial_id,strmaxvalue,strminvalue FROM pv_cpdata_elevation HD 
		where HD.Frequency=freq and HD.Prodserial_id=serialid ;
    end if;
	if datatype='T' then
      SELECT case when HD.Angle >180 then HD.Angle -360 else HD.Angle end Angle ,HD.Amplitude,case unt when 'GHz' then concat(RPAD(round(HD.Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(HD.Frequency,prec),10,' '),unt) end Frequency,HD.Prodserial_id,strmaxvalue,strminvalue FROM pv_cpdata_GT HD 
		where HD.Frequency=freq and HD.Prodserial_id=serialid ;
    end if;
end if;
if typ='B' then
	if cnt=0 then
			if datatype='A' then
			select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM pv_hdata_azimuth HD 
			where HD.Frequency= freq and HD.Prodserial_id=serialid ;
			select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM pv_hdata_azimuth HD 
			where HD.Frequency=freq and HD.Prodserial_id=serialid ;
	end if;
	if datatype='E' then
			select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM pv_hdata_elevation HD 
			where HD.Frequency= freq and HD.Prodserial_id=serialid ;
			select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM pv_hdata_elevation HD 
			where HD.Frequency=freq and HD.Prodserial_id=serialid ;
	end if;
	if datatype='T' then
			select convert(floor(max(Amplitude))+1,char(30)) into strmaxvalue FROM pv_hdata_GT HD 
			where HD.Frequency= freq and HD.Prodserial_id=serialid ;
			select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM pv_hdata_GT HD 
			where HD.Frequency=freq and HD.Prodserial_id=serialid ;
	end if;
	end if;
    if datatype='A' then	
				select test_id, case unt when 'GHz' then concat(RPAD(round(Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(Frequency,prec),10,' '),unt) end frequency,case when HD.Angle >180 then HD.Angle -360 else HD.Angle end  Angle,sum(hamplitude) hamplitude,sum(vamplitude) vamplitude,strmaxvalue,strminvalue 
				from (
				SELECT hp.Prodserial_id, frequency ,hp.angle,hp.amplitude hamplitude, 0 vamplitude, 0 camplitude, 0 pamplitude, 0 ramplitude, 0 yamplitude,t.frequnit
				FROM pv_hdata_azimuth hp inner join pv_prodserial t on hp.Prodserial_id=t.Prodserial_id where Frequency  =freq and t.Prodserial_id=serialid 
				UNION All
				SELECT hp.Prodserial_id, frequency,hp.angle,0 hamplitude,hp.amplitude vamplitude, 0 camplitude, 0 pamplitude, 0 ramplitude, 0 yamplitude,t.frequnit
				FROM pv_vdata_azimuth hp inner join pv_prodserial t on hp.Prodserial_id=t.Prodserial_id where Frequency  =freq and hp.Prodserial_id=serialid  ) as tab
				group by Prodserial_id,frequency,angle,strmaxvalue,strminvalue;
		end if;
		if datatype='E' then	
				select test_id, case unt when 'GHz' then concat(RPAD(round(Frequency/1000,prec),10,' '),unt) else  concat(RPAD(round(Frequency,prec),10,' '),unt) end frequency,case when HD.Angle >180 then HD.Angle -360 else HD.Angle end  Angle,sum(hamplitude) hamplitude,sum(vamplitude) vamplitude,strmaxvalue,strminvalue 
				from (
				SELECT hp.Prodserial_id, frequency ,hp.angle,hp.amplitude hamplitude, 0 vamplitude, 0 camplitude, 0 pamplitude, 0 ramplitude, 0 yamplitude,t.frequnit
				FROM pv_hdata_elevation hp inner join pv_prodserial t on hp.Prodserial_id=t.Prodserial_id where Frequency  =freq and t.Prodserial_id=serialid 
				UNION All
				SELECT hp.Prodserial_id, frequency,hp.angle,0 hamplitude,hp.amplitude vamplitude, 0 camplitude, 0 pamplitude, 0 ramplitude, 0 yamplitude,t.frequnit
				FROM pv_vdata_elevation hp inner join pv_prodserial t on hp.Prodserial_id=t.Prodserial_id where Frequency  =freq and hp.Prodserial_id=serialid  ) as tab
				group by Prodserial_id,frequency,angle,strmaxvalue,strminvalue;
		end if;
end if;

END$$
DELIMITER ;

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
END$$
DELIMITER ;


DELIMITER $$

-- to calculate axial ratio
CREATE FUNCTION `pv_calc_AxialRatio`(
cProdSerialId INT, freq decimal(40,20), degree INT, cdatatype char(2)
) RETURNS decimal(40,20)
BEGIN

# Axial Ratio =( HP – VP) at degree for freq

DECLARE AR decimal(40,20) default 0;


-- if degree = 0 then 
-- 	set degree = 360;
--  else
if degree = -45 then
	set degree = 315;
end if;

if cdatatype = 'A' then
	-- HP
	select Amplitude into @hp from pv_hdata_azimuth where Prodserial_id = cProdSerialId and Frequency = freq
	and Angle = degree ;
	-- VP
	select Amplitude into @vp from pv_vdata_azimuth where Prodserial_id = cProdSerialId and Frequency = freq
	and Angle = degree ;

elseif cdatatype = 'E' then

-- HP
select Amplitude into @hp from pv_hdata_elevation where Prodserial_id = cProdSerialId and Frequency = freq
and Angle = degree ;
-- VP
select Amplitude into @vp from pv_vdata_elevation where Prodserial_id = cProdSerialId and Frequency = freq
and Angle = degree ;

elseif cdatatype = 'M' then

-- HP
select Amplitude into @hp from pv_hdata_gm where Prodserial_id = cProdSerialId and Frequency = freq
and Angle = degree ;
-- VP
select Amplitude into @vp from pv_vdata_gm where Prodserial_id = cProdSerialId and Frequency = freq
and Angle = degree ;

end if;


set AR = @hp - @vp;
 
RETURN AR;
END$$

DELIMITER ;

-- to calculate CPdata
DELIMITER $$
CREATE FUNCTION `pv_calc_cpdata`(
cProdSerialId INT, freq decimal(40,20), cAngle decimal(40,20),
cAmplitudeA decimal(40,20),cAmplitudeB decimal(40,20)
) RETURNS decimal(40,20)
BEGIN

declare C,D,E,cpdata decimal(40,20) default 0;


if cAmplitudeA > cAmplitudeB then
	set C = cAmplitudeA - cAmplitudeB;
else 
	set C = cAmplitudeB - cAmplitudeA;
end if;

set D = EXP(C/20);
-- select D;

set E = 20 * LOG10((D+1)/(1.414*D));
-- select E;

if cAmplitudeA > cAmplitudeB then
	set cpdata = cAmplitudeA+E;
else 
	set cpdata = cAmplitudeB+E;
end if;

-- select cpdata;    
    
RETURN cpdata;
END$$

DELIMITER ;

-- the parent calculate procedure for new type - call with myPoltype = 'PV'
DELIMITER $$
CREATE PROCEDURE `pv_Calculate_params`(
myTestId INT,
-- myFreqUnit char(1), -- 'M' = MHz, 'G' = GHz
myPoltype char(2), -- 'L'=linear, 'C'= circular
myserial INT
)
BEGIN

# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'pv_Calculate_params';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;

-- declare myserial INT;
declare myfreq decimal(40,20);
declare myTestDate datetime;
DECLARE myTestType char(4);

 -- for the cursor
DECLARE done INT DEFAULT 0;

 DECLARE freqcur CURSOR FOR
 select Frequency-- ,p.Prodserial_Id -- , lineargain
 from pv_testfreq t
 -- inner join pv_prodserial p on p.Test_id = t.Test_id
 where t.Test_id = myTestId
 -- order by p.Prodserial_Id, Frequency;
  order by Frequency;


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
        SET @infoText = CONCAT("Test Id : ", myTestId, ", Polarization Type : ",myPolType,", Test Type : ", myTestType,", Serial : ", myserial);
		call debug(l_proc_id,@infoText,'I','I');
        
        
	end if;
    
    -- rollback all calculations
    delete from pv_gt_intermediate where Test_id = myTestId and Prodserial_Id = myserial;
    delete from pv_gt_calculated where Test_id = myTestId;
	delete from pv_gmcalculated where test_id = myTestId and Prodserial_Id = myserial;
    -- delete from pv_cpdata_gt where Prodserial_Id = myserial; -- in (select prodserial_id from pv_prodserial where Test_id = myTestId);
    delete from pv_cpdata_azimuth where Prodserial_Id = myserial;
    delete from pv_cpdata_elevation where Prodserial_Id = myserial;
    delete from pv_cpcalculated where test_id = myTestId and Prodserial_Id = myserial;
	delete from pv_speccalculated where test_id = myTestId;
	
    
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
from pv_testdata where Test_id = myTestId;

if isDebug > 0 then
	SET @infoText = CONCAT("Test Id : ", myTestId, ", Polarization Type : ",myPolType,", Test Type : ", myTestType,", Serial : ", myserial);
	call debug(l_proc_id,@infoText,'I','I');
 end if;
 
#open cursor
  OPEN freqcur;
  
  #starts the loop
  pv_the_loop: LOOP
  
 FETCH freqcur INTO myfreq;-- ,myserial; -- ,mylinear_Gain;
IF done = 1 THEN
	if isDebug > 0 then
		SET @infoText = "Done looping through spot frequencies";
		call debug(l_proc_id,@infoText,'I','I');
	end if;
LEAVE pv_the_loop;
END IF;
   
    -- call calculate(myTestId,myPolType,myfreq,mylinear_Gain,myTestDate,myFreqUnit);
   
-- conv GHz to MHz - REMOVED AS IT IS NOT REQUIRED, only M supported
-- if myFreqUnit = 'G' then
-- set myfreq = myfreq*1000;
-- end if;
        
        -- sanity check is not done
        -- call pv_sanity_check(myTestId,myFreq,myPolType,myTestType);


#calculations - begin
-- Gain Measurement
  IF ( myPolType = 'PV' and myTestType = 'GM') THEN
	if isDebug > 0 then
		SET @infoText = CONCAT("invoking Gain-Measurement calculations for frequency : ",myfreq," , serial ",myserial);
		call debug(l_proc_id,@infoText,'I','I');
	end if;
	 call pv_calc_Gain_Measurement(myTestId,myfreq,myTestDate,myserial);
-- Gain TRacking
  elseif ( myPolType = 'PV' and myTestType = 'GT') THEN
	if isDebug > 0 then
		SET @infoText = CONCAT("invoking Gain Tracking calculations for frequency : ",myfreq," , serial ",myserial);
		call debug(l_proc_id,@infoText,'I','I');
	end if;
	call pv_calc_Gain_Tracking(myTestId,myfreq,myTestDate,myserial);
-- Combination
  elseif ( myPolType = 'PV' and myTestType = 'CO') THEN
	if isDebug > 0 then
		SET @infoText = CONCAT("invoking Combination calculations for frequency : ",myfreq," , serial ",myserial);
		call debug(l_proc_id,@infoText,'I','I');
	end if;
	call pv_calc_combination(myTestId,myfreq,myTestDate,myserial);
    
    
 END IF;
  #Calculations - end
    
    END LOOP pv_the_loop;
 
  CLOSE freqcur;
  
  -- to populate the spec tables for combination testtype
 -- if myTestType = 'CO' then
 --    call pv_calc_spec(myTestId,myTestDate);
-- end if;
   
-- store calculated values for gain tracking
-- if myTestType = 'GT' then
	# store calculated values into calculated table
	
   -- delete from pv_gt_calculated where Test_id = myTestId;
	 -- insert into pv_gt_calculated (Test_id,Frequency,TestDate, 
		-- 							MAX_CP_0,MIN_CP_0,Window_0,
			-- 						MAX_CP_P45,MIN_CP_P45,Window_P45,
				-- 					MAX_CP_M45,MIN_CP_M45,Window_M45
					-- 				)
		-- select Test_id,Frequency,TestDate, 
			-- 						MAX(CP_0),MIN(CP_0),MAX(CP_0) - MIN(CP_0),
				-- 					MAX(CP_P45),MIN(CP_P45),MAX(CP_P45) - MIN(CP_P45),
					-- 				MAX(CP_M45),MIN(CP_M45),MAX(CP_M45) - MIN(CP_M45)
						-- 	from pv_gt_intermediate
						-- 	where Test_id = myTestId 
						-- 	group by Frequency,Test_id,TestDate;

-- end if;
    
if isDebug > 0 then
	call debug(l_proc_id,'Calculations end','I','I');
 end if;
 
 
END$$

DELIMITER ;

-- Gain measurement calculations
DELIMITER $$
CREATE PROCEDURE `pv_calc_Gain_Measurement`(
gmTestId INT,
gmFreq decimal(40,20),
gmTestDate datetime,
gmSerial INT
)
BEGIN
# Declarations -begin
declare C,Gv,Y,GF,CPGAIN decimal(40,20) default 0;


DECLARE HPDataPresent INT default 0;
DECLARE VPDataPresent INT default 0;
DECLARE raDataPresent INT default 0;
DECLARE GainSTDHornPresent INT default 0;

# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare gm_proc_id varchar(100) default 'pv_calc_Gain_Measurement';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;

 
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
		call debug(gm_proc_id, @full_error,'F','I');
        SET @details = CONCAT("Test id : ",gmTestId,",Frequency : ",gmFreq);
		call debug(gm_proc_id, @details,'I','I');
        
	end if;
	RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(gm_proc_id,'in pv_calc_Gain_Measurement','I','I');
 end if;
 
 
# Declarations -end

# --------------CALCULATIONS BEGIN ----------------------
select count(*) into HPDataPresent from pv_hdata_gm  where Prodserial_id = gmSerial and Frequency = gmFreq and Angle=0;
select count(*) into VPDataPresent from pv_vdata_gm  where Prodserial_id = gmSerial and Frequency = gmFreq and Angle=0;
select count(*) into raDataPresent from pv_radata where Prodserial_id = gmSerial and Frequency = gmFreq;
select count(*) into GainSTDHornPresent from pv_GainSTDHorn where test_id = gmTestId and Frequency = gmFreq;

if HPDataPresent > 0 and VPDataPresent > 0 and raDataPresent > 0  and GainSTDHornPresent > 0 then
	-- Max Received Amplitude of AUT in VP -> A
	select MAX(Amplitude) into @A from pv_vdata_gm where Prodserial_id = gmSerial and Frequency = gmFreq ;

	-- Received Amplitude of STD HORN -> B
	select RecvdAmp into @B from pv_radata where Prodserial_id = gmSerial and Frequency = gmFreq;

	-- Received Amp Diff (C=A-B) 
	set C = @A - @B;

	-- Gain of STD HORN ,D 
	select stdhorn into @D from pv_GainSTDHorn where test_id = gmTestId and Frequency = gmFreq;

	-- Gain (dBLi) ,GV = C+D
	set Gv = C + @D;

	-- AXIAL RATIO (dB) X
	select pv_calc_AxialRatio(gmSerial,gmFreq,0,'M') into @X;

	-- AXIAL RATIO (UNITLESS) Y= Antilog (X / 20)
	set Y = EXP(@X/20);

	-- Gain correction Factor ,GF = 20 log (Y+1/√2*Y)
	set GF = 20 * LOG10((Y+1)/(1.414*Y));

	-- CP GAIN = GV + GF (dBiC) Measured GAIN
	set CPGAIN = Gv + GF;


	# --------------CALCULATIONS END ------------------------

	delete from pv_gmcalculated where Prodserial_id = gmSerial and Test_id = gmTestId and Frequency = gmFreq;
	-- insert into calculated table
	insert into pv_gmcalculated (Prodserial_id,Test_id ,Frequency,TestDate,
								gm_A,gm_B,gm_C,gm_D,gm_Gv,
								gm_X,gm_Y,gm_GF,gm_CPGAIN)
				values
								(gmSerial, gmTestId, gmFreq, gmTestDate,
								@A, @B, C, @D, Gv,
								@X, Y, GF, CPGAIN);
else

	call debug(gm_proc_id,'all required raw data not imported/input','E','I');
end if;
 
 
END$$

DELIMITER ;

-- Gain tracking
DELIMITER $$
CREATE PROCEDURE `pv_calc_Gain_Tracking`(
gmTestId INT,
gmFreq decimal(40,20),
gmTestDate datetime,
gmSerial decimal(40,20)
)
BEGIN

# Declarations -begin

# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare gm_proc_id varchar(100) default 'pv_calc_Gain_Tracking';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;

DECLARE HPDataPresent INT default 0;
DECLARE VPDataPresent INT default 0;

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
		call debug(gm_proc_id, @full_error,'F','I');
        SET @details = CONCAT("Test id : ",gmTestId,",Frequency : ",gmFreq);
		call debug(gm_proc_id, @details,'I','I');
        
	end if;
	RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(gm_proc_id,'in pv_calc_Gain_Tracking','I','I');
 end if;
 
 
# Declarations -end


# --------------CALCULATIONS BEGIN ----------------------
select count(*) into HPDataPresent from pv_hdata_gt  where Prodserial_id = gmSerial and Frequency = gmFreq and Angle=0;
select count(*) into VPDataPresent from pv_vdata_gt  where Prodserial_id = gmSerial and Frequency = gmFreq and Angle=0;

# Gain tracking on axis
if HPDataPresent > 0 and VPDataPresent > 0 then
-- hp
select Amplitude into @Hamp_0 from pv_hdata_gt where Prodserial_id = gmSerial and Frequency = gmFreq
and Angle = 0 ;

-- vp
select Amplitude into @Vamp_0 from pv_vdata_gt where Prodserial_id = gmSerial and Frequency = gmFreq
and Angle = 0 ;

-- cp
select pv_calc_cpdata(gmSerial, gmFreq, 0,@Hamp_0,@Vamp_0) into @CPamp_0; 

# Gain tracking at +45 degree

-- hp
select Amplitude into @Hamp_p45 from pv_hdata_gt where Prodserial_id = gmSerial  and Frequency = gmFreq
and Angle = 45;

-- vp
select Amplitude into @Vamp_p45 from pv_vdata_gt where Prodserial_id = gmSerial and Frequency = gmFreq
and Angle = 45 ;

-- cp
select pv_calc_cpdata(gmSerial, gmFreq, 45,@Hamp_p45,@Vamp_p45) into @CPamp_p45; 

# Gain tracking at -45 degree

-- hp
select Amplitude into @Hamp_m45 from pv_hdata_gt where Prodserial_id = gmSerial and Frequency = gmFreq
and Angle = 315 ;

-- vp
select Amplitude into @Vamp_m45 from pv_vdata_gt where Prodserial_id = gmSerial and Frequency = gmFreq
and Angle = 315;

-- cp
select pv_calc_cpdata(gmSerial, gmFreq, 315, @Hamp_m45, @Vamp_m45) into @CPamp_m45; 

-- store into intermediate table
delete from pv_gt_intermediate where Prodserial_id= gmSerial and Test_id = gmTestId and Frequency =gmFreq;
insert into pv_gt_intermediate (Prodserial_id, Frequency, TestDate,
								HP_0,VP_0,CP_0,
                                HP_P45,VP_P45,CP_P45,
                                HP_M45,VP_M45,CP_M45,
                                Test_id)
						VALUES (gmSerial, gmFreq, gmTestDate, 
										@Hamp_0, @Vamp_0, @CPamp_0,
                                        @Hamp_P45, @Vamp_P45, @CPamp_P45,
                                        @Hamp_M45, @Vamp_M45, @CPamp_M45,
                                        gmTestId);

# --------------- CALCULATIONS END ------------------------
else

	call debug(gm_proc_id,'all required raw data not imported','E','I');
end if;
 
END$$

DELIMITER ;



-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE  PROCEDURE spPV_Axial(
testid INT,
vdatatype varchar(5), -- Elevation
deg varchar(10), -- 0,BM
serialid INT,
prec int

)
BEGIN


# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'spPV_Axial';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;


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
        SET @details = CONCAT("Test id : ", testid, ", deg : ",deg, ", typ : ",typ,",serialid : ",serialid);
		call debug(l_proc_id, @details,'I','I');
        
         RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
	end if;
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in spPV_Axial','I','I');
 end if;


-- select nprecision into prec from fwk_company;

 select frequnit into @unt from pv_testdata where test_id=testid;

  select case @unt when 'GHz' then frequency/1000 else frequency end frequency, 
   round( case deg when '0' then VP_0 when 'P45' then VP_P45 else VP_M45 end,prec) VP_A,
   round( case deg when '0' then HP_0 when 'P45' then HP_P45 else HP_M45 end,prec) VP_B,
   round( case deg when '0' then AR_0 when 'P45' then AR_P45 else AR_M45 end,prec) AR, '' remark
   from pv_arcalculated where prodserial_id=serialid and datatype=vdatatype ;



END$$
DELIMITER ;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE  PROCEDURE spPV_BSBL(
testid INT,
vdatatype varchar(5), -- Azimuth,Elevation
deg varchar(10), -- 0,BM
serialid INT,
prec int

)
BEGIN


# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'spPV_BSBL';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;


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
        SET @details = CONCAT("Test id : ", testid, ", deg : ",deg, ", typ : ",typ,",serialid : ",serialid);
		call debug(l_proc_id, @details,'I','I');
        
         RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
	end if;
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in spPV_BSBL','I','I');
 end if;


-- select nprecision into prec from fwk_company;

 select frequnit into @unt from pv_testdata where test_id=testid;
  select case @unt when 'GHz' then frequency/1000 else frequency end frequency, 
   round( case deg when '0' then 3Db_BW_0_left else 3Db_BW_BMax_left end,prec) ldbpoint,
    round(case deg when '0' then 3Db_BW_0_right else 3Db_BW_BMax_right end,prec) rdbpoint ,
    round(case deg when '0' then 3Db_BS_0 else 3Db_BS_BMax end,prec) BS ,
    round(X1,prec) X1, round(Y1,prec) Y1, round(Backlobe,prec) Backlobe, '' remark
    from pv_cpcalculated where prodserial_id=serialid and datatype=vdatatype ;



END$$
DELIMITER ;


-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE  PROCEDURE spPV_DB(
testid INT,
typ varchar(5), -- 3,10 db
vdatatype varchar(5), -- Azimuth,Elevation
deg varchar(10), -- 0,BM
serialid INT,
prec int

)
BEGIN


# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'spPV_DB';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;


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
        SET @details = CONCAT("Test id : ", testid, ", deg : ",deg, ", typ : ",typ,",serialid : ",serialid);
		call debug(l_proc_id, @details,'I','I');
        
         RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
	end if;
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in spPV_DB','I','I');
 end if;


-- select nprecision into prec from fwk_company;

 select frequnit into @unt from pv_testdata where test_id=testid;


if typ='3' then

	select case @unt when 'GHz' then frequency/1000 else frequency end frequency, 
    round(case deg when '0' then 3Db_BW_0_left else 3Db_BW_BMax_left end,prec) ldbpoint,
    round(case deg when '0' then 3Db_BW_0_right else 3Db_BW_BMax_right end,prec) rdbpoint ,
    round(case deg when '0' then 3Db_BW_0 else 3Db_BW_BMax end,prec) cp,'' remarks 
    from pv_cpcalculated where prodserial_id=serialid and datatype=vdatatype ;
end if;
if typ='10' then
	select case @unt when 'GHz' then frequency/1000 else frequency end frequency, 
    round(case deg when '0' then 10Db_BW_0_left else 10Db_BW_BMax_left end,prec) ldbpoint,
    round(case deg when '0' then 10Db_BW_0_right else 10Db_BW_BMax_right end,prec) rdbpoint ,
    round(case deg when '0' then 10Db_BW_0 else 10Db_BW_BMax end,prec) cp,'' remarks
    from pv_cpcalculated where prodserial_id=serialid and datatype=vdatatype ;
end if;


END$$
DELIMITER ;



-- drop procedure if exists spPV_DB_sum;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE  PROCEDURE spPV_DB_sum(
testid INT,
typ varchar(5), -- 3,10 
vdatatype varchar(5), -- A,E
deg varchar(10), -- 0,BM
serialid INT,
prec int

)
BEGIN


# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'spPV_DB_sum';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;


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
        SET @details = CONCAT("Test id : ", testid, ", deg : ",deg, ", typ : ",typ,",serialid : ",serialid);
		call debug(l_proc_id, @details,'I','I');
        
         RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
	end if;
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in spPV_DB_sum','I','I');
 end if;


-- select nprecision into prec from fwk_company;

 select frequnit into @unt from pv_testdata where test_id=testid;


if typ='3' then

	select  
    round(case deg when '0' then 3dbBW_0_spec else 3dbBW_BM_spec end,prec) majorspec,
    '' minorspec, '' remarks 
    from pv_speccalculated where prodserial_id=serialid and datatype=vdatatype ;
end if;
if typ='10' then
	select  
    round(case deg when '0' then 10dbBW_0_majorspec else 10dbBW_BM_majorspec end,prec) majorspec,
    round(case deg when '0' then 10dbBW_0_minorspec else 10dbBW_BM_minorspec end,prec) minorspec ,
    '' remarks
    from pv_speccalculated where prodserial_id=serialid and datatype=vdatatype ;
end if;
if typ='BSBL' then
	select  
    round(case deg when '0' then 3dbBS_0_majorspec else 3dbBS_BM_majorspec end,prec) majorspec,
    round(case deg when '0' then 3dbBS_0_minorspec else 3dbBS_BM_minorspec end,prec) minorspec ,
    '' remarks
    from pv_speccalculated where prodserial_id=serialid and datatype=vdatatype ;
end if;

END$$

DELIMITER;

DELIMITER $$

CREATE PROCEDURE `pv_calc_combination`(
coTestId INT,
coFreq decimal(40,20),
coTestDate datetime,
coSerial INT
)
BEGIN

# Declarations -begin

declare _3dbBW_BM_Azimuth,_3dbBW_BM_Azimuth_left, _3dbBW_BM_Azimuth_right, _3dbBS_BM_Azimuth decimal(40,20) ;
declare _3dbBW_BM_Elevation,_3dbBW_BM_Elevation_left, _3dbBW_BM_Elevation_right, _3dbBS_BM_Elevation decimal(40,20) ;
declare _3dbBW_0_Azimuth,_3dbBW_0_Azimuth_left, _3dbBW_0_Azimuth_right, _3dbBS_0_Azimuth decimal(40,20) ;
declare _3dbBW_0_Elevation,_3dbBW_0_Elevation_left, _3dbBW_0_Elevation_right, _3dbBS_0_Elevation decimal(40,20) ;

declare _10dbBW_BM_Azimuth,_10dbBW_BM_Azimuth_left, _10dbBW_BM_Azimuth_right decimal(40,20) ;
declare _10dbBW_BM_Elevation,_10dbBW_BM_Elevation_left, _10dbBW_BM_Elevation_right decimal(40,20) ;
declare _10dbBW_0_Azimuth,_10dbBW_0_Azimuth_left, _10dbBW_0_Azimuth_right decimal(40,20) ;
declare _10dbBW_0_Elevation,_10dbBW_0_Elevation_left, _10dbBW_0_Elevation_right decimal(40,20);

declare dummyBS decimal(40,20) default 0;

declare X1_Azimuth, Y1_Azimuth, Backlobe_Azimuth decimal(40,20) ;
declare X1_Elevation, Y1_Elevation, Backlobe_Elevation decimal(40,20) ;

declare hp_0,vp_0,AR_0 decimal(40,20);
declare hp_p45,vp_p45,AR_P45 decimal(40,20);
declare hp_m45,vp_m45,AR_M45 decimal(40,20) ;

DECLARE azimuthHPDataPresent INT default 0;
DECLARE azimuthVPDataPresent INT default 0;

DECLARE elevationHPDataPresent INT default 0;
DECLARE elevationVPDataPresent INT default 0;

# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare co_proc_id varchar(100) default 'pv_calc_combination';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;

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
		call debug(co_proc_id, @full_error,'F','I');
        SET @details = CONCAT("Test id : ",coTestId,",Frequency : ",coFreq);
		call debug(co_proc_id, @details,'I','I');
        
	end if;
	RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(co_proc_id,'in pv_calc_Combination','I','I');
 end if;
 
 
# Declarations -end

# --------------CALCULATIONS BEGIN ----------------------

select count(*) into azimuthHPDataPresent from pv_hdata_azimuth  where Prodserial_id = coSerial and Frequency = coFreq and Angle=0;
select count(*) into azimuthVPDataPresent from pv_vdata_azimuth  where Prodserial_id = coSerial and Frequency = coFreq and Angle=0;

select count(*) into elevationHPDataPresent from pv_hdata_elevation  where Prodserial_id = coSerial and Frequency = coFreq and Angle=0;
select count(*) into elevationVPDataPresent from pv_vdata_elevation  where Prodserial_id = coSerial and Frequency = coFreq and Angle=0;

# convert to cp and store in cpdata table
if azimuthHPDataPresent > 0 and azimuthVPDataPresent then
	 delete from pv_cpdata_azimuth where Prodserial_id = coSerial and Frequency = coFreq;

	 insert into pv_cpdata_azimuth ( Prodserial_id, Frequency, Angle, Amplitude)
	 select Prodserial_id, Frequency, Angle, pv_calc_cpdata_combi(Prodserial_id, Frequency, Angle,'A')
	 from pv_hdata_azimuth  
	 where Prodserial_id = coSerial and Frequency = coFreq;
     
   #Beamwidth, Beamsquint  
     -- 3 db BW and BS from Bmax Azimuth
 call pv_calc_XdB_BW_BS(coSerial,coFreq,3,'CP','BM','A',_3dbBW_BM_Azimuth_left,_3dbBW_BM_Azimuth_right, _3dbBW_BM_Azimuth, _3dbBS_BM_Azimuth);
 -- 3 db BW and BS from 0 Azimuth
call pv_calc_XdB_BW_BS(coSerial,coFreq,3,'CP','0','A',_3dbBW_0_Azimuth_left,_3dbBW_0_Azimuth_right, _3dbBW_0_Azimuth, _3dbBS_0_Azimuth);
-- 10 db BW and BS from Bmax Azimuth
call pv_calc_XdB_BW_BS(coSerial,coFreq,10,'CP','BM','A',_10dbBW_BM_Azimuth_left,_10dbBW_BM_Azimuth_right, _10dbBW_BM_Azimuth, dummyBS);
-- 10 db BW and BS from 0 Azimuth
call pv_calc_XdB_BW_BS(coSerial,coFreq,10,'CP','0','A',_10dbBW_0_Azimuth_left,_10dbBW_0_Azimuth_right, _10dbBW_0_Azimuth, dummyBS);
# Backlobe
 call pv_calc_backlobelevel(coSerial, coFreq, 'CP','A', X1_Azimuth, Y1_Azimuth, Backlobe_Azimuth);

-- insert into calculated table
-- azimuth
delete from pv_cpcalculated where Prodserial_id = coSerial and Test_id = coTestId and  datatype ='A' and Frequency = coFreq;
insert into pv_cpcalculated ( Prodserial_id,Test_id,datatype,Frequency,TestDate,
						3Db_BW_BMax_left,3Db_BW_BMax_right,3Db_BW_BMax,3Db_BS_BMax,
						3Db_BW_0_left,3Db_BW_0_right,3Db_BW_0,3Db_BS_0,
						10Db_BW_BMax_left,10Db_BW_BMax_right,10Db_BW_BMax,
						10Db_BW_0_left,10Db_BW_0_right,10Db_BW_0,
						X1,Y1,Backlobe)
			values
							(coSerial, coTestId, 'A',coFreq, coTestDate,
                            _3dbBW_BM_Azimuth_left, _3dbBW_BM_Azimuth_right, _3dbBW_BM_Azimuth, _3dbBS_BM_Azimuth,
                            _3dbBW_0_Azimuth_left, _3dbBW_0_Azimuth_right, _3dbBW_0_Azimuth, _3dbBS_0_Azimuth,
                            _10dbBW_BM_Azimuth_left, _10dbBW_BM_Azimuth_right, _10dbBW_BM_Azimuth, 
                            _10dbBW_0_Azimuth_left, _10dbBW_0_Azimuth_right, _10dbBW_0_Azimuth, 
                            X1_Azimuth,Y1_Azimuth,Backlobe_Azimuth
                            );

end if; 

if elevationHPDataPresent > 0 and elevationVPDataPresent > 0 then
  delete from pv_cpdata_elevation where Prodserial_id = coSerial and Frequency = coFreq;

  insert into pv_cpdata_elevation ( Prodserial_id, Frequency, Angle, Amplitude)
	select Prodserial_id, Frequency, Angle, pv_calc_cpdata_combi(Prodserial_id, Frequency, Angle,'E')
  from pv_hdata_elevation  
	where Prodserial_id = coSerial and Frequency = coFreq;
    
    
    #Beamwidth, Beamsquint
-- set _3dbBW_BM_Azimuth_left =0,_3dbBW_BM_Azimuth_right=0,_3dbBW_BM_Azimuth=0,_3dbBS_BM_Azimuth=0;

-- 3 db BW and BS from Bmax Elevation
call pv_calc_XdB_BW_BS(coSerial,coFreq,3,'CP','BM','E',_3dbBW_BM_Elevation_left,_3dbBW_BM_Elevation_right, _3dbBW_BM_Elevation, _3dbBS_BM_Elevation);
-- 3 db BW and BS from 0 Elevation
call pv_calc_XdB_BW_BS(coSerial,coFreq,3,'CP','0','E',_3dbBW_0_Elevation_left,_3dbBW_0_Elevation_right, _3dbBW_0_Elevation, _3dbBS_0_Elevation);

-- 10 db BW and BS from Bmax Elevation
call pv_calc_XdB_BW_BS(coSerial,coFreq,10,'CP','BM','E',_10dbBW_BM_Elevation_left,_10dbBW_BM_Elevation_right, _10dbBW_BM_Elevation, dummyBS);
-- 10 db BW and BS from 0 Elevation
call pv_calc_XdB_BW_BS(coSerial,coFreq,10,'CP','0','E',_10dbBW_0_Elevation_left,_10dbBW_0_Elevation_right, _10dbBW_0_Elevation, dummyBS);

 call pv_calc_backlobelevel(coSerial, coFreq, 'CP','E', X1_Elevation, Y1_Elevation, Backlobe_Elevation);

# Axial Ratio
-- on axis
select Amplitude into vp_0 
from pv_vdata_elevation 
where Prodserial_id = coSerial and Frequency = coFreq and Angle = 0 ;

select Amplitude into hp_0 
from pv_hdata_elevation 
where Prodserial_id = coSerial and Frequency = coFreq and Angle = 0 ;

set AR_0 = hp_0 - vp_0;

-- at +45 degree
select Amplitude into vp_P45 from pv_vdata_elevation 
where Prodserial_id = coSerial and Frequency = coFreq and Angle = 45 ;

select Amplitude into hp_P45 from pv_hdata_elevation 
where Prodserial_id = coSerial and Frequency = coFreq and Angle = 45 ;

set AR_P45 = hp_P45 - vp_P45;

-- at -45 degree
select Amplitude into vp_M45 from pv_vdata_elevation 
where Prodserial_id = coSerial and Frequency = coFreq and Angle = 315 ;

select Amplitude into hp_M45 from pv_hdata_elevation 
where Prodserial_id = coSerial and Frequency = coFreq and Angle = 315 ;

set AR_M45 = hp_M45 - vp_M45;

-- elevation
delete from pv_cpcalculated where Prodserial_id = coSerial and Test_id = coTestId and  datatype ='E' and Frequency = coFreq;

insert into pv_cpcalculated ( Prodserial_id,Test_id,datatype,Frequency,TestDate,
						3Db_BW_BMax_left,3Db_BW_BMax_right,3Db_BW_BMax,3Db_BS_BMax,
						3Db_BW_0_left,3Db_BW_0_right,3Db_BW_0,3Db_BS_0,
						10Db_BW_BMax_left,10Db_BW_BMax_right,10Db_BW_BMax,
						10Db_BW_0_left,10Db_BW_0_right,10Db_BW_0,
						X1,Y1,Backlobe)
			values
							(coSerial, coTestId, 'E',coFreq, coTestDate,
                            _3dbBW_BM_Elevation_left, _3dbBW_BM_Elevation_right, _3dbBW_BM_Elevation, _3dbBS_BM_Elevation,
                            _3dbBW_0_Elevation_left, _3dbBW_0_Elevation_right, _3dbBW_0_Elevation, _3dbBS_0_Elevation,
                            _10dbBW_BM_Elevation_left, _10dbBW_BM_Elevation_right, _10dbBW_BM_Elevation, 
                            _10dbBW_0_Elevation_left, _10dbBW_0_Elevation_right, _10dbBW_0_Elevation, 
                            X1_Elevation,Y1_Elevation,Backlobe_Elevation
                            );

-- axial ratio
delete from pv_arcalculated where Prodserial_id = coSerial 
and Test_id = coTestId and  Frequency = coFreq;

	insert into pv_arcalculated( Prodserial_id,Test_id,datatype,Frequency,TestDate,
    VP_0, HP_0, AR_0 ,
	VP_P45, HP_P45 ,AR_P45,
	VP_M45, HP_M45, AR_M45)
    values
    (coSerial,coTestId, 'E',  coFreq,coTestDate,
     vp_0,hp_0, AR_0,
     vp_P45, hp_P45, AR_P45,
     vp_M45, hp_M45, AR_M45);
     
end if;



# --------------CALCULATIONS END ----------------------


  
END$$

DELIMITER;

DELIMITER $$

CREATE PROCEDURE `pv_calc_backlobelevel`(
bProdserialId INT, bFreq decimal(40,20), bPolType char(2),bDatatype char(2),
out X1 decimal(40,20), out Y1 decimal(40,20), out backlobe decimal(40,20)
)
BEGIN

# A = Amplitude at 0 degree 
# B = Amplitude at 180 degree 
# Back Lobe = B - A

if bDatatype = 'A' then
	set X1 = (select Amplitude 
				from pv_cpdata_azimuth 
				where Prodserial_id = bProdserialId and Frequency = bFreq and Angle = 0 );
	set Y1 =(select Amplitude 
					from pv_cpdata_azimuth 
					where Prodserial_id = bProdserialId and Frequency = bFreq and Angle = 180 );
else

	set X1 = (select Amplitude 
				from pv_cpdata_elevation 
				where Prodserial_id = bProdserialId and Frequency = bFreq and Angle = 0 );
	set Y1 =(select Amplitude 
					from pv_cpdata_elevation 
					where Prodserial_id = bProdserialId and Frequency = bFreq and Angle = 180 );
end if;
set backlobe = Y1 - X1;



END$$

DELIMITER;

DELIMITER $$

CREATE PROCEDURE `pv_calc_XdB_BW_BS`(
xProdSerialId INT, freq decimal(40,20), X INT, polType char(2), fromAngle char(2), xdatatype char(2),
out leftpoint decimal(40,20), out rightpoint decimal(40,20), out beam_width decimal(40,20), out beam_squint decimal(40,20)
)
BEGIN



# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'pv_calc_XdB_BW_BS';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;

declare C,D,E,AminX,B_angle decimal(40,20);

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
        SET @details = CONCAT("ProdSerial id : ",xProdSerialId,",Frequency : ",freq,",X : ",X,", Type : ",polType,", fromAngle : ",fromAngle);
		call debug(l_proc_id, @details,'I','I');
        
	end if;
    RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in pv_calc_XdB_BW_BS','I','I');
 end if;

if xdatatype = 'A' then 
	if fromAngle = 'BM' then

		select MAX(amplitude) into @A from pv_cpdata_azimuth where Prodserial_id = xProdSerialId and Frequency = freq;  
	   
		select MAX(angle) into @B from pv_cpdata_azimuth where Prodserial_id = xProdSerialId and Frequency = freq and amplitude = @A;  
		 
	elseif fromAngle = '0' then
		select amplitude, angle into @A,@B from pv_cpdata_azimuth where Prodserial_id = xProdSerialId and Frequency = freq and angle = 0;  

	end if;
else
	if fromAngle = 'BM' then

		select MAX(amplitude) into @A from pv_cpdata_elevation where Prodserial_id = xProdSerialId and Frequency = freq;  
	   
		select MAX(angle) into @B from pv_cpdata_elevation where Prodserial_id = xProdSerialId and Frequency = freq and amplitude = @A;  
		 
	elseif fromAngle = '0' then
		select amplitude, angle into @A,@B from pv_cpdata_elevation where Prodserial_id = xProdSerialId and Frequency = freq and angle = 0;  

	end if;
end if;
    
-- A-X to the right
set AminX = @A-X;
  set B_angle = @B;
  set @p=0;
  set @j=0;
    -- select @A as 'A';
    -- select AminX as 'A-X';
	-- select @B;
 if xdatatype = 'A' then 
	 select amplitude,angle into @tempright,@p 
	 from pv_cpdata_azimuth 
	 where Prodserial_Id = xProdSerialId and Frequency = freq 
	and Angle >= 0 and Angle <= 180 
	and amplitude <= AminX
	group by amplitude
	order by Angle limit 1;
	 
   set rightpoint = @p;
   
	select amplitude,angle-360 into @templeft,@j
	 from pv_cpdata_azimuth 
	where Prodserial_Id = xProdSerialId and Frequency = freq 
	and Angle >= 180 and Angle <= 360 
	and amplitude <= AminX
	group by amplitude
	order by Angle desc limit 1;
	   
  
	set leftpoint = @j;
else

		select amplitude,angle into @tempright,@p 
		 from pv_cpdata_elevation 
		 where Prodserial_Id = xProdSerialId and Frequency = freq 
		and Angle >= 0 and Angle <= 180 
		and amplitude <= AminX
		group by amplitude
		order by Angle limit 1;
		 
		   set rightpoint = @p;
		   
		select amplitude,angle-360 into @templeft,@j
		 from pv_cpdata_elevation 
		where Prodserial_Id = xProdSerialId and Frequency = freq 
		and Angle >= 180 and Angle <= 360 
		and amplitude <= AminX
		group by amplitude
		order by Angle desc limit 1;
		   
		  
		set leftpoint = @j;

end if;
-- set E = 360-D;
-- select E as 'E';

set beam_width = rightpoint-leftpoint;

-- select beam_width as 'BW';


-- Beamsquint calculation

set beam_squint = leftpoint + (rightpoint - leftpoint)/2;

 -- select beam_squint as 'BS';

END$$

DELIMITER;

DELIMITER $$
CREATE PROCEDURE `pv_calc_spec`(
coTestId INT
)
BEGIN
# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare co_proc_id varchar(100) default 'pv_calc_spec';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;

DECLARE AzimuthDataPresent INT default 0;
DECLARE ElevationDataPresent INT default 0;


declare myserial int(11);
declare coTestDate datetime;

 -- for the cursor
DECLARE done INT DEFAULT 0;

 
 
 #declare cursor for serials
 DECLARE serialcur CURSOR FOR 
 select Prodserial_id 
 from pv_prodserial ps
 where ps.test_id = coTestId;

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
		call debug(co_proc_id, @full_error,'F','I');
        SET @details = CONCAT("Test id : ",coTestId);
		call debug(co_proc_id, @details,'I','I');
        
	end if;
	RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(co_proc_id,'in pv_calc_spec','I','I');
 end if;
 
 
# Declarations -end

select TestDate into coTestDate 
from pv_testdata where Test_id = coTestId;

#open cursor
  OPEN serialcur;
  
  #starts the loop
  the_loop: LOOP
  
 FETCH serialcur INTO myserial; 
IF done = 1 THEN
	if isDebug > 0 then
		SET @infoText = "Done looping through serials";
		call debug(co_proc_id,@infoText,'I','I');
	end if;
LEAVE the_loop;
END IF;


# --------------CALCULATIONS BEGIN ----------------------

select count(*) into AzimuthDataPresent from pv_cpcalculated  
where Prodserial_id = myserial and datatype = 'A';

select count(*) into ElevationDataPresent from pv_cpcalculated  
where Prodserial_id = myserial and datatype = 'E';

if AzimuthDataPresent > 0 then
		-- 3 db BW
		select count(*) into @_3dbBW_BM_A_spec
		from pv_cpcalculated 
		where 3Db_BW_BMax >= 55 and 3Db_BW_BMax <= 110
		and Prodserial_id = myserial and datatype = 'A';

		select count(*) into @_3dbBW_0_A_spec
		from pv_cpcalculated 
		where 3Db_BW_0 >= 55 and 3Db_BW_0 <= 110
		and Prodserial_id = myserial and datatype = 'A';

		-- 10 db BW
		select count(*) into @_10dbBW_BM_A_majorspec
		from pv_cpcalculated 
		where 10Db_BW_BMax >= 100 and 10Db_BW_BMax <= 220
		and Prodserial_id = myserial and datatype = 'A';

		select count(*) into @_10dbBW_BM_A_minorspec
		from pv_cpcalculated 
		where 10Db_BW_BMax >= 110 and 10Db_BW_BMax <= 200
		and Prodserial_id = myserial and datatype = 'A';

		select count(*) into @_10dbBW_0_A_majorspec
		from pv_cpcalculated 
		where 10Db_BW_0 >= 100 and 10Db_BW_0 <= 220
		and Prodserial_id = myserial and datatype = 'A';

		select count(*) into @_10dbBW_0_A_minorspec
		from pv_cpcalculated 
		where 10Db_BW_0 >= 110 and 10Db_BW_0 <= 200
		and Prodserial_id = myserial and datatype = 'A';

		-- BS

		select count(*) into @_BS_BM_A_majorspec
		from pv_cpcalculated 
		where 3Db_BS_BMax <= 10
		and Prodserial_id = myserial and datatype = 'A';


		select count(*) into @_BS_BM_A_minorspec
		from pv_cpcalculated 
		where 3Db_BS_BMax <= 6
		and Prodserial_id = myserial and datatype = 'A';

		select count(*) into @_BS_0_A_majorspec
		from pv_cpcalculated 
		where 3Db_BS_0 <= 10
		and Prodserial_id = myserial and datatype = 'A';


		select count(*) into @_BS_0_A_minorspec
		from pv_cpcalculated 
		where 3Db_BS_0 <= 6
		and Prodserial_id = myserial and datatype = 'A';

		-- insert into calculated table
		-- azimuth

		delete from pv_speccalculated where Prodserial_Id = myserial and datatype = 'A';

		 insert into pv_speccalculated(Prodserial_id,Test_id,datatype,TestDate,
		  3dbBW_BM_spec,3dbBW_0_spec,
		  10dbBW_BM_majorspec ,10dbBW_BM_minorspec,
		  10dbBW_0_majorspec, 10dbBW_0_minorspec, 
		  3dbBS_BM_majorspec , 3dbBS_BM_minorspec,
		  3dbBS_0_majorspec ,3dbBS_0_minorspec )
		  values
		  (myserial,coTestId,'A',coTestDate,
		  @_3dbBW_BM_A_spec,@_3dbBW_0_A_spec,
		  @_10dbBW_BM_A_majorspec, @_10dbBW_BM_A_minorspec,
		   @_10dbBW_0_A_majorspec, @_10dbBW_0_A_minorspec,
		   @_BS_BM_A_majorspec,@_BS_BM_A_minorspec,
		   @_BS_0_A_majorspec,@_BS_0_A_minorspec);

end if;

if ElevationDataPresent > 0 then 
		select count(*) into @_3dbBW_BM_E_spec
		from pv_cpcalculated 
		where 3Db_BW_BMax >= 55 and 3Db_BW_BMax <= 110
		and Prodserial_id = myserial and datatype = 'E';

		select count(*) into @_3dbBW_0_E_spec
		from pv_cpcalculated 
		where 3Db_BW_0 >= 55 and 3Db_BW_0 <= 110
		and Prodserial_id = myserial and datatype = 'E';


		select count(*) into @_10dbBW_BM_E_majorspec
		from pv_cpcalculated 
		where 10Db_BW_BMax >= 100 and 10Db_BW_BMax <= 220
		and Prodserial_id = myserial and datatype = 'E';

		select count(*) into @_10dbBW_BM_E_minorspec
		from pv_cpcalculated 
		where 10Db_BW_BMax >= 110 and 10Db_BW_BMax <= 200
		and Prodserial_id = myserial and datatype = 'E';

		select count(*) into @_10dbBW_0_E_majorspec
		from pv_cpcalculated 
		where 10Db_BW_0 >= 100 and 10Db_BW_0 <= 220
		and Prodserial_id = myserial and datatype = 'E';

		select count(*) into @_10dbBW_0_E_minorspec
		from pv_cpcalculated 
		where 10Db_BW_0 >= 110 and 10Db_BW_0 <= 200
		and Prodserial_id = myserial and datatype = 'E';

		select count(*) into @_BS_BM_E_majorspec
		from pv_cpcalculated 
		where 3Db_BS_BMax <= 10
		and Prodserial_id = myserial and datatype = 'E';


		select count(*) into @_BS_BM_E_minorspec
		from pv_cpcalculated 
		where 3Db_BS_BMax <= 6
		and Prodserial_id = myserial and datatype = 'E';
		 
		select count(*) into @_BS_0_E_majorspec
		from pv_cpcalculated 
		where 3Db_BS_0 <= 10
		and Prodserial_id = myserial and datatype = 'E';


		select count(*) into @_BS_0_E_minorspec
		from pv_cpcalculated 
		where 3Db_BS_0 <= 6
		and Prodserial_id = myserial and datatype = 'E';

		# --------------CALCULATIONS END ----------------------

		delete from pv_speccalculated where Prodserial_Id = myserial and datatype = 'E';
		  
		-- elevation
		 insert into pv_speccalculated(Prodserial_id,Test_id,datatype,TestDate,
		  3dbBW_BM_spec,3dbBW_0_spec,
		  10dbBW_BM_majorspec ,10dbBW_BM_minorspec,
		  10dbBW_0_majorspec, 10dbBW_0_minorspec, 
		  3dbBS_BM_majorspec , 3dbBS_BM_minorspec,
		  3dbBS_0_majorspec ,3dbBS_0_minorspec )
		  values
		  (myserial,coTestId,'E',coTestDate,
		  @_3dbBW_BM_E_spec,@_3dbBW_0_E_spec,
		  @_10dbBW_BM_E_majorspec, @_10dbBW_BM_E_minorspec,
		   @_10dbBW_0_E_majorspec, @_10dbBW_0_E_minorspec,
		   @_BS_BM_E_majorspec,@_BS_BM_E_minorspec,
		   @_BS_0_E_majorspec,@_BS_0_E_minorspec);
end if;
   
 END LOOP the_loop;
 
  CLOSE serialcur;

END$$

DELIMITER;

DELIMITER $$
CREATE FUNCTION `pv_calc_cpdata_combi`(
cProdSerialId INT, freq decimal(40,20), cAngle decimal(40,20), cDatatype char(2)
) RETURNS decimal(40,20)
BEGIN

declare A,B,C,D,E,cpdata decimal(40,20) default 0;
if cDatatype = 'A' then
	 select Amplitude into A from pv_hdata_azimuth h
		 where h.Prodserial_id = cProdSerialId and h.Frequency = freq and h.Angle = cAngle ;
	-- select A;
	 select Amplitude into B from pv_vdata_azimuth v
			 where v.Prodserial_id = cProdSerialId and v.Frequency = freq and v.Angle = cAngle ;
	-- select B;
else
		select Amplitude into A from pv_hdata_elevation h
			 where h.Prodserial_id = cProdSerialId and h.Frequency = freq and h.Angle = cAngle ;
		-- select A;
		 select Amplitude into B from pv_vdata_elevation v
				 where v.Prodserial_id = cProdSerialId and v.Frequency = freq and v.Angle = cAngle ;
		-- select B;
end if;

set C = ABS( A - B );

-- select C;

set D = EXP(C/20);
-- select D;

set E = 20 * LOG10((D+1)/(1.414*D));
-- select E;

if A > B then
	set cpdata = A+E;
else 
	set cpdata = B+E;
end if;

-- select cpdata;    
    
RETURN cpdata;
END$$

DELIMITER;

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE  PROCEDURE spPV_GT(
testid INT,
deg varchar(10), -- 0,P45,M45
prec int

)
BEGIN


# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'spPV_GT';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;


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

DECLARE v_finished INTEGER DEFAULT 0;
Declare v_freq decimal(40,20);
Declare v_serialid int;
Declare v_prevfreq decimal(40,20);
Declare v_prevserialid int;
Declare v_id int default 0;
Declare v_insertsql varchar(2000) default '';
Declare v_valsql  varchar(2000) default '';
Declare v_hp decimal(40,4);
Declare v_vp decimal(40,4);
Declare v_cp decimal(40,4);

DECLARE C1 CURSOR FOR select distinct frequency,prodserial_id from pv_gt_intermediate 
where test_id=testid order by frequency,prodserial_id;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;
DECLARE EXIT HANDLER FOR SQLEXCEPTION 
 

begin
	if isDebug > 0 then
		GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
		@errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
		SET @full_error = CONCAT("SQLException ", @errno, " (", @sqlstate, "): ", @text);
		call debug(l_proc_id, @full_error,'F','I');
        SET @details = CONCAT("Test id : ", testid, ", deg : ",deg, ", prec : ",prec);
		call debug(l_proc_id, @details,'I','I');
        
         RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
	end if;
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in spPV_GT','I','I');
 end if;


-- select nprecision into prec from fwk_company;

 select frequnit into @unt from pv_testdata where test_id=testid;
 truncate table temp_GT;
 /* insert into temp_GT(frequency,V1,H1,C1,V2,H2,C2,V3,H3,C3,V4,H4,C4,V4,H5,C5,V6,H6,C6,V7,H7,C7,V8,H8,C8,V9,H9,C9,V10,H10,C10
,V11,H11,C11,V12,H12,C12,V13,H13,C13,V14,H14,C14,V14,H15,C15,V16,H16,C16,V17,H17,C17,V18,H18,C18,V19,H19,C19,V20,H20,C20
,V21,H21,C21,V22,H22,C22,V23,H23,C23,V24,H24,C24,V24,H25,C25,V26,H26,C26,V27,H27,C27,V28,H28,C28,V29,H29,C29,V30,H30,C30
calc_Linear_Elevation,V31,H31,C31,V32,H32,C32,V33,H33,C33,V34,H34,C34,V34,H35,C35,V36,H36,C36,V37,H37,C37,V38,H38,C38,V39,H39,C39,V40,H40,C40
,V41,H41,C41,V42,H42,C42,V43,H43,C43,V44,H44,C44,V44,H45,C45,V46,H46,C46,V47,H47,C47,V48,H48,C48,V49,H49,C49,V50,H50,C50)
*/
set v_id=0;
set v_insertsql='';
set v_valsql='';
set v_prevfreq=-1;


			OPEN C1;
			 
				getlist: LOOP
				 
				 FETCH C1 INTO v_freq,v_serialid;
				 
				IF v_finished = 1 THEN
				  LEAVE getlist;
				END IF;
                if v_prevfreq=-1 then
				  set v_prevfreq=v_freq;
                end if;
                if v_prevfreq<>v_freq then
                 -- select concat(v_freq,' ',v_prevfreq);
                 
					set v_insertsql =concat('insert into temp_GT (frequency',v_insertsql,')');
					set v_valsql=concat('values(',round(v_prevfreq,prec), v_valsql,')');

					 -- select v_insertsql;
					 -- select  v_valsql;

                	set	@sql1= concat(v_insertsql,v_valsql);
					PREPARE stmt1 FROM @sql1; 
					EXECUTE stmt1; 
					DEALLOCATE PREPARE stmt1;
				set v_id=0;
				set v_insertsql='';
				set v_valsql='';
                end if;


					select round(case deg when '0' then HP_0 when 'P45' then HP_P45 else HP_M45 end,prec),
					 round(case deg when '0' then VP_0 when 'P45' then VP_P45 else VP_M45 end,prec),
					 round(case deg when '0' then CP_0 when 'P45' then CP_P45 else CP_M45 end,prec)
					into v_hp,v_vp,v_cp  from pv_gt_intermediate a where Prodserial_id=v_serialid and frequency=v_freq;
					

					if v_hp is null then
					set v_hp=0;
					end if;
					if v_vp is null then
					set v_vp=0;
					end if;
					if v_cp is null then
					set v_cp=0;
					end if;

                    set v_id=v_id+1;
					set v_insertsql=concat(v_insertsql,',','V',v_id,',','H',v_id,',','C',v_id);
					set v_valsql=concat(v_valsql,',',v_hp,',',v_vp,',',v_cp);
                     
					set v_prevfreq=v_freq;
					

				END LOOP getlist;
			 
			CLOSE C1;

                    set v_insertsql =concat('insert into temp_GT (frequency',v_insertsql,')');
					set v_valsql=concat('values(',round(v_prevfreq,prec), v_valsql,')');

					  -- select v_insertsql;
					  -- select  v_valsql;

                	set	@sql1= concat(v_insertsql,v_valsql);
					PREPARE stmt1 FROM @sql1; 
					EXECUTE stmt1; 
					DEALLOCATE PREPARE stmt1;


if deg='0' then
	select a.*,round(MAX_CP_0,prec) MAXCP,round(MIN_CP_0,prec) MINCP,round(Window_0,prec) WINDOW from temp_GT a left join pv_gt_calculated b on a.Frequency=b.Frequency 
	where Test_id=testid ;
END if;
 if deg='P45' then
	select a.*,round(MAX_CP_P45,prec) MAXCP,round(MIN_CP_P45,prec) MINCP,round(Window_P45,prec) WINDOW from temp_GT a left join pv_gt_calculated b on a.Frequency=b.Frequency 
	where Test_id=testid ;
else 
	select a.*,round(MAX_CP_M45,prec) MAXCP,round(MIN_CP_M45,prec) MINCP,round(Window_M45,prec) WINDOW from temp_GT a left join pv_gt_calculated b on a.Frequency=b.Frequency 
	where Test_id=testid ;
end if;

END$$
DELIMITER;

DELIMITER $$

CREATE PROCEDURE `pv_calc_gtcalculated`(
gtTestId INT)
BEGIN
DECLARE gtDataPresent INT default 0;

# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare co_proc_id varchar(100) default 'pv_calc_gtcalculated';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;
    
     DECLARE EXIT HANDLER FOR SQLEXCEPTION 
 begin
	if isDebug > 0 then
		GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
		@errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
		SET @full_error = CONCAT("SQLException ", @errno, " (", @sqlstate, "): ", @text);
		call debug(co_proc_id, @full_error,'F','I');
        SET @details = CONCAT("Test id : ",gtTestId);
		call debug(co_proc_id, @details,'I','I');
        
	end if;
	RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(co_proc_id,'in pv_calc_gtcalculated','I','I');
 end if;
 
 
# Declarations -end
select count(*) into gtDataPresent from pv_gt_intermediate where Test_id = gtTestId; 

if gtDataPresent > 0 then
delete from pv_gt_calculated where Test_id = gtTestId;
	  insert into pv_gt_calculated (Test_id,Frequency,TestDate, 
									MAX_CP_0,MIN_CP_0,Window_0,
									MAX_CP_P45,MIN_CP_P45,Window_P45,
									MAX_CP_M45,MIN_CP_M45,Window_M45
									)
		select Test_id,Frequency,TestDate, 
									MAX(CP_0),MIN(CP_0),MAX(CP_0) - MIN(CP_0),
									MAX(CP_P45),MIN(CP_P45),MAX(CP_P45) - MIN(CP_P45),
									MAX(CP_M45),MIN(CP_M45),MAX(CP_M45) - MIN(CP_M45)
							from pv_gt_intermediate
							where Test_id = gtTestId 
							group by Frequency,Test_id,TestDate;
 
 end if;  
END$$

DELIMITER;









