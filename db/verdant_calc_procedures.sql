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




DELIMITER $$
CREATE PROCEDURE `calc_CP`(
cpTestId INT,
cpFreq decimal(40,20),
cpTestDate datetime,
cpType char(4) -- DCP or CP
)
BEGIN
-- for direct CP and CP with conversion

# Declarations -begin
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

if cpType = 'CP' then
	
    
    select count(*) into hDataPresent from hdata where test_id = cpTestId and Frequency = cpFreq;
	select count(*) into vDataPresent from vdata where test_id = cpTestId and Frequency = cpFreq;
	
    if hDataPresent > 0 and vDataPresent > 0 then
		-- convert HP,VP to CP data
		call convert_to_CP(cpTestId, cpFreq);
        
        -- Calculate and store axial ratio
        -- Calculate Axial ratio at 0 degree
			  select calc_AxialRatio(cpTestId,cpFreq,0) into axial_0;
              
		   -- Calculate Axial ratio at +45 degree
			  select calc_AxialRatio(cpTestId,cpFreq,45) into axial_P45;
            
              
		   -- Calculate Axial ratio at  -45 degree
		      select calc_AxialRatio(cpTestId,cpFreq,-45) into axial_M45;
           
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
     end if;

end if;

select count(*) into cpDataPresent from cpdata where test_id = cpTestId and Frequency = cpFreq;

if cpDataPresent > 0 then
	
    -- calculate 3 db and 10 db BW & BS
			 -- Calculate 3dB Beam Width, Beam Squint for hp data for Beam Max and store
		    call calc_XdB_BW_BS(cpTestId,cpFreq,3,'CP','BM',_3dB_BW_CP_BM,_3dB_BS_CP_BM );
           
		   -- Calculate 3dB Beam Width, Beam Squint for hp data for 0 degree and store
		   call calc_XdB_BW_BS(cpTestId,cpFreq,3,'CP','0',_3dB_BW_CP_0,_3dB_BS_CP_0 );
           
		   -- Calculate 3dB Beam Width, Beam Squint for pitch data for 90 degree
		    call calc_XdB_BW_BS(cpTestId,cpFreq,3,'CP','90', _3dB_BW_CP_90, _3dB_BS_CP_90);
           
		        
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for Beam Max
		    call calc_XdB_BW_BS(cpTestId,cpFreq,10,'CP','BM', _10dB_BW_CP_BM, _10dB_BS_CP_BM);
            
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for 0 degree
		    call calc_XdB_BW_BS(cpTestId,cpFreq,10,'CP','0', _10dB_BW_CP_0, _10dB_BS_CP_0);
            
		   -- Calculate 10dB Beam Width, Beam Squint for Pitch data for 90 degree
		     call calc_XdB_BW_BS(cpTestId,cpFreq,10,'CP','90', _10dB_BW_CP_90, _10dB_BS_CP_90);
            
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

end if;	
END$$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE `calc_Linear_Azimuth`(
laTestId INT,
laFreq decimal(40,20),
laTestDate datetime
)
BEGIN

# Declarations -begin
DECLARE omni_Y decimal(40,20);

DECLARE yawDataPresent INT default 0;

# Declarations -end

select count(*) into yawDataPresent from yawdata where test_id = laTestId and Frequency = laFreq;
	
if yawDataPresent > 0 then
		-- calculate omni deviation
			select calc_omni(laTestId,laFreq,'Y') into omni_Y;
            
		-- insert into yawCalculated table
             delete from yawCalculated where Test_id = laTestId and Frequency = laFreq;
			 insert into yawCalculated(Test_id,Frequency,TestDate,OmniDeviation)
								select laTestId,laFreq,laTestDate,omni_Y;
end if;



END$$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE `calc_Linear_Elevation`(
leTestId INT,
leFreq decimal(40,20),
leTestDate datetime
)
BEGIN

