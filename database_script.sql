--Create Repository Hosting Serivce
CREATE TABLE Hosting_Services
(
	service_name VARCHAR2 (50) NOT NULL,
	service_url VARCHAR2 (100) NOT NULL,
	num_of_repos INT DEFAULT 0,
	sign_up_date DATE DEFAULT SYSDATE,
	CONSTRAINT pk_service_url PRIMARY KEY (service_url),
	CHECK(num_of_repos >=0 AND num_of_repos <= 500)
);

--Populate Hosting Services Table
INSERT INTO Hosting_Services
VALUES('GitHub','www.github.com',0,SYSDATE);

INSERT INTO Hosting_Services
VALUES('BitBucket','www.bitbucket.com',0,SYSDATE);

--Drop hosting_services table
DROP TABLE Hosting_Services;
---------------------------------------------------------------------------------------------------------------------------
--Create Repository
CREATE TABLE Repositories
(
	repo_id INT NOT NULL,
	repo_name VARCHAR2(30) NOT NULL,
	branch_name VARCHAR2(30) NOT NULL,
	repo_size VARCHAR2(20) NOT NULL, --eg. '3mb'
	num_of_files INT DEFAULT 0,
	has_readme CHAR DEFAULT 'N',
	up_to_date CHAR DEFAULT 'N',
	last_commit_time TIMESTAMP DEFAULT SYSDATE,
	pushes_made INT DEFAULT 0,
	pulls_made INT DEFAULT 0,
	repo_url VARCHAR2(100) NOT NULL,
	service_url VARCHAR2(100) NOT NULL,
	CONSTRAINT pk_repo_id PRIMARY KEY (repo_id),
	CONSTRAINT fk_service_url FOREIGN KEY (service_url) REFERENCES Hosting_Services(service_url),
	CHECK(repo_id > 0),
	CHECK(has_readme = 'Y'OR has_readme = 'N'),
	CHECK(up_to_date = 'Y' OR up_to_date = 'N')
);

--Populate Repositories Table
INSERT INTO Repositories
VALUES(1,'huffman_coding','origin','5mb',20,'Y','Y',
	   SYSDATE,0,0,'www.github.com/huffman_coding',(SELECT (service_url)FROM Hosting_Services
	   WHERE service_url = 'www.github.com'));
--update repo NUMBERS!!!

INSERT INTO Repositories
VALUES((SELECT MAX(repo_id) FROM Repositories) + 1,'postfix_stack_calculator','origin','8mb',18,'N','Y',
	   SYSDATE,0,0,'www.bitbucket.com/postfix_stack_calculator',(SELECT (service_url)FROM Hosting_Services
	   WHERE service_url = 'www.bitbucket.com'));

INSERT INTO Repositories
VALUES((SELECT MAX(repo_id) FROM Repositories) + 1,'x_and_o','origin','8mb',18,'N','Y',
	   SYSDATE,0,0,'www.bitbucket.com/x_and_o',(SELECT (service_url)FROM Hosting_Services
	   WHERE service_url = 'www.bitbucket.com'));

INSERT INTO Repositories
VALUES((SELECT MAX(repo_id) FROM Repositories) + 1,'movie_recommender','origin','8mb',18,'N','Y',
	   SYSDATE,0,0,'www.github.com/movie_recommender',(SELECT (service_url)FROM Hosting_Services
	   WHERE service_url = 'www.github.com'));

INSERT INTO Repositories
VALUES((SELECT MAX(repo_id) FROM Repositories) + 1,'kevins_crow','origin','24kb',18,'Y','Y',
	   SYSDATE,0,0,'www.github.com/kevins_crow',(SELECT (service_url)FROM Hosting_Services
	   WHERE service_url = 'www.github.com'));

--Update the Repo Number Counts after Inserts.
UPDATE Hosting_Services
SET num_of_repos = (SELECT COUNT(*) FROM Repositories WHERE service_url = 'www.github.com')
WHERE service_name = 'GitHub';

