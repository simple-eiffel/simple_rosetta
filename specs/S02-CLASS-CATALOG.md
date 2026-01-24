# S02-CLASS-CATALOG.md
## simple_rosetta - Class Catalog

**Generation Type:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23

---

### CLASS: SIMPLE_ROSETTA

**Role:** Main facade for Rosetta Code cross-language database

**Creation Procedures:**
- `make` - Create with default database
- `make_with_db(db_path)` - Create with specific database path

**Key Features:**
- Access: `last_error`, `progress_callback`
- Status: `has_error`, `close`
- Statistics: `stats`
- Import: `import_all_tasks`, `import_task`, `import_tasks_with_solutions`
- Query: `find_task`, `search`, `tasks_without_eiffel`, `tasks_with_eiffel`, `solutions_for`, `eiffel_solution_for`
- Comparison: `compare_solutions`
- Export: `export_tasks_csv`

**Collaborators:** TASK_STORE, ROSETTA_CLIENT, WIKI_PARSER

---

### CLASS: ROSETTA_CLIENT

**Role:** MediaWiki API client for Rosetta Code

**Key Features:**
- `fetch_all_task_names` - Get list of all tasks
- `fetch_task_content(name)` - Get raw wiki content
- `has_error`, `last_error` - Error handling

**API Endpoints:**
- List tasks: `/w/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Tasks`
- Task content: `/w/index.php?action=raw&title={name}`

---

### CLASS: ROSETTA_TASK

**Role:** Task data model

**Creation Procedures:**
- `make(name)` - Create task with name

**Key Features:**
- Access: `id`, `name`, `description`, `category`
- Status: `has_eiffel`, `is_eiffel_validated`
- Languages: `languages`, `language_count`, `add_language`

---

### CLASS: ROSETTA_SOLUTION

**Role:** Solution data model

**Creation Procedures:**
- `make(task_id, language, code)` - Create solution

**Key Features:**
- Access: `id`, `task_id`, `language`, `code`, `source`
- Status: `validated`, `validation_log`

---

### CLASS: TASK_STORE

**Role:** SQLite persistence for tasks and solutions

**Creation Procedures:**
- `make` - Create with default path
- `make_with_path(path)` - Create with specific path

**Key Features:**
- Tasks: `save_task`, `find_task_by_name`, `all_tasks`, `search_tasks`
- Solutions: `save_solution`, `solutions_for_task`, `eiffel_solution_for_task`
- Queries: `tasks_without_eiffel`, `tasks_with_eiffel`
- Statistics: `task_count`, `solution_count`, `eiffel_count`, `validated_count`
- Lifecycle: `close`

**Database Schema:**
```sql
CREATE TABLE tasks (
    id INTEGER PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    category TEXT,
    has_eiffel BOOLEAN DEFAULT FALSE,
    eiffel_validated BOOLEAN DEFAULT FALSE
);

CREATE TABLE solutions (
    id INTEGER PRIMARY KEY,
    task_id INTEGER REFERENCES tasks(id),
    language TEXT NOT NULL,
    code TEXT NOT NULL,
    source TEXT,
    validated BOOLEAN DEFAULT FALSE,
    validation_log TEXT,
    UNIQUE(task_id, language)
);
```

---

### CLASS: WIKI_PARSER

**Role:** Parse MediaWiki markup for Rosetta Code

**Key Features:**
- `extract_description(content)` - Extract task description
- `extract_solutions(content)` - Extract all language solutions

**Patterns:**
- Language header: `=={{header|LanguageName}}==`
- Code blocks: `<lang>...</lang>` or `<syntaxhighlight>...</syntaxhighlight>`

---

### CLASS: ROSETTA_CLI

**Role:** Command-line interface

**Key Features:**
- Import commands
- Query commands
- Export commands
- Progress display

---

### CLASS: SOLUTION_IMPORTER

**Role:** Import solutions from files or web

**Key Features:**
- File import
- Batch processing

---

### CLASS: SOLUTION_STORE

**Role:** Additional solution storage functionality

**Key Features:**
- Solution management
- Validation tracking