# Declarations -begin
DECLARE _3dB_BW_P_BM, _3dB_BW_R_BM decimal(40,20);
DECLARE _3dB_BW_P_0, _3dB_BW_R_0 decimal(40,20);
DECLARE _3dB_BW_P_90, _3dB_BW_R_90 decimal(40,20);
DECLARE _10dB_BW_P_BM, _10dB_BW_R_BM decimal(40,20);
DECLARE _10dB_BW_P_0, _10dB_BW_R_0 decimal(40,20);
DECLARE _10dB_BW_P_90, _10dB_BW_R_90 decimal(40,20);
DECLARE dummyBS decimal(40,20);

DECLARE pitchDataPresent INT default 0;
DECLARE rollDataPresent INT default 0;

# Declarations -end

select count(*) into pitchDataPresent from pitchdata where test_id = leTestId and Frequency = leFreq;
select count(*) into rollDataPresent from rolldata where test_id = leTestId and Frequency = leFreq;

-- pitch data calculations	
if pitchDataPresent > 0 then
		-- calculate 3 db and 10 db BW
			 -- Calculate 3dB Beam Width, Beam Squint for pitch data for Beam Max and store
		    call calc_XdB_BW_BS(leTestId,leFreq,3,'P','BM',_3dB_BW_P_BM,dummyBS );
           
		   -- Calculate 3dB Beam Width, Beam Squint for Pitch data for 0 degree and store
		   call calc_XdB_BW_BS(leTestId,leFreq,3,'P','0',_3dB_BW_P_0,dummyBS );
           
		   -- Calculate 3dB Beam Width, Beam Squint for pitch data for 90 degree
		    call calc_XdB_BW_BS(leTestId,leFreq,3,'P','90', _3dB_BW_P_90, dummyBS);
           
		        
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
end if;

-- roll data calculations
if rollDataPresent > 0 then
		-- calculate 3 db and 10 db BW
			 -- Calculate 3dB Beam Width, Beam Squint for roll data for Beam Max and store
		    call calc_XdB_BW_BS(leTestId,leFreq,3,'R','BM',_3dB_BW_R_BM,dummyBS );
           
		   -- Calculate 3dB Beam Width, Beam Squint for roll data for 0 degree and store
		   call calc_XdB_BW_BS(leTestId,leFreq,3,'R','0',_3dB_BW_R_0,dummyBS );
           
		   -- Calculate 3dB Beam Width, Beam Squint for roll data for 90 degree
		    call calc_XdB_BW_BS(leTestId,leFreq,3,'R','90', _3dB_BW_R_90, dummyBS);
           
		        
		   -- Calculate 10dB Beam Width, Beam Squint for roll data for Beam Max
		    call calc_XdB_BW_BS(leTestId,leFreq,10,'R','BM', _10dB_BW_R_BM, dummyBS);
            
		   -- Calculate 10dB Beam Width, Beam Squint for roll data for 0 degree
		    call calc_XdB_BW_BS(leTestId,leFreq,10,'R','0', _10dB_BW_R_0, dummyBS);
            
		   -- Calculate 10dB Beam Width, Beam Squint for roll data for 90 degree
		     call calc_XdB_BW_BS(leTestId,leFreq,10,'R','90', _10dB_BW_R_90, dummyBS);
            
		 
            
		-- insert into pitchCalculated table
             delete from rollCalculated where Test_id = leTestId and Frequency = leFreq;
			 insert into rollCalculated(Test_id,Frequency,TestDate
								,3Db_BW_BMax,3Db_BW_0,3Db_BW_90
                                ,10Db_BW_BMax,10Db_BW_0,10Db_BW_90)
		   select leTestId,leFreq,leTestDate,
				_3dB_BW_R_BM,_3dB_BW_R_0,_3dB_BW_R_90,
				_10dB_BW_R_BM,_10dB_BW_R_0,_10dB_BW_R_90;
end if;


END$$
DELIMITER ;



DELIMITER $$
CREATE  PROCEDURE `calc_MaxDiffAxialRatio`(
mdtest_id INT, freq decimal(40,20), P_or_M char(1),
OUT MaxdiffRatio decimal(40,20), 
OUT MaxdiffAngle decimal(40,20)
)
BEGIN
Declare i, currAngle, currRatio decimal(40,20);

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
    
    -- if MaxdiffAngle = 360 then
-- set MaxdiffAngle = 0;
-- end if;
    
else -- P_or_M ='M'

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

