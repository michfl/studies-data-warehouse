USE DW_LAB;


CREATE TABLE company_branches (
	branch_id int IDENTITY(1,1) PRIMARY KEY,
	country varchar(20) NOT NULL,
	city varchar(60) NOT NULL,
	address varchar(50) NOT NULL,
);


CREATE TABLE agents (
	agent_id int IDENTITY(1,1) PRIMARY KEY,
	branch_id int FOREIGN KEY REFERENCES company_branches(branch_id) ON DELETE CASCADE NOT NULL,
	first_name varchar(20) NOT NULL,
	last_name varchar(25) NOT NULL,
	email varchar(50) UNIQUE CHECK (email LIKE '_%@_%.__%' AND email IS NOT NULL),
	phone varchar(16),
	started_working datetime2 DEFAULT GETDATE()
);


CREATE TABLE salaries (
	payment_id int IDENTITY(1,1) PRIMARY KEY,
	agent_id int FOREIGN KEY REFERENCES agents(agent_id) ON DELETE CASCADE NOT NULL,
	value smallmoney NOT NULL,
	payment_date datetime2 DEFAULT GETDATE() NOT NULL
);


CREATE TABLE clients (
	client_id int IDENTITY(1,1) PRIMARY KEY,
	first_name varchar(20) NOT NULL,
	last_name varchar(25) NOT NULL,
	email varchar(50) UNIQUE CHECK (email LIKE '_%@_%.__%' AND email IS NOT NULL),
	phone varchar(16),
	creditworthiness money NOT NULL
);


CREATE TABLE real_estates (
	estate_id int IDENTITY(1,1) PRIMARY KEY,
	name varchar(50),
	description varchar(200),
	living_size int NOT NULL,
	plot_size int NOT NULL,
	type varchar(15) CHECK (type = 'sky_scraper'
						 OR type = 'block_of_flats'
						 OR type = 'villa'
						 OR type = 'house')
);


CREATE TABLE real_estate_locations (
	estate_id int PRIMARY KEY REFERENCES real_estates(estate_id) ON DELETE CASCADE,
	country varchar(20) NOT NULL,
	city varchar(60) NOT NULL,
	address varchar(50) NOT NULL,
	postal_code varchar(12) NOT NULL,
	district varchar(60),
	level smallint
);


CREATE TABLE market_values (
	estate_id int FOREIGN KEY REFERENCES real_estates(estate_id) ON DELETE CASCADE NOT NULL,
	entry_date datetime2 DEFAULT GETDATE() NOT NULL,
	value money NOT NULL,
	CONSTRAINT PK_market_value PRIMARY KEY (estate_id, entry_date)
);


CREATE TABLE presentations (
	agent_id int FOREIGN KEY REFERENCES agents(agent_id) ON DELETE CASCADE NOT NULL,
	client_id int FOREIGN KEY REFERENCES clients(client_id) ON DELETE CASCADE NOT NULL,
	estate_id int FOREIGN KEY REFERENCES real_estates(estate_id) ON DELETE CASCADE NOT NULL,
	presentation_date datetime2 DEFAULT GETDATE() NOT NULL,
	contract_code int DEFAULT NULL,
	agent_raport_code int,
	type varchar(5) CHECK (type = 'sale'
						OR type = 'rent'),
	CONSTRAINT PK_presentation PRIMARY KEY (agent_id, client_id, estate_id, presentation_date)
);