drop procedure if exists spPVPolarPlot;
drop procedure if exists spPVPolarSummary;
drop procedure if exists pv_calc_Gain_Tracking;
drop procedure if exists pv_Calculate_params;
drop procedure if exists pv_calc_AxialRatio;
drop procedure if exists pv_calc_Gain_Measurement;
drop procedure if exists pv_calc_cpdata;

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
END$$

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

-- HP
select Amplitude into @hp from pv_hdata where Prodserial_id = cProdSerialId and datatype = cdatatype and Frequency = freq
and Angle = degree ;
-- VP
select Amplitude into @vp from pv_vdata where Prodserial_id = cProdSerialId and datatype = cdatatype and Frequency = freq
and Angle = degree ;

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
myPoltype char(2) -- 'L'=linear, 'C'= circular
)
BEGIN

# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'pv_Calculate_params';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;

declare myfreq,myserial decimal(40,20);
declare myTestDate datetime;
DECLARE myTestType char(4);

 -- for the cursor
DECLARE done INT DEFAULT 0;

 DECLARE freqcur CURSOR FOR
 select Frequency,p.Prodserial_Id -- , lineargain
 from pv_testfreq t
 inner join pv_prodserial p on p.Test_id = t.Test_id
 where t.Test_id = myTestId
 order by p.Prodserial_Id, Frequency;
 

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
    delete from pv_gt_intermediate where Test_id = myTestId;
    delete from pv_gt_calculated where Test_id = myTestId;
	delete from pv_gmcalculated where test_id = myTestId;
    delete from pv_cpcalculated where test_id = myTestId;
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
	SET @infoText = CONCAT("Test Id : ", myTestId, ", Polarization Type : ",myPolType,", Test Type : ", myTestType);
	call debug(l_proc_id,@infoText,'I','I');
 end if;
 
#open cursor
  OPEN freqcur;
  
  #starts the loop
  pv_the_loop: LOOP
  
 FETCH freqcur INTO myfreq,myserial; -- ,mylinear_Gain;
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
	call pv_calc_Combination(myTestId,myfreq,myTestDate,myserial);
    
    
 END IF;
  #Calculations - end
    
    END LOOP pv_the_loop;
 
  CLOSE freqcur;
  
  -- to populate the spec tables for combination testtype
  -- if myTestType = 'CO' then
    -- call pv_calc_spec(myTestId,myTestDate);
   -- end if;
   
-- store calculated values for gain tracking
if myTestType = 'GT' then
	# store calculated values into calculated table
	
    delete from pv_gt_calculated where Test_id = myTestId;
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
							where Test_id = myTestId 
							group by Frequency,Test_id,TestDate;

end if;
    
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

-- Max Received Amplitude of AUT in VP -> A
select MAX(Amplitude) into @A from pv_vdata where Prodserial_id = gmSerial and datatype = 'M' and Frequency = gmFreq ;

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

# Gain tracking on axis

-- hp
select Amplitude into @Hamp_0 from pv_hdata where Prodserial_id = gmSerial and datatype = 'T' and Frequency = gmFreq
and Angle = 0 ;

-- vp
select Amplitude into @Vamp_0 from pv_vdata where Prodserial_id = gmSerial and datatype = 'T' and Frequency = gmFreq
and Angle = 0 ;

-- cp
select pv_calc_cpdata(gmSerial, gmFreq, 0,@Hamp_0,@Vamp_0) into @CPamp_0; 

# Gain tracking at +45 degree

-- hp
select Amplitude into @Hamp_p45 from pv_hdata where Prodserial_id = gmSerial  and datatype = 'T' and Frequency = gmFreq
and Angle = 45;

-- vp
select Amplitude into @Vamp_p45 from pv_vdata where Prodserial_id = gmSerial and datatype = 'T' and Frequency = gmFreq
and Angle = 45 ;

-- cp
select pv_calc_cpdata(gmSerial, gmFreq, 45,@Hamp_p45,@Vamp_p45) into @CPamp_p45; 

# Gain tracking at -45 degree

-- hp
select Amplitude into @Hamp_m45 from pv_hdata where Prodserial_id = gmSerial and datatype = 'T' and Frequency = gmFreq
and Angle = 315 ;

-- vp
select Amplitude into @Vamp_m45 from pv_vdata where Prodserial_id = gmSerial  and datatype = 'T' and Frequency = gmFreq
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
 
 
END$$

DELIMITER ;


