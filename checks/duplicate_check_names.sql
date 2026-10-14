-- Flags enabled checks whose name is shared with another enabled check, in any package.
-- Reads `checks` with no package filter, keeps enabled rows, and a QUALIFY window counts
-- rows per name; any name with count > 1 returns every check that has it.
-- The rows are check ids, which a --select of models or sources never includes. With the
-- default selection filtering, any selected run (e.g. CI on modified state) skips this check
-- ("selection matched no nodes"). selection_filter_on: none (set in _checks.yml) stops that
-- filtering, so the check always runs across the whole project.
-- Set it in YAML, not a config() block: a config() block here stopped a root project's
-- +enabled: true from taking effect (dbt 2.0.8).
select unique_id
from {{ info_schema('checks') }}
where enabled
qualify count(*) over (partition by name) > 1
