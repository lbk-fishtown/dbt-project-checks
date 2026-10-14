select unique_id
from {{ info_schema('checks') }}
where enabled
qualify count(*) over (partition by name) > 1
