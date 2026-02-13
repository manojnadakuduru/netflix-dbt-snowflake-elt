🎬 Netflix Analytics Engineering Project
Modern ELT Pipeline using Snowflake + dbt Core
📌 Overview
This project demonstrates a production-style analytics engineering workflow using:
AWS S3 for data storage
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
This project highlights why dbt is powerful for modern ELT-based analytics engineering.
🏗 Architecture
AWS S3 → Snowflake (Raw Layer) → dbt Transformations → Analytics / BI
1️⃣ Ingestion
Data is uploaded to S3
Loaded into Snowflake using:
CREATE STAGE
COPY INTO
Raw tables remain untouched and are declared as sources inside dbt.
🧱 Data Modeling Approach
This project follows a layered modeling strategy.
🔹 Staging Layer (models/staging/)
Purpose:
Clean raw data
Rename columns
Standardize types
Prepare structured inputs
Examples:
src_movies
src_ratings
src_tags
src_genome_score
src_genome_tags
src_links
Materialized mostly as views.
🔹 Dimension Layer (models/dim/)
Purpose:
Descriptive entities
Clean primary keys
Enforce grain
Examples:
dim_movies
dim_users
dim_genome_tags
dim_movies_with_tags
🔹 Fact Layer (models/fct/)
Purpose:
Measurable events
Analytical metrics
Examples:
fct_ratings
fct_genome_scores
🔹 Mart Layer (models/mart/)
Purpose:
Business-ready datasets
Reporting-friendly structures
Example:
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
✅ Generic Tests
Defined in schema.yml:
not_null
unique
relationships
✅ Singular Tests
Custom validation logic:
relevance_score_test.sql
✅ Macro-Based Testing
Reusable validation macro:
no_nulls_in_columns.sql
Ensures only validated data moves downstream.
🕒 Snapshots (SCD Type 2)
snap_tags.sql
Implements Slowly Changing Dimension Type 2.
Features:
Change tracking
dbt_valid_from
dbt_valid_to
Historical record preservation
🌱 Seeds
seed_movie_release_dates.csv
Used for:
Static reference data
Lookup tables
Loaded using:
dbt seed
🧠 Macros
Located in /macros.
Used to:
Reduce duplication
Encapsulate complex logic
Dynamically generate SQL via Jinja
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
Lineage graph
Source tracking

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
