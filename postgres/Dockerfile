# Use the official PostgreSQL image
FROM postgres:latest

# Copy your custom configuration files (make sure they exist in the specified directory) -- required for azure
COPY ./witDevOps/postgres/pg_hba.conf /etc/postgresql/pg_hba.conf

# Copy the initialization script into the Docker image -- required for azure
COPY ./witDevOps/postgres/init.sql /docker-entrypoint-initdb.d/init.sql

# Set appropriate permissions
RUN chmod a+r /docker-entrypoint-initdb.d/init.sql

# Set environment variables to point to your custom configuration files
ENV POSTGRESQL_CONF_DIR=/etc/postgresql
ENV PG_HBA_FILE=/etc/postgresql/pg_hba.conf

# Override the entrypoint to ensure PostgreSQL uses the custom configurations
CMD ["postgres", "-c", "hba_file=/etc/postgresql/pg_hba.conf"]
