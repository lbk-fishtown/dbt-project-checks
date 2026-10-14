select unique_id
from {{ info_schema('models') }}
where enabled
  and package_name = (select project_name from {{ info_schema('project') }})
  and not regexp_matches(name, '{{ var("model_name_pattern", "^(stg|int|dim|fct|base|mart)_.+") }}')
