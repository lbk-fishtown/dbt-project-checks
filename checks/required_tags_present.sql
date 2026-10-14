-- Flags models and sources missing any required tag.
-- Unions enabled `models` and `sources` in this project, then compares
-- len(list_intersect(tags, required)) with the number of required tags; a shortfall means
-- at least one is missing. Jinja renders var `required_tags` (default ['owner']) as a list literal.
-- Pass required_tags as a list, even for one tag (required_tags: [owner]). A bare string such as
-- `owner` renders as invalid SQL, and its length counts characters rather than tags.
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
