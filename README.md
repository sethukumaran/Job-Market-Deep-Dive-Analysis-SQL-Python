# Job Market Deep-Dive Analysis — SQL & Python

## 1. Project Overview

This project performs an end-to-end **job-market analytics study** using the supplied job-market datasets.

The analysis combines:

- **Python / Pandas / NumPy** for data cleaning, EDA, feature engineering and statistical/business analysis.
- **SQL / SQLite** for KPI extraction, segmentation, ranking and business questions.
- **Matplotlib** for decision-oriented visualizations.
- Separate daily datasets for open-job and skill-demand trends.

### Business objective

The objective is to answer:

1. What does the job market look like by category, level, source and company?
2. Which companies and skills create the largest opportunity pools?
3. How accessible is the market for freshers?
4. How important is remote work?
5. What skills have the strongest demand?
6. What is the salary-data coverage and what quality limitations exist?
7. What data-quality and market-signal issues should a decision maker consider?


## 2. Dataset

| Dataset | Rows | Purpose |
|---|---:|---|
| `jobs.csv` | 81,753 | Main job-level fact table |
| `jobs_by_company.csv` | 856 | Company-level fresher/job metrics |
| `open_jobs_daily.csv` | 8 | Daily open-job and fresher-job trend |
| `skill_demand_daily.csv` | 829 | Daily skill demand and share |

Main job table contains **81,753 job records**, **5,953 companies**, and **9 sources**.


## 3. Initial EDA

### Structural findings

- Duplicate rows: **0**
- Duplicate URLs: **0**
- Remote jobs: **10,363 (12.68%)**
- Fresher-friendly jobs: **13,095 (16.02%)**
- Records with salary values: **15,930 (19.49%)**
- Records with a ghost score: **72,536**
- High ghost-score records (>= 0.5): **11,277**
- Invalid `first_seen > closed_at` sequences: **23**

### Important missing-data observations

The main table has substantial missingness in:

- `pay_min`, `pay_max`, `pay_currency`
- `employment`
- `years_experience`
- `skills`
- `closed_at`

Missing values are not automatically errors because several fields are optional in job-board data. However, they reduce the reliability of salary, experience and skill-level conclusions.


## 4. Key Business Findings

### 4.1 Market scale and growth

The daily open-job dataset increased from **17,437** to **74,685**, a change of approximately **328.3%** over the observed period.

This indicates a rapidly expanding observed opportunity pool. Because the period is short, this should be interpreted as a **dataset/market snapshot trend**, not a long-term employment-market forecast.

### 4.2 Largest job categories

Top categories by job-record volume:

- **engineering**: 19,466 jobs (23.81%)
- **sales**: 9,702 jobs (11.87%)
- **other**: 8,460 jobs (10.35%)
- **operations**: 5,009 jobs (6.13%)
- **data**: 4,927 jobs (6.03%)

**Interpretation:** Engineering is the largest opportunity pool, followed by sales and a broad "other" category. Data and finance are also material segments.

### 4.3 Company concentration

The largest employers by job-record volume should be treated as **opportunity concentration indicators**, not necessarily unique hiring demand, because a company may publish the same role through multiple channels or maintain many requisitions.

Top companies include:

- Bosch
- SpaceX
- Microsoft
- Carvana
- LifeStance Health
- Securitas
- Databricks
- Veeva Systems
- Primark
- OpenAI

### 4.4 Fresher opportunity

Approximately **16.02%** of job records are marked fresher-friendly.

Fresher access is strongly concentrated in **intern and junior** levels. Mid-level roles have much lower fresher eligibility, while senior/lead/manager/staff roles are effectively non-fresher segments.

Among sufficiently large categories, the strongest fresher-friendly shares include:

- Protective
- Logistics
- Retail
- Operations
- Manufacturing
- People
- Marketing

**Business implication:** A fresher should not evaluate the market only by total job volume. Category-level accessibility matters much more.

### 4.5 Skill demand

Top skills by aggregated daily job mentions include:

- **python**: 46,199 mentions
- **ml**: 30,029 mentions
- **sql**: 26,067 mentions
- **aws**: 23,060 mentions
- **supply_chain**: 16,906 mentions
- **salesforce**: 15,951 mentions
- **java**: 15,449 mentions
- **project_management**: 14,537 mentions
- **crm**: 13,939 mentions
- **c++**: 13,620 mentions

