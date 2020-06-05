1 Check postgresql
 	sudo apt-get install postgresql-client
	sudo apt-get install postgresql

2 	--without-zlib
	--without-readline
	
	make
	
	cd contrib
	
	make
	
	cd pgbench
	
	sudo cp pgbench /usr/lib/postgresql/9.3/bin/
	
	sudo su postgres
	
	
	CREATE DATABASE pgbench OWNER dbuser;
	GRANT ALL PRIVILEGES ON DATABASE pgbench to dbuser;
	\c pgbench
	\d
	
	pgbench -i pgbench
	
	pgbench -c 96  -j 12 -T 20 -r pgbench
