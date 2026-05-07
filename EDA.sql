-- Exploratory Data Analysis on Layoffs Dataset

-- View complete dataset
SELECT *
FROM layoffs_staging2;


-- Find the maximum number of layoffs and highest layoff percentage
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;


-- Find companies where 100% employees were laid off
-- Ordered by highest funds raised
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


-- Find total layoffs by company
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


-- Find the earliest and latest layoff dates
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;


-- Find total layoffs by industry
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


-- Find total layoffs by country
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


-- Find total layoffs year-wise
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;


-- Calculate rolling total of layoffs month-wise
WITH Rolling_total AS
(
    -- Extract month and calculate layoffs per month
    SELECT SUBSTR(`date`,1,7) AS month,
           SUM(total_laid_off) AS total_off
    FROM layoffs_staging2
    WHERE SUBSTR(`date`,1,7) IS NOT NULL
    GROUP BY SUBSTR(`date`,1,7)
    ORDER BY 1
)

-- Calculate cumulative layoffs over time
SELECT month,
       total_off,
       SUM(total_off) OVER(ORDER BY month) AS rolling_total
FROM Rolling_total;


-- Find total layoffs by company and year
SELECT company,
       YEAR(`date`),
       SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;


-- Find top 5 companies with highest layoffs each year
WITH company_year (company, years, total_laid_off) AS
(
    -- Calculate total layoffs by company and year
    SELECT company,
           YEAR(`date`),
           SUM(total_laid_off)
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
),

company_year_rank AS
(
    -- Rank companies based on layoffs within each year
    SELECT *,
           DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
    FROM company_year
    WHERE years IS NOT NULL
)

-- Display only top 5 ranked companies each year
SELECT *
FROM company_year_rank
WHERE Ranking <= 5;


-- Find companies with high funding (100M+) and their industries
SELECT company,
       industry,
       YEAR(`date`) AS year,
       funds_raised_millions
FROM layoffs_staging2
WHERE funds_raised_millions >= 100
ORDER BY funds_raised_millions DESC;
