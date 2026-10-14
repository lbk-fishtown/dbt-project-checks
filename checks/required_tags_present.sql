{% set required_tags = var('required_tags', ['owner']) %}
select unique_id
from (
  select unique_id, tags from {{ info_schema('models') }}
  where enabled and package_name = (select project_name from {{ info_schema('project') }})
  union all
  select unique_id, tags from {{ info_schema('sources') }}
  where enabled and package_name = (select project_name from {{ info_schema('project') }})
)
where len(list_intersect(coalesce(tags, []), {{ required_tags }})) < {{ required_tags | length }}
