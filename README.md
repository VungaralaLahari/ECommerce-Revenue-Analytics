#  E-commerce Revenue and Customer Analytics

##  Overview
This project analyzes an e-commerce dataset using SQL and Power BI to understand revenue patterns, customer behavior, and product performance.

The goal was not just to build a dashboard, but to identify **real business problems and risks** from the data.

---

##  Tools Used
- SQL (MySQL)
- Power BI
- CSV files for data storage

---

##  Dataset
The project is based on 5 relational tables:

- customers  
- orders  
- order_items  
- products  
- payments  

These tables are connected using primary and foreign keys to simulate a real-world e-commerce database.

---

##  Data Modeling
Relationships created:

- customers → orders  
- orders → order_items  
- products → order_items  
- orders → payments  

Order_items acts as the **fact table**, connecting all dimensions.

---

##  SQL Analysis

I approached the project step-by-step:

### Basic Analysis
- Most ordered product
- Most ordered category
- Top 5 products by revenue
- Category-wise revenue
- Most common payment method
- Customers with highest orders

### Intermediate Analysis
- Monthly revenue trend
- Cancelled vs pending orders
- Customers who never ordered

### Advanced Analysis
- Repeat vs one-time customers
- Customers who didn’t return
- Top 3 products per category
- Monthly revenue growth
- Revenue contribution by top customers

All queries were written with a focus on **answering business questions**, not just practicing syntax.

---

##  Power BI Dashboard

The dashboard includes:

- KPI Cards:
  - Total Revenue
  - Total Orders
  - Average Order Value

- Visuals:
  - Monthly Revenue Trend
  - Revenue by Category
  - Top 5 Customers by Revenue
  - Top 5 Products by Revenue
  - Order Status Distribution

---

##  Project Structure

- Data/
   - customers.csv
   -  products.csv
   - orders.csv
   - order_items.csv
   -  payments.csv
- SQL/
   -  schema.sql
   -  queries.sql

- Power BI/
   -  dashboard.pbix
   -  dashboard.png
- README.md
- INSIGHTS.md

 
---

##  Key Learnings

- Designed a relational database from scratch  
- Generated realistic datasets for analysis  
- Wrote business-focused SQL queries  
- Built a structured and interactive Power BI dashboard  
- Learned how to interpret data beyond visuals  

---

##  Note

This project focuses not just on visualization, but on identifying **business risks, patterns, and decision-making insights** from the data.
