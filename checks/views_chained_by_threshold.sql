{% set max_view_depth = var('max_view_depth', 2) %}
with recursive chain as (
  select e.child_unique_id as node, e.parent_unique_id as ancestor, 1 as depth
  from {{ info_schema('edges') }} e
  join {{ info_schema('models') }} c on c.unique_id = e.child_unique_id and c.materialized = 'view'
  join {{ info_schema('models') }} p on p.unique_id = e.parent_unique_id and p.materialized = 'view'
  where c.package_name = (select project_name from {{ info_schema('project') }})
  union all
  select ch.node, e.parent_unique_id, ch.depth + 1
  from chain ch
  join {{ info_schema('edges') }} e on e.child_unique_id = ch.ancestor
  join {{ info_schema('models') }} p on p.unique_id = e.parent_unique_id and p.materialized = 'view'
  where ch.depth < 20
)
select distinct node as unique_id
from chain
where depth > {{ max_view_depth }}
