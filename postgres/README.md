### Tips and Tricks

This Docker implementation creates a Postgres instance with the following characteristics:

1. `pgdata` dir mounted on host's `/data/pgsql_data`
2. `test_db` created with access defined for user `randre`
3. `psql` access needs to specify the `-h` (host) 

### To Build:

`docker build -t postgis-docker .`

`sudo cp postgis-docker.service /etc/systemd/system/postgis-docker.service`

`sudo systemctl enable postgis-docker.service`

`sudo systemctl start postgis-docker.service`

### To setup the Database Instance

Login to builtin 'postgres' db as 'postgres' user.

`$ psql -h posit2 -U postgres -d postgres`

Set a passwd for the 'randre' user.
```
postgres=# \password randre
Enter new password for user "randre": 
Enter it again:
``

Exit ("\q") postgres db.

Login to "test_db" as 'postgres' and add 'postgis' extension

```
$ psql -h posit2 -d test_db -U postgres

test_db=# create extension postgis;
CREATE EXTENSION

test_db=# \d
               List of relations
 Schema |       Name        | Type  |  Owner   
--------+-------------------+-------+----------
 public | geography_columns | view  | postgres
 public | geometry_columns  | view  | postgres
 public | spatial_ref_sys   | table | postgres
(3 rows)
```
