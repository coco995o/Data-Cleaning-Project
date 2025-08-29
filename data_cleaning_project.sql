SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off,
percentage_laid_off, date,state,country,funds_raised_millions) AS row_number
FROM new_layoffs;

WITH cte AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off,
percentage_laid_off, date,state,country,funds_raised_millions) AS row_number
FROM new_layoffs
)
SELECT * FROM cte
WHERE row_number > 1;

SELECT * FROM new_layoffs
WHERE company = 'Casper';

CREATE TABLE IF NOT EXISTS public.new_layoffs2
(
    company text COLLATE pg_catalog."default",
    location text COLLATE pg_catalog."default",
    industry text COLLATE pg_catalog."default",
    total_laid_off numeric,
    percentage_laid_off numeric,
    date text COLLATE pg_catalog."default",
    state text COLLATE pg_catalog."default",
    country text COLLATE pg_catalog."default",
    funds_raised_millions numeric,
	id serial
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.new_layoffs
    OWNER to postgres;

INSERT INTO new_layoffs2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off,
percentage_laid_off, date,state,country,funds_raised_millions) AS row_number
FROM new_layoffs;

SELECT * FROM new_layoffs2;

DELETE FROM new_layoffs2
WHERE id > 1;

SELECT * FROM new_layoffs2;

--Remove Duplicates
--Standardizing data
--Remove NULL values and blanks
--Remove wrong columns

SELECT company, TRIM(company) FROM new_layoffs2;

UPDATE new_layoffs2
SET company = TRIM(company);

SELECT * FROM new_layoffs2
WHERE industry LIKE '%Crypto%';

UPDATE new_layoffs2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT * FROM new_layoffs2
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) FROM new_layoffs2
WHERE country LIKE 'United States%';

UPDATE new_layoffs2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT TO_DATE(date, 'MM/DD/YYYY') AS new_date, date, correct_date
FROM new_layoffs2;

--ALTER TABLE new_layoffs2
--ADD correct_date date;

UPDATE new_layoffs2
SET correct_date = TO_DATE(date, 'MM/DD/YYYY');

SELECT * FROM new_layoffs2
WHERE total_laid_off IS NULL
	AND percentage_laid_off IS NULL;

SELECT * FROM new_layoffs2
WHERE industry IS NULL
	OR industry = '';
	
SELECT * FROM new_layoffs2
WHERE company = 'Airbnb';

UPDATE new_layoffs2
SET industry = 'Travel'
WHERE (industry = '' 
	OR industry IS NULL)
	AND company = 'Airbnb';

SELECT DISTINCT company, industry FROM new_layoffs2
WHERE company LIKE 'Carvana';

UPDATE new_layoffs2
SET industry = 'Transportation'
WHERE (industry = '' 
	OR industry IS NULL)
	AND company = 'Carvana';

SELECT DISTINCT company, industry FROM new_layoffs2
WHERE company LIKE 'Juul';

UPDATE new_layoffs2
SET industry = 'Consumer'
WHERE (industry = '' 
	OR industry IS NULL)
	AND company = 'Juul';	

SELECT * FROM new_layoffs2
WHERE total_laid_off IS NULL
	AND percentage_laid_off IS NULL;

DELETE FROM new_layoffs2
WHERE total_laid_off IS NULL
	AND percentage_laid_off IS NULL;

ALTER TABLE new_layoffs2
DROP COLUMN id;

