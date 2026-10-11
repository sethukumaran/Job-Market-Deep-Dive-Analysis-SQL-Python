-- Job Market Deep-Dive SQL Analysis
-- Generated from the supplied CSV datasets.

-- 01_kpi_summary
SELECT COUNT(*) AS job_records,
       COUNT(DISTINCT company) AS companies,
       COUNT(DISTINCT source) AS sources,
       SUM(openings) AS total_openings,
       SUM(CASE WHEN remote=1 THEN 1 ELSE 0 END) AS remote_jobs,
       SUM(CASE WHEN fresher_friendly=1 THEN 1 ELSE 0 END) AS fresher_jobs,
       SUM(CASE WHEN closed_at IS NULL THEN 1 ELSE 0 END) AS currently_open_records,
       SUM(CASE WHEN pay_min IS NOT NULL AND pay_max IS NOT NULL THEN 1 ELSE 0 END) AS salary_records
FROM jobs;

-- 02_top_companies
SELECT company, COUNT(*) AS job_count, SUM(openings) AS openings
FROM jobs GROUP BY company ORDER BY job_count DESC LIMIT 15;

-- 03_category_mix
SELECT category, COUNT(*) AS job_count,
       ROUND(100.0*COUNT(*)/(SELECT COUNT(*) FROM jobs),2) AS share_pct
FROM jobs GROUP BY category ORDER BY job_count DESC;

-- 04_level_mix
SELECT level, COUNT(*) AS job_count,
       ROUND(100.0*COUNT(*)/(SELECT COUNT(*) FROM jobs),2) AS share_pct
FROM jobs GROUP BY level ORDER BY job_count DESC;

-- 05_fresher_by_category
SELECT category, COUNT(*) AS job_count,
       SUM(CASE WHEN fresher_friendly=1 THEN 1 ELSE 0 END) AS fresher_jobs,
       ROUND(100.0*SUM(CASE WHEN fresher_friendly=1 THEN 1 ELSE 0 END)/COUNT(*),2) AS fresher_share_pct
FROM jobs GROUP BY category HAVING COUNT(*) >= 250
ORDER BY fresher_share_pct DESC;

-- 06_remote_by_category
SELECT category, COUNT(*) AS job_count,
       SUM(CASE WHEN remote=1 THEN 1 ELSE 0 END) AS remote_jobs,
       ROUND(100.0*AVG(CASE WHEN remote=1 THEN 1.0 ELSE 0.0 END),2) AS remote_share_pct
FROM jobs GROUP BY category HAVING COUNT(*) >= 250
ORDER BY remote_share_pct DESC;

-- 07_source_mix
SELECT source, COUNT(*) AS job_count,
       ROUND(100.0*COUNT(*)/(SELECT COUNT(*) FROM jobs),2) AS share_pct
FROM jobs GROUP BY source ORDER BY job_count DESC;

-- 08_skill_demand
SELECT skill, SUM(jobs) AS skill_job_mentions,
       ROUND(AVG(share_pct),2) AS avg_share_pct
FROM skill_demand_daily GROUP BY skill
ORDER BY skill_job_mentions DESC LIMIT 20;

-- 09_daily_trend
SELECT date, open_jobs, fresher_friendly_jobs,
       ROUND(100.0*fresher_friendly_jobs/open_jobs,2) AS fresher_share_pct
FROM open_jobs_daily ORDER BY date;

-- 10_salary_by_currency
SELECT pay_currency, COUNT(*) AS records,
       ROUND(AVG((pay_min+pay_max)/2),2) AS avg_mid_salary,
       ROUND(AVG((pay_min+pay_max)/2),2) AS avg_mid_salary_repeat
FROM jobs
WHERE pay_min IS NOT NULL AND pay_max IS NOT NULL
GROUP BY pay_currency ORDER BY records DESC;

-- 11_data_quality
SELECT
  SUM(CASE WHEN skills IS NULL OR TRIM(skills)='' THEN 1 ELSE 0 END) AS missing_skills,
  SUM(CASE WHEN employment IS NULL OR TRIM(employment)='' THEN 1 ELSE 0 END) AS missing_employment,
  SUM(CASE WHEN years_experience IS NULL THEN 1 ELSE 0 END) AS missing_experience,
  SUM(CASE WHEN pay_min IS NULL OR pay_max IS NULL THEN 1 ELSE 0 END) AS missing_salary,
  SUM(CASE WHEN posted IS NULL THEN 1 ELSE 0 END) AS missing_posted,
  SUM(CASE WHEN closed_at IS NULL THEN 1 ELSE 0 END) AS missing_closed_at,
  SUM(CASE WHEN closed_at IS NOT NULL AND first_seen > closed_at THEN 1 ELSE 0 END) AS invalid_close_sequence
FROM jobs;

