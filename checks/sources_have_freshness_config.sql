select unique_id
from {{ info_schema('sources') }}
where enabled
  and package_name = (select project_name from {{ info_schema('project') }})
  and (loaded_at_field is null or trim(loaded_at_field) = '')
