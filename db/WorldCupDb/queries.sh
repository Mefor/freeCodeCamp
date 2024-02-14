#! /bin/bash

PSQL="psql --username=postgres --dbname=worldcup --no-align --tuples-only -c"
# PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "select SUM(winner_goals + opponent_goals) from games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "select ROUND(AVG(winner_goals),16) from games g")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "select ROUND(AVG(winner_goals),2) from games g")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "select ROUND(AVG(winner_goals + opponent_goals),16) from games g")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "select MAX(winner_goals) from games g")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "select COUNT(*) from games g where g.winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "select t."name" from  games g inner join teams t on g.winner_id = t.team_id where round = 'Final' and g."year" = 2018")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "(select t."name" from games g inner join teams t on g.winner_id = t.team_id where g."year" = 2014) union (select t."name" from games g inner join teams t on g.opponent_id = t.team_id where g."year" = 2014 ) order by name ASC")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "select distinct(t."name") from games g inner join teams t on g.winner_id = t.team_id order by name")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "select g."year", t."name" from  games g inner join teams t on g.winner_id = t.team_id where round = 'Final' order by g."year"")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "select "name" from teams t where t."name" like 'Co%'")"
