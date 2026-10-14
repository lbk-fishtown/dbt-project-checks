select unique_id
from {{ info_schema('macros') }}
where package_name = (select project_name from {{ info_schema('project') }})
  and (description is null or trim(description) = '')
