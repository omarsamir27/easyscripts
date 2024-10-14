# Easyscripts
A collection of scripts to automate tasks and make life easier.

## pgclone
A script to clone a **PostgreSQL** database from one server to another.
### Installation
1. Download the script
2. Make the script executable by running `chmod +x pgclone`

### Usage
`pgclone` is interactive and will ask for the necessary information to clone a database. 

It will ask for the following information:
1. Source server and port
2. Source database
3. Source user
4. Destination server and port
5. Destination database
6. Destination user

It will also back up both the source and destination databases before cloning to the destination server.

