🎬 Netflix Analytics Engineering Platform
Modern ELT Pipeline using Snowflake + dbt Core
📌 Executive Summary
This project demonstrates a production-grade Analytics Engineering ELT pipeline built using:
Amazon S3 for raw data storage
Snowflake as the cloud data warehouse
dbt Core as the transformation, testing, and governance layer
Raw Netflix MovieLens-style data is ingested into Snowflake and transformed using a layered dimensional modeling approach (Staging → Dimensions → Facts → Marts).
This project showcases:
Modular ELT architecture
Layered dimensional modeling
Data quality testing framework
Incremental model processing
SCD Type 2 snapshots
Reusable macros
Seeds for static reference data
Automated documentation & lineage
The goal is to demonstrate how modern data teams build scalable, governed, production-ready ELT pipelines using dbt.
🏗 Architecture Overview

High-Level Flow
Extract → Load → Transform → Serve
Detailed Flow
Netflix CSV
→ Amazon S3 (Raw Storage)
→ Snowflake (Raw Layer)
→ dbt Core (Staging → Dimensions → Facts → Marts)
→ BI Tools (Power BI / Tableau / Looker Studio)
🔹 Data Ingestion (Raw Layer)
Data is uploaded into Amazon S3 and loaded into Snowflake using:
CREATE STAGE
COPY INTO
Raw Layer Principles
Raw tables remain immutable
No transformations applied at ingestion
Declared as sources inside dbt
Maintains auditability and traceability
This follows a true ELT pattern where transformation happens inside the warehouse.
🔹 Transformation Layer (dbt Core)
All transformations are managed using dbt Core and executed inside Snowflake.
dbt handles:
SQL-based transformations
Model dependency resolution (DAG)
Data quality testing
Documentation generation
Snapshot-based historical tracking
Model materialization strategies
This enables scalable and maintainable transformation workflows.
🧱 Data Modeling Strategy
The project follows a layered dimensional modeling architecture.
🔹 Staging Layer (models/staging/)
Purpose
Clean raw data
Rename columns
Standardize data types
Prepare structured inputs
Models
src_movies
src_links
src_genome_score
src_tags
src_genome_tags
src_ratings
Materialized primarily as views.
🔹 Dimension Layer (models/dim/)
Purpose
Create descriptive entities
Enforce proper grain
Clean primary keys
Optimize joins
Models
dim_movies
dim_users
dim_genome_tags
dim_movies_with_tags
🔹 Fact Layer (models/fct/)
Purpose
Store measurable events
Support aggregations and analytics
Models
fct_ratings
fct_genome_scores
🔹 Mart Layer (models/mart/)
Purpose
Business-ready reporting datasets
Optimized for BI tools
Simplified analytical structures
Model
mart_movie_releases
⚙️ Materialization Strategies Demonstrated
This project showcases multiple dbt materializations:
view
table
incremental
ephemeral
materialized view
Why This Matters
Optimizes Snowflake compute usage
Demonstrates warehouse cost awareness
Aligns model performance with data layer purpose
Reflects real-world production tuning
🔍 Data Quality & Governance
Generic Tests (schema.yml)
not_null
unique
relationships
Singular Tests
relevance_score_test
Macro-Based Validation
no_nulls_in_columns
These validations ensure:
Referential integrity
Column-level validation
Reliable downstream datasets
Trusted analytics
🕒 Snapshots (SCD Type 2 Implementation)
File: snap_tags.sql
Implements Slowly Changing Dimension Type 2 using:
dbt_valid_from
dbt_valid_to
Capabilities
Historical record preservation
Change tracking
Point-in-time analytics
🌱 Seeds
File: seed_movie_release_dates.csv
Used for:
Static reference data
Lookup tables
Controlled enrichment
Loaded using dbt seed.
🧠 Macros
Located in the macros directory.
Used to:
Reduce SQL duplication
Encapsulate complex logic
Generate dynamic SQL via Jinja
Standardize validation patterns
Demonstrates modular and scalable SQL engineering.
📊 Analyses
Located in analyses/movie_analysis.sql.
Used for:
Ad-hoc analysis
Complex query experimentation
Prototyping analytical logic
Business query validation
Does not create warehouse objects — purely analytical exploration.
📚 Documentation & Lineage
Documentation is generated using dbt docs.
Provides:
Model documentation
Column-level descriptions
Test documentation
Full DAG lineage graph
Ensures transparency and governance across the transformation pipeline.
🚀 How to Run This Project
Step 1 – Create Project Directory
Create a project folder and open it in your IDE.
Step 2 – Create Virtual Environment
Install and activate a Python virtual environment.
Step 3 – Install dbt Snowflake Adapter
Install dbt-snowflake version 1.9.0.
Step 4 – Configure dbt Profile
Create a dbt profile with:
Snowflake account
Username
Password
Role
Warehouse
Database
Schema
Threads
This creates the profiles configuration file.
Step 5 – Install Dependencies
Run dbt deps to install packages.
Step 6 – Execute Models
Run dbt run to build all models.
Step 7 – Execute Tests
Run dbt test to validate data quality.
Step 8 – Run Snapshots
Run dbt snapshot to implement SCD Type 2 tracking.
Step 9 – Load Seeds
Run dbt seed to load static reference data.
Step 10 – Generate Documentation
Generate documentation and serve it locally to visualize lineage and metadata.
🏆 Engineering Concepts Demonstrated
Modern ELT architecture
Snowflake warehouse optimization
Layered dimensional modeling
Incremental model processing
SCD Type 2 implementation
Data validation framework
Modular SQL engineering
Source freshness monitoring
Analytics-ready marts
Governance through documentation
DAG-based transformation orchestration
