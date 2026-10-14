select unique_id
from {{ info_schema('sources') }}
where enabled
  and package_name = (select project_name from {{ info_schema('project') }})
  and (
    source_description is null or trim(source_description) = ''
    or description is null or trim(description) = ''
  )
