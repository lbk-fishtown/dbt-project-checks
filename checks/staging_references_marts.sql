-- Flags staging models that depend on a mart.
-- Joins `edges` to `models` twice: c is the child, p the parent. Keeps children in this project
-- whose name matches '^stg_' and whose parent matches '^(dim|fct)_' or has an
-- original_file_path containing '/marts/'. DISTINCT gives one row per child.
select distinct e.child_unique_id as unique_id
from {{ info_schema('edges') }} e
join {{ info_schema('models') }} c on c.unique_id = e.child_unique_id
join {{ info_schema('models') }} p on p.unique_id = e.parent_unique_id
where c.package_name = (select project_name from {{ info_schema('project') }})
  and regexp_matches(c.name, '^stg_')
  and (regexp_matches(p.name, '^(dim|fct)_') or p.original_file_path like '%/marts/%')
