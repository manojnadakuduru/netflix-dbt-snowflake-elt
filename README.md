# 🎬 Netflix Analytics Engineering Platform  
## Modern ELT Pipeline using Snowflake + dbt Core

---

## 📌 Executive Summary

This project demonstrates a production-style **Analytics Engineering pipeline** built using:

- **AWS S3** for raw data storage  
- **Snowflake** as the cloud data warehouse  
- **dbt Core** as the transformation, testing, and governance layer  

Raw MovieLens-style Netflix data is ingested into Snowflake and transformed using a layered dimensional modeling approach:

**Staging → Dimensions → Facts → Marts**

The project showcases:

- Modular ELT design  
- Scalable SQL transformations  
- Data quality testing framework  
- SCD Type 2 snapshots  
- Reusable macros  
- Incremental processing  
- Documentation & lineage generation  
- Analytics-ready mart tables  

The goal is to demonstrate how **modern data teams build governed, production-grade ELT pipelines using dbt.**

---

# 🏗 Architecture Overview

![Architecture Diagram](architecture/ArchitectureDiagram.png)

---

## 🔄 High-Level Flow

---

# 🔧 Step 2 – Transformation Layer (dbt Core)

All transformations are executed inside **Snowflake** using **dbt Core**.

dbt acts as the transformation, governance, and orchestration layer within the warehouse.

### dbt Responsibilities in This Project

- SQL-based transformations
- Automatic dependency resolution (DAG)
- Data quality testing
- Documentation generation
- Snapshot-based historical tracking
- Model materialization strategies

This approach ensures modular, maintainable, and production-grade transformation logic.

---

# 🧱 Data Modeling Strategy

The project follows a layered dimensional modeling architecture:

**Staging → Dimensions → Facts → Marts**

Each layer has a clearly defined responsibility.

---

## 🔹 Staging Layer (`models/staging/`)

### 🎯 Purpose

- Clean raw data
- Rename columns
- Standardize data types
- Prepare structured transformation inputs
- Maintain 1:1 alignment with raw sources

### 📂 Models

- `src_movies`
- `src_links`
- `src_genome_score`
- `src_tags`
- `src_genome_tags`
- `src_ratings`

### ⚙️ Materialization

Primarily materialized as **views** to reduce storage footprint and keep transformations lightweight.

---

## 🔹 Dimension Layer (`models/dim/`)

### 🎯 Purpose

- Create descriptive entities
- Enforce grain consistency
- Standardize primary keys
- Enable efficient analytical joins

### 📂 Models

- `dim_movies`
- `dim_users`
- `dim_genome_tags`
- `dim_movies_with_tags`

These models are curated for analytical querying and optimized joins.

---

## 🔹 Fact Layer (`models/fct/`)

### 🎯 Purpose

- Store measurable events
- Support aggregations and KPI calculations
- Represent business activity at defined grain

### 📂 Models

- `fct_ratings`
- `fct_genome_scores`

Facts are designed to integrate seamlessly with dimensions via surrogate or natural keys.

---

## 🔹 Mart Layer (`models/mart/`)

### 🎯 Purpose

- Deliver business-ready datasets
- Optimize structures for BI consumption
- Simplify reporting logic

### 📂 Model

- `mart_movie_releases`

Marts provide reporting-friendly, analytics-ready structures for dashboarding tools.

---

# ⚙️ Materialization Strategies Demonstrated

This project intentionally showcases multiple dbt materializations:

- `view`
- `table`
- `incremental`
- `ephemeral`
- `materialized view`

### 🚀 Why This Matters

- Optimizes Snowflake compute usage
- Demonstrates warehouse cost awareness
- Aligns model type with query frequency
- Improves scalability and performance
- Mimics real production decision-making

---

# 🔍 Data Quality & Governance

Data quality is enforced at the transformation layer.

---

## ✅ Generic Tests (`schema.yml`)

- `not_null`
- `unique`
- `relationships`

These enforce:

- Primary key integrity
- Referential consistency
- Downstream reliability

---

## ✅ Singular Tests

- `relevance_score_test.sql`

Used for business-rule validation.

---

## ✅ Macro-Based Validation

- `no_nulls_in_columns.sql`

Reusable macro logic ensures standardized validation across models.

---

# 🕒 Snapshots – SCD Type 2 Implementation

**File:** `snap_tags.sql`

Implements Slowly Changing Dimension Type 2 using:

- `dbt_valid_from`
- `dbt_valid_to`

### 📌 Capabilities

- Historical change tracking
- Point-in-time analytics
- Record version preservation
- Audit-friendly dimension history

This demonstrates real-world dimensional governance patterns.

---

# 🌱 Seeds

**File:** `seed_movie_release_dates.csv`

Used for:

- Static reference data
- Lookup enrichment
- Controlled dimension augmentation

Load using:

```bash
dbt seed
