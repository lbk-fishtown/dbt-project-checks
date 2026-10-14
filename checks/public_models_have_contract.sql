-- Flags public models without an enforced contract.
-- Reads enabled `models` in this project where access = 'public', and returns rows where
-- contract_enforced is false or null (null is coalesced to false).
select unique_id
from {{ info_schema('models') }}
where enabled
  and package_name = (select project_name from {{ info_schema('project') }})
  and access = 'public'
  and not coalesce(contract_enforced, false)
