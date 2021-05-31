--Load the data assigning it data strucrues 
data = LOAD 'unsd.csv' USING PigStorage(',') AS (Country:chararray,Year:int,Area:chararray,Sex:chararray,City:chararray,
				City_type:chararray,Record_type:chararray,Reliability:chararray,
				Source_year:int,Value:int,Value_footnotes:int);

--I select the Country, Year, Sex and Value column data from the whole data and use the Distinct function to remove duplicates
population = DISTINCT (FOREACH data GENERATE Country, Year, Sex, Value);

--i Group the new data "population" in relation to Country and year
group_population = GROUP population BY (Country, Year);

--i filter the groupdata by the sex and summmed the diffferent population values for the male and female
--i now calculated for the ration of the female to male by diving the sum values
MFratio = FOREACH group_population {male = FILTER population  by Sex == 'Male';SumMale = SUM(male.Value);
				female = FILTER population  by Sex == 'Female';SumFemale = SUM(female.Value);
   				GENERATE group, (float) SumFemale / (float) SumMale AS count;}

--Order result in Ascending order
result = ORDER MFratio BY count ASC;

--Store R=Long Result in a text file
STORE result  INTO 'threesult.txt' using PigStorage(';');

--show result
DUMP result;
