-- functions
DROP function IF EXISTS `calc_AxialRatio`;
-- procedures
DROP procedure IF EXISTS `calc_MaxDiffAxialRatio`;
DROP procedure IF EXISTS `calc_Circular_NCP`;
DROP procedure IF EXISTS `Calculate_params`;

-- functions
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

-- procedures
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





