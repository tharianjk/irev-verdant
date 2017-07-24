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
drop procedure if exists calc_tracking;
drop function if exists calc_AxialRatio;
drop function if exists calc_backlobe;
drop function if exists calc_cpdata;
drop function if exists calc_cpgain;
drop function if exists calc_omni;
drop procedure if exists spGetPolarSummary;
DROP procedure IF EXISTS `debug`;
drop procedure if exists spPolarMultiple;
drop procedure if exists sanity_check;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `calc_CP`(
cpTestId INT,
cpFreq decimal(40,20),
cpTestDate datetime,
cpType char(4) -- DCP or CP
)
BEGIN
-- for direct CP and CP with conversion

# Declarations -begin


# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'calc_CP for C-CP/C-DCP';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;

# change to include HP VP calculations for CP with conversion - begin

DECLARE _3dB_BW_HP_BM,_3dB_BW_HP_0,_3dB_BW_HP_90 decimal(40,20);
DECLARE _10dB_BW_HP_BM, _10dB_BW_HP_0,_10dB_BW_HP_90 decimal(40,20);

DECLARE _3dB_BS_HP_BM,_3dB_BS_HP_0,_3dB_BS_HP_90 decimal(40,20);
DECLARE _10dB_BS_HP_BM, _10dB_BS_HP_0,_10dB_BS_HP_90 decimal(40,20);

DECLARE backlobe_HP decimal(40,20);

DECLARE _3dB_BW_VP_BM,_3dB_BW_VP_0,_3dB_BW_VP_90 decimal(40,20);
DECLARE _10dB_BW_VP_BM, _10dB_BW_VP_0,_10dB_BW_VP_90 decimal(40,20);

DECLARE _3dB_BS_VP_BM,_3dB_BS_VP_0,_3dB_BS_VP_90 decimal(40,20);
DECLARE _10dB_BS_VP_BM, _10dB_BS_VP_0,_10dB_BS_VP_90 decimal(40,20);

DECLARE backlobe_VP decimal(40,20);

# change to include HP VP calculations for CP with conversion - end


    
DECLARE _3dB_BW_CP_BM,_3dB_BW_CP_0,_3dB_BW_CP_90 decimal(40,20);
DECLARE _10dB_BW_CP_BM, _10dB_BW_CP_0,_10dB_BW_CP_90 decimal(40,20);

DECLARE _3dB_BS_CP_BM,_3dB_BS_CP_0,_3dB_BS_CP_90 decimal(40,20);
DECLARE _10dB_BS_CP_BM, _10dB_BS_CP_0,_10dB_BS_CP_90 decimal(40,20);

DECLARE backlobe_CP decimal(40,20);

DECLARE axial_0,axial_P45,axial_M45,AR_Maxdiff_P, AR_Maxdiff_M decimal(40,20);
DECLARE angle_Maxdiff_P, angle_Maxdiff_M decimal(40,20);

DECLARE hDataPresent INT default 0;
DECLARE vDataPresent INT default 0;
DECLARE cpDataPresent INT default 0;

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
        SET @details = CONCAT("Test id : ",cpTestId,",Frequency : ",cpFreq,",Type : ",cpType);
		call debug(l_proc_id, @details,'I','I');
	end if;
    RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
	
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in calc_CP','I','I');
 end if;
 
 #declarations -end

