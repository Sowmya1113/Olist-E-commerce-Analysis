Olist Brazilian E-Commerce Analysis

End-to-end analysis of the Olist Brazilian E-Commerce public dataset using MySQL and Power BI, focused on diagnosing delivery delays and surfacing seller performance issues.

Project Duration: May 2026 – Jun 2026

📌 Objective

Delivery delays on the platform had no clear, data-backed explanation, and underperforming sellers weren't easily visible to stakeholders. This project builds the data infrastructure to diagnose the root cause of delivery delays and surface seller performance at a glance.

🗂️ Data & Schema (SQL / MySQL)
Designed a 9-table relational MySQL schema to model the Olist e-commerce dataset (orders, customers, sellers, products, payments, reviews, geolocation, and related entities)
Followed an ELT (Extract, Load, Transform) approach: raw data was loaded into MySQL first, with all cleaning and transformation performed afterward through SQL
Built 5 SQL views to handle the transformation layer — cleaning, joining, and aggregating raw tables into analysis-ready structures
Conducted a structured three-stage root-cause analysis to trace delivery delays back to their primary driver
Key Finding

Shipping distance was identified as the primary driver of delivery delays across the dataset.

📊 Dashboard (Power BI)
Built a Power BI dashboard on top of the SQL views, including:
KPI cards for high-level performance tracking
Supporting charts for delivery and sales trends
A conditionally formatted flagged-sellers table to enable at-a-glance identification of underperforming sellers
🛠️ Tech Stack

MySQL SQL (Schema Design, Views, ELT) Power BI DAX Root-Cause Analysis

🔑 Key Skills Demonstrated
Relational database schema design
ELT pipeline design and SQL-based data transformation
Root-cause analysis methodology
BI dashboard design (KPI cards, conditional formatting)
Seller performance monitoring
