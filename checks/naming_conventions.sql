-- Flags models whose names break the naming convention.
-- Reads enabled `models` in this project and returns those where regexp_matches(name, pattern)
-- is false. The pattern is var `model_name_pattern` (default '^(stg|int|dim|fct|base|mart)_.+').
select unique_id
from {{ info_schema('models') }}
where enabled
  and package_name = (select project_name from {{ info_schema('project') }})
  and not regexp_matches(name, '{{ var("model_name_pattern", "^(stg|int|dim|fct|base|mart)_.+") }}')
