# S04-FEATURE-SPECS.md
## simple_rosetta - Feature Specifications

**Generation Type:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23

---

## Feature Categories

### 1. Import Operations

| Feature | Class | Signature | Description |
|---------|-------|-----------|-------------|
| import_all_tasks | SIMPLE_ROSETTA | | Import all task names from Rosetta Code |
| import_task | SIMPLE_ROSETTA | (task_name: STRING) | Import single task with solutions |
| import_tasks_with_solutions | SIMPLE_ROSETTA | (limit: INTEGER) | Import first N tasks with solutions |

### 2. Query Operations

| Feature | Class | Signature | Description |
|---------|-------|-----------|-------------|
| find_task | SIMPLE_ROSETTA | (name: STRING): detachable ROSETTA_TASK | Find task by name |
| search | SIMPLE_ROSETTA | (query: STRING): ARRAYED_LIST | Search tasks |
| tasks_without_eiffel | SIMPLE_ROSETTA | : ARRAYED_LIST [ROSETTA_TASK] | Tasks missing Eiffel |
| tasks_with_eiffel | SIMPLE_ROSETTA | : ARRAYED_LIST [ROSETTA_TASK] | Tasks with Eiffel |
| solutions_for | SIMPLE_ROSETTA | (task_name: STRING): ARRAYED_LIST | All solutions for task |
| eiffel_solution_for | SIMPLE_ROSETTA | (task_name: STRING): detachable ROSETTA_SOLUTION | Get Eiffel solution |

### 3. Comparison

| Feature | Class | Signature | Description |
|---------|-------|-----------|-------------|
| compare_solutions | SIMPLE_ROSETTA | (task_name, languages): STRING | Side-by-side comparison |

### 4. Export

| Feature | Class | Signature | Description |
|---------|-------|-----------|-------------|
| export_tasks_csv | SIMPLE_ROSETTA | (path: STRING) | Export tasks to CSV |

### 5. Statistics

| Feature | Class | Signature | Description |
|---------|-------|-----------|-------------|
| stats | SIMPLE_ROSETTA | : STRING | Database statistics |
| task_count | TASK_STORE | : INTEGER | Total tasks |
| solution_count | TASK_STORE | : INTEGER | Total solutions |
| eiffel_count | TASK_STORE | : INTEGER | Tasks with Eiffel |
| validated_count | TASK_STORE | : INTEGER | Validated Eiffel |

### 6. Status/Error

| Feature | Class | Signature | Description |
|---------|-------|-----------|-------------|
| has_error | SIMPLE_ROSETTA | : BOOLEAN | Error occurred? |
| last_error | SIMPLE_ROSETTA | : STRING | Error message |
| progress_callback | SIMPLE_ROSETTA | : STRING | Progress message |
| close | SIMPLE_ROSETTA | | Close database |

### 7. API Client

| Feature | Class | Signature | Description |
|---------|-------|-----------|-------------|
| fetch_all_task_names | ROSETTA_CLIENT | : ARRAYED_LIST [ROSETTA_TASK] | Get task list |
| fetch_task_content | ROSETTA_CLIENT | (name: STRING): detachable STRING | Get wiki content |
| has_error | ROSETTA_CLIENT | : BOOLEAN | API error? |
| last_error | ROSETTA_CLIENT | : STRING | Error message |

### 8. Wiki Parsing

| Feature | Class | Signature | Description |
|---------|-------|-----------|-------------|
| extract_description | WIKI_PARSER | (content: STRING): STRING | Extract task description |
| extract_solutions | WIKI_PARSER | (content: STRING): ARRAYED_LIST | Extract code solutions |

### 9. Task Model

| Feature | Class | Signature | Description |
|---------|-------|-----------|-------------|
| id | ROSETTA_TASK | : INTEGER | Task ID |
| name | ROSETTA_TASK | : STRING | Task name |
| description | ROSETTA_TASK | : STRING | Task description |
| category | ROSETTA_TASK | : STRING | Task category |
| has_eiffel | ROSETTA_TASK | : BOOLEAN | Has Eiffel solution? |
| is_eiffel_validated | ROSETTA_TASK | : BOOLEAN | Eiffel validated? |
| languages | ROSETTA_TASK | : ARRAYED_LIST [STRING] | Available languages |
| language_count | ROSETTA_TASK | : INTEGER | Number of languages |
| add_language | ROSETTA_TASK | (language: STRING) | Add language |
| set_description | ROSETTA_TASK | (desc: STRING) | Set description |

### 10. Solution Model

| Feature | Class | Signature | Description |
|---------|-------|-----------|-------------|
| id | ROSETTA_SOLUTION | : INTEGER | Solution ID |
| task_id | ROSETTA_SOLUTION | : INTEGER | Parent task ID |
| language | ROSETTA_SOLUTION | : STRING | Programming language |
| code | ROSETTA_SOLUTION | : STRING | Source code |
| source | ROSETTA_SOLUTION | : STRING | Origin (rosetta/generated/community) |
| validated | ROSETTA_SOLUTION | : BOOLEAN | Has been validated? |
| validation_log | ROSETTA_SOLUTION | : STRING | Validation output |

### 11. Storage

| Feature | Class | Signature | Description |
|---------|-------|-----------|-------------|
| save_task | TASK_STORE | (task: ROSETTA_TASK) | Save task |
| find_task_by_name | TASK_STORE | (name: STRING): detachable ROSETTA_TASK | Find task |
| all_tasks | TASK_STORE | : ARRAYED_LIST [ROSETTA_TASK] | All tasks |
| search_tasks | TASK_STORE | (query: STRING): ARRAYED_LIST | Search |
| save_solution | TASK_STORE | (solution: ROSETTA_SOLUTION) | Save solution |
| solutions_for_task | TASK_STORE | (task_id: INTEGER): ARRAYED_LIST | Get solutions |
| eiffel_solution_for_task | TASK_STORE | (task_id: INTEGER): detachable ROSETTA_SOLUTION | Get Eiffel |
| close | TASK_STORE | | Close database |
