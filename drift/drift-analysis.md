# Drift Analysis: simple_rosetta

Generated: 2026-01-24
Method: `ec.exe -flatshort` vs `specs/*.md` + `research/*.md`

## Specification Sources

| Source | Files | Lines |
|--------|-------|-------|
| specs/*.md | 8 | 1104 |
| research/*.md | 1 | 855 |

## Classes Analyzed

| Class | Spec'd Features | Actual Features | Drift |
|-------|-----------------|-----------------|-------|
| SIMPLE_ROSETTA | 42 | 35 | -7 |

## Feature-Level Drift

### Specified, Implemented ✓
- `compare_solutions` ✓
- `eiffel_solution_for` ✓
- `export_tasks_csv` ✓
- `find_task` ✓
- `has_error` ✓
- `import_all_tasks` ✓
- `import_task` ✓
- `import_tasks_with_solutions` ✓
- `last_error` ✓
- `progress_callback` ✓
- ... and 3 more

### Specified, NOT Implemented ✗
- `add_language` ✗
- `all_tasks` ✗
- `eiffel_count` ✗
- `eiffel_solution_for_task` ✗
- `fetch_all_task_names` ✗
- `find_task_by_name` ✗
- `has_eiffel` ✗
- `is_eiffel_validated` ✗
- `language_count` ✗
- `save_solution` ✗
- ... and 19 more

### Implemented, NOT Specified
- `Io`
- `Operating_environment`
- `author`
- `close`
- `conforms_to`
- `copy`
- `date`
- `default_rescue`
- `description`
- `generating_type`
- ... and 12 more

## Summary

| Category | Count |
|----------|-------|
| Spec'd, implemented | 13 |
| Spec'd, missing | 29 |
| Implemented, not spec'd | 22 |
| **Overall Drift** | **HIGH** |

## Conclusion

**simple_rosetta** has high drift. Significant gaps between spec and implementation.
