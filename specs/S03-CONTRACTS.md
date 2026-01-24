# S03-CONTRACTS.md
## simple_rosetta - Contract Specifications

**Generation Type:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23

---

## SIMPLE_ROSETTA Contracts

### make
```eiffel
make
    ensure
        no_error: not has_error
```

### make_with_db
```eiffel
make_with_db (db_path: STRING)
    require
        path_not_empty: not db_path.is_empty
    ensure
        no_error: not has_error
```

### import_task
```eiffel
import_task (task_name: STRING)
    require
        name_not_empty: not task_name.is_empty
```

### import_tasks_with_solutions
```eiffel
import_tasks_with_solutions (limit: INTEGER)
    require
        positive_limit: limit > 0
```

### find_task
```eiffel
find_task (name: STRING): detachable ROSETTA_TASK
    require
        name_not_empty: not name.is_empty
```

### search
```eiffel
search (query: STRING): ARRAYED_LIST [ROSETTA_TASK]
    require
        query_not_empty: not query.is_empty
```

### solutions_for
```eiffel
solutions_for (task_name: STRING): ARRAYED_LIST [ROSETTA_SOLUTION]
    require
        name_not_empty: not task_name.is_empty
```

### eiffel_solution_for
```eiffel
eiffel_solution_for (task_name: STRING): detachable ROSETTA_SOLUTION
    require
        name_not_empty: not task_name.is_empty
```

### compare_solutions
```eiffel
compare_solutions (task_name: STRING; languages: ARRAY [STRING]): STRING
    require
        name_not_empty: not task_name.is_empty
        languages_not_empty: not languages.is_empty
```

### export_tasks_csv
```eiffel
export_tasks_csv (path: STRING)
    require
        path_not_empty: not path.is_empty
```

---

## ROSETTA_TASK Contracts

### make
```eiffel
make (a_name: STRING)
    require
        name_not_empty: not a_name.is_empty
    ensure
        name_set: name.same_string (a_name)
```

### add_language
```eiffel
add_language (a_language: STRING)
    require
        language_not_empty: not a_language.is_empty
    ensure
        language_added: languages.has (a_language)
```

### Class Invariant
```eiffel
invariant
    name_not_empty: not name.is_empty
    id_non_negative: id >= 0
```

---

## ROSETTA_SOLUTION Contracts

### make
```eiffel
make (a_task_id: INTEGER; a_language: STRING; a_code: STRING)
    require
        task_id_positive: a_task_id > 0
        language_not_empty: not a_language.is_empty
        code_not_empty: not a_code.is_empty
    ensure
        task_id_set: task_id = a_task_id
        language_set: language.same_string (a_language)
        code_set: code.same_string (a_code)
```

### Class Invariant
```eiffel
invariant
    task_id_positive: task_id > 0
    language_not_empty: not language.is_empty
    code_not_empty: not code.is_empty
```

---

## TASK_STORE Contracts

### make
```eiffel
make
    ensure
        database_initialized: is_initialized
```

### make_with_path
```eiffel
make_with_path (a_path: STRING)
    require
        path_not_empty: not a_path.is_empty
```

### save_task
```eiffel
save_task (a_task: ROSETTA_TASK)
    require
        task_attached: a_task /= Void
```

### find_task_by_name
```eiffel
find_task_by_name (a_name: STRING): detachable ROSETTA_TASK
    require
        name_not_empty: not a_name.is_empty
```

### save_solution
```eiffel
save_solution (a_solution: ROSETTA_SOLUTION)
    require
        solution_attached: a_solution /= Void
        task_exists: task_exists (a_solution.task_id)
```

### solutions_for_task
```eiffel
solutions_for_task (a_task_id: INTEGER): ARRAYED_LIST [ROSETTA_SOLUTION]
    require
        task_id_positive: a_task_id > 0
```

---

## WIKI_PARSER Contracts

### extract_description
```eiffel
extract_description (a_content: STRING): STRING
    require
        content_not_empty: not a_content.is_empty
```

### extract_solutions
```eiffel
extract_solutions (a_content: STRING): ARRAYED_LIST [TUPLE [language: STRING; code: STRING]]
    require
        content_not_empty: not a_content.is_empty
```

---

## ROSETTA_CLIENT Contracts

### fetch_task_content
```eiffel
fetch_task_content (a_name: STRING): detachable STRING
    require
        name_not_empty: not a_name.is_empty
```
