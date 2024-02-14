#! /bin/bash

if [[ $1 == "test" ]]; then
    PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
    PSQL="psql --username=postgres --dbname=worldcup -t --no-align -c"
#   PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo $($PSQL "TRUNCATE games, teams")
echo $($PSQL "ALTER SEQUENCE games_game_id_seq RESTART WITH 1")
echo $($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART WITH 1")

insert_team() {
    local TEAM_NAME=$1
    local IS_INSERTED=false

    # get team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM_NAME'")
    # if not found
    if [[ -z $TEAM_ID ]]; then
        # insert team
        INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM_NAME')")
        if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]; then
            echo "Inserted into team: '$TEAM_NAME'"
        fi

        # get new team_id
        TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM_NAME'")
    fi

    if [[ IS_INSERTED ]]; then
        echo "Inserted into team: '$TEAM_NAME' (id: $TEAM_ID)"
    else
        echo "Team already exists: '$TEAM_NAME' (id: $TEAM_ID)"
    fi

    return $TEAM_ID
}

insert_game() {
    local WINNER_ID=$1
    local OPPONENT_ID=$2
    local YEAR=$3
    local ROUND=$4
    local WINNER_GOALS=$5
    local OPPONENT_GOALS=$6

    # insert game
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID)")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]; then
        echo "Inserted into game: '$YEAR | $ROUND'"
    fi
}

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS; do
    if [[ $YEAR != "year" ]]; then

        echo "$YEAR | $ROUND | $WINNER | $OPPONENT | $WINNER_GOALS | $OPPONENT_GOALS"

        # get winner_id
        insert_team "$WINNER"
        WINNER_ID=$?

        insert_team "$OPPONENT"
        OPPONENT_ID=$?

        echo "W: $WINNER_ID L: $OPPONENT_ID"

        insert_game $WINNER_ID $OPPONENT_ID $YEAR "$ROUND" $WINNER_GOALS $OPPONENT_GOALS
    fi
done

TEAMS_COUNT=$($PSQL "SELECT COUNT(*) FROM teams")
GAMES_COUNT=$($PSQL "SELECT COUNT(*) FROM games")
echo "-> Teams: $TEAMS_COUNT | GAMES: $GAMES_COUNT"
