{% macro no_nulls_in_columns(model) %}
    SELECT * FROM {{ model }} WHERE
    {% for col in adapter.get_columns_in_relation(model) %}
        {{ col.column }} IS NULL OR
    {% endfor %}
    FALSE
{% endmacro %}

--Earlier for testing we have used singular tests 
-- We can do the same by using macros as well
--Let's use this macros in relevance_score_test under tests