if cpType = 'CP' then
	
    if isDebug > 0 then
				SET @infoText = "Circular with cp conversion";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
 
    select count(*) into hDataPresent from hdata where test_id = cpTestId and Frequency = cpFreq;
	select count(*) into vDataPresent from vdata where test_id = cpTestId and Frequency = cpFreq;
	
    # change to include HP and VP calculations for CP with conversion - begin
    if hDataPresent > 0 then
	
    if isDebug > 0 then
				SET @infoText = "hp data is present";
				call debug(l_proc_id,@infoText,'I','I');
	end if;
    -- calculate 3 db and 10 db BW & BS
    
    if isDebug > 0 then
				SET @infoText = "invoking 3 dB BW and BS calculations for HP data...";
				call debug(l_proc_id,@infoText,'I','I');
	end if;
			 -- Calculate 3dB Beam Width, Beam Squint for hp data for Beam Max and store
		    call calc_XdB_BW_BS(cpTestId,cpFreq,3,'HP','BM',_3dB_BW_HP_BM,_3dB_BS_HP_BM );
           
		   -- Calculate 3dB Beam Width, Beam Squint for hp data for 0 degree and store
		   call calc_XdB_BW_BS(cpTestId,cpFreq,3,'HP','0',_3dB_BW_HP_0,_3dB_BS_HP_0 );
           
		   -- Calculate 3dB Beam Width, Beam Squint for pitch data for 90 degree
		    call calc_XdB_BW_BS(cpTestId,cpFreq,3,'HP','90', _3dB_BW_HP_90, _3dB_BS_HP_90);
           
		 if isDebug > 0 then
				SET @infoText = "invoking 10 dB BW and BS calculations for HP data...";
				call debug(l_proc_id,@infoText,'I','I');
		end if;       
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for Beam Max
		    call calc_XdB_BW_BS(cpTestId,cpFreq,10,'HP','BM', _10dB_BW_HP_BM, _10dB_BS_HP_BM);
            
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for 0 degree
		    call calc_XdB_BW_BS(cpTestId,cpFreq,10,'HP','0', _10dB_BW_HP_0, _10dB_BS_HP_0);
            
		   -- Calculate 10dB Beam Width, Beam Squint for Pitch data for 90 degree
		     call calc_XdB_BW_BS(cpTestId,cpFreq,10,'HP','90', _10dB_BW_HP_90, _10dB_BS_HP_90);
           
           if isDebug > 0 then
				SET @infoText = "invoking Backlobe calculations ...";
				call debug(l_proc_id,@infoText,'I','I');
		end if;
		  -- Calculate Back Lobe for HP data
			  select calc_Backlobe(cpTestId,cpFreq,'HP') into backlobe_HP;
		           
            
		-- insert into pitchCalculated table
             delete from hcalculated where Test_id =cpTestId and Frequency = cpFreq;
			 insert into hcalculated(Test_id,Frequency,TestDate
								,3Db_BW_BMax,3Db_BW_0,3Db_BW_90
                                ,10Db_BW_BMax,10Db_BW_0,10Db_BW_90
                                ,3Db_BS_BMax,3Db_BS_0,3Db_BS_90
                                ,10Db_BS_BMax,10Db_BS_0,10Db_BS_90
                                ,BackLobe)
		   select cpTestId,cpFreq,cpTestDate,
				_3dB_BW_HP_BM,_3dB_BW_HP_0,_3dB_BW_HP_90,
				_10dB_BW_HP_BM,_10dB_BW_HP_0,_10dB_BW_HP_90,
                _3dB_BS_HP_BM,_3dB_BS_HP_0,_3dB_BS_HP_90,
				_10dB_BS_HP_BM,_10dB_BS_HP_0,_10dB_BS_HP_90,
                backlobe_HP;
                
		if isDebug > 0 then
				SET @infoText = "Calculated data saved successfully into hCalculated";
				call debug(l_proc_id,@infoText,'I','I');
		end if;

	end if;
    
    
	if vDataPresent > 0 then
	
    if isDebug > 0 then
				SET @infoText = "vp data is present";
				call debug(l_proc_id,@infoText,'I','I');
	end if;
    -- calculate 3 db and 10 db BW & BS
    
    if isDebug > 0 then
				SET @infoText = "invoking 3 dB BW and BS calculations for VP data...";
				call debug(l_proc_id,@infoText,'I','I');
	end if;
			 -- Calculate 3dB Beam Width, Beam Squint for hp data for Beam Max and store
		    call calc_XdB_BW_BS(cpTestId,cpFreq,3,'VP','BM',_3dB_BW_VP_BM,_3dB_BS_VP_BM );
           
		   -- Calculate 3dB Beam Width, Beam Squint for hp data for 0 degree and store
		   call calc_XdB_BW_BS(cpTestId,cpFreq,3,'VP','0',_3dB_BW_VP_0,_3dB_BS_VP_0 );
           
		   -- Calculate 3dB Beam Width, Beam Squint for pitch data for 90 degree
		    call calc_XdB_BW_BS(cpTestId,cpFreq,3,'VP','90', _3dB_BW_VP_90, _3dB_BS_VP_90);
           
		 if isDebug > 0 then
				SET @infoText = "invoking 10 dB BW and BS calculations for VP data...";
				call debug(l_proc_id,@infoText,'I','I');
		end if;       
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for Beam Max
		    call calc_XdB_BW_BS(cpTestId,cpFreq,10,'VP','BM', _10dB_BW_VP_BM, _10dB_BS_VP_BM);
            
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for 0 degree
		    call calc_XdB_BW_BS(cpTestId,cpFreq,10,'VP','0', _10dB_BW_VP_0, _10dB_BS_VP_0);
            
		   -- Calculate 10dB Beam Width, Beam Squint for Pitch data for 90 degree
		     call calc_XdB_BW_BS(cpTestId,cpFreq,10,'VP','90', _10dB_BW_VP_90, _10dB_BS_VP_90);
           
           if isDebug > 0 then
				SET @infoText = "invoking Backlobe calculations ...";
				call debug(l_proc_id,@infoText,'I','I');
		end if;
		  -- Calculate Back Lobe for HP data
			  select calc_Backlobe(cpTestId,cpFreq,'VP') into backlobe_VP;
		           
            
		-- insert into pitchCalculated table
             delete from vcalculated where Test_id =cpTestId and Frequency = cpFreq;
			 insert into vcalculated(Test_id,Frequency,TestDate
								,3Db_BW_BMax,3Db_BW_0,3Db_BW_90
                                ,10Db_BW_BMax,10Db_BW_0,10Db_BW_90
                                ,3Db_BS_BMax,3Db_BS_0,3Db_BS_90
                                ,10Db_BS_BMax,10Db_BS_0,10Db_BS_90
                                ,BackLobe)
		   select cpTestId,cpFreq,cpTestDate,
				_3dB_BW_VP_BM,_3dB_BW_VP_0,_3dB_BW_VP_90,
				_10dB_BW_VP_BM,_10dB_BW_VP_0,_10dB_BW_VP_90,
                _3dB_BS_VP_BM,_3dB_BS_VP_0,_3dB_BS_VP_90,
				_10dB_BS_VP_BM,_10dB_BS_VP_0,_10dB_BS_VP_90,
                backlobe_VP;
                
		if isDebug > 0 then
				SET @infoText = "Calculated data saved successfully into vCalculated";
				call debug(l_proc_id,@infoText,'I','I');
		end if;

	end if;
    # change to include HP and VP calculations for CP with conversion - end
    
    
    
    if hDataPresent > 0 and vDataPresent > 0 then
		-- convert HP,VP to CP data
        if isDebug > 0 then
				SET @infoText = "HP and VP data present. Converting to CP data ...";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
		call convert_to_CP(cpTestId, cpFreq);
        
        if isDebug > 0 then
				SET @infoText = "Conversion complete";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
       
       -- Calculate and store axial ratio
        if isDebug > 0 then
				SET @infoText = "invoking axial ratio calculations ...";
				call debug(l_proc_id,@infoText,'I','I');
		end if;
        -- Calculate Axial ratio at 0 degree
        
			  select calc_AxialRatio(cpTestId,cpFreq,0) into axial_0;
              
		   -- Calculate Axial ratio at +45 degree
			  select calc_AxialRatio(cpTestId,cpFreq,45) into axial_P45;
            
              
		   -- Calculate Axial ratio at  -45 degree
		      select calc_AxialRatio(cpTestId,cpFreq,-45) into axial_M45;
          
		if isDebug > 0 then
				SET @infoText = "invoking Max axial ratio calculations ...";
				call debug(l_proc_id,@infoText,'I','I');
		end if;
           
		   -- Calculate Max-diff Axial ratio from 0 to +45 : Maximum Axial ratio from 0 to +45 degree
			  call calc_MaxDiffAxialRatio(cpTestId, cpFreq, 'P', AR_Maxdiff_P, angle_Maxdiff_P);
              
		   -- Calculate Max-diff Axial ratio from 0 to -45 : Maximum Axial ratio from 0 to -45 degree
		      call calc_MaxDiffAxialRatio(cpTestId, cpFreq, 'M', AR_Maxdiff_M, angle_Maxdiff_M);
              
              -- insert into arcalculated
               delete from arcalculated where Test_id = cpTestId and Frequency = cpFreq;
				insert into arcalculated(Test_id,Frequency,TestDate,
										AR_0,AR_P45,AR_M45,MaxAR_P_Ratio,
                                        MaxAR_P_Angle,MaxAR_M_Ratio,MaxAR_M_Angle)
				select cpTestId,cpFreq,cpTestDate,
				 		axial_0,axial_P45,axial_M45,
                         AR_Maxdiff_P,angle_Maxdiff_P, AR_Maxdiff_M, angle_Maxdiff_M; 
                         
				if isDebug > 0 then
				SET @infoText = "Calculated data saved successfully into arcalculated";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
     end if;

end if;

select count(*) into cpDataPresent from cpdata where test_id = cpTestId and Frequency = cpFreq;

if cpDataPresent > 0 then
	
    if isDebug > 0 then
				SET @infoText = "cp data is present";
				call debug(l_proc_id,@infoText,'I','I');
	end if;
    -- calculate 3 db and 10 db BW & BS
    
    if isDebug > 0 then
				SET @infoText = "invoking 3 dB BW and BS calculations ...";
				call debug(l_proc_id,@infoText,'I','I');
	end if;
			 -- Calculate 3dB Beam Width, Beam Squint for hp data for Beam Max and store
		    call calc_XdB_BW_BS(cpTestId,cpFreq,3,'CP','BM',_3dB_BW_CP_BM,_3dB_BS_CP_BM );
           
		   -- Calculate 3dB Beam Width, Beam Squint for hp data for 0 degree and store
		   call calc_XdB_BW_BS(cpTestId,cpFreq,3,'CP','0',_3dB_BW_CP_0,_3dB_BS_CP_0 );
           
		   -- Calculate 3dB Beam Width, Beam Squint for pitch data for 90 degree
		    call calc_XdB_BW_BS(cpTestId,cpFreq,3,'CP','90', _3dB_BW_CP_90, _3dB_BS_CP_90);
           
		 if isDebug > 0 then
				SET @infoText = "invoking 10 dB BW and BS calculations ...";
				call debug(l_proc_id,@infoText,'I','I');
		end if;       
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for Beam Max
		    call calc_XdB_BW_BS(cpTestId,cpFreq,10,'CP','BM', _10dB_BW_CP_BM, _10dB_BS_CP_BM);
            
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for 0 degree
		    call calc_XdB_BW_BS(cpTestId,cpFreq,10,'CP','0', _10dB_BW_CP_0, _10dB_BS_CP_0);
            
		   -- Calculate 10dB Beam Width, Beam Squint for Pitch data for 90 degree
		     call calc_XdB_BW_BS(cpTestId,cpFreq,10,'CP','90', _10dB_BW_CP_90, _10dB_BS_CP_90);
           
           if isDebug > 0 then
				SET @infoText = "invoking Backlobe calculations ...";
				call debug(l_proc_id,@infoText,'I','I');
		end if;
		  -- Calculate Back Lobe for HP data
			  select calc_Backlobe(cpTestId,cpFreq,'CP') into backlobe_CP;
		           
            
		-- insert into pitchCalculated table
             delete from cpcalculated where Test_id =cpTestId and Frequency = cpFreq;
			 insert into cpcalculated(Test_id,Frequency,TestDate
								,3Db_BW_BMax,3Db_BW_0,3Db_BW_90
                                ,10Db_BW_BMax,10Db_BW_0,10Db_BW_90
                                ,3Db_BS_BMax,3Db_BS_0,3Db_BS_90
                                ,10Db_BS_BMax,10Db_BS_0,10Db_BS_90
                                ,BackLobe)
		   select cpTestId,cpFreq,cpTestDate,
				_3dB_BW_CP_BM,_3dB_BW_CP_0,_3dB_BW_CP_90,
				_10dB_BW_CP_BM,_10dB_BW_CP_0,_10dB_BW_CP_90,
                _3dB_BS_CP_BM,_3dB_BS_CP_0,_3dB_BS_CP_90,
				_10dB_BS_CP_BM,_10dB_BS_CP_0,_10dB_BS_CP_90,
                backlobe_CP;
                
		if isDebug > 0 then
				SET @infoText = "Calculated data saved successfully into cpCalculated";
				call debug(l_proc_id,@infoText,'I','I');
		end if;

