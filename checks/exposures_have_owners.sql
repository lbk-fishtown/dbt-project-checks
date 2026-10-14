-- Flags exposures with no owner at all.
-- Reads `exposures` for this project and returns rows where owner_name and owner_email
-- are both null or blank (trimmed to '').
select unique_id
from {{ info_schema('exposures') }}
where package_name = (select project_name from {{ info_schema('project') }})
  and (owner_name is null or trim(owner_name) = '')
  and (owner_email is null or trim(owner_email) = '')
