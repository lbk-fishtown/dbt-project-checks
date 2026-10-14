{% set threshold = var('test_coverage_threshold', 100) %}
with models as (
  select unique_id from {{ info_schema('models') }}
  where enabled and package_name = (select project_name from {{ info_schema('project') }})
),
coverage as (
  select
    count(distinct m.unique_id) as models_total,
    count(distinct t.node_unique_id) as models_with_tests
  from models m
  left join {{ info_schema('data_tests') }} t on t.node_unique_id = m.unique_id
)
select models_total, models_with_tests,
       round(100.0 * models_with_tests / nullif(models_total, 0), 1) as coverage_pct
from coverage
where coverage_pct < {{ threshold }}
