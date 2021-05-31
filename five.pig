--Load the data assigning it data strucrues 
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

--i group the population data into ascending and descending order to get the most recent year called "lastyear" and the oldest year "firstyear" in the data
--sum the population for the first year as "firstvalue" and sum the population of the lastyear as "lastvalue"
result = FOREACH group_population generate group,population.Value;
B = FOREACH group_population{
	DA = ORDER population BY Year DESC;
	DB = LIMIT DA 1; 
	DA = ORDER population BY Year ASC;
	DC = LIMIT DA 1;  
	GENERATE group AS City, FLATTEN(DB.Year) AS lastYear, SUM(DB.Value) AS lastValue,FLATTEN(DC.Year) AS firstYear, SUM(DC.Value) AS firstValue; 
};

--now we make sure the ne data contains cities with more than one year or else we cant calculate change if there only a year
B = FILTER B BY (lastYear > firstYear);

--formula for population change recent poulation subtracted from the oldest population dvided by the oldest population multiplied by 100 and divide by the number of years betwwen the recent population and oldest population
PopChange = FOREACH B {
		Z = 100*(lastValue - firstValue) / firstValue;
		Y = lastYear - firstYear;
		X = Z/Y;
		GENERATE City, (int) X AS change;
};

--Order the result in Descending order
topChange = ORDER PopChange BY change DESC;

--use the limit function to get the top 10 data
topChange = LIMIT topChange 10;


--show result		
DUMP topChange;
