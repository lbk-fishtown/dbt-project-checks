select unique_id
from {{ info_schema('seeds') }}
where enabled
  and package_name = (select project_name from {{ info_schema('project') }})
  and (description is null or trim(description) = '')
