# Use the official PostgreSQL image
FROM postgres:latest

# Set environment variables
ENV POSTGRES_DB=postgres
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=wit2024

# Copy the initialization script into the Docker image
COPY postgres/init.sql /docker-entrypoint-initdb.d/init.sql

# Ensure the script is executable
RUN chmod a+r /docker-entrypoint-initdb.d/init.sql