select m.unique_id
from {{ info_schema('models') }} m
where m.enabled
  and m.package_name = (select project_name from {{ info_schema('project') }})
  and not exists (
    select 1 from {{ info_schema('data_tests') }} t
    where t.node_unique_id = m.unique_id
      and t.test_name in ('unique', 'unique_combination_of_columns')
  )
