USE world_layoff;

SELECT *
FROM layoffs;

-- 1.REMOVE DUPLICATES
-- 2.STANDARDIZE THE DATA 
-- 3.NULL VALUES OR BLANK VALUES
-- 4.REMOVE ANY COLUMN


CREATE TABLE layoffs_staging
LIKE layoffs;
  

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

--  1.REMOVE DUPLICATES

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company ,location, industry , total_laid_off, percentage_laid_off , `date`,stage, country , funds_raised_millions) AS  row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company ,location, industry , total_laid_off, percentage_laid_off , `date`,stage, country , funds_raised_millions) AS  row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;


-- create another staging to add row_num column as we cant delete directly from cte 
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company ,location, industry , total_laid_off, percentage_laid_off , `date`,stage, country , funds_raised_millions) AS  row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num = 2;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;


-- 2.STANDARDIZING DATA

-- removing white space 
SELECT company , TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- industry name 

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;


SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- check location
SELECT DISTINCT location
FROM layoffs_staging2; -- everything is good

-- Check country
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1; 

UPDATE layoffs_staging2
SET country = 'United States'  
WHERE country LIKE 'United States%';

-- date
-- text to date 
SELECT `date`,
STR_TO_DATE(`date` , '%m/%d/%Y') -- small m & d , capital Y
FROM layoffs_staging2; 

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date` , '%m/%d/%Y');


ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- 3.NULL VALUES OR BLANK VALUES

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '';

-- filling numm or blank values 
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

-- change blank rows into null 
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';


SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
	AND t1.location = t2.location
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;



UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- 4.DELETE COLUMN
ALTER TABLE layoffs_staging2
DROP COLUMN row_num; 


SELECT *
FROM layoffs_staging2;
 

