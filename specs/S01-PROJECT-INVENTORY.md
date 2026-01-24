# S01-PROJECT-INVENTORY.md
## simple_rosetta - Rosetta Code Cross-Language Database

**Generation Type:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23
**Source:** Implementation analysis + research/SIMPLE_ROSETTA_RESEARCH.md

---

### 1. PROJECT IDENTITY

| Field | Value |
|-------|-------|
| Name | simple_rosetta |
| UUID | 46208015-390e-468a-b821-e5dd6e1140ae |
| Description | Rosetta Code cross-language translation database for Eiffel |
| Version | 1.0.0 |
| License | MIT License |
| Author | Larry Rix |

### 2. PURPOSE

Imports and manages Rosetta Code programming tasks:
- Fetch tasks from MediaWiki API
- Store tasks and solutions in SQLite
- Parse wiki markup for code extraction
- Compare solutions across languages
- Generate Eiffel solutions (via AI)
- Validate Eiffel code compilation

### 3. DEPENDENCIES

| Library | Location | Purpose |
|---------|----------|---------|
| base | $ISE_LIBRARY/library/base/base.ecf | Core Eiffel types |
| time | $ISE_LIBRARY/library/time/time.ecf | Timestamps |
| simple_cache | $SIMPLE_EIFFEL/simple_cache/simple_cache.ecf | Caching |
| simple_datetime | $SIMPLE_EIFFEL/simple_datetime/simple_datetime.ecf | Date handling |
| simple_json | $SIMPLE_EIFFEL/simple_json/simple_json.ecf | API responses |
| simple_logger | $SIMPLE_EIFFEL/simple_logger/simple_logger.ecf | Logging |
| simple_process | $SIMPLE_EIFFEL/simple_process/simple_process.ecf | Compiler validation |
| simple_regex | $SIMPLE_EIFFEL/simple_regex/simple_regex.ecf | Wiki parsing |
| simple_sql | $SIMPLE_EIFFEL/simple_sql/simple_sql.ecf | SQLite database |

### 4. FILE INVENTORY

| File | Class | Role |
|------|-------|------|
| src/facade/simple_rosetta.e | SIMPLE_ROSETTA | Main facade |
| src/api/rosetta_client.e | ROSETTA_CLIENT | MediaWiki API client |
| src/models/rosetta_task.e | ROSETTA_TASK | Task data model |
| src/models/rosetta_solution.e | ROSETTA_SOLUTION | Solution data model |
| src/storage/task_store.e | TASK_STORE | SQLite persistence |
| src/storage/wiki_parser.e | WIKI_PARSER | Wiki markup parser |
| src/solution_importer.e | SOLUTION_IMPORTER | Solution import |
| src/solution_store.e | SOLUTION_STORE | Solution storage |
| src/cli/rosetta_cli.e | ROSETTA_CLI | CLI interface |
| src/generation/* | Various | AI generation |
| src/training/* | Various | Training data |

### 5. BUILD TARGETS

| Target | Root Class | Purpose |
|--------|------------|---------|
| simple_rosetta | (library) | Main library target |
| simple_rosetta_tests | TEST_APP | Test suite |
| simple_rosetta_live | LIVE_API_TEST | Live API testing |
| simple_rosetta_report | REPORT_GENERATOR | Report generation |
| simple_rosetta_solutions | SOLUTIONS_VALIDATOR | Solution validation |
| rosetta_cli | ROSETTA_CLI | CLI executable |
| solutions_tests | TEST_APP | Solutions tests |

### 6. CAPABILITIES

- Concurrency: SCOOP support (uses thread)
- Void Safety: Full (all)
- Assertions: Full (precondition, postcondition, check, invariant, loop, supplier_precondition)

### 7. RELATED RESEARCH

- research/SIMPLE_ROSETTA_RESEARCH.md - Complete 7-step research (32KB)
- design/ - Design documents
- md/ - Markdown documentation
- solutions/ - Eiffel solutions for Rosetta Code tasks
