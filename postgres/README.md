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
