--Create Repository Hosting Serivce
CREATE TABLE Hosting_Services
(
	service_name VARCHAR2 (50) NOT NULL,
	service_url VARCHAR2 (100) NOT NULL,
	num_of_repos INT NOT NULL,
	sign_up_date DATE NOT NULL,
	CONSTRAINT pk_service_url PRIMARY KEY (service_url)
);

--Populate Hosting Services Table
INSERT INTO Hosting_Services
VALUES('GitHub','www.github.com',0,SYSDATE);

INSERT INTO Hosting_Services
VALUES('BitBucket','www.bitbucket.com',0,SYSDATE);

--Drop hosting_services table
DROP TABLE Hosting_Services;

--Create Repository
CREATE TABLE Repositories
(
	repo_id INT NOT NULL,
	repo_name VARCHAR2(30) NOT NULL,
	branch_name VARCHAR2(30) NOT NULL,
	repo_size VARCHAR2(20) NOT NULL, --eg. '3mb'
	num_of_files INT NOT NULL,
	has_readme CHAR NOT NULL,
	up_to_date CHAR NOT NULL,
	last_commit_time TIMESTAMP NOT NULL,
	repo_url VARCHAR2(100) NOT NULL,
	service_url VARCHAR2(100) NOT NULL,
	CONSTRAINT pk_repo_id PRIMARY KEY (repo_id),
	CONSTRAINT fk_service_url FOREIGN KEY (service_url) REFERENCES Hosting_Services(service_url)
);

--Populate Repositories Table
INSERT INTO Repositories
VALUES(1,'huffman_coding','origin','5mb',20,'Y','Y',
	   SYSDATE,'www.github.com/huffman_coding',(SELECT (service_url)FROM Hosting_Services
	   WHERE service_url = 'www.github.com'));

INSERT INTO Repositories
VALUES((SELECT MAX(repo_id) FROM Repositories) + 1,'postfix_stack_calculator','origin','8mb',18,'N','Y',
	   SYSDATE,'www.bitbucket.com/postfix_stack_calculator',(SELECT (service_url)FROM Hosting_Services
	   WHERE service_url = 'www.bitbucket.com'));

INSERT INTO Repositories
VALUES((SELECT MAX(repo_id) FROM Repositories) + 1,'x_and_o','origin','8mb',18,'N','Y',
	   SYSDATE,'www.bitbucket.com/x_and_o',(SELECT (service_url)FROM Hosting_Services
	   WHERE service_url = 'www.bitbucket.com'));

INSERT INTO Repositories
VALUES((SELECT MAX(repo_id) FROM Repositories) + 1,'movie_recommender','origin','8mb',18,'N','Y',
	   SYSDATE,'www.github.com/movie_recommender',(SELECT (service_url)FROM Hosting_Services
	   WHERE service_url = 'www.github.com'));

INSERT INTO Repositories
VALUES((SELECT MAX(repo_id) FROM Repositories) + 1,'kevins_crow','origin','24kb',18,'Y','Y',
	   SYSDATE,'www.github.com/kevins_crow',(SELECT (service_url)FROM Hosting_Services
	   WHERE service_url = 'www.github.com'));

--Drop repositories table
DROP TABLE Repositories;

--Create the Projects table
CREATE TABLE Projects
(
	project_id INT NOT NULL,
	project_name VARCHAR2(100) NOT NULL,
	project_start_date DATE NOT NULL,
	project_dead_line DATE NOT NULL,
	project_programmers INT NULL,
	project_language VARCHAR2(50) NOT NULL,
	project_ide VARCHAR2(50) NULL,
	project_brief VARCHAR2(300) NOT NULL,
	repo_id INT NOT NULL,
	CONSTRAINT pk_project_id PRIMARY KEY (project_id),
	CONSTRAINT fk_repo_id FOREIGN KEY (repo_id) REFERENCES Repositories(repo_id)
);

--Populate Projects Table
INSERT INTO Projects
VALUES(1,'Huffman Coding',SYSDATE,'23-SEP-2016',NULL,'Java','Eclipse',
	  'Compress a text file using huffman coding techniques.',
	  (SELECT (repo_id) FROM Repositories WHERE repo_name = 'huffman_coding'));

