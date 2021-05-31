--Load the data assigning it data strucrues 
data = LOAD 'unsd.csv' USING PigStorage(',') AS (Country:chararray,Year:int,Area:chararray,Sex:chararray,City:chararray,
				City_type:chararray,Record_type:chararray,Reliability:chararray,
				Source_year:int,Value:int,Value_footnotes:int);

--I select the country and city column data from the whole data and use the Distinct function to remove duplicates
countries = DISTINCT(FOREACH data GENERATE Country,City);

--Group the countries data with against the city to show the city next to its country
country_group = GROUP countries by Country;

--For each group created we count all cities using the count function 
noCoty = FOREACH country_group GENERATE FLATTEN(group), COUNT(countries) as count;

--Store result in text file
STORE noCoty  INTO 'resultwoo' using PigStorage(';');

--show the result
DUMP noCoty;
