-- Flags sources that point at the same relation as another enabled source.
-- Reads enabled `sources` in this project and uses EXISTS to find a different enabled source,
-- from any package, with the same database_name, schema_name and identifier.
-- IS NOT DISTINCT FROM treats two nulls as equal, so adapters with no database still match.
-- Every project source in a duplicate group is returned, including ones whose twin lives in a package.
select s1.unique_id
from {{ info_schema('sources') }} s1
where s1.enabled
  and s1.package_name = (select project_name from {{ info_schema('project') }})
  and exists (
    select 1 from {{ info_schema('sources') }} s2
    where s2.enabled
      and s2.unique_id <> s1.unique_id
      and s2.database_name is not distinct from s1.database_name
      and s2.schema_name   is not distinct from s1.schema_name
      and s2.identifier    is not distinct from s1.identifier
  )
