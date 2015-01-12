use Verdant

# ***************** func to calculate axial ratio ******************
DELIMITER $$
CREATE FUNCTION `calc_AxialRatio`(
test_id INT, freq decimal(20,10), degree INT
) RETURNS decimal(20,10)
BEGIN

# Axial Ratio =( HP – VP) at degree for freq

DECLARE AR decimal(20,10) default 0;

select axialRatio 
into AR
from axialratio_view
 where test_id = test_id and Frequency = freq and angle = degree;
 
RETURN AR;
END$$
DELIMITER ;
# ***************** func to calculate backlobe ******************
DELIMITER $$
CREATE FUNCTION `calc_backlobe`(
test_id INT, freq decimal(20,10), polType char(2)
) RETURNS decimal(20,10)
BEGIN

# A = Amplitude at 0 degree 
# B = Amplitude at 180 degree 
# Back Lobe = A-B

DECLARE backlobe decimal(20,10) default 0;
DECLARE Amp_0, Amp_180 decimal(20,10);

if polType = 'HP' then
	set Amp_0 = (select amplitude 
				from hdata 
				where test_id = test_id and Frequency = freq and angle = 360);
	set Amp_180 =(select amplitude 
					from hdata 
					where test_id = test_id and Frequency = freq and angle = 180);
	 
elseif polType = 'VP' then
	set Amp_0 = (select amplitude 
				from vdata 
				where test_id = test_id and Frequency = freq and angle = 360);
	set Amp_180 =(select amplitude 
					from vdata 
					where test_id = test_id and Frequency = freq and angle = 180);
else -- polType = 'CP' then
	set Amp_0 = (select amplitude 
				from cpdata 
				where test_id = test_id and Frequency = freq and angle = 360);
	set Amp_180 =(select amplitude 
					from cpdata 
					where test_id = test_id and Frequency = freq and angle = 180);

end if;

set backlobe = Amp_0 - Amp_180;

RETURN backlobe;

END$$
DELIMITER ;
# ***************** func to calculate cpdata ******************
DELIMITER $$
CREATE FUNCTION `calc_cpdata`(
test_id INT, freq decimal(20,10), angle decimal(20,10)
) RETURNS decimal(20,10)
BEGIN

declare A,B,C,D,E,cpdata decimal(20,10) default 0;

select amplitude into A from hdata h
 		 where h.test_id = test_id and h.Frequency = freq and h.angle = angle;
-- select A;
 select amplitude into B from vdata v
 		 where v.test_id = test_id and v.Frequency = freq and v.angle = angle; 
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
# ***************** func to calculate cp gain ******************
DELIMITER $$
CREATE FUNCTION `calc_cpgain`(
test_id INT, freq decimal(20,10), linearGain decimal(20,10)
) RETURNS decimal(20,10)
BEGIN
declare A, B, C, D, E, cpgain decimal(20,10);

select amplitude into A 
from vdata v 
where v.test_id = test_id and v.Frequency = freq and v.angle = 360; 

select amplitude into B 
from hdata h 
where h.test_id = test_id and h.Frequency = freq and h.angle = 360;

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
# ***************** func to calculate omni deviation ******************
DELIMITER $$
CREATE FUNCTION `calc_omni`(
test_id INT, freq decimal(20,10), polType char(2)
) RETURNS decimal(20,10)
BEGIN

#omni deviation = (Max - min)/2

DECLARE omni_dev decimal(20,10) default 0;

if polType = 'HP' then
	select ifnull((max(Amplitude)-min(Amplitude))/2,0) into omni_dev
	from hdata where test_id = test_id and Frequency = freq;
else -- polType = 'VP'
	select ifnull((max(Amplitude)-min(Amplitude))/2,0) into omni_dev
	from vdata where test_id = test_id and Frequency = freq;
end if;

