# dbt Project Checks

28 [dbt Checks](https://docs.getdbt.com/docs/build/checks) covering popular practices for
documentation, governance, testing and DAG structure. A working example of the pattern: extend them,
or copy `checks/` into your own project and shape them to fit.

Checks ship disabled, so installing the package does not change how your project behaves.

- Runs against the [dbt Information Schema](https://docs.getdbt.com/reference/info-schema) inside
  DuckDB at parse time, so no warehouse connection is needed and nothing is materialised. Metadata
  only, which puts anything needing warehouse data or model SQL text out of scope.
- Every check looks at your project's own resources, apart from `duplicate_check_names`, which
  deliberately scans every package to catch name clashes.
- Enabled checks run before every `dbt build`, or on demand with `dbt check`. Default severity is
  `warn`, so a violation reports without failing the run; add `+severity: error` to gate on one. See
  [check configs](https://docs.getdbt.com/reference/check-configs) for the rest of the surface.

## Install

```yaml
# packages.yml
packages:
  - git: https://github.com/<you>/dbt-project-checks
    revision: v1.0.0
```

Run `dbt deps`.

## Configure

Paste this into your `dbt_project.yml`. Five popular checks are on. The other 23 sit below commented
out beside what they do, so enabling one means uncommenting two lines. Where a check reads a setting,
the setting is noted beneath it and declared under a top-level `vars:` key.

```yaml
# dbt_project.yml
info_schema:
  version: 1

checks:
  dbt_project_checks:

    # Popular checks, already on.

    models_have_descriptions:
      +enabled: true   # Models that are missing a description.
    sources_have_descriptions:
      +enabled: true   # Sources or source tables that are missing a description.
    models_are_tested:
      +enabled: true   # Models that have no tests.
    sources_have_freshness_config:
      +enabled: true   # Sources with no freshness (loaded_at_field) configured.
    public_models_have_contract:
      +enabled: true   # Public models with no enforced contract.

    # --- documentation ---
    # model_columns_documented:
    #   +enabled: true   # Model columns that are missing a description.
    # source_columns_documented:
    #   +enabled: true   # Source columns that are missing a description.
    # seeds_have_descriptions:
    #   +enabled: true   # Seeds that are missing a description.
    # macros_documented:
    #   +enabled: true   # Project macros that are missing a description.
    # models_have_yml_files:
    #   +enabled: true   # Models that have no properties YAML file.

    # --- governance ---
    # public_models_have_group_owner:
    #   +enabled: true   # Public models with no group owner.
    # public_models_documented:
    #   +enabled: true   # Public models that are missing a description.
    # exposures_have_owners:
    #   +enabled: true   # Exposures with no owner name or email.
    # required_tags_present:
    #   +enabled: true   # Models and sources that are missing their required tags.
    #   # var required_tags: [owner]

    # --- testing ---
    # sources_are_tested:
    #   +enabled: true   # Source tables that have no tests.
    # models_have_primary_key_test:
    #   +enabled: true   # Models with no unique test on the primary key.
    # primary_key_declared:
    #   +enabled: true   # Models that do not declare a primary_key.
    # test_coverage_below_threshold:
    #   +enabled: true   # Test coverage below the configured threshold.
    #   # var test_coverage_threshold: 100

    # --- structure and DAG ---
    # no_direct_source_dependencies:
    #   +enabled: true   # Non-staging models that read a source directly.
    # sources_joined:
    #   +enabled: true   # Models that read more than one source directly.
    # sources_unused:
    #   +enabled: true   # Sources with no downstream models.
    # sources_duplicated:
    #   +enabled: true   # Sources that point at the same relation.
    # staging_references_staging:
    #   +enabled: true   # Staging models whose parent is another staging model.
    # staging_references_marts:
    #   +enabled: true   # Staging models with a marts-layer parent.
    # naming_conventions:
    #   +enabled: true   # Models whose name does not match the configured pattern.
    #   # var model_name_pattern: '^(stg|int|dim|fct|base|mart)_.+'
    # views_chained_by_threshold:
    #   +enabled: true   # Views chained deeper than the configured limit.
    #   # var max_view_depth: 2
    # models_without_upstream_dependencies:
    #   +enabled: true   # Models that reference no other model or source.

    # --- meta ---
    # duplicate_check_names:
    #   +enabled: true   # Checks that share a name with another enabled check.
```