end if;	
END$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `calc_Linear_Azimuth`(
laTestId INT,
laFreq decimal(40,20),
laTestDate datetime
)
BEGIN

# Declarations -begin


# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'calc_Linear_Azimuth';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;

DECLARE omni_Y decimal(40,20);

DECLARE yawDataPresent INT default 0;

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
        SET @details = CONCAT("Test id : ",laTestId,",Frequency : ",laFreq);
		call debug(l_proc_id, @details,'I','I');
        
	end if;
	RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in calc_Linear_Azimuth','I','I');
 end if;

# Declarations -end

select count(*) into yawDataPresent from yawdata where test_id = laTestId and Frequency = laFreq;
	
if yawDataPresent > 0 then
		-- calculate omni deviation
			if isDebug > 0 then
				SET @infoText = "Yaw data present. Invoking omni deviation calculations";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
            
			select calc_omni(laTestId,laFreq,'Y') into omni_Y;
            
            
		-- insert into yawCalculated table
             delete from yawCalculated where Test_id = laTestId and Frequency = laFreq;
			 insert into yawCalculated(Test_id,Frequency,TestDate,OmniDeviation)
								select laTestId,laFreq,laTestDate,omni_Y;
                                
			if isDebug > 0 then
				SET @infoText = "Calculated data saved successfully into yawCalculated";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
end if;



END$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `calc_Linear_Elevation`(
leTestId INT,
leFreq decimal(40,20),
leTestDate datetime
)
BEGIN

# Declarations -begin

# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'calc_Linear_Elevation';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;

DECLARE _3dB_BW_P_BM, _3dB_BW_R_BM decimal(40,20);
DECLARE _3dB_BW_P_0, _3dB_BW_R_0 decimal(40,20);
DECLARE _3dB_BW_P_90, _3dB_BW_R_90 decimal(40,20);
DECLARE _10dB_BW_P_BM, _10dB_BW_R_BM decimal(40,20);
DECLARE _10dB_BW_P_0, _10dB_BW_R_0 decimal(40,20);
DECLARE _10dB_BW_P_90, _10dB_BW_R_90 decimal(40,20);
DECLARE dummyBS decimal(40,20);

DECLARE pitchDataPresent INT default 0;
DECLARE rollDataPresent INT default 0;


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
        SET @details = CONCAT("Test id : ",leTestId,",Frequency : ",leFreq);
		call debug(l_proc_id, @details,'I','I');
   
	end if;
    RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in calc_Linear_Elevation','I','I');
 end if;

# Declarations -end

select count(*) into pitchDataPresent from pitchdata where test_id = leTestId and Frequency = leFreq;
select count(*) into rollDataPresent from rolldata where test_id = leTestId and Frequency = leFreq;

-- pitch data calculations	
if pitchDataPresent > 0 then

			if isDebug > 0 then
				SET @infoText = "Pitch data present"; 
				call debug(l_proc_id,@infoText,'I','I');
			end if;
            
		-- calculate 3 db and 10 db BW
			 -- Calculate 3dB Beam Width, Beam Squint for pitch data for Beam Max and store
             if isDebug > 0 then
				SET @infoText = "invoking 3 db BW calculations ..."; 
				call debug(l_proc_id,@infoText,'I','I');
			end if;
            
		    call calc_XdB_BW_BS(leTestId,leFreq,3,'P','BM',_3dB_BW_P_BM,dummyBS );
           
		   -- Calculate 3dB Beam Width, Beam Squint for Pitch data for 0 degree and store
		   call calc_XdB_BW_BS(leTestId,leFreq,3,'P','0',_3dB_BW_P_0,dummyBS );
           
		   -- Calculate 3dB Beam Width, Beam Squint for pitch data for 90 degree
		    call calc_XdB_BW_BS(leTestId,leFreq,3,'P','90', _3dB_BW_P_90, dummyBS);
           
		    if isDebug > 0 then
				SET @infoText = "invoking 10 db BW calculations ..."; 
				call debug(l_proc_id,@infoText,'I','I');
			end if;
            
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for Beam Max
		    call calc_XdB_BW_BS(leTestId,leFreq,10,'P','BM', _10dB_BW_P_BM, dummyBS);
            
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for 0 degree
		    call calc_XdB_BW_BS(leTestId,leFreq,10,'P','0', _10dB_BW_P_0, dummyBS);
            
		   -- Calculate 10dB Beam Width, Beam Squint for Pitch data for 90 degree
		     call calc_XdB_BW_BS(leTestId,leFreq,10,'P','90', _10dB_BW_P_90, dummyBS);
            
		 
            
		-- insert into pitchCalculated table
             delete from pitchCalculated where Test_id = leTestId and Frequency = leFreq;
			 insert into pitchCalculated(Test_id,Frequency,TestDate
								,3Db_BW_BMax,3Db_BW_0,3Db_BW_90
                                ,10Db_BW_BMax,10Db_BW_0,10Db_BW_90)
		   select leTestId,leFreq,leTestDate,
				_3dB_BW_P_BM,_3dB_BW_P_0,_3dB_BW_P_90,
				_10dB_BW_P_BM,_10dB_BW_P_0,_10dB_BW_P_90;
                
		   if isDebug > 0 then
				SET @infoText = "Calculated data saved successfully into pitchCalculated";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
end if;

