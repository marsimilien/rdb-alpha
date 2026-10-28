Total number of goals in all games from winning teams:echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

Total number of goals in all games from both teams combined:echo "$($PSQL "SELECT SUM(winner_goals + opponent_goals) FROM games")"

Average number of goals in all games from winning teams:echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

Average number of goals in all games from winning teams rounded to two decimal places:echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games")"

Average number of goals in all games from both teams:echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games")"

Most goals scored in a single game by one team:echo "$($PSQL "SELECT MAX(winner_goals) FROM games")"

Number of games where the winning team scored more than two goals:echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2")"

Winner of the 2018 tournament round name:echo "$($PSQL "SELECT name FROM games JOIN teams ON games.winner_id = teams.team_id WHERE year=2018 AND round='Final'")"

List of teams who played in the 2014 'Eighth-Final' round:echo "$($PSQL "SELECT DISTINCT name FROM games JOIN teams ON games.winner_id = teams.team_id OR games.opponent_id = teams.team_id WHERE year=2014 AND round='Eighth-Final' ORDER BY name")"

List of unique team names in the database in alphabetical order:echo "$($PSQL "SELECT name FROM teams ORDER BY name")"

Year and team name of all the champions:echo "$($PSQL "SELECT year, name FROM games JOIN teams ON games.winner_id = teams.team_id WHERE round='Final' ORDER BY year")"

List of teams that start with 'Co':echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%'")"