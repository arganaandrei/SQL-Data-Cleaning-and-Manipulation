## UPDATING NULL AGE AS 30 (default value)


UPDATE titanic
SET
age = 30
where age is null




## UPDATING CABIN BASED ON TICKET NUMBER

insert into titanic(passengerid,
    survived,pclass,
    name, sex,age,sibsp,parch,
    ticket,fare,cabin,embarked)
    
select a.passengerid,
    a.survived,a.pclass,
    a.name, a.sex,a.age,a.sibsp,a.parch,
    a.ticket,a.fare,b.cabins as cabin,a.embarked from titanic a
    inner join
    (
    select ticket, string_agg(cabin,'/') as cabins
    from titanic
    group by ticket
    )b
on a.ticket = b.ticket
where a.ticket in 
    (
    select ticket from
    (
        select *, count(*) over (partition by ticket) as rec_count
        from titanic
    ) ticket_count 
    where ticket_count.rec_count > 1
    )
ON CONFLICT ON CONSTRAINT passengerid_pkey
DO UPDATE set cabin = excluded.cabin




#UPDATING CABIN WITH NULL VALUES AFTER REFERENCING TO TICKET NUMBERS
UPDATE titanic
SET
cabin = 'C1'
where cabin is null


# UPDATING OF GENDER FOR UNIFORMITY OF DATA
UPDATE titanic
SET sex = 'male'
WHERE sex = 'M'

UPDATE titanic
SET sex = 'female'
WHERE sex = 'F'

SELECT DISTINCT(sex) from titanic




#ADDING COLUMN TO THE TITANIC TABLE 

alter table titanic
add column Last_Name character varying(60)


##INSERT AND SPLITTING 

insert into titanic(passengerid, survived, pclass, name, sex,age, sibSp,parch,ticket,fare,
                    cabin,embarked, last_name)
select a.passengerid, a.survived, a.pclass, a.name, a.sex,a.age, a.sibSp,a.parch,a.ticket,a.fare,
                    a.cabin,a.embarked, b.last_name1 as last_name
    from titanic a inner join
    (
           select passengerid, split_part(name, ',', 1) as last_name1 from titanic
    ) b
        on a.passengerid=b.passengerid
    order by a.passengerid
    
ON CONFLICT ON CONSTRAINT passengerid_pkey
DO UPDATE set last_name = excluded.last_name






alter table titanic
add column Title character varying(60)


##INSERT AND SPLITTING (DO NOT INCLUDE IN THE SQL)

insert into titanic(passengerid, survived, pclass, name, sex,age, sibSp,parch,ticket,fare,
                    cabin,embarked, last_name, title)
select a.passengerid, a.survived, a.pclass, a.name, a.sex,a.age, a.sibSp,a.parch,a.ticket,a.fare,
                    a.cabin,a.embarked, a.last_name, c.title2 as title
    from titanic a inner join
           (select b.name, b.passengerid, split_part(b.title1, ' ', 2) as title2 from 
            (select name, passengerid, split_part(name, ',', -1) as title1 from titanic)b
           )c
   
        on a.passengerid=c.passengerid
    order by a.passengerid
    
ON CONFLICT ON CONSTRAINT passengerid_pkey
DO UPDATE set title = excluded.title





alter table titanic
add column First_Name character varying(60)

insert into titanic(passengerid, survived, pclass, name, sex,age, sibSp,parch,ticket,fare,
                    cabin,embarked, last_name, title, first_name)
select a.passengerid, a.survived, a.pclass, a.name, a.sex,a.age, a.sibSp,a.parch,a.ticket,a.fare,
                    a.cabin,a.embarked, a.last_name, a.title, b.first_name1 as first_name
    from titanic a inner join
    (
           select passengerid, split_part(name, '.', -1) as first_name1 from titanic
    ) b
        on a.passengerid=b.passengerid
    order by a.passengerid
    
ON CONFLICT ON CONSTRAINT passengerid_pkey
DO UPDATE set first_name = excluded.first_name