RETURN omni_dev;
END$$
DELIMITER ;
# ***************** proc to calculate maximum axial ratio ******************
DELIMITER $$
CREATE PROCEDURE `calc_MaxDiffAxialRatio`(
test_id INT, freq decimal(20,10), P_or_M char(1),
OUT MaxdiffRatio decimal(20,10), 
OUT MaxdiffAngle decimal(20,10)
)
BEGIN
Declare i, currAngle, currRatio decimal(20,10);

if P_or_M = 'P' then
	
	select MAX(axialRatio) 
    into MaxdiffRatio
    from axialratio_view 
    where test_id = test_id and Frequency = freq 
    and ((angle >= 0 and angle <=45) or (angle = 360));
    
    
    select MAX(angle)
    into MaxdiffAngle
    from axialratio_view 
    where test_id = test_id and Frequency = freq and axialRatio = MaxdiffRatio;
    
    if MaxdiffAngle = 360 then
		set MaxdiffAngle = 0;
	end if;
    
else -- P_or_M ='M'

	select MAX(axialRatio) 
    into MaxdiffRatio
    from axialratio_view 
    where test_id = test_id and Frequency = freq 
    and angle >= 315 and angle <=360;
    
    
    select MAX(angle)
    into MaxdiffAngle
    from axialratio_view 
    where test_id = test_id and Frequency = freq and axialRatio = MaxdiffRatio;
    
    set MaxdiffAngle = MaxdiffAngle-360;
end if;

END$$
DELIMITER ;
# ***************** proc to calculate 3dB and 10dB BW and BS ******************
DELIMITER $$
CREATE PROCEDURE `calc_XdB_BW_BS`(
test_id INT, freq decimal(20,10), X INT, polType char(2), fromAngle char(2),
out beam_width decimal(20,10), out beam_squint decimal(20,10)
)
BEGIN
declare C,D,E,AminX,i,j decimal(20,10);

# ************************** HP ******************************
if polType = 'HP' then
set @tab = 'hdata';
elseif polType = 'VP' then
set @tab = 'vdata';
else 
set @tab = 'cpdata';
end if;

if fromAngle = 'BM' then
SET @s = CONCAT('select MAX(amplitude) into @A from ', @tab, ' where test_id = ',test_id,' and Frequency = ',freq);  
PREPARE stmt1 FROM @s; 
EXECUTE stmt1; 
DEALLOCATE PREPARE stmt1;
        
        SET @s = CONCAT('select MAX(angle) into @B from ', @tab, ' where test_id = ',test_id,' and Frequency = ',freq,' and amplitude = ',@A);  
PREPARE stmt1 FROM @s; 
EXECUTE stmt1; 
DEALLOCATE PREPARE stmt1;
elseif fromAngle = '0' then
SET @s = CONCAT('select amplitude, angle into @A,@B from ', @tab, 
' where test_id = ',test_id,' and Frequency = ',freq,
                        ' and angle = 360');  

PREPARE stmt1 FROM @s; 
EXECUTE stmt1; 
DEALLOCATE PREPARE stmt1;
        
