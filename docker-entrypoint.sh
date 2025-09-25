#!/bin/sh

# Function to check if PostgreSQL is ready
wait_for_postgres() {
    echo "Waiting for PostgreSQL to be ready..."
    until PGPASSWORD=$SPRING_DATASOURCE_PASSWORD psql -h "postgres" -U "$SPRING_DATASOURCE_USERNAME" -d "miDB" -c '\q'; do
        echo "PostgreSQL is unavailable - sleeping"
        sleep 1
    done
    echo "PostgreSQL is up and running!"
}
wait_for_dns() {
    echo "Waiting for DNS resolution of postgres..."
    until getent hosts postgres; do
        echo "DNS for postgres not available - sleeping"
        sleep 1
    done
    echo "DNS for postgres resolved!"
}

wait_for_dns
wait_for_postgres

# Wait for PostgreSQL
wait_for_postgres

# Start the application
echo "Starting the application..."
exec java -jar /app.jar