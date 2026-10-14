-- Flags the project when its share of tested models is below var `test_coverage_threshold` (default 100).
-- Left-joins enabled `models` in this project to `data_tests` and counts distinct models against
-- distinct tested models. It returns one row (totals and coverage_pct, rounded to 1 dp) when
-- coverage is under the threshold. There is no unique_id column, so dbt runs it project-wide and
-- ignores --select.
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
