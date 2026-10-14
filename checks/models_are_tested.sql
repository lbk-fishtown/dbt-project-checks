-- Flags models with no data tests.
-- Reads enabled `models` in this project and uses NOT EXISTS to keep those with no
-- `data_tests` row whose node_unique_id points at the model.
select m.unique_id
from {{ info_schema('models') }} m
where m.enabled
  and m.package_name = (select project_name from {{ info_schema('project') }})
  and not exists (
    select 1 from {{ info_schema('data_tests') }} t
    where t.node_unique_id = m.unique_id
  )
