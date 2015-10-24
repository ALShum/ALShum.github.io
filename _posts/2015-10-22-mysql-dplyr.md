---
layout: post
title: "Creating a database for data with dplyr"
description: "Creating a mysql database, loading data and reading to dplyr"
author: "alex shum"
modified: 2015-10-22
---


One of the best features of `dplyr` is that it allows you to rearrange and summarize data from different sources using the same functions.  Data read in from text/csv and data read in from a database can be treated similarly.  If a dataset is too large to load into memory putting it into a database and using familiar `dplyr` functions is a simple fix.  It turns out that the entire process of creating a database, loading data to a database and connecting `dplyr` is pretty simple.

To start download the [Movie Lens Dataset](http://grouplens.org/datasets/movielens/).  The biggest version of this dataset is around 150 Mb -- not a large dataset by any means but an excellent example that should be easy to work with.

#### Preliminary

`dplyr` can use both sqlite and mysql as well as other database types.  Installing `mysql` is fairly straight forward on most non-windows operating systems.  For OS X, `homebrew` is probably the easiest way:

Install MySQL with homebrew on OS X:

```
brew install mysql
```

Install MySQL with apt on Ubuntu:

```
apt-get install mysql
```

On other linux distributions and windows you are on your own.

#### Setup MySQL

Setup administrator -- in practice it might be better to make a new user rather than just using root.  From the terminal:

```
mysqladmin -u root password 'SET YOUR PASSWORD'
```

Next, startup the MySQL Server and login:

```
mysql.server start
mysql -u root -p 'PASSWORD'
```

#### Creating databases and tables

Now you should be in the MySQL command line.  Create a database where the movielens data will be stored.

List the databases available using:

```
show databases;
```

Create database, select it, list the tables in the database and show all the columns from a table:

```
create database my_db_name;
use my_db_name;
show tables;
show columns from TABLE_NAME;
```

For a new database the tables and columns should be empty.

#### Creating tables

The table must be created correctly to be able to store the incoming datasets.  The dataset contains 3 files: movies.dat, ratings.dat, and users.dat.  
Here are the first few lines of each dataset:

movies.dat:

```
1::Toy Story (1995)::Animation|Children's|Comedy
2::Jumanji (1995)::Adventure|Children's|Fantasy
3::Grumpier Old Men (1995)::Comedy|Romance
4::Waiting to Exhale (1995)::Comedy|Drama
5::Father of the Bride Part II (1995)::Comedy
6::Heat (1995)::Action|Crime|Thriller
7::Sabrina (1995)::Comedy|Romance
8::Tom and Huck (1995)::Adventure|Children's
9::Sudden Death (1995)::Action
10::GoldenEye (1995)::Action|Adventure|Thriller
```

From the documentation it appears that the columns are movie id, movie name and genres delimited by "::".

ratings.dat:

```
1::1193::5::978300760
1::661::3::978302109
1::914::3::978301968
1::3408::4::978300275
1::2355::5::978824291
1::1197::3::978302268
1::1287::5::978302039
1::2804::5::978300719
1::594::4::978302268
1::919::4::978301368
```

The columns are user id, movie id, rating, timestamp (probably in unix time).

users.dat:

```
1::F::1::10::48067
2::M::56::16::70072
3::M::25::15::55117
4::M::45::7::02460
5::M::25::20::55455
6::F::50::9::55117
7::M::35::1::06810
8::M::25::12::11413
9::M::25::17::61614
10::F::35::1::95370
```

The columns are user id, gender, age, occupation and zipcode.

The above datasets correspond to the tables created below:

```
CREATE TABLE movies ( 
movie_id INT NOT NULL AUTO_INCREMENT, 
title VARCHAR(255) NOT NULL, 
genres VARCHAR(255) NOT NULL, 
PRIMARY KEY (movie_id) 
);
ALTER DATABASE movielens CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci;

CREATE TABLE ratings ( 
user_id INT NOT NULL, 
movie_id INT NOT NULL, 
rating INT NOT NULL, 
timestamp BIGINT NOT NULL
);

CREATE TABLE users ( 
user_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, 
gender ENUM('m', 'f') NOT NULL, 
age INT NOT NULL, 
occupation VARCHAR(50) NOT NULL, 
zip VARCHAR(20) NOT NULL );
```

#### Loading data into database

Once the tables are created then to load the data from the text files:

```
LOAD DATA INFILE '/Users/MKULTRA/Downloads/ml-1m/movies.dat' 
INTO TABLE movies 
FIELDS TERMINATED BY '::' 
LINES TERMINATED BY '\n';

LOAD DATA INFILE '/Users/MKULTRA/Downloads/ml-1m/ratings.dat' 
INTO TABLE ratings 
FIELDS TERMINATED BY '::' 
LINES TERMINATED BY '\n';

LOAD DATA INFILE '/Users/MKULTRA/Downloads/ml-1m/users.dat' 
INTO TABLE users 
FIELDS TERMINATED BY '::' 
LINES TERMINATED BY '\n';
```

To make sure that the tables were created correctly and that data was loaded correctly we can look at the top 10 rows from each table:

```
SELECT * FROM movies
LIMIT 10;

SELECT * FROM ratings
LIMIT 10;

SELECT * FROM users
LIMIT 10;
```

# Loading MySQL into R

Once the databases are created and the data is in the database correctly, from R install `dplyr` and `RMySQL`.  Then enter the following commands to connect `dplyr` to the databased just created:

```
library(dplyr)
db = src_mysql('my_db_name', host = 'localhost', user='root', password='PASSWORD')

movies = tbl(db, "movies")
ratings = tbl(db, "ratings")
users = tbl(db, "users")
```

At this point can can treat the three databases as R dataframes. 

```
movies %>% left_join(ratings)
```


Important links:
* https://www.digitalocean.com/community/tutorials/a-basic-mysql-tutorial
* http://stackoverflow.com/questions/20411440/incorrect-string-value-xf0-x9f-x8e-xb6-xf0-x9f-mysql
* http://www.mysqltutorial.org/import-csv-file-mysql-table/
