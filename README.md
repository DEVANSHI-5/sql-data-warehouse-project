# Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository! 🚀  
This project shows how to build a complete data warehouse and use it for analytics and reporting.  
It is designed as a **portfolio project** and follows real-world data engineering best practices.

---

## 🏗️ Data Architecture

This project uses the **Medallion Architecture**, which is divided into three layers:

### 🟤 Bronze Layer
- Stores raw data exactly as received from source systems
- Data is loaded from CSV files into a SQL Server database
- No transformations are applied at this stage

### ⚪ Silver Layer
- Cleans and standardizes the raw data
- Fixes data quality issues
- Prepares data for analysis

### 🟡 Gold Layer
- Contains business-ready data
- Uses a **Star Schema** (fact and dimension tables)
- Designed for reporting and analytics

---

## 📖 Project Overview

This project covers the full data warehouse lifecycle, including:

- **Data Architecture**  
  Designing a modern data warehouse using the Bronze, Silver, and Gold layers

- **ETL Pipelines**  
  Extracting data from source systems, transforming it, and loading it into the warehouse

- **Data Modeling**  
  Creating fact and dimension tables optimized for analytical queries

- **Analytics & Reporting**  
  Writing SQL queries to generate insights and business metrics

---

## 🎯 Who This Project Is For

This repository is useful for professionals and students who want to demonstrate skills in:

- SQL Development  
- Data Architecture  
- Data Engineering  
- ETL Pipeline Development  
- Data Modeling  
- Data Analytics  

It is especially suitable as a **portfolio project**.

---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

**Objective:**  
Build a modern SQL Server data warehouse that combines sales data from multiple systems to support analytics and decision-making.

**Key Requirements:**
- **Data Sources:**  
  Load data from two systems (ERP and CRM) provided as CSV files
- **Data Quality:**  
  Clean and fix data quality issues before analysis
- **Integration:**  
  Combine data from both systems into a single, easy-to-query model
- **Scope:**  
  Focus only on the latest data (no historical tracking required)
- **Documentation:**  
  Clearly document the data model for business and analytics users

---

### 📊 BI, Analytics & Reporting (Data Analysis)

**Objective:**  
Use SQL to generate insights related to:

- Customer behavior  
- Product performance  
- Sales trends  

These insights help stakeholders understand the business and make better decisions.

For more details, see `docs/requirements.md`.

---

## 📂 Repository Structure

```text
data-warehouse-project/
│
├── datasets/                # Raw ERP and CRM CSV files
│
├── docs/                    # Project documentation and diagrams
│   ├── etl.drawio           # ETL process diagrams
│   ├── data_architecture.drawio
│   ├── data_catalog.md
│   ├── data_flow.drawio
│   ├── data_models.drawio   # Star schema diagrams
│   ├── naming-conventions.md
│
├── scripts/                 # SQL scripts
│   ├── bronze/              # Raw data loading scripts
│   ├── silver/              # Data cleaning and transformation scripts
│   ├── gold/                # Analytical views and models
│
├── tests/                   # Data quality and validation scripts
│
├── README.md                # Project overview
├── LICENSE                  # License information
├── .gitignore               # Git ignore file
└── requirements.txt         # Project requirements

---
## 🛡️ License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify,.

---

## 🙏 Credits

This project was developed with guidance and inspiration from:

**[BARAA KHATIB SALKINI]**  
- Data Engineering & Analytics Professional  
- GitHub: https://github.com/DataWithBaraa
  

Special thanks for the guidance, knowledge sharing, and best practices that helped shape this project.