UPDATE Hosting_Services
SET num_of_repos = (SELECT COUNT(*) FROM Repositories WHERE service_url = 'www.bitbucket.com')
WHERE service_name = 'BitBucket';

--Drop repositories table
DROP TABLE Repositories;

---------------------------------------------------------------------------------------------------------------------------


--Create the Projects table
CREATE TABLE Projects
(
	project_id INT NOT NULL,
	project_name VARCHAR2(100) NOT NULL,
	project_start_date DATE DEFAULT SYSDATE,
	project_dead_line DATE NOT NULL,
	project_programmers INT DEFAULT 0,
	project_language VARCHAR2(50) NOT NULL,
	project_ide VARCHAR2(50) DEFAULT 'Undecided at this time',
	project_brief VARCHAR2(300) DEFAULT 'To be discussed',
	has_repo CHAR DEFAULT 'N',
	repo_id INT NULL,
	CONSTRAINT pk_project_id PRIMARY KEY (project_id),
	CONSTRAINT fk_repo_id FOREIGN KEY (repo_id) REFERENCES Repositories(repo_id),
	CHECK(project_id > 0),
	CHECK(has_repo = 'Y' OR has_repo = 'N')
);

--Populate Projects Table
INSERT INTO Projects
VALUES(1,'Huffman Coding',SYSDATE,'23-SEP-2016',NULL,'Java','Eclipse',
	  'Compress a text file using huffman coding techniques.','Y',
	  (SELECT (repo_id) FROM Repositories WHERE repo_name = 'huffman_coding'));

