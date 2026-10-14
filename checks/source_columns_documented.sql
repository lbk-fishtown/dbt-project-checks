-- Flags source columns with no description.
-- Joins `node_columns` to `sources` on node_unique_id, keeps enabled sources in this project,
-- and returns the source table's id once per column whose description is null or blank.
-- Only columns declared in YAML are seen.
select c.node_unique_id as unique_id
from {{ info_schema('node_columns') }} c
join {{ info_schema('sources') }} s on s.unique_id = c.node_unique_id
where s.enabled
  and s.package_name = (select project_name from {{ info_schema('project') }})
  and (c.description is null or trim(c.description) = '')