END$$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE `calc_Slant_Azimuth`(
saTestId INT,
saFreq decimal(40,20),
saTestDate datetime
)
BEGIN
# Declarations -begin
DECLARE omni_HP decimal(40,20);
DECLARE omni_VP decimal(40,20);

DECLARE hDataPresent INT default 0;
DECLARE vDataPresent INT default 0;

# Declarations -end

select count(*) into hDataPresent from hdata where test_id = saTestId and Frequency = saFreq;
select count(*) into vDataPresent from vdata where test_id = saTestId and Frequency = saFreq;

	
if hDataPresent > 0 then
		-- calculate omni deviation
			select calc_omni(saTestId,saFreq,'HP') into omni_HP;
            
		-- insert into hCalculated table
             delete from hcalculated where Test_id = saTestId and Frequency = saFreq;
			 insert into hcalculated(Test_id,Frequency,TestDate,OmniDeviation)
								select saTestId,saFreq,saTestDate,omni_HP;
end if;

if vDataPresent > 0 then
		-- calculate omni deviation
			select calc_omni(saTestId,saFreq,'VP') into omni_VP;
            
		-- insert into vCalculated table
             delete from vcalculated where Test_id = saTestId and Frequency = saFreq;
			 insert into vcalculated(Test_id,Frequency,TestDate,OmniDeviation)
								select saTestId,saFreq,saTestDate,omni_VP;
end if;


END$$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE `calc_Slant_Elevation`(
seTestId INT,
seFreq decimal(40,20),
seTestDate datetime
)
BEGIN
-- same for cp without conversion

# Declarations -begin
DECLARE _3dB_BW_HP_BM, _3dB_BW_VP_BM decimal(40,20);
DECLARE _3dB_BW_HP_0, _3dB_BW_VP_0 decimal(40,20);
DECLARE _3dB_BW_HP_90, _3dB_BW_VP_90 decimal(40,20);
DECLARE _10dB_BW_HP_BM, _10dB_BW_VP_BM decimal(40,20);
DECLARE _10dB_BW_HP_0, _10dB_BW_VP_0 decimal(40,20);
DECLARE _10dB_BW_HP_90, _10dB_BW_VP_90 decimal(40,20);
DECLARE _3dB_BS_HP_BM, _3dB_BS_VP_BM decimal(40,20);
DECLARE _3dB_BS_HP_0, _3dB_BS_VP_0 decimal(40,20);
DECLARE _3dB_BS_HP_90, _3dB_BS_VP_90 decimal(40,20);
DECLARE _10dB_BS_HP_BM, _10dB_BS_VP_BM decimal(40,20);
DECLARE _10dB_BS_HP_0, _10dB_BS_VP_0 decimal(40,20);
DECLARE _10dB_BS_HP_90, _10dB_BS_VP_90 decimal(40,20);
DECLARE backlobe_HP,backlobe_VP decimal(40,20);
DECLARE axial_0,axial_P45,axial_M45,AR_Maxdiff_P, AR_Maxdiff_M decimal(40,20);
DECLARE angle_Maxdiff_P, angle_Maxdiff_M decimal(40,20);


DECLARE hDataPresent INT default 0;
DECLARE vDataPresent INT default 0;

# Declarations -end

select count(*) into hDataPresent from hdata where test_id = seTestId and Frequency = seFreq;
select count(*) into vDataPresent from vdata where test_id = seTestId and Frequency = seFreq;

