import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

jobs = pd.read_csv("data/jobs.csv", parse_dates=["posted","first_seen","closed_at"])
open_daily = pd.read_csv("data/open_jobs_daily.csv", parse_dates=["date"])
skill_daily = pd.read_csv("data/skill_demand_daily.csv", parse_dates=["date"])

# ---------------- EDA ----------------
print(jobs.shape)
print(jobs.info())
print(jobs.describe(include="all").T)
print(jobs.isna().sum().sort_values(ascending=False))
print("Duplicate rows:", jobs.duplicated().sum())
print("Duplicate URLs:", jobs["url"].duplicated().sum())

# ---------------- Feature engineering ----------------
jobs["salary_mid"] = (jobs["pay_min"] + jobs["pay_max"]) / 2
jobs["days_observed"] = (jobs["closed_at"].fillna(pd.Timestamp("2026-10-11")) - jobs["first_seen"]).dt.days

# ---------------- Business analysis ----------------
print(jobs.groupby("category").size().sort_values(ascending=False).head(15))
print(jobs.groupby("company").size().sort_values(ascending=False).head(15))
print(jobs.groupby("source").size().sort_values(ascending=False))
print(jobs.groupby("level").size().sort_values(ascending=False))
print(jobs.groupby("category")["fresher_friendly"].mean().sort_values(ascending=False))
print(skill_daily.groupby("skill")["jobs"].sum().sort_values(ascending=False).head(20))

# ---------------- Visualizations ----------------
# Each chart is saved as a standalone PNG.
fig, ax = plt.subplots(figsize=(10,6))
jobs["category"].value_counts().head(12).sort_values().plot(kind="barh", ax=ax)
ax.set_title("Top Job Categories by Volume")
ax.set_xlabel("Job records")
fig.tight_layout(); fig.savefig("visualizations/01_category_volume.png", dpi=180); plt.close(fig)

fig, ax = plt.subplots(figsize=(10,6))
jobs["company"].value_counts().head(15).sort_values().plot(kind="barh", ax=ax)
ax.set_title("Top Companies by Job Records")
ax.set_xlabel("Job records")
fig.tight_layout(); fig.savefig("visualizations/02_company_volume.png", dpi=180); plt.close(fig)

fig, ax = plt.subplots(figsize=(10,6))
open_daily.plot(x="date", y="open_jobs", marker="o", ax=ax)
ax.set_title("Open Jobs Trend")
ax.set_ylabel("Open jobs")
fig.tight_layout(); fig.savefig("visualizations/03_open_jobs_trend.png", dpi=180); plt.close(fig)

fig, ax = plt.subplots(figsize=(10,6))
open_daily["fresher_share_pct"] = 100*open_daily["fresher_friendly_jobs"]/open_daily["open_jobs"]
open_daily.plot(x="date", y="fresher_share_pct", marker="o", ax=ax)
ax.set_title("Fresher-Friendly Share Trend")
ax.set_ylabel("Share (%)")
fig.tight_layout(); fig.savefig("visualizations/04_fresher_share_trend.png", dpi=180); plt.close(fig)

skill_totals = skill_daily.groupby("skill")["jobs"].sum().sort_values(ascending=False).head(15)
fig, ax = plt.subplots(figsize=(10,6))
skill_totals.sort_values().plot(kind="barh", ax=ax)
ax.set_title("Top Skills by Job Mentions")
ax.set_xlabel("Job mentions")
fig.tight_layout(); fig.savefig("visualizations/05_skill_demand.png", dpi=180); plt.close(fig)

fresher_cat = jobs.groupby("category").agg(jobs=("title","size"), fresher_jobs=("fresher_friendly","sum"))
fresher_cat["fresher_share_pct"] = 100*fresher_cat["fresher_jobs"]/fresher_cat["jobs"]
fresher_cat = fresher_cat[fresher_cat["jobs"]>=250].sort_values("fresher_share_pct", ascending=False).head(12)
fig, ax = plt.subplots(figsize=(10,6))
fresher_cat["fresher_share_pct"].sort_values().plot(kind="barh", ax=ax)
ax.set_title("Fresher-Friendly Share by Category")
ax.set_xlabel("Fresher-friendly share (%)")
fig.tight_layout(); fig.savefig("visualizations/06_fresher_by_category.png", dpi=180); plt.close(fig)
