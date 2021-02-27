# Database Development Tools

These files allow developers to run a local development copy of an MSSQL database.

- [Database Development Tools](#database-development-tools)
  - [Requirements](#requirements)
    - [Requirements for Windows](#requirements-for-windows)
    - [Requirements for Linux](#requirements-for-linux)
  - [Contents of This Folder](#contents-of-this-folder)
  - [Getting Started](#getting-started)
  - [Development/Administrative Actions](#developmentadministrative-actions)
    - [Deleting All Rows from the Database](#deleting-all-rows-from-the-database)

---

## Requirements

1. Bash, or Git Bash
2. Python
3. `mssql-scripter` - To install, run `pip install mssql-scripter`

### Requirements for Windows

1. [Docker Desktop for Windows](https://docs.docker.com/docker-for-windows/install/)
2. A `.env` file in `dev-environment` to define the database name and the root user's (`sa`) password. See [below](#running-a-development-database-environment).

### Requirements for Linux

1. `docker`
2. `docker-compose`
3. A `.env` file in `dev-environment` to define the database name and the root user's (`sa`) password. See [below](#running-a-development-database-environment).

## Contents of This Folder

- `docker-compose.yml` - This file controls the *run-time* configuration of the Docker container
- `entrypoint.sh` - This file allows the Docker container to run the SQL script when the container is started
- `init.sql` - SQL file that creates the database when run
- `README.md` - This file

## Getting Started

First change directory to the `dev-environment` folder and create a
 file called `.env` that we will use to define the starting system admin
 password for the development server.

*Note: The password will be stored in plain-text, but the server should only be
 able to be accessed from the localhost, so security shouldn't really be an
 issue. That being said, don't upload highly-confidential information, and don't
 leave the development container running when you don't need it.*

The `.env` file must contain the following environment variables:

- `SA_PASSWORD` - The starting password of the system administrator database user.

Example `.env` file:

```shell
12:33 $  cat .env
SA_PASSWORD=XXXXXXXXXXXXX
```

*Note: MSSQL has password strength requirements for the SA password, which must
 be longer than 8 characters.*

After you create the `.env` file, you can start the server with the following command:

```shell
docker-compose up
```

To enter the SQL CMD shell:

```shell
docker exec -it CONTAINER_NAME /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P XXXXXXXXXXXXX
```

## Development/Administrative Actions

### Deleting All Rows from the Database

You can run the `DeleteAllRows.sql` query to delete all rows from all tables in
 the database. The query can easily be modified to work on any other table,
 but be careful, as it will **delete all of the data**.