else -- fromAngle = '90' then
        SET @s = CONCAT('select amplitude, angle into @A,@B from ', @tab, 
' where test_id = ',test_id,' and Frequency = ',freq,
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
        if i = 360.1 then 
set i = 0.1;
end if;
        
SET @s = CONCAT('select amplitude into @temp from ', @tab, 
' where test_id = ',test_id,' and Frequency = ',freq,
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
    
    set C= i;
    
    set j = @B-0.1;
   
    loop_left : while j <> @B do
        if j=0 then
set j=360;
end if;
        
        SET @s = CONCAT('select amplitude into @temp from ', @tab, 
' where test_id = ',test_id,' and Frequency = ',freq,
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
    
    set D= j;
    
    
set E = 360-D;
set beam_width = C+E;
set beam_squint = (C-E)/2;


END$$
DELIMITER ;
# ***************** proc to convert to CP data  ******************
DELIMITER $$
CREATE PROCEDURE `convert_to_CP`(
test_id INT, freq decimal(20,10)
)
BEGIN

-- delete existing data for that freq
delete from cpdata 
where test_id = test_id and frequency = freq;


insert into cpdata ( test_id, Frequency, Angle, Amplitude)

select test_id, Frequency, Angle, calc_cpdata(test_id, Frequency, Angle)
from hdata  
where test_id = test_id and frequency = freq;




END$$
DELIMITER ;
# ***************** proc to calculate antenna params ******************
DELIMITER $$
CREATE PROCEDURE `calculate`(
myTest_Id INT,
Polarization_type char(2), -- 'L'=linear, 'C'= circular
freq_unit char(1),
freq decimal(20,10),
linear_Gain decimal(20,10),
mytest_date datetime
 )
BEGIN


# Declarations -begin
-- DECLARE freq decimal(20,10);
-- DECLARE linear_Gain decimal(20,10);
-- DECLARE Test_Id INT;
-- Calculated params
DECLARE omni_HP,omni_VP decimal(20,10);
DECLARE _3dB_BW_HP_BM, _3dB_BW_VP_BM, _3dB_BW_CP_BM decimal(20,10);
DECLARE _3dB_BW_HP_0, _3dB_BW_VP_0, _3dB_BW_CP_0 decimal(20,10);
DECLARE _3dB_BW_HP_90, _3dB_BW_VP_90,_3dB_BW_CP_90 decimal(20,10);
DECLARE _3dB_BS_HP_BM, _3dB_BS_VP_BM, _3dB_BS_CP_BM decimal(20,10);
DECLARE _3dB_BS_HP_0, _3dB_BS_VP_0, _3dB_BS_CP_0 decimal(20,10);
DECLARE _3dB_BS_HP_90, _3dB_BS_VP_90, _3dB_BS_CP_90 decimal(20,10);
DECLARE _10dB_BW_HP_BM, _10dB_BW_VP_BM, _10dB_BW_CP_BM decimal(20,10);
DECLARE _10dB_BW_HP_0, _10dB_BW_VP_0, _10dB_BW_CP_0 decimal(20,10);
DECLARE _10dB_BW_HP_90, _10dB_BW_VP_90, _10dB_BW_CP_90 decimal(20,10);
DECLARE _10dB_BS_HP_BM, _10dB_BS_VP_BM, _10dB_BS_CP_BM decimal(20,10);
DECLARE _10dB_BS_HP_0, _10dB_BS_VP_0, _10dB_BS_CP_0 decimal(20,10);
DECLARE _10dB_BS_HP_90, _10dB_BS_VP_90, _10dB_BS_CP_90 decimal(20,10);
DECLARE backlobe_HP,backlobe_VP,backlobe_CP decimal(20,10);
DECLARE axial_0,axial_P45,axial_M45,AR_Maxdiff_P, AR_Maxdiff_M decimal(20,10);
DECLARE angle_Maxdiff_P, angle_Maxdiff_M decimal(20,10);
DECLARE CP_Gain decimal(20,10);

 -- for the cursor

  
 
-- Get the testId from file_Id
--  select Test_Id = Test_id from testfiles where file_id = file_Id ; 


        select freq;
	   #calculations - begin
       
       -- convert GHz to MHz for matching raw data 
	    if freq_unit = 'G' then
			set freq = freq*1000;
		end if;
       
		   # omni deviation (for linear polarization only)
		   IF Polarization_type = 'L' THEN
				-- Calculate Omni deviation for HP data and store
				select calc_omni(myTest_Id,freq,'HP') into omni_HP;
                
				-- Calculate Omni deviation for VP data and store
                select calc_omni(myTest_Id,freq,'VP') into omni_VP; 
		   END IF;
		   
		   # 3dB BW and BS, 10dB BW and BS
		   
		   -- Calculate 3dB Beam Width, Beam Squint for HP data for Beam Max and store
		    call calc_XdB_BW_BS(myTest_Id,freq,3,'HP','BM',_3dB_BW_HP_BM,_3dB_BS_HP_BM );
           
		   -- Calculate 3dB Beam Width, Beam Squint for HP data for 0 degree and store
		    call calc_XdB_BW_BS(myTest_Id,freq,3,'HP','0', _3dB_BW_HP_0, _3dB_BS_HP_0);
           
		   -- Calculate 3dB Beam Width, Beam Squint for HP data for 90 degree
		    call calc_XdB_BW_BS(myTest_Id,freq,3,'HP','90', _3dB_BW_HP_90, _3dB_BS_HP_90);
           
		   -- Calculate 3dB Beam Width, Beam Squint for VP data for Beam Max
		    call calc_XdB_BW_BS(myTest_Id,freq,3,'VP','BM', _3dB_BW_VP_BM, _3dB_BS_VP_BM);
           
		   -- Calculate 3dB Beam Width , Beam Squint for VP data for 0 degree
		    call calc_XdB_BW_BS(myTest_Id,freq,3,'VP','0', _3dB_BW_VP_0, _3dB_BS_VP_0);
           
		   -- Calculate 3dB Beam Width, Beam Squint for VP data for 90 degree
		    call calc_XdB_BW_BS(myTest_Id,freq,3,'VP','90', _3dB_BW_VP_90, _3dB_BS_VP_90);
            
		   -- Calculate 10dB Beam Width, Beam Squint for HP data for Beam Max
		    call calc_XdB_BW_BS(myTest_Id,freq,10,'HP','BM', _10dB_BW_HP_BM, _10dB_BS_HP_BM);
            
		   -- Calculate 10dB Beam Width, Beam Squint for HP data for 0 degree
		    call calc_XdB_BW_BS(myTest_Id,freq,10,'HP','0', _10dB_BW_HP_0, _10dB_BS_HP_0);
             
		   -- Calculate 10dB Beam Width, Beam Squint for HP data for 90 degree
		    call calc_XdB_BW_BS(myTest_Id,freq,10,'HP','90', _10dB_BW_HP_90, _10dB_BS_HP_90);
             
		  -- Calculate 10dB Beam Width, Beam Squint for VP data for Beam Max
		    call calc_XdB_BW_BS(myTest_Id,freq,10,'VP','BM', _10dB_BW_VP_BM, _10dB_BS_VP_BM);
            
		   -- Calculate 10dB Beam Width, Beam Squint for VP data for 0 degree
		    call calc_XdB_BW_BS(myTest_Id,freq,10,'VP','0', _10dB_BW_VP_0, _10dB_BS_VP_0);
             
		   -- Calculate 10dB Beam Width, Beam Squint for VP data for 90 degree
		    call calc_XdB_BW_BS(myTest_Id,freq,10,'VP','90', _10dB_BW_VP_90, _10dB_BS_VP_90);
		   
		   
		   IF Polarization_type = 'C' THEN -- (only for circular polarization)
		   
		   -- Calculate Back Lobe for HP data
		      select calc_Backlobe(myTest_Id,freq,'HP') into backlobe_HP;
           
		   -- Calculate Back Lobe for VP data
		      select calc_Backlobe(myTest_Id,freq,'VP') into backlobe_VP;
           
		   -- Calculate Axial ratio at 0 degree
			  select calc_AxialRatio(myTest_Id,freq,0) into axial_0;
              
		   -- Calculate Axial ratio at +45 degree
			  select calc_AxialRatio(myTest_Id,freq,45) into axial_P45;
            
              
		   -- Calculate Axial ratio at  -45 degree
		      select calc_AxialRatio(myTest_Id,freq,-45) into axial_M45;
           
		   -- Calculate Max-diff Axial ratio from 0 to +45 : Maximum Axial ratio from 0 to +45 degree
			  call calc_MaxDiffAxialRatio(myTest_Id, freq, 'P', AR_Maxdiff_P, angle_Maxdiff_P);
              
		   -- Calculate Max-diff Axial ratio from 0 to -45 : Maximum Axial ratio from 0 to -45 degree
		      call calc_MaxDiffAxialRatio(myTest_Id, freq, 'M', AR_Maxdiff_M, angle_Maxdiff_M);
              
		   -- for Circular polarization with correction
		   -- Obtain CP data from HP and VP data and store
			  call convert_to_CP(myTest_Id, freq);
              
		   -- Calculate 3dB Beam Width, Beam Squint  for CP data for Beam Max
		      call calc_XdB_BW_BS(myTest_Id,freq,3,'CP','BM', _3dB_BW_CP_BM, _3dB_BS_CP_BM);
            
		   -- Calculate 3dB Beam Width, Beam Squint  for CP data for 0 degree
			  call calc_XdB_BW_BS(myTest_Id,freq,3,'CP','0', _3dB_BW_CP_0, _3dB_BS_CP_0);
              
		   -- Calculate 3dB Beam Width, Beam Squint  for CP data for 90 degree
			  call calc_XdB_BW_BS(myTest_Id,freq,3,'CP','90', _3dB_BW_CP_90, _3dB_BS_CP_90);
              
		   -- Calculate 10dB Beam Width, Beam Squint  for CP data for Beam Max
			  call calc_XdB_BW_BS(myTest_Id,freq,10,'CP','BM', _10dB_BW_CP_BM, _10dB_BS_CP_BM);
              
		   -- Calculate 10dB Beam Width, Beam Squint  for CP data for 0 degree
			  call calc_XdB_BW_BS(myTest_Id,freq,10,'CP','0', _10dB_BW_CP_0, _10dB_BS_CP_0);
              
		   -- Calculate 10dB Beam Width, Beam Squint  for CP data for 90 degree
			  call calc_XdB_BW_BS(myTest_Id,freq,10,'CP','90', _10dB_BW_CP_90, _10dB_BS_CP_90);
              
		   -- Calculate Back Lobe for CP data
			  select calc_Backlobe(myTest_Id,freq,'CP') into backlobe_CP;
		   
		   -- Calculate CP Gain
			  select calc_cpgain(myTest_Id,freq,linear_Gain) into CP_Gain;
		  
		   END IF;
       	   
	   #Calculations - end
       
       #insert into calculated tables
       
       delete from hcalculated where Test_id = myTest_Id and Frequency = freq;
       delete from vcalculated where Test_id = myTest_Id and Frequency = freq;
       delete from arcalculated where Test_id = myTest_Id and Frequency = freq;
       delete from cpcalculated where Test_id = myTest_Id and Frequency = freq;
       
       if(Polarization_type = 'L') then
			insert into hcalculated(Test_id,Frequency,TestDate,OmniDeviation
								,3Db_BW_BMax,3Db_BW_0,3Db_BW_90
                                ,10Db_BW_BMax,10Db_BW_0,10Db_BW_90)
		   select myTest_Id,freq,myTest_date,omni_HP,
				_3dB_BW_HP_BM,_3dB_BW_HP_0,_3dB_BW_HP_90,
				_10dB_BW_HP_BM,_10dB_BW_HP_0,_10dB_BW_HP_90;
                
			insert into vcalculated(Test_id,Frequency,TestDate,OmniDeviation
								,3Db_BW_BMax,3Db_BW_0,3Db_BW_90
                                ,10Db_BW_BMax,10Db_BW_0,10Db_BW_90)
			select myTest_Id,freq,myTest_date,omni_VP,
				_3dB_BW_VP_BM,_3dB_BW_VP_0,_3dB_BW_VP_90,
				_10dB_BW_VP_BM,_10dB_BW_VP_0,_10dB_BW_VP_90;
                
		else -- polarization type = 'C'
				insert into hcalculated(Test_id,Frequency,TestDate,
								3Db_BW_BMax,3Db_BW_0,3Db_BW_90,3Db_BS_BMax,3Db_BS_0,3Db_BS_90,
                                10Db_BW_BMax,10Db_BW_0,10Db_BW_90,10Db_BS_BMax,10Db_BS_0,10Db_BS_90,
								BackLobe)
				select myTest_Id,freq,myTest_date,
				_3dB_BW_HP_BM,_3dB_BW_HP_0,_3dB_BW_HP_90,_3dB_BS_HP_BM,_3dB_BS_HP_0,_3dB_BS_HP_90,
				_10dB_BW_HP_BM,_10dB_BW_HP_0,_10dB_BW_HP_90,_10dB_BS_HP_BM,_10dB_BS_HP_0,_10dB_BS_HP_90,
                backlobe_HP;
                
                insert into vcalculated(Test_id,Frequency,TestDate,
				 			3Db_BW_BMax,3Db_BW_0,3Db_BW_90,3Db_BS_BMax,3Db_BS_0,3Db_BS_90,
                          10Db_BW_BMax,10Db_BW_0,10Db_BW_90,10Db_BS_BMax,10Db_BS_0,10Db_BS_90,
						BackLobe)
				 select myTest_Id,freq,myTest_date,
				 _3dB_BW_VP_BM,_3dB_BW_VP_0,_3dB_BW_VP_90,_3dB_BS_VP_BM,_3dB_BS_VP_0,_3dB_BS_VP_90,
				 _10dB_BW_VP_BM,_10dB_BW_VP_0,_10dB_BW_VP_90,_10dB_BS_VP_BM,_10dB_BS_VP_0,_10dB_BS_VP_90,
                 backlobe_VP;
                
                insert into arcalculated(Test_id,Frequency,TestDate,
										AR_0,AR_P45,AR_M45,MaxAR_P_Ratio,
                                        MaxAR_P_Angle,MaxAR_M_Ratio,MaxAR_M_Angle)
				select myTest_Id,freq,myTest_date,
				 		axial_0,axial_P45,axial_M45,
                         AR_Maxdiff_P,angle_Maxdiff_P, AR_Maxdiff_M, angle_Maxdiff_M; 
        
				insert into cpcalculated(Test_id,Frequency,TestDate,
				 				3Db_BW_BMax,3Db_BW_0,3Db_BW_90,3Db_BS_BMax,3Db_BS_0,3Db_BS_90,
                               10Db_BW_BMax,10Db_BW_0,10Db_BW_90,10Db_BS_BMax,10Db_BS_0,10Db_BS_90,
				 				BackLobe,CPGain)
				select myTest_Id,freq,myTest_date,
				 _3dB_BW_CP_BM,_3dB_BW_CP_0,_3dB_BW_CP_90,_3dB_BS_CP_BM,_3dB_BS_CP_0,_3dB_BS_CP_90,
				 _10dB_BW_CP_BM,_10dB_BW_CP_0,_10dB_BW_CP_90,_10dB_BS_CP_BM,_10dB_BS_CP_0,_10dB_BS_CP_90,
                 backlobe_CP,CP_Gain;
			
        end if;
            
     
END$$
DELIMITER ;
# ***************** Calculate procedure - starting point ******************
DELIMITER $$
CREATE PROCEDURE `Calculate_params`(
myTestId INT,
myPoltype char(2), -- 'L'=linear, 'C'= circular
myfrequnit char(1)
)
BEGIN

declare myfreq,mylinear_Gain decimal(20,10);
-- declare myTestId INT;
declare myTestDate datetime;
 -- for the cursor
DECLARE done INT DEFAULT 0;

 #declare cursor
 DECLARE cur CURSOR FOR 
 select Frequency, lineargain
 from testfreq t
 where t.Test_id = myTestId;

 #declare handle 
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
# Declarations -end

select TestDate into myTestDate 
from testdata where test_id = myTestId;

#open cursor
  OPEN cur;
  
  #starts the loop
  the_loop: LOOP
  
	  FETCH cur INTO myfreq,mylinear_Gain;
		IF done = 1 THEN
			LEAVE the_loop;
		END IF;
	    
   call calculate(myTestId,myPolType,myFreqUnit,myfreq,mylinear_Gain,myTestDate);
    
    END LOOP the_loop;
 
  CLOSE cur;
    

END$$
DELIMITER ;