-- roll data calculations
if rollDataPresent > 0 then
			
			if isDebug > 0 then
				SET @infoText = "roll data present";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
		-- calculate 3 db and 10 db BW
        
        if isDebug > 0 then
				SET @infoText = "invoking 3 dB BW calculations ...";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
			 -- Calculate 3dB Beam Width, Beam Squint for roll data for Beam Max and store
		    call calc_XdB_BW_BS(leTestId,leFreq,3,'R','BM',_3dB_BW_R_BM,dummyBS );
           
		   -- Calculate 3dB Beam Width, Beam Squint for roll data for 0 degree and store
		   call calc_XdB_BW_BS(leTestId,leFreq,3,'R','0',_3dB_BW_R_0,dummyBS );
           
		   -- Calculate 3dB Beam Width, Beam Squint for roll data for 90 degree
		    call calc_XdB_BW_BS(leTestId,leFreq,3,'R','90', _3dB_BW_R_90, dummyBS);
          
          if isDebug > 0 then
				SET @infoText = "invoking 10 dB BW calculations ...";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
		        
		   -- Calculate 10dB Beam Width, Beam Squint for roll data for Beam Max
		    call calc_XdB_BW_BS(leTestId,leFreq,10,'R','BM', _10dB_BW_R_BM, dummyBS);
            
		   -- Calculate 10dB Beam Width, Beam Squint for roll data for 0 degree
		    call calc_XdB_BW_BS(leTestId,leFreq,10,'R','0', _10dB_BW_R_0, dummyBS);
            
		   -- Calculate 10dB Beam Width, Beam Squint for roll data for 90 degree
		     call calc_XdB_BW_BS(leTestId,leFreq,10,'R','90', _10dB_BW_R_90, dummyBS);
            
		 
            
		-- insert into rollCalculated table
             delete from rollCalculated where Test_id = leTestId and Frequency = leFreq;
			 insert into rollCalculated(Test_id,Frequency,TestDate
								,3Db_BW_BMax,3Db_BW_0,3Db_BW_90
                                ,10Db_BW_BMax,10Db_BW_0,10Db_BW_90)
		   select leTestId,leFreq,leTestDate,
				_3dB_BW_R_BM,_3dB_BW_R_0,_3dB_BW_R_90,
				_10dB_BW_R_BM,_10dB_BW_R_0,_10dB_BW_R_90;
                
			if isDebug > 0 then
				SET @infoText = "Calculated data saved successfully into rollCalculated";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
end if;


END$$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE `calc_MaxDiffAxialRatio`(
mdtest_id INT, freq decimal(40,20), P_or_M char(3),
OUT MaxdiffRatio decimal(40,20), 
OUT MaxdiffAngle decimal(40,20)
)
BEGIN

# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'calc_MaxDiffAxialRatio';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;

Declare i, currAngle, currRatio decimal(40,20);

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
	call debug(l_proc_id,'in calc_MaxDiffAxialRatio','I','I');
 end if;


if P_or_M = 'P' then
select MAX(axialRatio) 
    into MaxdiffRatio
    from axialratio_view 
    where test_id = mdtest_id and Frequency = freq 
    and (angle >= 0 and angle <=45);
    
    
    select MAX(angle)
    into MaxdiffAngle
    from axialratio_view 
    where test_id = mdtest_id and Frequency = freq and axialRatio = MaxdiffRatio;
end if;    
    -- if MaxdiffAngle = 360 then
-- set MaxdiffAngle = 0;
-- end if;
    
if P_or_M = 'M' then-- P_or_M ='M'

select MAX(axialRatio) 
    into MaxdiffRatio
    from axialratio_view 
    where test_id = mdtest_id and Frequency = freq 
    and ((angle >= 315 and angle < 360) or (angle = 0));
    
    
    select MAX(angle)
    into MaxdiffAngle
    from axialratio_view 
    where test_id = mdtest_id and Frequency = freq and axialRatio = MaxdiffRatio;
    
    if MaxdiffAngle <> 0 then
set MaxdiffAngle = MaxdiffAngle-360;
    end if;
end if;

-- 24 Jul 2017 changes
if P_or_M = 'P30' then
select MAX(axialRatio) 
    into MaxdiffRatio
    from axialratio_view 
    where test_id = mdtest_id and Frequency = freq 
    and (angle >= 0 and angle <=30);
    
    
    select MAX(angle)
    into MaxdiffAngle
    from axialratio_view 
    where test_id = mdtest_id and Frequency = freq and axialRatio = MaxdiffRatio;
end if;    
    -- if MaxdiffAngle = 360 then
-- set MaxdiffAngle = 0;
-- end if;
    
if P_or_M = 'M30' then-- P_or_M ='M'

select MAX(axialRatio) 
    into MaxdiffRatio
    from axialratio_view 
    where test_id = mdtest_id and Frequency = freq 
    and ((angle >= 330 and angle < 360) or (angle = 0));
    
    
    select MAX(angle)
    into MaxdiffAngle
    from axialratio_view 
    where test_id = mdtest_id and Frequency = freq and axialRatio = MaxdiffRatio;
    
    if MaxdiffAngle <> 0 then
set MaxdiffAngle = MaxdiffAngle-360;
    end if;
end if;


if P_or_M = 'P60' then
select MAX(axialRatio) 
    into MaxdiffRatio
    from axialratio_view 
    where test_id = mdtest_id and Frequency = freq 
    and (angle >= 0 and angle <=60);
    
    
    select MAX(angle)
    into MaxdiffAngle
    from axialratio_view 
    where test_id = mdtest_id and Frequency = freq and axialRatio = MaxdiffRatio;
end if;    
    -- if MaxdiffAngle = 360 then
-- set MaxdiffAngle = 0;
-- end if;
    
if P_or_M = 'M60' then-- P_or_M ='M'

select MAX(axialRatio) 
    into MaxdiffRatio
    from axialratio_view 
    where test_id = mdtest_id and Frequency = freq 
    and ((angle >= 300 and angle < 360) or (angle = 0));
    
    
    select MAX(angle)
    into MaxdiffAngle
    from axialratio_view 
    where test_id = mdtest_id and Frequency = freq and axialRatio = MaxdiffRatio;
    
    if MaxdiffAngle <> 0 then
set MaxdiffAngle = MaxdiffAngle-360;
    end if;
end if;

END$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `calc_Slant_Azimuth`(
saTestId INT,
saFreq decimal(40,20),
saTestDate datetime
)
BEGIN
# Declarations -begin

# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'calc_Slant_Azimuth';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;

DECLARE omni_HP decimal(40,20);
DECLARE omni_VP decimal(40,20);

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
        SET @details = CONCAT("Test id : ",saTestId,",Frequency : ",saFreq);
		call debug(l_proc_id, @details,'I','I');
        
	end if;
    
          RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in calc_Slant_Azimuth','I','I');
 end if;

# Declarations -end

select count(*) into hDataPresent from hdata where test_id = saTestId and Frequency = saFreq;
select count(*) into vDataPresent from vdata where test_id = saTestId and Frequency = saFreq;

	
if hDataPresent > 0 then
		-- calculate omni deviation
        if isDebug > 0 then
				SET @infoText = "HP data present. Invoking omni deviation calculations";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
            
			select calc_omni(saTestId,saFreq,'HP') into omni_HP;
            
		-- insert into hCalculated table
             delete from hcalculated where Test_id = saTestId and Frequency = saFreq;
			 insert into hcalculated(Test_id,Frequency,TestDate,OmniDeviation)
								select saTestId,saFreq,saTestDate,omni_HP;
                                
		if isDebug > 0 then
				SET @infoText = "Calculated data saved successfully into hcalculated";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
end if;

if vDataPresent > 0 then

			 if isDebug > 0 then
				SET @infoText = "VP data present. Invoking omni deviation calculations";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
            
		-- calculate omni deviation
			select calc_omni(saTestId,saFreq,'VP') into omni_VP;
            
		-- insert into vCalculated table
             delete from vcalculated where Test_id = saTestId and Frequency = saFreq;
			 insert into vcalculated(Test_id,Frequency,TestDate,OmniDeviation)
								select saTestId,saFreq,saTestDate,omni_VP;
                                
			if isDebug > 0 then
				SET @infoText = "Calculated data saved successfully into vcalculated";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
end if;


