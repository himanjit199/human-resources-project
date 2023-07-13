
describe hr;
select * from hr ;
update hr 
set termdate = date(str_to_date(termdate,'%Y-%m-%d'))
where termdate is not null and termdate != '';


select termdate from hr;
alter table hr 
modify column termdate date;
describe hr;
select hire_date from hr;
update hr 
set hire_date = case
when hire_date like '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
when hire_date like '%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
end;
select hire_date from hr;
select birthdate from hr;
alter table hr 
modify column hire_date date;
describe hr;
alter table hr add column age int;
select * from hr ;
update hr
set age = timestampdiff(year,birthdate,curdate());
select age from hr;
update hr 
set age = case 
when age<0 then age
else age 
end;
select age from hr;
select count(age) from hr
where age=0;
select min(age) as min_age,max(age) as max_age from hr 
where age!=0;
select * from hr;








-- questions:
-- 1. What is the gender breakdown of employees in the company?
-- ans:
select gender ,count(age) as emp_no from hr where age >=20 and termdate is null 
group by gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
-- ans:
 select count(race) as count_race ,race from hr where  age >=20 and termdate is null group by race order by count(race) DESC;
 
-- 3. What is the age distribution of employees in the company?
-- ans:
select 
case 
when age>=0 and age<25 then 'interval_1 (0-25)'
when age >=25 and age <50 then 'interval_2 (25-50)'
else 'interval_3(50+)'
end as interval_age,
count(*) as count_age
from hr
where  age >=20 and termdate is null
group by interval_age
order by count_age DESC;
 
-- 4. How many employees work at headquarters versus remote locations?
-- ans :
select * from hr;
select  location, count(*) as count_location  from hr where  age >=20 and termdate is null group by location;

-- 5. What is the average length of employment for employees who have been terminated?
-- ans :
select round(avg(datediff(termdate,hire_date))/365,0)  as avg_year_working
from hr 
where age >=20 and  termdate is not null and termdate<= curdate();

-- 6. How does the gender distribution vary across departments and job titles?
select count(*) as count ,department,jobtitle from hr where age >=20 and termdate is null
group by department, jobtitle;

-- 7. What is the distribution of job titles across the company?
select  jobtitle,count(*) as count from hr where age >=20 and termdate is null
group by jobtitle
order by jobtitle;


-- 8. Which department has the highest turnover rate?
-- ans:: 
select department ,total_count,terminated_count,terminated_count/total_count as turnover_rate
from (select department, count(*) as total_count, sum(case when termdate is not null and termdate<= curdate() then 1 else 0 end ) as terminated_count
from hr where age>=20 group by department) as abc ;

-- 9. What is the distribution of employees across locations by city and state?
-- ans: 
select count(*) as count,location_city,location_state from hr where age >=20 and termdate is null
group by location_city , location_state;

-- 10. How has the company's employee count changed over time based on hire and term dates?
 select hire_count,term_count, round((hire_count-term_count)/hire_count *100,2)  as changed ,year
 from (select count(*) as hire_count,sum(case when termdate is not null then 1 else 0 end) as term_count,extract(year from hire_date) as year 
 from hr where age>=20 
 group by year) as query
 order by year;
 
 -- 11. What is the tenure distribution for each department?
 select department ,round(avg(datediff(termdate,Hire_date)/365),0)as avg_tenure 
 from hr 
 where age>=18 and termdate is not null and termdate<=curdate()
 group by department;
 






 

