-- Flags models that have no properties YAML.
-- Reads enabled `models` in this project and returns rows where properties_yml_file_path is null.
select unique_id
from {{ info_schema('models') }}
where enabled
  and package_name = (select project_name from {{ info_schema('project') }})
  and properties_yml_file_path is null