END$$
DELIMITER ;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `calc_Slant_Elevation`(
seTestId INT,
seFreq decimal(40,20),
seTestDate datetime
)
BEGIN
-- same for cp without conversion
-- same for cp without conversion

# Declarations -begin

# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'calc_Slant_Elevation for S-E/C-NCP';

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
        SET @details = CONCAT("Test id : ",seTestId,",Frequency : ",seFreq);
		call debug(l_proc_id, @details,'I','I');
           
         
	end if;
    RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in calc_Slant_Elevation','I','I');
 end if;


# Declarations -end

select count(*) into hDataPresent from hdata where test_id = seTestId and Frequency = seFreq;
select count(*) into vDataPresent from vdata where test_id = seTestId and Frequency = seFreq;

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
		    call calc_XdB_BW_BS(seTestId,seFreq,3,'HP','BM',_3dB_BW_HP_BM,_3dB_BS_HP_BM );
           
		   -- Calculate 3dB Beam Width, Beam Squint for hp data for 0 degree and store
		   call calc_XdB_BW_BS(seTestId,seFreq,3,'HP','0',_3dB_BW_HP_0,_3dB_BS_HP_0 );
           
		   -- Calculate 3dB Beam Width, Beam Squint for pitch data for 90 degree
		    call calc_XdB_BW_BS(seTestId,seFreq,3,'HP','90', _3dB_BW_HP_90, _3dB_BS_HP_90);
            
            -- new req
             -- Calculate 3dB Beam Width, Beam Squint for pitch data for 90 degree
		    call calc_XdB_BW_BS(seTestId,seFreq,3,'HP','270', _3dB_BW_HP_270, _3dB_BS_HP_270);
           
			 if isDebug > 0 then
				SET @infoText = "invoking 10 db BW and BS calculations ..."; 
				call debug(l_proc_id,@infoText,'I','I');
			end if;
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for Beam Max
		    call calc_XdB_BW_BS(seTestId,seFreq,10,'HP','BM', _10dB_BW_HP_BM, _10dB_BS_HP_BM);
            
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for 0 degree
		    call calc_XdB_BW_BS(seTestId,seFreq,10,'HP','0', _10dB_BW_HP_0, _10dB_BS_HP_0);
            
		   -- Calculate 10dB Beam Width, Beam Squint for Pitch data for 90 degree
		     call calc_XdB_BW_BS(seTestId,seFreq,10,'HP','90', _10dB_BW_HP_90, _10dB_BS_HP_90);
             
             -- new req
              -- Calculate 10dB Beam Width, Beam Squint for Pitch data for 270 degree
		     call calc_XdB_BW_BS(seTestId,seFreq,10,'HP','270', _10dB_BW_HP_270, _10dB_BS_HP_270);
            
		 if isDebug > 0 then
				SET @infoText = "invoking Backlobe calculations ..."; 
				call debug(l_proc_id,@infoText,'I','I');
			end if;
		  -- Calculate Back Lobe for HP data
			  select calc_Backlobe(seTestId,seFreq,'HP') into backlobe_HP;
		   
         
            
		-- insert into pitchCalculated table
             delete from hcalculated where Test_id =seTestId and Frequency = seFreq;
			 insert into hcalculated(Test_id,Frequency,TestDate
								,3Db_BW_BMax,3Db_BW_0,3Db_BW_90,3Db_BW_270
                                ,10Db_BW_BMax,10Db_BW_0,10Db_BW_90,10Db_BW_270
                                ,3Db_BS_BMax,3Db_BS_0,3Db_BS_90,3Db_BS_270
                                ,10Db_BS_BMax,10Db_BS_0,10Db_BS_90,10Db_BS_270
                                ,BackLobe)
		   select seTestId,seFreq,seTestDate,
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
		    call calc_XdB_BW_BS(seTestId,seFreq,3,'VP','BM',_3dB_BW_VP_BM,_3dB_BS_VP_BM );
           
		   -- Calculate 3dB Beam Width, Beam Squint for hp data for 0 degree and store
		   call calc_XdB_BW_BS(seTestId,seFreq,3,'VP','0',_3dB_BW_VP_0,_3dB_BS_VP_0 );
           
		   -- Calculate 3dB Beam Width, Beam Squint for pitch data for 90 degree
		    call calc_XdB_BW_BS(seTestId,seFreq,3,'VP','90', _3dB_BW_VP_90, _3dB_BS_VP_90);
            
             -- Calculate 3dB Beam Width, Beam Squint for pitch data for 90 degree
		    call calc_XdB_BW_BS(seTestId,seFreq,3,'VP','270', _3dB_BW_VP_270, _3dB_BS_VP_270);
           
		     
            if isDebug > 0 then
				SET @infoText = "invoking 10dB BW and BS calculations ..."; 
				call debug(l_proc_id,@infoText,'I','I');
			end if; 
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for Beam Max
		    call calc_XdB_BW_BS(seTestId,seFreq,10,'VP','BM', _10dB_BW_VP_BM, _10dB_BS_VP_BM);
            
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for 0 degree
		    call calc_XdB_BW_BS(seTestId,seFreq,10,'VP','0', _10dB_BW_VP_0, _10dB_BS_VP_0);
            
		   -- Calculate 10dB Beam Width, Beam Squint for Pitch data for 90 degree
		     call calc_XdB_BW_BS(seTestId,seFreq,10,'VP','90', _10dB_BW_VP_90, _10dB_BS_VP_90);
             
             -- Calculate 10dB Beam Width, Beam Squint for Pitch data for 90 degree
		     call calc_XdB_BW_BS(seTestId,seFreq,10,'VP','270', _10dB_BW_VP_270, _10dB_BS_VP_270);
            
		  if isDebug > 0 then
				SET @infoText = "invoking backlobe calculations ..."; 
				call debug(l_proc_id,@infoText,'I','I');
			end if;
          -- Calculate Back Lobe for HP data
			  select calc_Backlobe(seTestId,seFreq,'VP') into backlobe_VP;
		   
         
            
		-- insert into vcalculated table
             delete from vcalculated where Test_id =seTestId and Frequency = seFreq;
			 insert into vcalculated(Test_id,Frequency,TestDate
								,3Db_BW_BMax,3Db_BW_0,3Db_BW_90,3Db_BW_270
                                ,10Db_BW_BMax,10Db_BW_0,10Db_BW_90,10Db_BW_270
                                ,3Db_BS_BMax,3Db_BS_0,3Db_BS_90,3Db_BS_270
                                ,10Db_BS_BMax,10Db_BS_0,10Db_BS_90,10Db_BS_270
                                ,BackLobe)
		   select seTestId,seFreq,seTestDate,
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

-- axial ratio calculations
if hDataPresent > 0 and vDataPresent > 0 then
	  -- Calculate Axial ratio at 0 degree
			  select calc_AxialRatio(seTestId,seFreq,0) into axial_0;
              
		   -- Calculate Axial ratio at +45 degree
			  select calc_AxialRatio(seTestId,seFreq,45) into axial_P45;
            
              
		   -- Calculate Axial ratio at  -45 degree
		      select calc_AxialRatio(seTestId,seFreq,-45) into axial_M45;
           
		   -- Calculate Max-diff Axial ratio from 0 to +45 : Maximum Axial ratio from 0 to +45 degree
			  call calc_MaxDiffAxialRatio(seTestId, seFreq, 'P', AR_Maxdiff_P, angle_Maxdiff_P);
              
		   -- Calculate Max-diff Axial ratio from 0 to -45 : Maximum Axial ratio from 0 to -45 degree
		      call calc_MaxDiffAxialRatio(seTestId, seFreq, 'M', AR_Maxdiff_M, angle_Maxdiff_M);
              
              -- insert into arcalculated
               delete from arcalculated where Test_id = seTestId and Frequency = seFreq;
				insert into arcalculated(Test_id,Frequency,TestDate,
										AR_0,AR_P45,AR_M45,MaxAR_P_Ratio,
                                        MaxAR_P_Angle,MaxAR_M_Ratio,MaxAR_M_Angle)
				select seTestId,seFreq,seTestDate,
				 		axial_0,axial_P45,axial_M45,
                         AR_Maxdiff_P,angle_Maxdiff_P, AR_Maxdiff_M, angle_Maxdiff_M; 
        
        
        if isDebug > 0 then
				SET @infoText = "Calculated data saved successfully into arcalculated";
				call debug(l_proc_id,@infoText,'I','I');
			end if;