The strongest technical demand is concentrated around **Python, ML, SQL, AWS, Java, TypeScript, Kubernetes and Azure**, while business/operational skills such as supply chain, Salesforce, project management, CRM and customer service also have substantial demand.

**Business implication:** A candidate combining SQL + Python + cloud + analytics/ML or domain/business skills can address multiple high-demand job segments.

### 4.6 Remote work

Remote roles represent approximately **12.68%** of the main job records.

Remote availability varies materially by category, so candidates should evaluate remote work at the **category/role level**, rather than assuming that the overall remote rate applies equally everywhere.

### 4.7 Salary analysis

Only **15,930 records (19.49%)** contain both salary endpoints.

The salary dataset is also heterogeneous across currencies and contains extreme values. Therefore:

- Do not compare raw salary numbers across currencies without FX normalization.
- Prefer median over mean for skewed salary distributions.
- Investigate outliers before using salary as a benchmark.
- Treat missing salary as a coverage limitation, not as zero compensation.

---

## 5. Data Quality Risks

### Risk 1 — Missing fields

Experience, employment type, skills and salary are incomplete. Any model built from these variables should explicitly account for missingness.

### Risk 2 — Date sequence anomaly

There are **23 records** where `closed_at` precedes `first_seen`. These records should be investigated before calculating exact time-to-close metrics.

### Risk 3 — Job-board duplication / aggregation

The dataset combines multiple sources. A high company count or job count does not automatically equal the same number of unique vacancies.

### Risk 4 — Ghost-job signal

The `ghost_score` field identifies potentially stale/non-genuine listings, but its interpretation should be source-aware because the average score differs significantly across sources.

### Risk 5 — Salary comparability

Currencies, units and extreme values make direct salary comparisons unsafe without normalization and outlier controls.

---

## 6. Recommended Business Actions

### For job seekers

1. Prioritize **Python + SQL + cloud** because these skills appear repeatedly across high-demand technical roles.
2. Add one cloud platform such as **AWS or Azure**.
3. Build portfolio projects that demonstrate business outcomes, not only coding.
4. Target junior/intern/fresher-friendly categories first if experience is limited.
5. Use category-level demand to choose a specialization rather than applying randomly.

### For recruiters

1. Track skill demand by category and seniority.
2. Monitor fresher-friendly roles separately from experienced-hire demand.
3. Use source-level metrics to detect unusual listing behavior.
4. Improve salary disclosure to increase candidate conversion and market transparency.

### For workforce planners

1. Track daily job volume over a longer period before making macro hiring conclusions.
2. Normalize salary by currency and geography.
3. Deduplicate cross-source vacancies before calculating true demand.
4. Build a recurring skill-demand dashboard.

## 7. SQL Analysis

- KPI summary
- Top companies
- Category mix
- Level mix
- Fresher opportunity by category
- Remote opportunity by category
- Source concentration
- Skill demand
- Daily job trends
- Salary coverage
- Data-quality checks

## 8. Python Analysis

1. Data loading
2. Schema inspection
3. Missing-value analysis
4. Duplicate checks
5. Feature engineering
6. Category/company/source analysis
7. Fresher analysis
8. Skill-demand analysis
9. Visualization generation

## 9. Final Conclusion

The analysis shows a **large and diverse job market with strong concentration in engineering, sales, operations, data and finance**, while the most visible technical skills include **Python, SQL, ML, AWS, Java, TypeScript, Kubernetes and Azure**.

For early-career candidates, the biggest opportunity is not simply the largest job category; it is the intersection of **high-demand skills and fresher-accessible roles**. The data suggests that building a practical stack around **SQL + Python + cloud + analytics/business problem solving** can create access to multiple job families.

However, the dataset has meaningful limitations: missing salary/experience/skill fields, cross-source aggregation, potential ghost listings and date anomalies. Therefore, the strongest business use of this dataset is **market intelligence and directional decision support**, rather than treating every row as a unique verified vacancy.

**Overall recommendation:** use this dataset as the foundation for a recurring job-market dashboard that tracks job volume, fresher accessibility, skill demand, remote availability, source quality and normalized compensation over a longer time window.

