# Incubeta Retail Data Engineering Challenge

## Project Overview

This repository contains my solution for the **Incubeta Retail Data Engineering Challenge**. The objective was to build an end-to-end data engineering pipeline entirely within **Google BigQuery**, following the **Bronze, Silver, and Gold** architecture.

The solution demonstrates data ingestion, data cleansing, feature engineering, and customer segmentation using **BigQuery ML (BQML)**.

---

# Solution Architecture

```
                 Raw CSV File
                      │
                      ▼
      ┌────────────────────────────┐
      │     Bronze Layer           │
      │ retail_bronze              │
      │ raw_transactions           │
      └────────────────────────────┘
                      │
                      ▼
      ┌────────────────────────────┐
      │     Silver Layer           │
      │ retail_silver              │
      │ cleaned_transactions       │
      └────────────────────────────┘
                      │
                      ▼
      ┌────────────────────────────┐
      │     Gold Layer             │
      │ retail_gold                │
      │ customer_segmentation_model│
      │ analytics_customer_segments│
      └────────────────────────────┘
```

---

# Technologies Used

- Google Cloud Platform (GCP)
- BigQuery
- BigQuery ML (BQML)
- Standard SQL
- GitHub
- ChatGpt

---

# Bronze Layer

### Dataset

```
retail_bronze
```

### Table

```
raw_transactions
```

### Purpose

The Bronze layer stores the raw retail transaction data exactly as received from the source CSV file with minimal transformation.

---

# Silver Layer

### Dataset

```
retail_silver
```

### Table

```
cleaned_transactions
```

### Data Cleansing & Transformations

The Silver layer performs the following transformations:

- Converted `signup_date` to the DATE data type.
- Replaced missing `signup_date` values with `purchase_date`.
- Converted `is_returned` from STRING to BOOLEAN.
- Replaced missing `is_returned` values with FALSE.
- Removed invalid transactions where `amount <= 0`.
- Trimmed whitespace from string columns.
- Standardised `item_category` values to uppercase.
- Removed duplicate transaction IDs.
- Corrected invalid signup dates occurring after purchase dates.
- Created the feature `days_to_first_purchase`.

---

# Gold Layer

### Dataset

```
retail_gold
```

### Machine Learning Model

```
customer_segmentation_model
```

### Final Analytics Table

```
analytics_customer_segments
```

### Customer Segmentation

A **BigQuery ML K-Means clustering model** was trained using:

- Purchase Amount
- Item Category (One-Hot Encoded)

The trained model is then applied using `ML.PREDICT`, and the predicted customer cluster is joined back to the cleaned Silver layer data to generate the final Gold layer analytics table.

---

# Repository Structure

```
SQL/
├── silver_transform.sql
├── gold_model_training.sql
└── gold_prediction.sql

architecture/
└── architecture_diagram.png

proof/
├── analytics_customer_segments.png
└── bqml_model_evaluation.png

README.md
```

---

# Pipeline Orchestration

In a production environment, this solution could be orchestrated using **BigQuery Scheduled Queries**, **Dataform**, or **Cloud Composer (Apache Airflow)**.

A typical workflow would be:

1. Load new transaction data into the Bronze layer.
2. Execute the Silver transformation script to cleanse and standardise the data.
3. Train or retrain the BigQuery ML customer segmentation model.
4. Execute the prediction script using `ML.PREDICT`.
5. Refresh the Gold analytics table for downstream reporting and analytics.

This orchestration provides an automated, scalable, and maintainable ELT pipeline.

---

# Deliverables

This repository contains:

- SQL scripts for the Silver and Gold layers.
- BigQuery ML model training script.
- Customer segmentation prediction script.
- Architecture diagram.
- Proof of successful execution.
- Project documentation.

---

# Proof of Execution

The `proof` directory contains evidence that the solution executed successfully in BigQuery:

- `analytics_customer_segments.png` – Screenshot showing the schema and preview of the final Gold layer table.
- `bqml_model_evaluation.png` – Screenshot showing the evaluation metrics of the BigQuery ML model.

---

# Author

**Phumelelo M**

Data Engineer
