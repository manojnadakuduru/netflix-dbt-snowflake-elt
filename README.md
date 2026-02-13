🎬 Netflix Analytics Engineering Project
Modern ELT Pipeline using Snowflake + dbt Core
📌 Overview
This project demonstrates a production-style analytics engineering workflow using:
AWS S3 for raw data storage
Snowflake as the cloud data warehouse
dbt Core as the transformation and governance layer
Raw MovieLens-style data is transformed into a layered dimensional model with:
Staging models
Dimension tables
Fact tables
Business-ready marts
Data quality testing
SCD Type 2 snapshots
Reusable macros
Seeds for reference data
Automated documentation & lineage
The goal of this project is to showcase why dbt is powerful for modern ELT-based analytics engineering.
🏗 Architecture
AWS S3 → Snowflake (Raw Layer) → dbt Transformations → Analytics / BI
Step 1 – Ingestion
Data uploaded to S3
Loaded into Snowflake using:
CREATE STAGE
COPY INTO
Raw tables remain untouched and are declared as sources in dbt
Step 2 – Transformation (dbt Core)
dbt handles:
SQL-based transformations
Dependency resolution
Data quality testing
Documentation
Historical tracking
Model materialization strategies
🧱 Data Modeling Strategy
🔹 Staging Layer (models/staging/)
Purpose:
Clean raw data
Rename columns
Standardize data types
Prepare structured inputs
Models include:
src_movies
src_links
src_genome_score
src_tags
src_genome_tags
src_ratings
Materialized primarily as views.
🔹 Dimension Layer (models/dim/)
Purpose:
Descriptive entities
Clean primary keys
Enforce grain
Models:
dim_movies
dim_users
dim_genome_tags
dim_movies_with_tags
🔹 Fact Layer (models/fct/)
Purpose:
Measurable events
Analytical metrics
Models:
fct_ratings
fct_genome_scores
🔹 Mart Layer (models/mart/)
Purpose:
Business-ready datasets
Reporting-friendly structures
Model:
mart_movie_releases
⚙️ Materialization Strategies Demonstrated
This project showcases multiple dbt materializations:
view
table
incremental
ephemeral
materialized view
This demonstrates performance tuning and warehouse cost awareness.
🔍 Data Quality & Governance
Generic Tests (schema.yml)
not_null
unique
relationships
Singular Tests
relevance_score_test.sql
Macro-Based Validation
no_nulls_in_columns.sql
Ensures only validated data moves downstream.
🕒 Snapshots (SCD Type 2)
snap_tags.sql
Implements Slowly Changing Dimension Type 2:
Change tracking
dbt_valid_from
dbt_valid_to
Historical record preservation
🌱 Seeds
seed_movie_release_dates.csv
Used for:
Static reference data
Lookup tables
Load using:
dbt seed
🧠 Macros
Located in /macros.
Used to:
Reduce duplication
Encapsulate complex logic
Generate dynamic SQL via Jinja
📊 Analyses
analyses/movie_analysis.sql
Used for:
Ad-hoc analysis
Complex query experimentation
Prototype queries without creating warehouse objects
📚 Documentation & Lineage
Generate documentation and DAG:
dbt docs generate
dbt docs serve
Provides:
Model documentation
Column descriptions
Test documentation
Full lineage graph
🚀 How to Run This Project
Below are the exact setup steps used in this project.
1️⃣ Create Project Directory
cd DBT
mkdir netflixdbt
cd netflixdbt
code .
2️⃣ Create Virtual Environment
pip3 install virtualenv
virtualenv venv
source venv/bin/activate
3️⃣ Install dbt (Snowflake Adapter)
pip install dbt-snowflake==1.9.0
4️⃣ Create dbt Profile Directory
mkdir ~/.dbt
5️⃣ Initialize dbt Project
dbt init netflix
During setup, provide:
Snowflake account
User
Password
Role
Warehouse
Database
Schema
Threads
This creates:
~/.dbt/profiles.yml
6️⃣ Install Packages
dbt deps
7️⃣ Run Models
dbt run
8️⃣ Run Tests
dbt test
9️⃣ Run Snapshots
dbt snapshot
🔟 Load Seeds
dbt seed
1️⃣1️⃣ Generate Documentation
dbt docs generate
dbt docs serve
🏆 Engineering Concepts Demonstrated
Modern ELT architecture
Snowflake warehouse optimization
Layered dimensional modeling
Incremental processing
SCD Type 2 implementation
Data validation framework
Modular SQL engineering
Source freshness monitoring
Analytics-ready marts
Governance through documentation
