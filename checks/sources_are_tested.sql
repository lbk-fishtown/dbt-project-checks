-- Flags source tables with no data tests.
-- dbt never sets node_unique_id on source tests, so tests are found through `edges` instead.
-- test_edges has one row per (parent, enabled test), with the test's total parent count and
-- arguments.model (the node the test is defined on). An edge counts as testing the source when
-- the test has only one parent, or, for multi-parent tests such as relationships, when model
-- names this source(); otherwise the source is just the test's `to` target.
with test_edges as (
  select
    e.parent_unique_id,
    json_extract_string(t.arguments, '$.model') as tested_model,
    count(*) over (partition by t.unique_id) as parent_count
  from {{ info_schema('edges') }} e
  join {{ info_schema('data_tests') }} t on t.unique_id = e.child_unique_id
  where t.enabled
)
select s.unique_id
from {{ info_schema('sources') }} s
where s.enabled
  and s.package_name = (select project_name from {{ info_schema('project') }})
  and not exists (
    select 1
    from test_edges te
    where te.parent_unique_id = s.unique_id
      and (
        te.parent_count = 1
        or contains(te.tested_model, format('source(''{}'', ''{}'')', s.source_name, s.name))
      )
  )
