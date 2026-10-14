-- Flags models with no parents, usually a hard-coded relation instead of ref()/source().
-- Reads enabled `models` in this project and uses NOT EXISTS to keep those that never
-- appear as child_unique_id in `edges`.
select m.unique_id
from {{ info_schema('models') }} m
where m.enabled
  and m.package_name = (select project_name from {{ info_schema('project') }})
  and not exists (
    select 1 from {{ info_schema('edges') }} e
    where e.child_unique_id = m.unique_id
  )
