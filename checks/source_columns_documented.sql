select c.node_unique_id as unique_id
from {{ info_schema('node_columns') }} c
join {{ info_schema('sources') }} s on s.unique_id = c.node_unique_id
where s.enabled
  and s.package_name = (select project_name from {{ info_schema('project') }})
  and (c.description is null or trim(c.description) = '')
