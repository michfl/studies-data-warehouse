USE DW_LAB;


-- LICZNOŒÆ TABEL

SELECT COUNT(*) AS Presentations FROM presentations;

SELECT COUNT(*) AS Agents FROM agents;

SELECT COUNT(*) AS Clients FROM clients;

SELECT COUNT(*) AS 'Company branches' FROM company_branches;

SELECT COUNT(*) AS 'Market values' FROM market_values;

SELECT COUNT(*) AS 'Real estate locations' FROM real_estate_locations;

SELECT COUNT(*) AS 'Real estates' FROM real_estates;

SELECT COUNT(*) AS Salaries FROM salaries;



-- PRZYK£ADY Z TABEL

SELECT TOP 10 *
FROM presentations
ORDER BY presentation_date ASC;

SELECT TOP 10 *
FROM presentations
WHERE contract_code IS NOT NULL;

SELECT TOP 10 *
FROM (((presentations INNER JOIN agents ON presentations.agent_id = agents.agent_id)
	INNER JOIN clients ON presentations.client_id = clients.client_id)
	INNER JOIN real_estates ON presentations.estate_id = real_estates.estate_id)
	INNER JOIN real_estate_locations ON presentations.estate_id = real_estate_locations.estate_id;


SELECT TOP 10 *
FROM clients
ORDER BY creditworthiness DESC;


SELECT TOP 10 *
FROM agents INNER JOIN company_branches
ON agents.branch_id = company_branches.branch_id;

SELECT *
FROM salaries
WHERE agent_id = 100;


SElECT TOP 10 *
FROM real_estates INNER JOIN real_estate_locations
ON real_estates.estate_id = real_estate_locations.estate_id;

SELECT *
FROM market_values
WHERE estate_id = 100;