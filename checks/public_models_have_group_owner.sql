select m.unique_id
from {{ info_schema('models') }} m
left join {{ info_schema('groups') }} g on g.name = m."group"
where m.enabled
  and m.package_name = (select project_name from {{ info_schema('project') }})
  and m.access = 'public'
  and (
    g.unique_id is null
    or (
      (g.owner_name is null or trim(g.owner_name) = '')
      and (g.owner_email is null or trim(g.owner_email) = '')
    )
  )