-- h data calculations	
if hDataPresent > 0 then
		-- calculate 3 db and 10 db BW & BS
			 -- Calculate 3dB Beam Width, Beam Squint for hp data for Beam Max and store
		    call calc_XdB_BW_BS(seTestId,seFreq,3,'HP','BM',_3dB_BW_HP_BM,_3dB_BS_HP_BM );
           
		   -- Calculate 3dB Beam Width, Beam Squint for hp data for 0 degree and store
		   call calc_XdB_BW_BS(seTestId,seFreq,3,'HP','0',_3dB_BW_HP_0,_3dB_BS_HP_0 );
           
		   -- Calculate 3dB Beam Width, Beam Squint for pitch data for 90 degree
		    call calc_XdB_BW_BS(seTestId,seFreq,3,'HP','90', _3dB_BW_HP_90, _3dB_BS_HP_90);
           
		        
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for Beam Max
		    call calc_XdB_BW_BS(seTestId,seFreq,10,'HP','BM', _10dB_BW_HP_BM, _10dB_BS_HP_BM);
            
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for 0 degree
		    call calc_XdB_BW_BS(seTestId,seFreq,10,'HP','0', _10dB_BW_HP_0, _10dB_BS_HP_0);
            
		   -- Calculate 10dB Beam Width, Beam Squint for Pitch data for 90 degree
		     call calc_XdB_BW_BS(seTestId,seFreq,10,'HP','90', _10dB_BW_HP_90, _10dB_BS_HP_90);
            
		  -- Calculate Back Lobe for HP data
			  select calc_Backlobe(seTestId,seFreq,'HP') into backlobe_HP;
		   
         
            
		-- insert into pitchCalculated table
             delete from hcalculated where Test_id =seTestId and Frequency = seFreq;
			 insert into hcalculated(Test_id,Frequency,TestDate
								,3Db_BW_BMax,3Db_BW_0,3Db_BW_90
                                ,10Db_BW_BMax,10Db_BW_0,10Db_BW_90
                                ,3Db_BS_BMax,3Db_BS_0,3Db_BS_90
                                ,10Db_BS_BMax,10Db_BS_0,10Db_BS_90
                                ,BackLobe)
		   select seTestId,seFreq,seTestDate,
				_3dB_BW_HP_BM,_3dB_BW_HP_0,_3dB_BW_HP_90,
				_10dB_BW_HP_BM,_10dB_BW_HP_0,_10dB_BW_HP_90,
                _3dB_BS_HP_BM,_3dB_BS_HP_0,_3dB_BS_HP_90,
				_10dB_BS_HP_BM,_10dB_BS_HP_0,_10dB_BS_HP_90,
                backlobe_HP;
end if;

-- v data calculations	
if vDataPresent > 0 then
		-- calculate 3 db and 10 db BW & BS
			 -- Calculate 3dB Beam Width, Beam Squint for hp data for Beam Max and store
		    call calc_XdB_BW_BS(seTestId,seFreq,3,'VP','BM',_3dB_BW_VP_BM,_3dB_BS_VP_BM );
           
		   -- Calculate 3dB Beam Width, Beam Squint for hp data for 0 degree and store
		   call calc_XdB_BW_BS(seTestId,seFreq,3,'VP','0',_3dB_BW_VP_0,_3dB_BS_VP_0 );
           
		   -- Calculate 3dB Beam Width, Beam Squint for pitch data for 90 degree
		    call calc_XdB_BW_BS(seTestId,seFreq,3,'VP','90', _3dB_BW_VP_90, _3dB_BS_VP_90);
           
		        
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for Beam Max
		    call calc_XdB_BW_BS(seTestId,seFreq,10,'VP','BM', _10dB_BW_VP_BM, _10dB_BS_VP_BM);
            
		   -- Calculate 10dB Beam Width, Beam Squint for pitch data for 0 degree
		    call calc_XdB_BW_BS(seTestId,seFreq,10,'VP','0', _10dB_BW_VP_0, _10dB_BS_VP_0);
            
		   -- Calculate 10dB Beam Width, Beam Squint for Pitch data for 90 degree
		     call calc_XdB_BW_BS(seTestId,seFreq,10,'VP','90', _10dB_BW_VP_90, _10dB_BS_VP_90);
            
		  -- Calculate Back Lobe for HP data
			  select calc_Backlobe(seTestId,seFreq,'VP') into backlobe_VP;
		   
         
            
		-- insert into pitchCalculated table
             delete from vcalculated where Test_id =seTestId and Frequency = seFreq;
			 insert into vcalculated(Test_id,Frequency,TestDate
								,3Db_BW_BMax,3Db_BW_0,3Db_BW_90
                                ,10Db_BW_BMax,10Db_BW_0,10Db_BW_90
                                ,3Db_BS_BMax,3Db_BS_0,3Db_BS_90
                                ,10Db_BS_BMax,10Db_BS_0,10Db_BS_90
                                ,BackLobe)
		   select seTestId,seFreq,seTestDate,
				_3dB_BW_VP_BM,_3dB_BW_VP_0,_3dB_BW_VP_90,
				_10dB_BW_VP_BM,_10dB_BW_VP_0,_10dB_BW_VP_90,
                _3dB_BS_VP_BM,_3dB_BS_VP_0,_3dB_BS_VP_90,
				_10dB_BS_VP_BM,_10dB_BS_VP_0,_10dB_BS_VP_90,
                backlobe_VP;
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
        
