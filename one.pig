--Load the data assigning it data strucrues 
data = LOAD 'unsd.csv' USING PigStorage(',') AS (Country:chararray,Year:int,Area:chararray,Sex:chararray,City:chararray,
				City_type:chararray,Record_type:chararray,Reliability:chararray,
				Source_year:int,Value:int,Value_footnotes:int);

--I select the country column data from the whole data and use the Distinct function to remove duplicates
countries = DISTINCT(FOREACH data GENERATE Country);

--Group the countries data 
c_group = GROUP countries ALL;

--use the count function to count the number of distinct countries in the data set
noCountry = FOREACH c_group GENERATE COUNT(countries) as count;

--show the result 
DUMP noCountry;
