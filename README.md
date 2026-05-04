# 📊 Layoffs Data Cleaning Project (SQL)

## 📌 Overview

This project focuses on cleaning and preparing a real-world layoffs dataset using SQL. The goal is to transform raw, inconsistent data into a structured and analysis-ready format.

---

## 🎯 Objectives

* Remove duplicate records
* Standardize inconsistent data
* Handle null and blank values
* Convert data types for better usability
* Prepare dataset for further analysis

---

## 🛠 Tools & Technologies

* SQL (MySQL)
* Window Functions
* Joins
* Data Cleaning Techniques

---

## 📂 Dataset

The dataset contains information about global layoffs including:

* Company
* Location
* Industry
* Total layoffs
* Percentage layoffs
* Date
* Funding stage
* Country
* Funds raised

---

## 🔄 Data Cleaning Steps

### 1. Removing Duplicates

* Used `ROW_NUMBER()` with `PARTITION BY`
* Identified duplicate rows
* Deleted extra records while keeping unique entries

### 2. Standardizing Data

* Removed extra spaces using `TRIM()`
* Standardized industry names (e.g., Crypto)
* Fixed inconsistent country names (e.g., United States)
* Converted date format from text to `DATE`

### 3. Handling Null & Blank Values

* Replaced blank values with `NULL`
* Filled missing industry values using self join
* Removed rows where critical data was missing

### 4. Removing Unnecessary Columns

* Dropped helper column (`row_num`) after cleaning

---

## 📈 Key Learnings

* Practical use of SQL window functions
* Data cleaning workflow in real-world datasets
* Importance of data consistency before analysis
* Handling missing and duplicate data efficiently

---

## 🚀 Future Improvements

* Perform Exploratory Data Analysis (EDA)
* Build dashboards using Power BI / Excel
* Create insights on layoffs trends

---

## 📎 Project Files

* `Data_cleaning.sql` → Complete SQL script for cleaning dataset

---

## 💡 Author

**Anushka Kamble**
Aspiring Data Analyst

---
