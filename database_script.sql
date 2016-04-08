--Create Repository Hosting Serivce
CREATE TABLE Hosting_Services
(
	service_url VARCHAR2 (100) NOT NULL,
	service_name VARCHAR2 (50) NOT NULL,
	num_of_repos INT NOT NULL,
	sign_up_date DATE NOT NULL,
	CONSTRAINT pk_service_url PRIMARY KEY (service_url)
);
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
--Drop programmers table
DROP TABLE Programmers;

--Create Commits Table
CREATE TABLE Commits
(
	commit_number INT NOT NULL,
	commit_comment VARCHAR2(50) NULL,
	repository_id INT NOT NULL,
	commit_time TIMESTAMP NOT NULL,
	CONSTRAINT pk_commit_number PRIMARY KEY (commit_number),
	CONSTRAINT fk_repository_id FOREIGN KEY (repository_id) REFERENCES Repositories(repo_id))
);
--Drop commits table
DROP TABLE Commits;

--Create Files table
CREATE TABLE Files
(
	file_name VARCHAR2 (20) NOT NULL,
	creation_date DATE NOT NULL,
	last_modified DATE NOT NULL,
	file_size VARCHAR2(15) NOT NULL, -- eg.'42kb'
	num_of_lines INT NOT NULL,
	programmer_id INT NOT NULL,
	completed CHAR NOT NULL,
	brief VARCHAR2(300) NOT NULL,
	note VARCHAR2(100) NULL,
	commit_number INT NOT NULL,
	CONSTRAINT pk_file_name PRIMARY KEY(file_name),
	CONSTRAINT fk_programmer_id FOREIGN KEY (programmer_id) REFERENCES Programmers(programmer_id),
	CONSTRAINT fk_commit_number FOREIGN KEY (commit_number) REFERENCES Commits(commit_number)
);
DROP TABLE Files;

