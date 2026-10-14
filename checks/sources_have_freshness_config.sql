-- Flags source tables with no freshness threshold.
-- Reads enabled `sources` in this project and returns rows where neither
-- config.freshness.warn_after.count nor config.freshness.error_after.count is set, read from the
-- config JSON with json_extract_string. A missing or null freshness block also counts as unset.
-- How freshness is measured (loaded_at_field, loaded_at_query or warehouse metadata) is not
-- checked, because dbt only evaluates a source's freshness when one of these thresholds is set.
select unique_id
from {{ info_schema('sources') }}
where enabled
  and package_name = (select project_name from {{ info_schema('project') }})
  and json_extract_string(config, '$.freshness.warn_after.count') is null
  and json_extract_string(config, '$.freshness.error_after.count') is null
