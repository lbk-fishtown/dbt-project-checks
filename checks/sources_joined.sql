select e.child_unique_id as unique_id
from {{ info_schema('edges') }} e
join {{ info_schema('models') }} m on m.unique_id = e.child_unique_id
where e.parent_unique_id like 'source.%'
  and m.package_name = (select project_name from {{ info_schema('project') }})
group by e.child_unique_id
having count(distinct e.parent_unique_id) > 1
