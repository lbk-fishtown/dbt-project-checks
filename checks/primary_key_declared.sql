-- Flags models with no primary_key declared.
-- Reads enabled `models` in this project and returns those whose primary_key list,
-- with null coalesced to [], has length 0.
select unique_id
from {{ info_schema('models') }}
where enabled
  and package_name = (select project_name from {{ info_schema('project') }})
  and len(coalesce(primary_key, [])) = 0
