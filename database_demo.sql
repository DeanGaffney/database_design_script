------DATABASE DEMO--------

--Show created tables
SELECT * FROM view_hosting_services_table;
SELECT * FROM view_repositories_table;
SELECT * FROM view_projects_table;
SELECT * FROM view_programmers_table;
SELECT * FROM view_commits_table;
SELECT * FROM view_pushes_table;
SELECT * FROM view_pulls_table;
SELECT * FROM view_files_table;


--insert a repository
INSERT INTO Repositories
VALUES((SELECT MAX(repo_id) FROM Repositories) + 1,'file_renamer','origin','24kb',18,'N','Y',
	   SYSDATE,0,0,'www.github.com/file_renamer',(SELECT (service_url)FROM Hosting_Services
	   WHERE service_url = 'www.github.com'));

UPDATE Repositories
SET has_readme = 'Y'
WHERE repo_name = 'file_renamer';

--update the amount of repositories on github
UPDATE Hosting_Services
SET num_of_repos = (SELECT COUNT(*) FROM Repositories WHERE service_url = 'www.github.com')
WHERE service_name = 'GitHub';

--Delete the new entry
DELETE FROM Repositories
WHERE repo_name = 'file_renamer';

--update again to correct counter
UPDATE Hosting_Services
SET num_of_repos = (SELECT COUNT(*) FROM Repositories WHERE service_url = 'www.github.com')
WHERE service_name = 'GitHub';

SELECT * FROM view_programmers_of_git_repo;

SELECT * FROM view_most_active_repo;

--What programmers are currently working on a specific project.
SELECT p.programmer_id AS "ID",p.programmer_first_name AS "First Name",													----> QUEREY 1.
	   p.programmer_last_name AS "Last Name",pro.project_id AS "Project ID",
	   pro.project_name AS "Project Name"
FROM Programmers p JOIN Projects pro ON p.project_id = pro.project_id
WHERE p.project_id = pro.project_id AND pro.project_name LIKE '%Kev%';

--What programmer wrote a particular file. (uses regex to find files ending with .java or .py)
SELECT p.programmer_id AS "ID",p.programmer_first_name AS "First Name",													----> QUEREY 2.
	   p.programmer_last_name AS "Last Name",f.file_name AS "File Name"
FROM Programmers p JOIN Files f ON p.programmer_id = f.programmer_id
WHERE p.programmer_id = f.programmer_id AND REGEXP_LIKE (f.file_name,'\.(java|py)$');

SELECT repo_id AS "ID",repo_name AS "Name",
	   MAX(last_commit_time) AS "Last Commit" 
FROM Repositories
WHERE repo_name = 'kevins_crow'
GROUP BY repo_id, repo_name
ORDER BY repo_id;