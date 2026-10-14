-- Flags models with no description.
-- Reads enabled `models` in this project and returns rows whose description is null or blank.
select unique_id
from {{ info_schema('models') }}
where enabled
  and package_name = (select project_name from {{ info_schema('project') }})
  and (description is null or trim(description) = '')
