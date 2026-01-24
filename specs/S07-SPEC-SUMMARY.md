# S07-SPEC-SUMMARY.md
## simple_rosetta - Specification Summary

**Generation Type:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23

---

## Executive Summary

**simple_rosetta** imports and manages Rosetta Code programming tasks:
- Fetch 1,338 tasks from MediaWiki API
- Store in SQLite database
- Compare solutions across languages
- Validate Eiffel code compilation

## Quick Reference

### Import Tasks
```eiffel
local
    rosetta: SIMPLE_ROSETTA
do
    create rosetta.make
    rosetta.import_all_tasks
    print (rosetta.stats)
end
```

### Find and Display Task
```eiffel
if attached rosetta.find_task ("Bubble sort") as task then
    print (task.name)
    print (task.description)
    across task.languages as lang loop
        print (lang)
    end
end
```

### Get Solutions
```eiffel
solutions := rosetta.solutions_for ("Factorial")
across solutions as sol loop
    print (sol.language + ": ")
    print (sol.code)
end
```

### Compare Languages
```eiffel
comparison := rosetta.compare_solutions ("Hello world",
    << "Python", "Java", "Eiffel" >>)
print (comparison)
```

### Find Tasks Without Eiffel
```eiffel
missing := rosetta.tasks_without_eiffel
print ("Tasks without Eiffel: " + missing.count.out)
```

## Class Summary

| Class | Purpose | Key Features |
|-------|---------|--------------|
| SIMPLE_ROSETTA | Main facade | Import, query, export |
| ROSETTA_CLIENT | API client | Fetch from MediaWiki |
| ROSETTA_TASK | Task model | Name, description, languages |
| ROSETTA_SOLUTION | Solution model | Language, code, validation |
| TASK_STORE | Database | SQLite persistence |
| WIKI_PARSER | Parser | Extract code from wiki |

## Database Schema

```sql
tasks (id, name, description, category, has_eiffel, eiffel_validated)
solutions (id, task_id, language, code, source, validated, validation_log)
```

## Statistics Example

```
Rosetta Code Database Statistics
================================
Total tasks: 1,338
Tasks with Eiffel: 159
Validated Eiffel: 150
Total solutions: 15,000

Coverage: 11.9%
```

## Contract Highlights

| Contract | Feature | Rule |
|----------|---------|------|
| Precondition | import_task | name_not_empty |
| Precondition | make_with_db | path_not_empty |
| Precondition | search | query_not_empty |
| Invariant | ROSETTA_TASK | name_not_empty |
| Invariant | ROSETTA_SOLUTION | task_id_positive |

## Key Design Decisions

1. **SQLite Storage**: Local, portable database
2. **MediaWiki API**: Direct access to Rosetta Code
3. **Wiki Parsing**: Regex-based extraction
4. **Compile Validation**: ec -batch for Eiffel
5. **Rate Limiting**: Polite 1 req/sec

## Research Highlights (from SIMPLE_ROSETTA_RESEARCH.md)

| Metric | Value |
|--------|-------|
| Total Rosetta Tasks | 1,338 |
| Existing Eiffel | 159 (12%) |
| Missing Eiffel | 1,179 (88%) |
| Target Coverage | 75%+ |

## Related Documents

- S01-PROJECT-INVENTORY.md - Project structure
- S02-CLASS-CATALOG.md - Class details
- S03-CONTRACTS.md - Contract specifications
- S04-FEATURE-SPECS.md - Feature catalog
- S05-CONSTRAINTS.md - Design constraints
- S06-BOUNDARIES.md - Scope and limits
- S08-VALIDATION-REPORT.md - Test coverage
- research/SIMPLE_ROSETTA_RESEARCH.md - Full research (32KB)
