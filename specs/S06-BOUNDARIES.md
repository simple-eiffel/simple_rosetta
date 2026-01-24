# S06-BOUNDARIES.md
## simple_rosetta - System Boundaries

**Generation Type:** BACKWASH (reverse-engineered from implementation)
**Date:** 2026-01-23

---

## 1. Scope Boundaries

### IN SCOPE

| Capability | Description |
|------------|-------------|
| Task import | Fetch from Rosetta Code MediaWiki API |
| Wiki parsing | Extract descriptions and code |
| SQLite storage | Persist tasks and solutions |
| Solution comparison | Side-by-side language comparison |
| Eiffel validation | Compile-check generated solutions |
| CSV export | Export task data |
| CLI interface | Command-line operations |

### OUT OF SCOPE

| Capability | Reason |
|------------|--------|
| AI generation | Separate process (Claude Max) |
| Fine-tuning | Separate ML pipeline |
| Web interface | Future enhancement |
| Real-time sync | One-time import model |
| Code execution | Compile-only validation |
| Multi-database | SQLite only |

## 2. Integration Boundaries

### INTERNAL DEPENDENCIES

```
simple_rosetta
    |
    +-- simple_sql (SQLite database)
    |
    +-- simple_json (API response parsing)
    |
    +-- simple_regex (Wiki markup parsing)
    |
    +-- simple_process (Compiler validation)
    |
    +-- simple_cache (Response caching)
    |
    +-- simple_logger (Progress logging)
```

### EXTERNAL INTERFACES

| Interface | Protocol | Notes |
|-----------|----------|-------|
| Rosetta Code | MediaWiki API | HTTPS, JSON responses |
| EiffelStudio | ec.exe CLI | Batch compilation |
| File System | Local SQLite | Database persistence |

## 3. Error Boundaries

### API Errors

| Error Type | Handling |
|------------|----------|
| Network failure | has_error flag, last_error message |
| Rate limit | Automatic retry with backoff |
| Invalid response | Parse error logged |
| Timeout | Request timeout with message |

### Parse Errors

| Error Type | Handling |
|------------|----------|
| Malformed wiki | Skip solution, continue |
| Missing header | Log and skip |
| Empty code | Skip solution |

### Database Errors

| Error Type | Handling |
|------------|----------|
| Constraint violation | Update existing record |
| Connection failure | Error message |
| Disk full | Exception |

## 4. Data Boundaries

### Task Data

| Field | Limit | Notes |
|-------|-------|-------|
| name | 255 chars | Wiki page title |
| description | TEXT | Full task text |
| languages | Array | Multiple entries |

### Solution Data

| Field | Limit | Notes |
|-------|-------|-------|
| code | TEXT | Full source code |
| language | 64 chars | Language name |

### Database Size

| Metric | Expected |
|--------|----------|
| Tasks | ~1,400 |
| Solutions | ~20,000+ |
| Database file | ~20-50 MB |

## 5. API Boundaries

### Rosetta Code MediaWiki API

| Endpoint | Purpose | Rate |
|----------|---------|------|
| api.php?action=query | Task list | 1/sec |
| index.php?action=raw | Raw content | 1/sec |

### Response Sizes

| Response | Typical Size |
|----------|--------------|
| Task list page | ~50 KB |
| Task content | 5-500 KB |

## 6. Extension Points

### Custom Parsers

Implement alternative WIKI_PARSER for different wiki formats.

### Custom Validators

Add validation backends beyond ec.exe.

### Custom Storage

Alternative TASK_STORE implementations possible.

## 7. Version Boundaries

| Component | Version | Notes |
|-----------|---------|-------|
| EiffelStudio | 25.02+ | Required |
| SQLite | Via simple_sql | Bundled |
| Void Safety | All | Full void safety |
| SCOOP | Thread mode | Concurrency |

## 8. Future Extensions (from Research)

| Extension | Status |
|-----------|--------|
| AI generation | Separate tool |
| Training data export | JSONL format |
| Instruction pairs | Post-processing |
| Model fine-tuning | Separate pipeline |
