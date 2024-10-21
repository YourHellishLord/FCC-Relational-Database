#!/bin/bash

SET_PSQL_DB () {
    PSQL="psql --username=freecodecamp --dbname=$1 -c"
}

echo -e "\n~~~ Working on ur DB you lazy ass ~~~\n"

# ---------------------------
# connecting to <postgres> db
# ---------------------------

SET_PSQL_DB "postgres"

# -----------------
# DATABASE CREATION
# -----------------

echo -e "\nDropping database..."
echo $($PSQL "DROP DATABASE IF EXISTS salon")
echo -e "\nCreating database..."
echo $($PSQL "CREATE DATABASE salon")

# ---------------------------
# connecting to <postgres> db
# ---------------------------

SET_PSQL_DB "salon"

# -----------------
#  TABLES CREATION
# -----------------


# customers table

echo -e "\nCreating <customers> table..."
echo $($PSQL " \
CREATE TABLE customers ( \
    customer_id SERIAL PRIMARY KEY, \
    phone VARCHAR(30) UNIQUE NOT NULL, \
    name VARCHAR(50) NOT NULL \
); \
")

# services table

echo -e "\nCreating <services> table..."
echo $($PSQL " \
CREATE TABLE services ( \
    service_id SERIAL PRIMARY KEY, \
    name VARCHAR(50) NOT NULL \
); \
")

# appointments table

echo -e "\nCreating <appointments> table..."
echo $($PSQL " \
CREATE TABLE appointments ( \
    appointment_id SERIAL PRIMARY KEY, \
    \
    time VARCHAR(30), \
    \
    customer_id INT, \
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id), \
    service_id INT, \
    FOREIGN KEY(service_id) REFERENCES services(service_id) \
); \
")

# -----------------
# VALUES INSERTION
# -----------------

# insert customers
echo -e "\nInserting new customers..."
echo $($PSQL " \
INSERT INTO customers(phone, name) VALUES \
    ('555-5555', 'Gennaro'), \
    ('000-0000', 'Pasquale'), \
    ('888-8888', 'Ciro'); \
")

# insert services
echo -e "\nInserting new services..."
echo $($PSQL " \
INSERT INTO services(name) VALUES \
    ('hair cut'), \
    ('beard cut'), \
    ('color'); \
")

# insert appointments
echo -e "\nInserting new appointments..."
echo $($PSQL " \
INSERT INTO appointments(time, customer_id, service_id) VALUES \
    ('08:15', 1, 3), \
    ('09:00', 2, 1), \
    ('09:20', 3, 2); \
")

# --------------------------
# SHOWING DATABASE STRUCTURE
# --------------------------

echo -e "\n\n$($PSQL "\d")"
echo -e "\n$($PSQL "\d customers")"
echo -e "\n$($PSQL "\d services")"
echo -e "\n$($PSQL "\d appointments")"

# --------------------------
#  SHOWING DATABASE RECORDS
# --------------------------

echo -e "\n\n$($PSQL "SELECT * FROM customers")" # list customers
echo -e "\n$($PSQL "SELECT * FROM services")" # list services
echo -e "\n$($PSQL "SELECT * FROM appointments")" # list appointments