INSERT INTO Projects
VALUES((SELECT MAX(project_id) FROM Projects)+1,'Postfix Stack Calculator',
		SYSDATE,'20-MAR-2017',NULL,'C++','Visual Studio 2013','Make a calculator with stacks
		using postfix notation.',(SELECT (repo_id) FROM Repositories WHERE repo_name = 'postfix_stack_calculator'));

INSERT INTO Projects
VALUES((SELECT MAX(project_id) FROM Projects)+1,'X and O',
		SYSDATE,'20-MAY-2017',NULL,'C++','Visual Studio 2013','Make a game of X and O against an AI Computer',
		(SELECT (repo_id) FROM Repositories WHERE repo_name = 'x_and_o'));

INSERT INTO Projects
VALUES((SELECT MAX(project_id) FROM Projects)+1,'Movie Recommender',
		SYSDATE,'15-JUN-2016',NULL,'Java','Eclipse','A Movie Recommender that recommends movies to users',
		(SELECT (repo_id) FROM Repositories WHERE repo_name = 'movie_recommender'));

INSERT INTO Projects
VALUES((SELECT MAX(project_id) FROM Projects)+1,'Kevins Crow',
		SYSDATE,'10-JUL-2016',NULL,'Python','Sublime Text','A script to send pictures of crows to Kevin',
		(SELECT (repo_id) FROM Repositories WHERE repo_name = 'kevins_crow'));

--******REMEMBER TO UPDATE NUM OF REPOS ACCORDING TO THESE UPDATES!!******

--Drop projects table
DROP TABLE Projects;

--Create Programmers table
CREATE TABLE Programmers
(
	programmer_id INT NOT NULL,
	programmer_first_name VARCHAR2(20) NOT NULL,
	programmer_last_name VARCHAR2(20) NOT NULL,
	programmer_dob DATE NOT NULL,
	hire_date DATE NOT NULL,
	repo_username VARCHAR2(40) NOT NULL,
	project_id INT NULL,
	CONSTRAINT pk_programmer_id PRIMARY KEY (programmer_id),
	CONSTRAINT fk_project_id FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);

--Populate Progammers Table
INSERT INTO Programmers
VALUES(1,'Dean','Gaffney','20-MAR-1996','13-SEP-2014','Gaffmasterflex',
	(SELECT (project_id) FROM Projects WHERE project_name = 'kevins_crow'));

INSERT INTO Programmers
VALUES((SELECT MAX(programmer_id) FROM Programmers) + 1,'Shawn','Michaels','15-JUN-1983','31-OCT-2014','HBK',
	(SELECT (project_id) FROM Projects WHERE project_name = 'huffman_coding'));

INSERT INTO Programmers
VALUES((SELECT MAX(programmer_id) FROM Programmers) + 1,'Steve','Austin','01-JAN-1990','15-NOV-2014','SteveAustin316',
	(SELECT (project_id) FROM Projects WHERE project_name = 'postfix_stack_calculator'));

INSERT INTO Programmers
VALUES((SELECT MAX(programmer_id) FROM Programmers) + 1,'Philip','Meagher','20-MAR-1992','10-NOV-2014','PhillyMeagher',
	(SELECT (project_id) FROM Projects WHERE project_name = 'kevins_crow'));

--****REMEMBER TO UPDATE PROJECTS NUM OF PROGRAMMERS ACCORDING TO THESE*******

--Drop programmers table
DROP TABLE Programmers;

--Create Commits Table
CREATE TABLE Commits
(
	commit_number INT NOT NULL,
	commit_comment VARCHAR2(50) NOT NULL,
	repository_id INT NOT NULL,
	commit_time TIMESTAMP NOT NULL,
	CONSTRAINT pk_commit_number PRIMARY KEY (commit_number),
	CONSTRAINT fk_repository_id FOREIGN KEY (repository_id) REFERENCES Repositories(repo_id)
);

--Populate Commits Table
INSERT INTO Commits
VALUES (1,'Added multiple recipients to email sending.',(SELECT (repo_id) FROM Repositories WHERE repo_name = 'kevins_crow'),
		SYSDATE);

INSERT INTO Commits
VALUES ((SELECT MAX(commit_number) FROM Commits) + 1,'Postfix evaluation working.',(SELECT (repo_id) FROM Repositories WHERE repo_name = 'postfix_stack_calculator'),
		SYSDATE);

INSERT INTO Commits
VALUES ((SELECT MAX(commit_number) FROM Commits) + 1,'Users ArrayList fully populated',(SELECT (repo_id) FROM Repositories WHERE repo_name = 'movie_recommender'),
		SYSDATE);

INSERT INTO Commits
VALUES ((SELECT MAX(commit_number) FROM Commits) + 1,'Text file is now being compressed',(SELECT (repo_id) FROM Repositories WHERE repo_name = 'huffman_coding'),
		SYSDATE);

--****** CHECK AND MAKE SURE NOTHING NEEDS TO BE ALTERED iN oTHER TABLES BECAUSE OF THESE ADDITIONS********

--Drop commits table
DROP TABLE Commits;

--Create Files table
CREATE TABLE Files
(
	file_name VARCHAR2 (40) NOT NULL,
	creation_date DATE NOT NULL,
	last_modified DATE NOT NULL,
	file_size VARCHAR2(15) NOT NULL, -- eg.'42kb'
	num_of_lines INT NOT NULL,
	programmer_id INT NOT NULL,
	completed CHAR NOT NULL,
	brief VARCHAR2(300) NOT NULL,
	note VARCHAR2(100) NULL,
	commit_number INT NULL,
	CONSTRAINT pk_file_name PRIMARY KEY(file_name),
	CONSTRAINT fk_programmer_id FOREIGN KEY (programmer_id) REFERENCES Programmers(programmer_id),
	CONSTRAINT fk_commit_number FOREIGN KEY (commit_number) REFERENCES Commits(commit_number)
);

INSERT INTO Files
VALUES('HuffmanCodingTree.java',SYSDATE,SYSDATE,'2kb',87,
		(SELECT (programmer_id) FROM Programmers WHERE repo_username = 'HBK'),
		 'Y','This file deals with traversing and finding nodes in tree.','Slight Bug in tree traversal',
		  NULL);
	
DROP TABLE Files;

