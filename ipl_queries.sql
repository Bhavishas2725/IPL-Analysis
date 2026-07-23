create database ipl_analysis;
use  ipl_analysis;

CREATE TABLE matches (
    id INT PRIMARY KEY,
    season VARCHAR(20),
    city VARCHAR(100),
    date VARCHAR(50),
    match_type VARCHAR(50),
    player_of_match VARCHAR(100),
    venue VARCHAR(200),
    team1 VARCHAR(100),
    team2 VARCHAR(100),
    toss_winner VARCHAR(100),
    toss_decision VARCHAR(20),
    winner VARCHAR(100),
    result VARCHAR(50),
    result_margin VARCHAR(50),
    target_runs VARCHAR(50),
    target_overs VARCHAR(50),
    super_over VARCHAR(10),
    method VARCHAR(50),
    umpire1 VARCHAR(100),
    umpire2 VARCHAR(100)
);

-- Recreate deliveries with correct columns
CREATE TABLE deliveries (
    match_id INT,
    inning INT,
    batting_team VARCHAR(100),
    bowling_team VARCHAR(100),
    `over` INT,
    ball INT,
    batter VARCHAR(100),
    bowler VARCHAR(100),
    non_striker VARCHAR(100),
    batsman_runs INT,
    extra_runs INT,
    total_runs INT,
    extras_type VARCHAR(50),
    is_wicket INT,
    player_dismissed VARCHAR(100),
    dismissal_kind VARCHAR(50),
    fielder VARCHAR(100),
    id INT,
    season VARCHAR(20),
    venue VARCHAR(200),
    team1 VARCHAR(100),
    team2 VARCHAR(100),
    winner VARCHAR(100),
    city VARCHAR(100),
    toss_winner VARCHAR(100),
    toss_decision VARCHAR(20),
    is_four INT,
    is_six INT,
    over_phase VARCHAR(30),
    is_wicket_clean INT
);

select * from matches;
select * from deliveries;

-- First check if local infile is enabled
SHOW VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/bhavi/Documents/Python/deliveries_cleaned.csv'
INTO TABLE deliveries
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- matches table:
-- id, season, city, date, team1, team2, toss_winner, toss_decision, winner, 
-- result, result_margin, venue, player_of_match

-- deliveries table:
-- match_id, inning, batting_team, bowling_team, over, ball, batter, bowler, non_striker, batsman_runs,
-- total_runs, is_wicket, player_dismissed, dismissal_kind, is_four, is_six, over_phase, season

-- Q1: Which team won the most matches overall?
select winner, count(*) as total_wins
from matches
where winner is not null
group by winner
order by total_wins desc;

-- Q2: Which city hosted the most IPL matches?
select city, count(*) as total_matches
from matches
where city is not null
group by city
order by total_matches desc;

-- Q3: Does winning the toss help win the match?
select count(*) as total_matches,
sum(case when toss_winner = winner then 1 else 0 end) as win_won,
sum(case when toss_winner != winner then 1 else 0 end) as win_lost,
round(sum(case when toss_winner = winner then 1 else 0 end) * 100.0 / count(*) , 2) as win_percentage
from matches
where winner is not null;

-- Q4: Who won Player of the Match most times?
select player_of_match, count(*) as total_matches
from matches
where player_of_match is not null
group by player_of_match
order by total_matches desc;

-- Q5: Who scored the most runs overall? (Top 10)
select batter, sum(batsman_runs) as runs
from deliveries
where batsman_runs is not null
group by batter
order by runs desc
limit 10;

-- Q6: Who hit the most sixes overall? (Top 10)
select batter, sum(is_six) as six
from deliveries
where is_six is not null
group by batter
order by six desc
limit 10;

-- Q7: Who took the most wickets? (Top 10)
select bowler, sum(is_wicket) as wicket
from deliveries
where dismissal_kind NOT IN ('run out', 'retired hurt', 'obstructing the field')
group by bowler
order by wicket desc
limit 10;

-- Q8: Which over phase (Powerplay/Middle/Death) has the most sixes?
select over_phase, sum(is_six) as six
from deliveries
group by over_phase
order by six desc;

-- Q9: Which venue has the highest average runs per match?
select sum(total_runs) as total_runs, count(distinct match_id) as total_matches, venue,
round(sum(total_runs) / count(distinct match_id) , 0) as avg_runs_per_match
from deliveries
group by venue
having count(distinct match_id) >= 10
order by avg_runs_per_match desc;

-- Q10: Rank top 3 run scorers in each season (window function)
SELECT season, batter, total_runs, rnk
FROM (
select season , batter, sum(batsman_runs) as total_runs,
dense_rank() over(partition by season order by sum(batsman_runs) desc ) as rnk
from deliveries
group by batter, season
) as ranked
where rnk <=3
order by season, rnk;
