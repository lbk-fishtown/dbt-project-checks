select m.unique_id
from {{ info_schema('models') }} m
where m.enabled
  and m.package_name = (select project_name from {{ info_schema('project') }})
  and not exists (
    select 1 from {{ info_schema('edges') }} e
    where e.child_unique_id = m.unique_id
  )
