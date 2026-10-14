-- Flags sources that nothing but tests depends on.
-- Reads enabled `sources` in this project and uses NOT EXISTS to keep those with no child in
-- `edges` other than a data test. Children that are data tests are spotted by matching their id
-- in `data_tests`, so a tested but otherwise unreferenced source is still flagged. Any other
-- child (model, snapshot, exposure, ...) counts as a use.
select s.unique_id
from {{ info_schema('sources') }} s
where s.enabled
  and s.package_name = (select project_name from {{ info_schema('project') }})
  and not exists (
    select 1 from {{ info_schema('edges') }} e
    where e.parent_unique_id = s.unique_id
      and not exists (
        select 1 from {{ info_schema('data_tests') }} t
        where t.unique_id = e.child_unique_id
      )
  )
