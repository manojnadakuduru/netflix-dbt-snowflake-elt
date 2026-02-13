# 🎬 Netflix Analytics Engineering Project - DBT

[![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)](https://www.getdbt.com/)
[![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)](https://www.snowflake.com/)
[![AWS S3](https://img.shields.io/badge/AWS_S3-569A31?style=for-the-badge&logo=amazon-s3&logoColor=white)](https://aws.amazon.com/s3/)

> A production-grade ELT pipeline demonstrating modern analytics engineering best practices using Snowflake, dbt Core, and AWS S3.

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Data Modeling Strategy](#-data-modeling-strategy)
- [Key Features](#-key-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Setup Instructions](#-setup-instructions)
- [Engineering Concepts](#-engineering-concepts-demonstrated)
- [Contributing](#-contributing)

---

## 🎯 Overview

This project showcases a **production-style analytics engineering workflow** that transforms raw MovieLens data into business-ready analytics models. The pipeline demonstrates why **dbt is powerful for modern ELT-based analytics engineering** by implementing:

- **Layered dimensional modeling** (staging → dimension → fact → mart)
- **Data quality testing** and validation frameworks
- **SCD Type 2** for slowly changing dimensions
- **Incremental processing** for performance optimization
- **Automated documentation** with full lineage tracking
- **Reusable macros** and modular SQL engineering

The end result is a robust, scalable, and well-governed data pipeline that serves analytics and BI tools like Power BI, Tableau, and Looker Studio.

---

## 🏗 Architecture


![Architecture Preview](https://github.com/manojnadakuduru/netflix-dbt-snowflake-elt/blob/main/Architecture.png)

### Pipeline Flow

1. **Extract & Load**: Raw data uploaded to AWS S3 → loaded into Snowflake raw layer using `COPY INTO`
2. **Transform**: dbt orchestrates multi-layered SQL transformations with dependency management
3. **Serve**: Business-ready models consumed by BI tools for analytics and reporting

---

## 🧱 Data Modeling Strategy

### Layer Structure

#### 🔹 **Staging Layer** (`models/staging/`)

**Purpose**: Standardize and prepare raw data for transformation

- Rename columns to consistent naming conventions
- Cast data types appropriately
- Apply basic data cleaning
- Create structured foundation for downstream models

**Models**:
- `src_movies` - Movie catalog with titles and genres
- `src_ratings` - User ratings and timestamps
- `src_tags` - User-generated movie tags
- `src_links` - External ID mappings (TMDB, IMDB)
- `src_genome_tags` - Tag relevance scores
- `src_genome_score` - Tag-movie relevance data

**Materialization**: Primarily `view` for flexibility and storage efficiency

---

#### 🔹 **Dimension Layer** (`models/dim/`)

**Purpose**: Create descriptive entities with clean primary keys

**Models**:
- `dim_movies` - Movie dimension with enriched attributes
- `dim_users` - User dimension (derived from ratings)
- `dim_genome_tags` - Tag taxonomy and descriptions
- `dim_movies_with_tags` - Movies with aggregated tag information

**Materialization**: `table` for optimized query performance

---

#### 🔹 **Fact Layer** (`models/fct/`)

**Purpose**: Capture measurable business events and metrics

**Models**:
- `fct_ratings` - User rating events with foreign keys to dimensions
- `fct_genome_scores` - Tag relevance scores for content analysis

**Materialization**: `table` with `incremental` processing where applicable

---

#### 🔹 **Mart Layer** (`models/mart/`)

**Purpose**: Business-ready datasets optimized for specific analytical use cases

**Models**:
- `mart_movie_releases` - Comprehensive movie analytics with release dates, ratings, and tags

**Materialization**: `table` or `materialized_view` for BI tool performance

---

## ✨ Key Features

### 🎯 Materialization Strategies

This project demonstrates **multiple dbt materializations** to optimize performance and manage warehouse costs:

| Strategy | Use Case | Models |
|----------|----------|--------|
| `view` | Lightweight staging, always fresh | Staging models |
| `table` | Frequently queried dimensions | Dimension & fact tables |
| `incremental` | Large datasets, append-only | Future enhancement for ratings |
| `ephemeral` | CTEs for code reusability | Intermediate transformations |

---

### 🔍 Data Quality & Governance

#### **Generic Tests** (`schema.yml`)
- `not_null` - Ensure critical fields have values
- `unique` - Validate primary keys
- `relationships` - Enforce referential integrity
- `accepted_values` - Check categorical data

#### **Singular Tests**
- `relevance_score_test.sql` - Custom business logic validation

#### **Macro-Based Validation**
- `no_nulls_in_columns.sql` - Bulk null checking across multiple columns

**Result**: Only validated, high-quality data flows downstream

---

### 🕒 Snapshots (SCD Type 2)

**`snap_tags.sql`** implements Slowly Changing Dimension Type 2 for historical tracking:

```sql
{% snapshot snap_tags %}
    {{
        config(
            target_schema='snapshots',
            unique_key='tag_id',
            strategy='timestamp',
            updated_at='updated_at'
        )
    }}
    SELECT * FROM {{ ref('src_tags') }}
{% endsnapshot %}
```

**Tracks**:
- `dbt_valid_from` - Record start date
- `dbt_valid_to` - Record end date
- `dbt_scd_id` - Unique snapshot identifier

**Use Case**: Track how movie tags evolve over time

---

### 🌱 Seeds

**`seed_movie_release_dates.csv`** provides static reference data for:
- Movie release dates
- Production years
- Distribution information

**Load command**:
```bash
dbt seed
```

---

### 🧠 Macros

Custom macros in `/macros` for:
- **Code reusability** - DRY principle across models
- **Dynamic SQL generation** - Jinja templating for flexibility
- **Complex logic encapsulation** - Centralized business rules

**Example**: `generate_schema_name.sql` for dynamic schema management

---

### 📊 Analyses

**`analyses/movie_analysis.sql`** enables:
- Ad-hoc exploratory queries
- Complex analytical prototypes
- Query testing without creating warehouse objects

---

### 📚 Documentation & Lineage

Generate comprehensive documentation with lineage graphs:

```bash
dbt docs generate
dbt docs serve
```

**Provides**:
- ✅ Model descriptions and metadata
- ✅ Column-level documentation
- ✅ Test documentation and results
- ✅ Full DAG visualization showing dependencies
- ✅ Source freshness checks

---

## 🛠 Tech Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Data Source** | Netflix/MovieLens CSV | Sample movie and rating data |
| **Cloud Storage** | AWS S3 | Raw data lake |
| **Data Warehouse** | Snowflake | Cloud data platform |
| **Transformation** | dbt Core 1.9.0 | SQL-based transformations |

---

## 📁 Project Structure

```
netflixdbt/
├── analyses/                  # Ad-hoc analysis queries
│   └── movie_analysis.sql
├── macros/                    # Reusable SQL functions
│   ├── generate_schema_name.sql
│   └── no_nulls_in_columns.sql
├── models/
│   ├── staging/              # Raw data standardization
│   │   ├── src_movies.sql
│   │   ├── src_ratings.sql
│   │   ├── src_tags.sql
│   │   ├── src_links.sql
│   │   ├── src_genome_tags.sql
│   │   └── src_genome_score.sql
│   ├── dim/                  # Dimension tables
│   │   ├── dim_movies.sql
│   │   ├── dim_users.sql
│   │   ├── dim_genome_tags.sql
│   │   └── dim_movies_with_tags.sql
│   ├── fct/                  # Fact tables
│   │   ├── fct_ratings.sql
│   │   └── fct_genome_scores.sql
│   └── mart/                 # Business marts
│       └── mart_movie_releases.sql
├── seeds/                    # Static reference data
│   └── seed_movie_release_dates.csv
├── snapshots/                # SCD Type 2 snapshots
│   └── snap_tags.sql
├── tests/                    # Singular data tests
│   └── relevance_score_test.sql
├── dbt_project.yml          # dbt project configuration
├── packages.yml             # dbt package dependencies
└── README.md               # This file
```

---

## 🚀 Setup Instructions

### Prerequisites

- Python 3.8 or higher
- Snowflake account with appropriate permissions
- AWS S3 bucket with raw data (or local CSV files)
- Git installed

---

### Step-by-Step Setup

#### 1️⃣ **Create Project Directory**

```bash
cd ~/projects
mkdir netflixdbt
cd netflixdbt
```

#### 2️⃣ **Create Virtual Environment**

```bash
# Install virtualenv if not already installed
pip3 install virtualenv

# Create and activate virtual environment
virtualenv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

#### 3️⃣ **Install dbt with Snowflake Adapter**

```bash
pip install dbt-snowflake==1.9.0
```

#### 4️⃣ **Initialize dbt Project**

```bash
dbt init netflix
```

You'll be prompted to configure:
- **Snowflake account** (e.g., `xy12345.us-east-1`)
- **User** (your Snowflake username)
- **Password** (your Snowflake password)
- **Role** (e.g., `ACCOUNTADMIN`, `SYSADMIN`)
- **Warehouse** (e.g., `COMPUTE_WH`)
- **Database** (e.g., `NETFLIX_DB`)
- **Schema** (e.g., `PUBLIC`)
- **Threads** (number of concurrent models, e.g., `4`)

This creates `~/.dbt/profiles.yml` with your connection details.

#### 5️⃣ **Verify Connection**

```bash
cd netflix
dbt debug
```

Expected output: `All checks passed!`

#### 6️⃣ **Install dbt Packages**

```bash
dbt deps
```

This installs packages defined in `packages.yml` (e.g., `dbt_utils`).

---

## 📖 Usage

### Running the Pipeline

#### **1. Load Raw Data to Snowflake**

In Snowflake, run:

```sql
-- Create stage pointing to S3
CREATE OR REPLACE STAGE netflix_stage
URL = 's3://your-bucket/netflix-data/'
CREDENTIALS = (AWS_KEY_ID = 'your_key' AWS_SECRET_KEY = 'your_secret');

-- Load data
COPY INTO raw_movies FROM @netflix_stage/movies.csv FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1);
COPY INTO raw_ratings FROM @netflix_stage/ratings.csv FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1);
-- Repeat for other tables...
```

#### **2. Load Seed Data**

```bash
dbt seed
```

Loads static reference data from `seeds/`.

#### **3. Run All Models**

```bash
dbt run
```

Executes all transformations in dependency order.

#### **4. Run Specific Model**

```bash
dbt run --select dim_movies
```

#### **5. Run Tests**

```bash
dbt test
```

Validates data quality across all models.

#### **6. Run Snapshots**

```bash
dbt snapshot
```

Creates SCD Type 2 historical records.

#### **7. Generate Documentation**

```bash
dbt docs generate
dbt docs serve
```

Opens documentation site at `http://localhost:8080`.

---


## 🎓 Engineering Concepts Demonstrated

This project showcases **production-grade analytics engineering practices**:

### 🏆 Architecture & Design
- ✅ Modern **ELT architecture** (Extract-Load-Transform)
- ✅ **Layered dimensional modeling** (Kimball methodology)
- ✅ **Separation of concerns** (staging → dim → fact → mart)
- ✅ **Schema-on-read** approach for flexibility

### ⚡ Performance & Optimization
- ✅ Snowflake **warehouse optimization** strategies
- ✅ **Incremental processing** for large datasets
- ✅ **Materialization strategy** selection based on use case
- ✅ **Query performance tuning** through proper modeling

### 🔐 Data Quality & Governance
- ✅ Comprehensive **data validation framework**
- ✅ **Referential integrity** enforcement
- ✅ **SCD Type 2 implementation** for historical tracking
- ✅ **Source freshness monitoring**
- ✅ **Automated documentation** and lineage

### 🧩 Code Quality
- ✅ **Modular SQL engineering** with reusable components
- ✅ **Analytics-ready marts** for business users


## 📬 Contact

**https://www.linkedin.com/in/manojnadakuduru/** 

---

