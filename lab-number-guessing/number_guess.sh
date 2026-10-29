#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read -r USERNAME

# Escape apostrophes for SQL
USERNAME_SQL=$(printf "%s" "$USERNAME" | sed "s/'/''/g")

# Look up the username
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME_SQL'")

if [[ -z "$USER_ID" ]]; then
  # Register a new user
  $PSQL "INSERT INTO users (username) VALUES ('$USERNAME_SQL')" > /dev/null
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME_SQL'")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  # Get the returning user's statistics
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games WHERE user_id=$USER_ID")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Generate a random number from 1 to 1000
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))

echo "Guess the secret number between 1 and 1000:"
NUMBER_OF_GUESSES=0

while true; do
  read -r GUESS
  ((NUMBER_OF_GUESSES++))

  # Reject input that isn't an integer
  if [[ ! "$GUESS" =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    continue
  fi

  # Interpret integer input as decimal, even with leading zeros
  GUESS_NUMBER=$((10#$GUESS))

  if (( GUESS_NUMBER > SECRET_NUMBER )); then
    echo "It's lower than that, guess again:"
  elif (( GUESS_NUMBER < SECRET_NUMBER )); then
    echo "It's higher than that, guess again:"
  else
    break
  fi
done

echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

# Save the completed game
$PSQL "INSERT INTO games (user_id, number_of_guesses) VALUES ($USER_ID, $NUMBER_OF_GUESSES)" > /dev/null
