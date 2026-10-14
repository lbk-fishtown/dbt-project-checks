select s.unique_id
from {{ info_schema('sources') }} s
where s.enabled
  and s.package_name = (select project_name from {{ info_schema('project') }})
  and not exists (
    select 1 from {{ info_schema('data_tests') }} t
    where t.node_unique_id = s.unique_id
  )