INSERT INTO Projects
VALUES((SELECT MAX(project_id) FROM Projects)+1,'Postfix Stack Calculator',
		SYSDATE,'20-MAR-2017',NULL,'C++','Visual Studio 2013','Make a calculator with stacks
		using postfix notation.','Y',(SELECT (repo_id) FROM Repositories WHERE repo_name = 'postfix_stack_calculator'));

INSERT INTO Projects
VALUES((SELECT MAX(project_id) FROM Projects)+1,'X and O',
		SYSDATE,'20-MAY-2017',NULL,'C++','Visual Studio 2013','Make a game of X and O against an AI Computer','Y',
		(SELECT (repo_id) FROM Repositories WHERE repo_name = 'x_and_o'));

INSERT INTO Projects
VALUES((SELECT MAX(project_id) FROM Projects)+1,'Movie Recommender',
		SYSDATE,'15-JUN-2016',NULL,'Java','Eclipse','A Movie Recommender that recommends movies to users','Y',
		(SELECT (repo_id) FROM Repositories WHERE repo_name = 'movie_recommender'));

INSERT INTO Projects
VALUES((SELECT MAX(project_id) FROM Projects)+1,'Kevins Crow',
		SYSDATE,'10-JUL-2016',NULL,'Python','Sublime Text','A script to send pictures of crows to Kevin','Y',
		(SELECT (repo_id) FROM Repositories WHERE repo_name = 'kevins_crow'));
 
--Drop projects table
DROP TABLE Projects;

---------------------------------------------------------------------------------------------------------------------------

--Create Programmers table
CREATE TABLE Programmers
(
	programmer_id INT NOT NULL,
	programmer_first_name VARCHAR2(20) NOT NULL,
	programmer_last_name VARCHAR2(20) NOT NULL,
	programmer_dob DATE NOT NULL,
	hire_date DATE DEFAULT SYSDATE,
	repo_username VARCHAR2(40) NOT NULL,
	project_id INT NULL,
	CONSTRAINT pk_programmer_id PRIMARY KEY (programmer_id),
	CONSTRAINT fk_project_id FOREIGN KEY (project_id) REFERENCES Projects(project_id),
	CHECK(programmer_id > 0)
);

--Populate Progammers Table
INSERT INTO Programmers
VALUES(1,'Dean','Gaffney','20-MAR-1996','13-SEP-2014','Gaffmasterflex',
	(SELECT (project_id) FROM Projects WHERE project_name = 'Kevins Crow'));

INSERT INTO Programmers
VALUES((SELECT MAX(programmer_id) FROM Programmers) + 1,'Shawn','Michaels','15-JUN-1983','31-OCT-2014','HBK',
	(SELECT (project_id) FROM Projects WHERE project_name = 'Huffman Coding'));

INSERT INTO Programmers
VALUES((SELECT MAX(programmer_id) FROM Programmers) + 1,'Steve','Austin','01-JAN-1990','15-NOV-2014','SteveAustin316',
	(SELECT (project_id) FROM Projects WHERE project_name = 'Postfix Stack Calculator'));

INSERT INTO Programmers
VALUES((SELECT MAX(programmer_id) FROM Programmers) + 1,'Philip','Meagher','20-MAR-1992','10-NOV-2014','PhillyMeagher',
	(SELECT (project_id) FROM Projects WHERE project_name = 'Kevins Crow'));

--****REMEMBER TO UPDATE PROJECTS NUM OF PROGRAMMERS ACCORDING TO THESE INSERTS*******

UPDATE Projects
SET project_programmers = (SELECT COUNT(*) FROM Programmers 
	WHERE project_id = (SELECT (project_id) FROM Projects WHERE project_name = 'Kevins Crow'))
WHERE project_name = 'Kevins Crow';

UPDATE Projects
SET project_programmers = (SELECT COUNT(*) FROM Programmers 
	WHERE project_id = (SELECT (project_id) FROM Projects WHERE project_name = 'Huffman Coding'))
WHERE project_name = 'Huffman Coding';

UPDATE Projects
SET project_programmers = (SELECT COUNT(*) FROM Programmers 
	WHERE project_id = (SELECT (project_id) FROM Projects WHERE project_name = 'Postfix Stack Calculator'))
WHERE project_name = 'Postfix Stack Calculator';

UPDATE Projects
SET project_programmers = (SELECT COUNT(*) FROM Programmers 
	WHERE project_id = (SELECT (project_id) FROM Projects WHERE project_name = 'Movie Recommender'))
WHERE project_name = 'Movie Recommender';

UPDATE Projects
SET project_programmers = (SELECT COUNT(*) FROM Programmers 
	WHERE project_id = (SELECT (project_id) FROM Projects WHERE project_name = 'X and O'))
WHERE project_name = 'X and O';

--Drop programmers table
DROP TABLE Programmers;

---------------------------------------------------------------------------------------------------------------------------

--Create Commits Table
CREATE TABLE Commits
(
	commit_number INT NOT NULL,
	commit_comment VARCHAR2(50) NOT NULL,
	num_of_files INT DEFAULT 0,
	repository_id INT NOT NULL,
	commit_time TIMESTAMP DEFAULT SYSDATE,
	CONSTRAINT pk_commit_number PRIMARY KEY (commit_number),
	CONSTRAINT fk_repository_id FOREIGN KEY (repository_id) REFERENCES Repositories(repo_id),
	CHECK(commit_number > 0)
);


--Populate Commits Table
INSERT INTO Commits
VALUES (1,'Added multiple recipients to email sending.',0,(SELECT (repo_id) FROM Repositories WHERE repo_name = 'kevins_crow'),
		SYSDATE);

INSERT INTO Commits
VALUES ((SELECT MAX(commit_number) FROM Commits) + 1,'Postfix evaluation working.',0,(SELECT (repo_id) FROM Repositories WHERE repo_name = 'postfix_stack_calculator'),
		SYSDATE);

INSERT INTO Commits
VALUES ((SELECT MAX(commit_number) FROM Commits) + 1,'Users ArrayList fully populated',0,(SELECT (repo_id) FROM Repositories WHERE repo_name = 'movie_recommender'),
		SYSDATE);

INSERT INTO Commits
VALUES ((SELECT MAX(commit_number) FROM Commits) + 1,'Text file is now being compressed',0,(SELECT (repo_id) FROM Repositories WHERE repo_name = 'huffman_coding'),
		SYSDATE);

--****** CHECK AND MAKE SURE NOTHING NEEDS TO BE ALTERED iN OTHER TABLES BECAUSE OF THESE ADDITIONS********

--Drop commits table
DROP TABLE Commits;

---------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Pushes
(
	push_id INT NOT NULL,
	time_of_push TIMESTAMP DEFAULT SYSDATE,
	repo_id INT NOT NULL,
	programmer_username VARCHAR2(100) NOT NULL,
	CONSTRAINT pk_push_id PRIMARY KEY (push_id),
	CONSTRAINT fk_rep_id FOREIGN KEY (repo_id) REFERENCES Repositories(repo_id),
	CHECK(push_id > 0)
);

--Populate Push Table
INSERT INTO Pushes
VALUES(1,SYSDATE,(SELECT (repo_id) FROM Repositories WHERE repo_name = 'kevins_crow'),
	(SELECT (repo_username) FROM Programmers WHERE programmer_id = 1));

INSERT INTO Pushes
VALUES((SELECT MAX(push_id) FROM Pushes) + 1,SYSDATE,(SELECT (repo_id) FROM Repositories WHERE repo_name = 'huffman_coding'),
	(SELECT (repo_username) FROM Programmers WHERE programmer_id = 2));

INSERT INTO Pushes
VALUES((SELECT MAX(push_id) FROM Pushes) + 1,SYSDATE,(SELECT (repo_id) FROM Repositories WHERE repo_name = 'movie_recommender'),
	(SELECT (repo_username) FROM Programmers WHERE programmer_id = 3));

INSERT INTO Pushes
VALUES((SELECT MAX(push_id) FROM Pushes) + 1,SYSDATE,(SELECT (repo_id) FROM Repositories WHERE repo_name = 'x_and_o'),
	(SELECT (repo_username) FROM Programmers WHERE programmer_id = 4));


-- *****UPDATE PUSHES TO REPO HERE*******
UPDATE Repositories
SET pushes_made = (SELECT COUNT(*) FROM Pushes 
	WHERE repo_id = (SELECT (repo_id) FROM Repositories WHERE repo_name = 'kevins_crow'))
WHERE repo_name = 'kevins_crow';

UPDATE Repositories
SET pushes_made = (SELECT COUNT(*) FROM Pushes 
	WHERE repo_id = (SELECT (repo_id) FROM Repositories WHERE repo_name = 'movie_recommender'))
WHERE repo_name = 'movie_recommender';

UPDATE Repositories
SET pushes_made = (SELECT COUNT(*) FROM Pushes 
	WHERE repo_id = (SELECT (repo_id) FROM Repositories WHERE repo_name = 'x_and_o'))
WHERE repo_name = 'x_and_o';

UPDATE Repositories
SET pushes_made = (SELECT COUNT(*) FROM Pushes 
	WHERE repo_id = (SELECT (repo_id) FROM Repositories WHERE repo_name = 'huffman_coding'))
WHERE repo_name = 'huffman_coding';


--Drop Push Table
DROP TABLE Pushs;

---------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Pulls
(
	pull_id INT NOT NULL,
	repo_id INT NOT NULL,
	pull_time TIMESTAMP DEFAULT SYSDATE,
	programmer_username VARCHAR2(100) NOT NULL,
	CONSTRAINT pk_pull_id PRIMARY KEY (pull_id),
	CONSTRAINT fk_repos_id FOREIGN KEY (repo_id) REFERENCES Repositories(repo_id),
	CHECK(pull_id > 0)
);

INSERT INTO Pulls
VALUES(1,(SELECT (repo_id) FROM Repositories WHERE repo_name = 'kevins_crow'),SYSDATE,
	  (SELECT (repo_username) FROM Programmers WHERE programmer_id = 1));

INSERT INTO Pulls
VALUES((SELECT MAX(pull_id) FROM Pulls) + 1,(SELECT (repo_id) FROM Repositories WHERE repo_name = 'movie_recommender'),SYSDATE,
	  (SELECT (repo_username) FROM Programmers WHERE programmer_id = 2));

INSERT INTO Pulls
VALUES((SELECT MAX(pull_id) FROM Pulls) + 1,(SELECT (repo_id) FROM Repositories WHERE repo_name = 'x_and_o'),SYSDATE,
	  (SELECT (repo_username) FROM Programmers WHERE programmer_id = 3));

INSERT INTO Pulls
VALUES((SELECT MAX(pull_id) FROM Pulls) + 1,(SELECT (repo_id) FROM Repositories WHERE repo_name = 'huffman_coding'),SYSDATE,
	  (SELECT (repo_username) FROM Programmers WHERE programmer_id = 4));

INSERT INTO Pulls
VALUES((SELECT MAX(pull_id) FROM Pulls) + 1,(SELECT (repo_id) FROM Repositories WHERE repo_name = 'huffman_coding'),SYSDATE,
	  (SELECT (repo_username) FROM Programmers WHERE programmer_id = 1));

-- *****UPDATE PUlls FROM REPO HERE*******
UPDATE Repositories
SET pulls_made = (SELECT COUNT(*) FROM Pulls 
	WHERE repo_id = (SELECT (repo_id) FROM Repositories WHERE repo_name = 'kevins_crow'))
WHERE repo_name = 'kevins_crow';

UPDATE Repositories
SET pulls_made = (SELECT COUNT(*) FROM Pulls 
	WHERE repo_id = (SELECT (repo_id) FROM Repositories WHERE repo_name = 'huffman_coding'))
WHERE repo_name = 'huffman_coding';

UPDATE Repositories
SET pulls_made = (SELECT COUNT(*) FROM Pulls 
	WHERE repo_id = (SELECT (repo_id) FROM Repositories WHERE repo_name = 'x_and_o'))
WHERE repo_name = 'x_and_o';


--Delete Pulls Table
DROP TABLE Pulls;
---------------------------------------------------------------------------------------------------------------------------

--Create Files table
CREATE TABLE Files
(
	file_name VARCHAR2 (40) NOT NULL,
	creation_date DATE DEFAULT SYSDATE,
	last_modified DATE DEFAULT SYSDATE,
	file_size VARCHAR2(15) NOT NULL, -- eg.'42kb'
	num_of_lines INT NOT NULL,
	programmer_id INT NOT NULL,
	completed CHAR DEFAULT 'N',
	brief VARCHAR2(300) DEFAULT 'To be discussed',
	note VARCHAR2(100) DEFAULT 'No note',
	commit_number INT NULL,
	CONSTRAINT pk_file_name PRIMARY KEY(file_name),
	CONSTRAINT fk_programmer_id FOREIGN KEY (programmer_id) REFERENCES Programmers(programmer_id),
	CONSTRAINT fk_commit_number FOREIGN KEY (commit_number) REFERENCES Commits(commit_number),
	CHECK(completed = 'Y' OR completed = 'N')
);

INSERT INTO Files
VALUES('HuffmanCodingTree.java',SYSDATE,SYSDATE,'2kb',87,
		(SELECT (programmer_id) FROM Programmers WHERE repo_username = 'HBK'),
		 'N','This file deals with traversing and finding nodes in tree.','Slight Bug in tree traversal',
		  NULL);

INSERT INTO Files
VALUES('Node.java',SYSDATE,SYSDATE,'2kb',54,
		(SELECT (programmer_id) FROM Programmers WHERE repo_username = 'HBK'),
		 'Y','Node class containing weight,left,right children and character','Fully Functional',
		  NULL);

INSERT INTO Files
VALUES('Calculator.java',SYSDATE,SYSDATE,'1kb',112,
		(SELECT (programmer_id) FROM Programmers WHERE repo_username = 'SteveAustin316'),
		 'N','The main GUI for the calculator','Added in power of button',
		  NULL);

INSERT INTO Files
VALUES('kevins_crow.py',SYSDATE,SYSDATE,'2kb',25,
		(SELECT (programmer_id) FROM Programmers WHERE repo_username = 'Gaffmasterflex'),
		 'Y','Emails pictures of crows to kevin everyday','Able to send email to serveral recipients',
		  NULL);

	
DROP TABLE Files;

