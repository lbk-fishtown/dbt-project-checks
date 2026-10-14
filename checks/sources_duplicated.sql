select s1.unique_id
from {{ info_schema('sources') }} s1
join {{ info_schema('sources') }} s2
  on  s1.database_name = s2.database_name
  and s1.schema_name   = s2.schema_name
  and s1.identifier    = s2.identifier
  and s1.unique_id < s2.unique_id
where s1.enabled
  and s1.package_name = (select project_name from {{ info_schema('project') }})