end if;
END$$
DELIMITER ;





DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `calc_XdB_BW_BS`(
xtest_id INT, freq decimal(40,20), X INT, polType char(2), fromAngle char(2),
out beam_width decimal(40,20), out beam_squint decimal(40,20)
)
BEGIN
declare C,D,E,AminX,i,j decimal(40,20);

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
        -- select @s;
        
PREPARE stmt1 FROM @s; 
EXECUTE stmt1; 
DEALLOCATE PREPARE stmt1;
        
        SET @s = CONCAT('select MAX(angle) into @B from ', @tab, ' where test_id = ',xtest_id,' and Frequency = ',freq,' and amplitude = ',@A);  
        -- select @s;
        
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
  
    set i = @B+0.1;
   
    loop_right : while i <> @B do
        if i = 360 then 
set i = 0;
            if i = @B then
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
        
end while;
    
    if i <> @B then
set C= i;
end if;
    
    set j = @B-0.1;
   
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
end while;
    
    
    if j <> @B then
set D= j;
end if;
    
    
    
set E = 360-D;
set beam_width = C+E;
set beam_squint = (C-E)/2;

END$$

DELIMITER ;




DELIMITER $$
USE `verdant`$$

CREATE PROCEDURE `Calculate_params`(
myTestId INT,
-- myFreqUnit char(1), -- 'M' = MHz, 'G' = GHz
myPoltype char(2) -- 'L'=linear, 'C'= circular
)
BEGIN

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
# Declarations -end

select TestDate,testType into myTestDate,myTestType 
from testdata where test_id = myTestId;

#open cursor
  OPEN cur;
  
  #starts the loop
  the_loop: LOOP
  
 FETCH cur INTO myfreq; -- ,mylinear_Gain;
IF done = 1 THEN
LEAVE the_loop;
END IF;
   
    -- call calculate(myTestId,myPolType,myfreq,mylinear_Gain,myTestDate,myFreqUnit);
   
-- conv GHz to MHz - REMOVED AS IT IS NOT REQUIRED, only M supported
-- if myFreqUnit = 'G' then
-- set myfreq = myfreq*1000;
-- end if;
        
#calculations - begin
-- Linear Azimuth
  IF ( myPolType = 'L' and myTestType = 'A') THEN
call calc_Linear_Azimuth(myTestId,myfreq,myTestDate);
-- Linear Elevation
  elseif ( myPolType = 'L' and myTestType = 'E') THEN
call calc_Linear_Elevation(myTestId,myfreq,myTestDate);
-- Slant Azimuth
  elseif ( myPolType = 'S' and myTestType = 'A') THEN
call calc_Slant_Azimuth(myTestId,myfreq,myTestDate);
-- Slant Elevation
  elseif ( myPolType = 'S' and myTestType = 'E') THEN
call calc_Slant_Elevation(myTestId,myfreq,myTestDate);
-- Circular - No conversion
  elseif ( myPolType = 'C' and myTestType = 'NCP') THEN
-- reports of NCP and Slant-Elevation are the same
call calc_Slant_Elevation(myTestId,myfreq,myTestDate);
-- Circular - CP with conversion / Direct-CP
  else -- Polarization_type = 'C' and testType = 'DCP'/'CP'
call calc_CP(myTestId,myfreq,myTestDate,myTestType);
           END IF;
  #Calculations - end
    
    END LOOP the_loop;
 
  CLOSE cur;
    

END$$

DELIMITER ;




