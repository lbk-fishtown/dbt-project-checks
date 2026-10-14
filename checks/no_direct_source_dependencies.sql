-- Flags non-staging models that read a source directly.
-- Takes `edges` whose parent id starts with 'source.', joins the child to `models` in this project,
-- and keeps children whose name does not match '^stg_'. DISTINCT gives one row per model.
select distinct e.child_unique_id as unique_id
from {{ info_schema('edges') }} e
join {{ info_schema('models') }} m on m.unique_id = e.child_unique_id
where e.parent_unique_id like 'source.%'
  and m.package_name = (select project_name from {{ info_schema('project') }})
  and not regexp_matches(m.name, '^stg_')
