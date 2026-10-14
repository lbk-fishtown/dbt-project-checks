-- Flags model columns with no description.
-- Joins `node_columns` to `models` on node_unique_id, keeps enabled models in this project,
-- and returns the model's id once per column whose description is null or blank.
-- node_columns only holds columns declared in YAML, so undeclared columns are not seen.
select c.node_unique_id as unique_id
from {{ info_schema('node_columns') }} c
join {{ info_schema('models') }} m on m.unique_id = c.node_unique_id
where m.enabled
  and m.package_name = (select project_name from {{ info_schema('project') }})
  and (c.description is null or trim(c.description) = '')