end if;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `calc_Circular_NCP`(
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

select count(*) into hDataPresent from hdata where test_id = cncpTestId and Frequency = cncpFreq;
select count(*) into vDataPresent from vdata where test_id = cncpTestId and Frequency = cncpFreq;

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
DELIMITER;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `calc_tracking`(
myProdSerialList varchar(200), -- eg: "1,2,3,4"
amp_or_phase char(1), -- 'A' = amp, 'P' = phase
out maxDiff decimal(40,20),
out maxFreq decimal(40,20)
)
BEGIN
# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'calc_tracking';

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
        SET @details = CONCAT("Product serial list : ",myProdSerialList,",A/P : ",amp_or_phase);
		call debug(l_proc_id, @details,'I','I');
        
         
	end if;
    RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in calc_tracking','I','I');
 end if;


if amp_or_phase = 'A' then

select  (MAX(ampvalue)-MIN(ampvalue))/2 diff, frequency 
into maxDiff,maxFreq
from amplitudedata
where find_in_set(prodserial_id, myProdSerialList) >0
group by frequency
order by diff desc
LIMIT 1;

else

select  (MAX(phasevalue)-MIN(phasevalue))/2 diff, frequency 
into maxDiff,maxFreq
from phasedata
where find_in_set(prodserial_id, myProdSerialList) >0
group by frequency
order by diff desc
LIMIT 1;

end if;
END$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `calc_XdB_BW_BS`(
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
DELIMITER $$
CREATE PROCEDURE `Calculate_params`(
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
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sanity_check`(
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
				 set MESSAGE_TEXT = 'Invalid angle values. Calculation cannot proceed';
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
				 set MESSAGE_TEXT = 'Invalid angle values. Calculation cannot proceed';
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
				 set MESSAGE_TEXT = 'Invalid angle values. Calculation cannot proceed';
			end if;
            
		end if;

 END IF;
 
 if isDebug > 0 then
	SET @infoText = CONCAT("Sanity checks complete");
		call debug(l_proc_id,@infoText,'I','I');
 end if;
 
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `convert_to_CP`(
ctest_id INT, freq decimal(40,20)
)
BEGIN

# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'convert_to_CP';

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
        SET @details = CONCAT("Test Id : ", ctest_id, ", Frequency : ",freq);
		call debug(l_proc_id,@details,'I','I');
        
	end if;
    
         RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in convert_to_CP','I','I');
 end if;



-- delete existing data for that freq
delete from cpdata 
where test_id = ctest_id and frequency = freq;


insert into cpdata ( test_id, Frequency, Angle, Amplitude)

select test_id, Frequency, Angle, calc_cpdata(test_id, Frequency, Angle)
from hdata  
where test_id = ctest_id and frequency = freq;




END$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `debug`(
p_proc_id varchar(100), -- procedure name
p_debug_info text, -- debug msg
msgtype char(1), -- ‘I’ : INFO, ‘E’ : ERROR, ‘F’ : FATAL
p_operation char(1) -- 'I' : insert, 'D' : delete, 'V' : View
)
BEGIN
declare m_type varchar(5);

if p_operation = 'I' then  -- insert into debug
	
    	select case when msgtype ='E' then 'ERROR' when msgtype ='F' then 'FATAL'
				when msgtype ='I' then 'INFO' end 
	into m_type;

		insert into debug (proc_id,message,msg_type,timestamp)
		values (p_proc_id,p_debug_info,m_type,now());
        
elseif p_operation = 'D' then  -- delete all entries
	
    delete from debug;

elseif p_operation = 'V' then  -- View all entries

	select timestamp as 'Timestamp', proc_id as 'Procedure Name', msg_type as 'Message Type', message as 'Message'
    from debug
    order by line_id desc;

end if;


END$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spCalCPGain`(
testid INT
)
BEGIN

# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'spCalCPGain';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;
 
DECLARE v_finished INTEGER DEFAULT 0;
Declare v_freq decimal(40,20);
Declare v_lg decimal(40,20);
Declare v_cpgain decimal(40,20); 
declare cnt int;
DECLARE C1 CURSOR FOR select distinct Frequency,lineargain from testfreq where test_id=testid;
 
-- declare NOT FOUND handler
DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_finished = 1;
        
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
        SET @details = CONCAT("Test id : ", testid);
		call debug(l_proc_id, @details,'I','I');
        
         
	end if;
    RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
 end;

# 4. store the debug flag 
select ndebugFlag into isDebug from fwk_company;
  
if isDebug > 0 then
	call debug(l_proc_id,'in spCalCPGain','I','I');
 end if;

 
OPEN C1;
 
getlist: LOOP
 
 FETCH C1 INTO v_freq,v_lg;
 
IF v_finished = 1 THEN
LEAVE getlist;
END IF;
 select count(*) into cnt from cpcalculated where test_id=testid and Frequency=v_freq;
if cnt >0 then
select calc_cpgain(testid,v_freq,v_lg) into v_cpgain;

update cpcalculated set cpgain =v_cpgain where test_id=testid and Frequency=v_freq;
 end if;
END LOOP getlist;
 
CLOSE C1;
 
END$$
DELIMITER ;



-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

drop procedure if exists spGetPolarPlot;

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetPolarPlot`(
testid INT,
freqparm decimal(40,20),
typ varchar(5), -- H HP,V VP,B HP&VP,P Pitch,R Roll ,Y Yaw
lg decimal(40,20)
)
BEGIN


# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'spGetPolarPlot';

# 2. declare variable to store debug flag
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
        SET @details = CONCAT("Test id : ", testid, ", Frequency : ",freq, ", typ : ",typ,",linear gain : ",lg);
		call debug(l_proc_id, @details,'I','I');
        
         RESIGNAL set MESSAGE_TEXT = 'Exception encountered in the inner procedure';
	end if;
 end;

# 4. store the debug flag 
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
        -- update testfreq set lineargain =lg where test_id=testid and frequency=freq;
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
       /*select convert(floor(max(Amplitude)),char(30)) into strmaxvalue from 
        (SELECT Amplitude -ampl+lg FROM hdata HD 
		where HD.Frequency=freq and HD.Test_id=testid 
        union
        SELECT Amplitude -vampl+lg Amplitude FROM vdata HD 
		where HD.Frequency=freq and HD.Test_id=testid) as tab;
        
        select convert(round(min(Amplitude),0),char(30)) into strminvalue from 
        (SELECT Amplitude-ampl+lg FROM hdata HD 
		where HD.Frequency=freq and HD.Test_id=testid union
        SELECT Amplitude-vampl+lg Amplitude FROM vdata HD 
		where HD.Frequency=freq and HD.Test_id=testid) as tab;*/


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
DELIMITER ;

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetPolarSummary`(
testid INT,
freqparm decimal(40,10),
typ varchar(5) -- H HP,V VP,B HP&VP,P Pitch,R Roll ,Y Yaw

)
BEGIn
# 1. Set procedure id. This is given to identify the procedure in log. Give the procedure name here
	declare l_proc_id varchar(100) default 'spGetPolarSummary';

# 2. declare variable to store debug flag
    declare isDebug INT default 0;

declare prec int;
declare unt varchar(10);
declare freq decimal(40,20);
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
	call debug(l_proc_id,'in spGetPolarSummary','I','I');
 end if;

set prec=1;

select nprecision into prec from fwk_company where company_id=1;
select frequnit into unt from testdata where test_id=testid;

set freq=freqparm;

if unt='GHz' then
set freq=freqparm*1000;
end if;

if typ='C' then
select round(sum(3Db_BW_BMax),prec) 3Db_BW_BMax,round(sum(3Db_BS_BMax),prec) 3Db_BS_BMax,round(sum(10Db_BW_BMax),prec) 10Db_BW_BMax,round(sum(10Db_BS_BMax),prec) 10Db_BS_BMax,round(sum(BackLobe),prec) BackLobe,round(sum(CPGain),prec) CPGain,round(sum(AR_0),prec) AR_0 ,round(sum(OmniDeviation),prec) OmniDeviation from (
select 3Db_BW_BMax,3Db_BS_BMax,10Db_BW_BMax,10Db_BS_BMax,BackLobe,CPGain,0 AR_0,0 OmniDeviation from cpcalculated where Test_id=testid and Frequency=freq
union select 0 3Db_BW_BMax,0 3Db_BS_BMax, 0 10Db_BW_BMax,0 10Db_BS_BMax,0 BackLobe, 0 CPGain,AR_0,0 OmniDeviation from arcalculated  where Test_id=testid and Frequency=freq) as tab;
end if;
if typ='H' then
select round(sum(3Db_BW_BMax),prec) 3Db_BW_BMax,round(sum(3Db_BS_BMax),prec) 3Db_BS_BMax,round(sum(10Db_BW_BMax),prec) 10Db_BW_BMax,round(sum(10Db_BS_BMax),prec) 10Db_BS_BMax,round(sum(BackLobe),prec) BackLobe,round(sum(CPGain),prec) CPGain,round(sum(AR_0),prec) AR_0 ,round(sum(OmniDeviation),prec) OmniDeviation from (
select 3Db_BW_BMax,3Db_BS_BMax,10Db_BW_BMax,10Db_BS_BMax,BackLobe,0 CPGain,0 AR_0, OmniDeviation from hcalculated where Test_id=testid and Frequency=freq
union select 0 3Db_BW_BMax,0 3Db_BS_BMax, 0 10Db_BW_BMax,0 10Db_BS_BMax,0 BackLobe, 0 CPGain,AR_0,0 OmniDeviation from arcalculated  where Test_id=testid and Frequency=freq) as tab;
end if;
if typ='V' then
select round(sum(3Db_BW_BMax),prec) 3Db_BW_BMax,round(sum(3Db_BS_BMax),prec) 3Db_BS_BMax,round(sum(10Db_BW_BMax),prec) 10Db_BW_BMax,round(sum(10Db_BS_BMax),prec) 10Db_BS_BMax,round(sum(BackLobe),prec) BackLobe,round(sum(CPGain),prec) CPGain,round(sum(AR_0),prec) AR_0 ,round(sum(OmniDeviation),prec) OmniDeviation from (
select 3Db_BW_BMax,3Db_BS_BMax,10Db_BW_BMax,10Db_BS_BMax,BackLobe,0 CPGain,0 AR_0, OmniDeviation from vcalculated where Test_id=testid and Frequency=freq
union select 0 3Db_BW_BMax,0 3Db_BS_BMax, 0 10Db_BW_BMax,0 10Db_BS_BMax,0 BackLobe, 0 CPGain,AR_0,0 OmniDeviation from arcalculated  where Test_id=testid and Frequency=freq) as tab;
end if;
if typ='P' then
select round(sum(3Db_BW_BMax),prec) 3Db_BW_BMax,round(sum(3Db_BS_BMax),prec) 3Db_BS_BMax,round(sum(10Db_BW_BMax),prec) 10Db_BW_BMax,round(sum(10Db_BS_BMax),prec) 10Db_BS_BMax,round(sum(BackLobe),prec) BackLobe,round(sum(CPGain),prec) CPGain,round(sum(AR_0),prec) AR_0 ,round(sum(OmniDeviation),prec) OmniDeviation from (
select 3Db_BW_BMax,0 3Db_BS_BMax,10Db_BW_BMax,0 10Db_BS_BMax,0 BackLobe,0 CPGain,0 AR_0, 0 OmniDeviation from pitchcalculated where Test_id=testid and Frequency=freq
) as tab;
end if;
if typ='R' then
select round(sum(3Db_BW_BMax),prec) 3Db_BW_BMax,round(sum(3Db_BS_BMax),prec) 3Db_BS_BMax,round(sum(10Db_BW_BMax),prec) 10Db_BW_BMax,round(sum(10Db_BS_BMax),prec) 10Db_BS_BMax,round(sum(BackLobe),prec) BackLobe,round(sum(CPGain),prec) CPGain,round(sum(AR_0),prec) AR_0 ,round(sum(OmniDeviation),prec) OmniDeviation from (
select 3Db_BW_BMax,0 3Db_BS_BMax,10Db_BW_BMax,0 10Db_BS_BMax,0 BackLobe,0 CPGain,0 AR_0, 0 OmniDeviation from rollcalculated where Test_id=testid and Frequency=freq
) as tab;
end if;
if typ='Y' then
select round(sum(3Db_BW_BMax),prec) 3Db_BW_BMax,round(sum(3Db_BS_BMax),prec) 3Db_BS_BMax,round(sum(10Db_BW_BMax),prec) 10Db_BW_BMax,round(sum(10Db_BS_BMax),prec) 10Db_BS_BMax,round(sum(BackLobe),prec) BackLobe,round(sum(CPGain),prec) CPGain,round(sum(AR_0),prec) AR_0 ,round(sum(OmniDeviation),prec) OmniDeviation from (
select 0 3Db_BW_BMax,0 3Db_BS_BMax,0 10Db_BW_BMax,0 10Db_BS_BMax,0 BackLobe,0 CPGain,0 AR_0, OmniDeviation from yawcalculated where Test_id=testid and Frequency=freq
) as tab;
end if;

	
if typ='B' then
select ptype, round(sum(3Db_BW_BMax),prec) 3Db_BW_BMax,round(sum(3Db_BS_BMax),prec) 3Db_BS_BMax,round(sum(10Db_BW_BMax),prec) 10Db_BW_BMax,round(sum(10Db_BS_BMax),prec) 10Db_BS_BMax,round(sum(BackLobe),prec) BackLobe,round(sum(CPGain),prec) CPGain,round(sum(AR_0),prec) AR_0 ,round(sum(OmniDeviation),prec) OmniDeviation from (
select 'HP' ptype,3Db_BW_BMax,3Db_BS_BMax,10Db_BW_BMax,10Db_BS_BMax,BackLobe,0 CPGain,0 AR_0, OmniDeviation from hcalculated where Test_id=testid and Frequency=freq
union select 'HP' ptype,0 3Db_BW_BMax,0 3Db_BS_BMax, 0 10Db_BW_BMax,0 10Db_BS_BMax,0 BackLobe, 0 CPGain,AR_0,0 OmniDeviation from arcalculated  where Test_id=testid and Frequency=freq
union
select 'VP' ptype,3Db_BW_BMax,3Db_BS_BMax,10Db_BW_BMax,10Db_BS_BMax,BackLobe,0 CPGain,0 AR_0, OmniDeviation from vcalculated where Test_id=testid and Frequency=freq 
union select 'VP' ptype,0 3Db_BW_BMax,0 3Db_BS_BMax, 0 10Db_BW_BMax,0 10Db_BS_BMax,0 BackLobe, 0 CPGain,AR_0,0 OmniDeviation from arcalculated  where Test_id=testid and Frequency=freq
) as tab
group by ptype;
end if;	
        
END$$
DELIMITER;


DELIMITER $$
CREATE FUNCTION `calc_AxialRatio`(
atest_id INT, freq decimal(40,20), degree INT
) RETURNS decimal(40,20)
BEGIN

# Axial Ratio =( HP – VP) at degree for freq

DECLARE AR decimal(40,20) default 0;

-- if degree = 0 then 
-- 	set degree = 360;
--  else
if degree < 0 then
	set degree = 360 + degree;
end if;

select axialRatio 
into AR
from axialratio_view
 where test_id = atest_id and Frequency = freq and angle = degree;
 
RETURN AR;
END$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `calc_backlobe`(
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
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `calc_cpdata`(
cTestId INT, freq decimal(40,20), cAngle decimal(40,20)
) RETURNS decimal(40,20)
BEGIN

declare A,B,C,D,E,cpdata decimal(40,20) default 0;

select amplitude into A from hdata h
 		 where h.test_id = cTestId and h.Frequency = freq and h.angle = cAngle;
-- select A;
 select amplitude into B from vdata v
 		 where v.test_id = cTestId and v.Frequency = freq and v.angle = cAngle; 
-- select B;
if A > B then
	set C = A - B;
else 
	set C = B - A;
end if;

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
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `calc_cpgain`(
testId_c INT, freq decimal(40,20), linearGain decimal(40,20)
) RETURNS decimal(40,20)
BEGIN
declare A, B, C, D, E, cpgain decimal(40,20);

select amplitude into A 
from vdata v 
where v.test_id = testId_c and v.Frequency = freq and v.angle = 0; 

select amplitude into B 
from hdata h 
where h.test_id = testId_c and h.Frequency = freq and h.angle = 0;

if A > B then 
	set C = A-B;
else 
	set C = B-A;
end if;

set D = EXP(C/20);

set E = 20 * LOG10((D+1)/(1.414*D));

set cpgain = linearGain+E;

RETURN cpgain;
END$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `calc_omni`(
oTestId INT, freq decimal(40,20), opolType char(2)
) RETURNS decimal(40,20)
BEGIN

#omni deviation = (Max - min)/2

DECLARE omni_dev decimal(40,20) default 0;

if opolType = 'HP' then
	select ifnull((max(Amplitude)-min(Amplitude))/2,0) into omni_dev
	from hdata where test_id = oTestId and Frequency = freq;
elseif opolType = 'Y' then
	select ifnull((max(Amplitude)-min(Amplitude))/2,0) into omni_dev
	from yawData where test_id = oTestId and Frequency = freq;
else -- polType = 'VP'
	select ifnull((max(Amplitude)-min(Amplitude))/2,0) into omni_dev
	from vdata where test_id = oTestId and Frequency = freq;
end if;

RETURN omni_dev;
END$$
DELIMITER ;

DELIMITER $$
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
drop procedure if exists spPolarMultiple;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE  PROCEDURE `spPolarMultiple`(strfreq varchar(100),strlg varchar(100),testid int,usr Varchar(20),typ varchar(2))
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
-- insert into testdebug values ('1');
        myloop: WHILE (@Occurrences > 0)        
 DO              SET @myValue = SUBSTRING_INDEX(@String, ',', 1); 
            IF (@myValue != '') THEN  
           insert into t1(id,freq) values(cnt,case @unt when 'GHz' then convert(@myValue,decimal)*1000 else convert(@myValue,decimal) end );   
          set cnt=cnt+1;        
     ELSE              
   LEAVE myloop;      
        END IF;    
         SET @Occurrences = LENGTH(@String) - LENGTH(REPLACE(@String, ',', '')); 
-- insert into testdebug values ('2');     
       IF (@occurrences = 0) THEN      
            LEAVE myloop;           
   END IF;            
 SET @String = SUBSTRING(@String,LENGTH(SUBSTRING_INDEX(@String, ',', 1))+2);      
   END WHILE;  


-- lg
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


myloop: WHILE (rint<@cnt)      
   DO  

select freq into @freq from t1 where id=rint; 
 -- SET @sql1 = CONCAT('insert into temppolar(user,test_id,angle,amp',rint+1,',freq',rint+1,')');
SET @sql1 = CONCAT('insert into temppolar(user,test_id,angle,amp',rint+1,',frequency)'); 
set @sql2= CONCAT('SELECT ''',usr,''', HD.Test_id,HD.Angle,HD.Amplitude,HD.Frequency FROM ',@tab,' HD where HD.Frequency=',@freq,' and HD.Test_id=',testid);  
set @s=CONCAT(@sql1,@sql2);  
        
PREPARE stmt1 FROM @s;  
EXECUTE stmt1;  
DEALLOCATE PREPARE stmt1;  
  set rint=rint+1;    
END WHILE;        
    drop table t1; 
 
 /* select test_id TestId,Angle,sum(amp1) Amplitude1,sum(freq1) frequency1,sum(amp2) Amplitude2,sum(freq2) frequency2,
sum(amp3) Amplitude3,sum(freq3) frequency3,sum(amp4) Amplitude4,sum(freq4) frequency4,
sum(amp5) Amplitude5,sum(freq5) frequency5 ,sum(amp6) Amplitude6,sum(freq6) frequency6,sum(amp7) Amplitude7,
sum(freq7) frequency7,sum(amp8) Amplitude8,sum(freq8) frequency8,sum(amp9) Amplitude9,sum(freq9) frequency9,
sum(amp10) Amplitude10,sum(freq10) frequency10 ,sum(amp11) Amplitude11,sum(freq11) frequency11,sum(amp12) Amplitude12,
sum(freq12) frequency12,sum(amp13) Amplitude13,sum(freq13) frequency13,sum(amp14) Amplitude14,sum(freq14) frequency4,
sum(amp15) Amplitude15,sum(freq15) frequency15, sum(amp16) Amplitude16,sum(freq16) frequency16,sum(amp17) Amplitude17,
sum(freq17) frequency17,sum(amp18) Amplitude18,sum(freq18) frequency18,sum(amp19) Amplitude19,sum(freq19) frequency19,
sum(amp20) Amplitude20,sum(freq20) frequency20
 from temppolar group by test_id,angle;  */

  select test_id TestId,Angle,sum(amp1) Amplitude1, frequency,sum(amp2) Amplitude2,
sum(amp3) Amplitude3,sum(amp4) Amplitude4,sum(amp5) Amplitude5 ,sum(amp6) Amplitude6,sum(amp7) Amplitude7,
sum(amp8) Amplitude8,sum(amp9) Amplitude9,sum(amp10) Amplitude10 ,sum(amp11) Amplitude11,sum(amp12) Amplitude12,
sum(amp13) Amplitude13,sum(amp14) Amplitude14,sum(amp15) Amplitude15, sum(amp16) Amplitude16,sum(amp17) Amplitude17,
sum(amp18) Amplitude18,sum(amp19) Amplitude19,sum(amp20) Amplitude20,strmaxvalue,strminvalue,@unt frequnit
 from temppolar where user=usr group by test_id,angle,frequency  ,strmaxvalue,strminvalue, frequnit
order by test_id,frequency,angle;  
END$$
