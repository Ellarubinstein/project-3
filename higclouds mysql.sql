create database project3;
use project3;
CREATE TABLE highcloud_airlines (
  Airline_ID int NOT NULL,
  Carrier_Group_ID int,
  Unique_Carrier_Code varchar(255),
  Unique_Carrier_Entity_Code varchar(255),
  Region_Code varchar(255),
  Origin_Airport_ID int,
  Origin_Airport_Sequence_ID int,
  Origin_Airport_Market_ID int,
  Origin_World_Area_Code varchar(255),
  Destination_Airport_ID int,
  Destination_Airport_Sequence_ID int,
  Destination_Airport_Market_ID int,
  Destination_World_Area_Code varchar(255),
  Aircraft_Group_ID int,
  Aircraft_Type_ID int,
  Aircraft_Configuration_ID int,
  Distance_Group_ID int,
  Service_Class_ID varchar(255),
  Datasource_ID varchar(255),
  Departures_Scheduled int,
  Departures_Performed int,
  Payload int,
  Distance int,
  Available_Seats int,
  Transported_Passengers int,
  Transported_Freight int,
  Transported_Mail int,
  Ramp_To_Ramp_Time int,
  Air_Time int,
  Unique_Carrier varchar(255),
  Carrier_Code varchar(255),
  Carrier_Name varchar(255),
  Origin_Airport_Code varchar(255),
  Origin_City varchar(255),
  Origin_State_Code varchar(255),
  Origin_State_FIPS varchar(255),
  Origin_State varchar(255),
  Origin_Country_Code varchar(255),
  Origin_Country varchar(255),
  Destination_Airport_Code varchar(255),
  Destination_City varchar(255),
  Destination_State_Code varchar(255),
  Destination_State_FIPS varchar(255),
  Destination_State varchar(255),
  Destination_Country_Code varchar(255),
  Destination_Country varchar(255),
  Year int,
  Month int,
  Day int,
  From_To_Airport_Code varchar(255),
  From_To_Airport_ID varchar(255),
  From_To_City varchar(255),
  From_To_State_Code varchar(255),
  From_To_State varchar(255)
);

select * from highcloud_airlines;

-- Q1
alter table highcloud_airlines
add date_feild  date ; 
SET SQL_SAFE_UPDATES = 0;
UPDATE HighCloud_Airlines
SET Date_feild = STR_TO_DATE(CONCAT(Year, '-', Month, '-', Day), '%Y-%m-%d');

------ year, month no --
select date_feild,year,month,monthnames,quarters ,yearmonth from highcloud_airlines ;

-- month name --
alter table highcloud_airlines 
add monthnames char(20);
update highcloud_airlines 
set monthnames = monthname(date_feild);

-- quarter --
alter table highcloud_airlines 
add Quarters char(20);
update highcloud_airlines 
set Quarters  = 
case 
when quarter(date_feild) = 1 then 'Q1'
when quarter(date_feild)= 2 then 'Q2'
when quarter(date_feild)= 3 then 'Q3'
else 'Q4' 
end ;
 
 -- year-month 
 alter table highcloud_airlines 
add yearmonth char(20);
update highcloud_airlines 
set yearmonth = date_format(date_feild,"%y-%M");

select date_feild,year,month,monthnames,quarters ,yearmonth ,weekno from highcloud_airlines ;

-- weekno-
alter table highcloud_airlines 
add weekno int ;
update highcloud_airlines 
set weekno = weekday(date_feild);

select date_feild,year,month,monthnames,quarters ,yearmonth ,weekno,weekdayname from highcloud_airlines ;

-- weekday name 
alter table highcloud_airlines 
add weekdayname char(20) ;
update highcloud_airlines 
set weekdayname  = dayname(date_feild);

select date_feild,year,month,monthnames,quarters ,yearmonth ,weekno,weekdayname,financialmonth from highcloud_airlines ;
-- financial month 
alter table highcloud_airlines 
add financialmonth varchar(20) ;
update highcloud_airlines 
set financialmonth = concat("FM-", month(finmonth));

-- financial quarter 
alter table highcloud_airlines 
add financialquarter varchar(20) ;
update highcloud_airlines 
set financialquarter= 
case 
when month(date_feild) in (1,2,3) then 'Q4'
when month (date_feild) in (4,5,6) then 'Q1'
when month (date_feild) in (7,8,9) then 'Q2' 
else 'Q3' 
end ; 

select date_feild,year,month,monthnames,quarters ,yearmonth ,weekno,weekdayname,
financialmonth,financialquarter  from highcloud_airlines ;

-- Q2 Find the load Factor percentage on a yearly , Quarterly , Monthly basis --

-- load factor 
alter table highcloud_airlines 
add column load_factor float default null;
select * from highcloud_airlines ;

update highcloud_airlines 
set load_factor = 
case when available_seats = 0 then 0 else 
ifnull(round(transported_passengers / available_seats * 100,2),0) 
end ;

-- on monthly yearly and quaterly basis 
select year(date_feild) as years ,
month(date_feild) as months ,
quarters ,
round (avg(load_factor),2) as load_factor_percentage
from highcloud_airlines 
group by years,quarters,months
order by years,months ; 
select * from highcloud_airlines ;

-- Q3 Find the load Factor percentage on a Carrier Name basis

select carrier_name , round(avg(load_factor),2) as loadfactor_percentage
from highcloud_airlines 
group by carrier_name
order by loadfactor_percentage desc ; 


-- Q4 Identify Top 10 Carrier Names based passengers preference

select carrier_name , sum(transported_passengers) as passenger_preference 
from highcloud_airlines 
group by carrier_name 
order by passenger_preference desc 
limit 10;

-- Q5 Display top Routes ( from-to City) based on Number of Flights 

select from_to_city , count(departures_performed) as no_of_flights 
from highcloud_airlines
group by from_to_city 
order by no_of_flights desc 
limit 15 ;

-- Q6 Identify the how much load factor is occupied on Weekend vs Weekdays

alter table highcloud_airlines 
add column weekday_vs_weekend varchar(20);

update highcloud_airlines 
set weekday_vs_weekend = 
case 
when weekdayname in ('saturday','sunday') then 'weekend'
else 'weekday'
end ;
select * from highcloud_airlines ;

select weekday_vs_weekend , round (avg(load_factor),2) as loadfactor_percentage
from highcloud_airlines 
group by  (weekday_Vs_weekend);

-- Q7  Use the filter to provide a search capability to find the flights between 
-- Source Country, Source State, Source City to Destination Country , Destination State, Destination City

select airline_id, region_code,datasource_id,carrier_name,origin_country,origin_state,origin_city,
destination_country,destination_state,destination_city
from highcloud_airlines ;


-- Q8 identify no. of flights based on distance groups 

select  distance_group_id , count(departures_performed) as no_of_flights
from highcloud_airlines 
group by distance_group_id 
order by distance_group_id;