DELIMITER $$
USE `verdant`$$
CREATE PROCEDURE `convert_to_CP`(
ctest_id INT, freq decimal(40,20)
)
BEGIN

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
CREATE FUNCTION `calc_AxialRatio`(
atest_id INT, freq decimal(40,20), degree INT
) RETURNS decimal(40,20)
BEGIN

# Axial Ratio =( HP � VP) at degree for freq

DECLARE AR decimal(40,20) default 0;

-- if degree = 0 then 
-- 	set degree = 360;
--  else
if degree = -45 then
	set degree = 315;
end if;

select axialRatio 
into AR
from axialratio_view
 where test_id = atest_id and Frequency = freq and angle = degree;
 
RETURN AR;
END$$
DELIMITER ;



DELIMITER $$
CREATE FUNCTION `calc_backlobe`(
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
CREATE FUNCTION `calc_cpdata`(
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

set E = 20 * LOG((D+1)/(1.414*D));
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
CREATE FUNCTION `calc_cpgain`(
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

set E = 20 * LOG((D+1)/(1.414*D));

set cpgain = linearGain+E;

RETURN cpgain;
END$$
DELIMITER ;



DELIMITER $$
CREATE FUNCTION `calc_omni`(
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
 
CREATE  PROCEDURE `spCalCPGain`(
testid INT
)
BEGIN
 
DECLARE v_finished INTEGER DEFAULT 0;
Declare v_freq decimal(40,20);
Declare v_lg decimal(40,20);
Declare v_cpgain decimal(40,20); 
declare cnt int;
DECLARE C1 CURSOR FOR select distinct Frequency,lineargain from testfreq where test_id=testid;
 
-- declare NOT FOUND handler
DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET v_finished = 1;
 
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

CREATE  PROCEDURE `spGetPolarPlot`(
testid INT,
freqparm decimal(40,20),
typ varchar(5), -- H HP,V VP,B HP&VP,P Pitch,R Roll ,Y Yaw
lg decimal(40,20)
)
BEGIN
DECLARE ampl decimal(40,20) default 0;
DECLARE vampl decimal(40,20) default 0;
declare lgampl decimal(40,20) default 0;
declare strmaxvalue varchar(50);
declare strminvalue varchar(50);

declare cnt int ;
declare unt varchar(10);
declare freq decimal(40,20);
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
        select convert(round(max(Amplitude),0),char(30)) into strmaxvalue FROM hdata HD 
		where HD.Frequency= freq and HD.Test_id=testid;
		select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM hdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
end if;
        SELECT HD.Angle,HD.Amplitude,case unt when 'GHz' then HD.Frequency/1000 else  HD.Frequency end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM hdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;

		end if;
		if typ='V' then
if cnt=0 then
		select convert(round(max(Amplitude),0),char(30)) into strmaxvalue FROM vdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM vdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
end if;
		SELECT HD.Angle,HD.Amplitude,case unt when 'GHz' then HD.Frequency/1000 else  HD.Frequency end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM vdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;

		end if;
		if typ='C' then
if cnt=0 then
        select convert(round(max(Amplitude),0),char(30)) into strmaxvalue FROM cpdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM cpdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
end if;
		SELECT HD.Angle,HD.Amplitude,case unt when 'GHz' then HD.Frequency/1000 else  HD.Frequency end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM cpdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		end if;
		if typ='B' then
if cnt=0 then
        select convert(round(max(Amplitude),0),char(30)) into strmaxvalue FROM hdata HD 
		where HD.Frequency=freq and HD.Test_id=testid ;
		select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM hdata HD 
		where HD.Frequency=freq and HD.Test_id=testid ;
end if;	
        select test_id, Frequency,angle,sum(hamplitude) hamplitude,sum(vamplitude) vamplitude,strmaxvalue,strminvalue 
		from vw_polardata where Frequency  =freqparm and Test_id=testid 
        group by test_id,frequency,angle,strmaxvalue,strminvalue;
		end if;
		if  typ='P' then
if cnt=0 then
        select convert(round(max(Amplitude),0),char(30)) into strmaxvalue FROM pitchdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM pitchdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
end if;
		SELECT HD.Angle,HD.Amplitude,case unt when 'GHz' then HD.Frequency/1000 else  HD.Frequency end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM pitchdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		end if;
		if typ='R' then
if cnt=0 then
        select convert(round(max(Amplitude),0),char(30)) into strmaxvalue FROM rolldata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM rolldata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
end if;
		SELECT HD.Angle,HD.Amplitude,case unt when 'GHz' then HD.Frequency/1000 else  HD.Frequency end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM rolldata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		end if;
		if typ='Y' then 
if cnt=0 then
        select convert(round(max(Amplitude),0),char(30)) into strmaxvalue FROM yawdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		select convert(round(min(Amplitude),0),char(30)) into strminvalue FROM yawdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
end if;
		SELECT HD.Angle,HD.Amplitude,case unt when 'GHz' then HD.Frequency/1000 else  HD.Frequency end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM yawdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		end if;
end if;
 if lg!=0.0001 then
		if typ='H' then
		SELECT HD.Amplitude into ampl FROM hdata HD 
		where HD.Frequency=freq and HD.Test_id=testid and angle=0;
if cnt=0 then
        select convert(round(max(Amplitude),0),char(30)) into strmaxvalue from(
        SELECT HD.Amplitude-ampl+lg Amplitude FROM hdata HD 
		where HD.Frequency=freq and HD.Test_id=testid) as tab;

        select convert(round(min(Amplitude),0),char(30)) into strminvalue from(
        SELECT HD.Amplitude-ampl+lg Amplitude FROM hdata HD 
		where HD.Frequency=freq and HD.Test_id=testid) as tab;
end if;
		SELECT HD.Angle,HD.Amplitude-ampl+lg Amplitude,case unt when 'GHz' then HD.Frequency/1000 else  HD.Frequency end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM hdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		end if;
		if typ='V' then
        SELECT HD.Amplitude into ampl FROM vdata HD 
		where HD.Frequency=freq and HD.Test_id=testid and angle=0;
if cnt=0 then
        select convert(round(max(Amplitude),0),char(30)) into strmaxvalue from(
        SELECT HD.Amplitude-ampl+lg Amplitude FROM vdata HD 
		where HD.Frequency=freq and HD.Test_id=testid) as tab;

        select convert(round(min(Amplitude),0),char(30)) into strminvalue from(
        SELECT HD.Amplitude-ampl+lg Amplitude FROM vdata HD 
		where HD.Frequency=freq and HD.Test_id=testid) as tab;
end if;
		SELECT HD.Angle,HD.Amplitude-ampl+lg Amplitude,case unt when 'GHz' then HD.Frequency/1000 else  HD.Frequency end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM vdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		end if;
        if typ='C' then

        select calc_cpgain(testid,testid,lg) into lgampl;
        -- update testfreq set lineargain =lg where test_id=testid and frequency=freq;
        SELECT HD.Amplitude into ampl FROM cpdata HD 
		where HD.Frequency=freq and HD.Test_id=testid and angle=0;
if cnt=0 then
        select convert(round(max(Amplitude),0),char(30)) into strmaxvalue from(
        SELECT HD.Amplitude-ampl+lgampl Amplitude FROM cpdata HD 
		where HD.Frequency=freq and HD.Test_id=testid) as tab;

        select convert(round(min(Amplitude),0),char(30)) into strminvalue from(
        SELECT HD.Amplitude-ampl+lgampl Amplitude FROM cpdata HD 
		where HD.Frequency=freq and HD.Test_id=testid) as tab;
end if;
        
		SELECT HD.Angle,HD.Amplitude-ampl+lgampl Amplitude,case unt when 'GHz' then HD.Frequency/1000 else  HD.Frequency end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM cpdata HD 
		where HD.Frequency=testid and HD.Test_id=testid;
		end if;
		if typ='B' then
        SELECT HD.Amplitude into ampl FROM hdata HD 
		where HD.Frequency=freq and HD.Test_id=testid and angle=0;
        SELECT HD.Amplitude into vampl FROM vdata HD 
		where HD.Frequency=freq and HD.Test_id=testid and angle=0;
if cnt=0 then
		select convert(round(max(Amplitude-ampl+lg),0),char(30)) into strmaxvalue from hdata HD 
		where HD.Frequency=freq and HD.Test_id=testid ;
        
        select convert(round(min(Amplitude-ampl+lg),0),char(30)) into strminvalue from hdata HD 
		where HD.Frequency=freq and HD.Test_id=testid ;
   end if;     
       /*select convert(round(max(Amplitude),0),char(30)) into strmaxvalue from 
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


		select test_id, Frequency,angle,sum(hamplitude)-ampl+lg hamplitude,sum(vamplitude)-vampl+lg vamplitude,strmaxvalue,strminvalue 
		from vw_polardata where Frequency=freqparm and Test_id=testid group by test_id,frequency,angle,strmaxvalue,strminvalue;
		end if;		

		if  typ='P' then
		SELECT HD.Amplitude into ampl FROM pitchdata HD 
		where HD.Frequency=freq and HD.Test_id=testid and angle=0;
if cnt=0 then
        select convert(round(max(Amplitude),0),char(30)) into strmaxvalue from(
        SELECT HD.Amplitude-ampl+lg Amplitude FROM pitchdata HD 
		where HD.Frequency=freq and HD.Test_id=testid) as tab;

        select convert(round(min(Amplitude),0),char(30)) into strminvalue from(
        SELECT HD.Amplitude-ampl+lg Amplitude FROM pitchdata HD 
		where HD.Frequency=freq and HD.Test_id=testid) as tab;
end if;
		SELECT HD.Angle,HD.Amplitude-ampl+lg Amplitude,case unt when 'GHz' then HD.Frequency/1000 else  HD.Frequency end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM pitchdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		end if;
		if typ='R' then
		SELECT HD.Amplitude into ampl FROM rolldata HD 
		where HD.Frequency=freq and HD.Test_id=testid and angle=0;
if cnt=0 then
        select convert(round(max(Amplitude),0),char(30)) into strmaxvalue from(
        SELECT HD.Amplitude-ampl+lg Amplitude FROM rolldata HD 
		where HD.Frequency=freq and HD.Test_id=testid) as tab;

        select convert(round(min(Amplitude),0),char(30)) into strminvalue from(
        SELECT HD.Amplitude-ampl+lg Amplitude FROM rolldata HD 
		where HD.Frequency=freq and HD.Test_id=testid) as tab;
end if;
		SELECT HD.Angle,HD.Amplitude-ampl+lg Amplitude,case unt when 'GHz' then HD.Frequency/1000 else  HD.Frequency end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM rolldata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		end if;
		if typ='Y' then
		SELECT HD.Amplitude into ampl FROM yawdata HD 
		where HD.Frequency=freq and HD.Test_id=testid and angle=0;
if cnt=0 then
        select convert(round(max(Amplitude),0),char(30)) into strmaxvalue from(
        SELECT HD.Amplitude-ampl+lg Amplitude FROM yawdata HD 
		where HD.Frequency=freq and HD.Test_id=testid) as tab;

        select convert(round(min(Amplitude),0),char(30)) into strminvalue from(
        SELECT HD.Amplitude-ampl+lg Amplitude FROM yawdata HD 
		where HD.Frequency=freq and HD.Test_id=testid) as tab;
end if;
		 SELECT HD.Angle,HD.Amplitude-ampl+lg Amplitude,case unt when 'GHz' then HD.Frequency/1000 else  HD.Frequency end Frequency,HD.Test_id,strmaxvalue,strminvalue FROM yawdata HD 
		where HD.Frequency=freq and HD.Test_id=testid;
		end if;

end if;



END $$



DELIMITER;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE  PROCEDURE `calc_tracking`(
myProdSerialList varchar(200), -- eg: "1,2,3,4"
amp_or_phase char(1), -- 'A' = amp, 'P' = phase
out maxDiff decimal(40,20),
out maxFreq decimal(40,20)
)
BEGIN

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
END $$
DELIMITER;


-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE  PROCEDURE `spGetPolarSummary`(
testid INT,
freqparm decimal(40,10),
typ varchar(5) -- H HP,V VP,B HP&VP,P Pitch,R Roll ,Y Yaw

)
BEGIn
declare prec int;
declare freq decimal(40,20);
declare unt varchar(10);
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
        
END $$

