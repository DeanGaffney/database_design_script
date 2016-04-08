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
	CONSTRAINT pk_project_id PRIMARY KEY (project_id)
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