-- Flags staging models built on other staging models.
-- Joins `edges` to `models` twice: c is the child, p the parent. Keeps children in this project
-- where both c.name and p.name match '^stg_'. DISTINCT gives one row per child.
select distinct e.child_unique_id as unique_id
from {{ info_schema('edges') }} e
join {{ info_schema('models') }} c on c.unique_id = e.child_unique_id
join {{ info_schema('models') }} p on p.unique_id = e.parent_unique_id
where c.package_name = (select project_name from {{ info_schema('project') }})
  and regexp_matches(c.name, '^stg_')
  and regexp_matches(p.name, '^stg_')
