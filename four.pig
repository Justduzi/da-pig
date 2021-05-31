--Load the data assigning it data strucrues 
data = LOAD 'unsd.csv' USING PigStorage(',') AS (Country:chararray,Year:int,Area:chararray,Sex:chararray,City:chararray,
				City_type:chararray,Record_type:chararray,Reliability:chararray,
				Source_year:int,Value:int,Value_footnotes:int);

--I select the Country, Year and Value column data from the whole data 
population = FOREACH data GENERATE City,Year,Value;

--Filter population removing null values in city
population = FILTER population BY City != '';

-- group population data in relation to City
group_population = GROUP population by (City);

--i group the population data into descending order to get the most recent year called "lastyear" 
--sum the population of the lastyear as "lastvalue"
result = FOREACH group_population generate group,population.Value;
B = FOREACH group_population{
	DA = ORDER population BY Year DESC;
	DB = LIMIT DA 1; 
	GENERATE group AS City, FLATTEN(DB.Year) AS lastYear, SUM(DB.Value) AS lastValue;
};
-- data "B" by the population "value"
order_by_population = ORDER B BY lastValue DESC;

--use the Limit function to get the top 10 data
top10 = LIMIT order_by_population 10;

--show the result
DUMP top10;
