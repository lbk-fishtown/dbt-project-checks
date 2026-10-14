-- Flags source tables missing a description.
-- Reads enabled `sources` (one row per source table) in this project, and flags a row when
-- source_description (the parent source block) or description (the table) is null or blank.
select unique_id
from {{ info_schema('sources') }}
where enabled
  and package_name = (select project_name from {{ info_schema('project') }})
  and (
    source_description is null or trim(source_description) = ''
    or description is null or trim(description) = ''
  )
