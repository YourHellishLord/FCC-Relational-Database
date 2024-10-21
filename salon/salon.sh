#!/bin/bash
PSQL="psql -X --tuples-only --username=freecodecamp --dbname=salon -c"

# service related vars
SERVICE_ID_SELECTED=""
SERVICE_NAME=""
SERVICE_TIME=""

#customer related vars
CUSTOMER_ID=""
CUSTOMER_NAME=""
CUSTOMER_PHONE=""

SERVICE_MENU () {
  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id ASC")

  echo "$SERVICES" | while read SERVICE_ID BAR NAME; do
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  if [[ -z $SERVICE_NAME ]]; then
    SERVICE_MENU # if the requested service id doesn't exist
  else
    CUSTOMER_MENU # continue asking customer info
  fi
}

CUSTOMER_MENU () {
  echo -e "\nWhat's ur phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # does the customer with this phone number exist?
  if [[ -z $CUSTOMER_ID ]]; then
    # if doesn't exist ask for name and create it
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    CUSTOMER_INSERTION_RESPONSE=$($PSQL "INSERT INTO customers(name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    
    if [[ $CUSTOMER_INSERTION_RESPONSE != "INSERT 0 1" ]]; then
      echo "unable to add customer $CUSTOMER_NAME $CUSTOMER_PHONE"
      exit
    fi
    
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    
    APPOINTMENT_MENU
  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")
    APPOINTMENT_MENU
  fi
}

APPOINTMENT_MENU () {
  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  APPOINTMENT_INSERTION_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  
  if [[ $APPOINTMENT_INSERTION_RESULT == "INSERT 0 1" ]]; then
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  else
    echo -e "unable to insert appointment $CUSTOMER_NAME $CUSTOMER_PHONE $SERVICE_TIME"
  fi
}

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"
SERVICE_MENU