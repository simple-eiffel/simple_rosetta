# Three-Hat Review: simple_rosetta

**Date**: 2025-12-22
**Hats Applied**: Contracting, Code Smell, Security
**Reviewer**: Claude (Eiffel Expert)

---

## Executive Summary

Overall, simple_rosetta demonstrates good practices in several areas (parameterized SQL, strong contracts in algorithms), but has issues that need addressing:

| Hat | Critical | Moderate | Minor |
|-----|----------|----------|-------|
| Contracting | 1 | 3 | 5 |
| Code Smell | 0 | 2 | 4 |
| Security | 0 | 2 | 1 |

---

## CONTRACTING HAT

### Critical Issues

**C1. TRIVIAL Invariants in `simple_rosetta.e` (lines 332-335)**
```eiffel
invariant
    store_attached: store /= Void   -- TRIVIAL: Void-safe guarantees this
    client_attached: client /= Void -- TRIVIAL: Void-safe guarantees this
```
**Fix**: Remove these invariants. In a void-safe system, attached types are guaranteed non-void by the compiler.

### Moderate Issues

**C2. Missing postconditions in storage operations**
- `task_store.e:save_task` - No postcondition verifying save succeeded
- `solution_store.e:store_solution` - No postcondition
- `simple_rosetta.e:import_task` - No postcondition

**C3. Missing `l_` prefix on local variables**
Files with violations:
- `src/storage/task_store.e` - Uses `sql_result`, `i` instead of `l_sql_result`, `l_i`
- `src/storage/solution_store.e` - Same issue
- `src/facade/simple_rosetta.e` - Uses `tasks`, `count`, `content` etc.
- Most solution files

**C4. Inconsistent precondition naming**
Some use descriptive names (`name_not_empty`), others don't.

### Minor Issues

**C5. Solution files vary widely in contract quality**
- EXCELLENT: `binary_search.e`, `quicksort.e`, `stack_operations.e` - Full DBC
- ACCEPTABLE: `fizzbuzz.e`, `empty_program.e` - Demo code, minimal contracts OK
- POOR: Several tier2 solutions have no contracts at all

### Good Examples to Follow

`binary_search.e` lines 51-76:
```eiffel
binary_search (arr: ARRAY [INTEGER]; target: INTEGER): INTEGER
    require
        sorted: is_sorted (arr)
    local
        low, high, mid: INTEGER
    do
        -- implementation
    ensure
        found_correct: Result > 0 implies arr [Result] = target
        not_found_absent: Result < 0 implies not arr.has (target)
    end
```

---

## CODE SMELL HAT

### Moderate Issues

**S1. Long Parameter List in `solution_store.e:store_solution`**
```eiffel
store_solution (a_task: STRING; a_tier: INTEGER; a_class: STRING;
                a_file: STRING; a_code: STRING; a_desc: STRING; a_url: STRING)
```
**7 parameters** - Consider using a parameter object or builder pattern.

**S2. Duplicate iteration patterns**
Both `task_store.e` and `solution_store.e` have identical patterns:
```eiffel
from i := 1 until i > sql_result.count loop
    if attached xxx_from_row (sql_result.item (i)) as item then
        Result.extend (item)
    end
    i := i + 1
end
```
Consider extracting to a shared helper or using `across`.

### Minor Issues

**S3. Magic numbers**
- `task_store.e:158` - `make (1500)` - Why 1500?
- `solution_store.e:89` - `make (20)` - Why 20?

**S4. Feature envy**
`simple_rosetta.e:import_task` does extensive manipulation of `task` and `solutions` - could be simplified.

**S5. No across loops**
Code uses old-style `from/until` loops instead of modern `across`:
```eiffel
-- Current (old style)
from i := 1 until i > tasks.count loop
    -- ...
    i := i + 1
end

-- Better (modern Eiffel)
across tasks as tc loop
    -- ...
end
```

**S6. Inconsistent string literal style**
Mix of `"string"` and `"[multi-line]"` without clear pattern.

---

## SECURITY HAT

### Good Practices Found

**SQL Injection Protection: PASSED**
All SQL queries use parameterized queries:
```eiffel
db.query_with_args ("SELECT ... WHERE name = ?", <<a_name>>)
db.execute_with_args ("INSERT INTO ... VALUES (?, ?, ?)", <<val1, val2, val3>>)
```

### Moderate Issues

**X1. CSV Export Injection Risk** (`simple_rosetta.e:286-319`)
```eiffel
file.put_string ("%"" + task.name + "%"")
```
If `task.name` contains `"` or `,`, this breaks CSV format and could enable formula injection in spreadsheets.

**Recommendation**: Use proper CSV escaping (double-quote escaping) or use simple_csv library.

**X2. Shell Command Demo** (`execute_system_command.e`)
While this is demo code for Rosetta Code, it demonstrates shell execution. The hardcoded "dir" command is safe, but this pattern could be dangerous if users copy and modify.

**Recommendation**: Add security warning comment to the solution file.

### Minor Issues

**X3. Wiki output not sanitized** (`solution_store.e:155-174`)
The `solution_as_wiki` feature constructs wiki markup from database content. If content contains wiki markup characters, it could break formatting.

---

## Action Items

### Must Fix (Critical)

- [x] Remove trivial invariants from `simple_rosetta.e`

### Should Fix (Moderate)

- [ ] Add `l_` prefix to local variables (systematic refactor)
- [ ] Fix CSV export escaping
- [ ] Add security warning to execute_system_command.e
- [ ] Consider parameter object for store_solution

### Nice to Have (Minor)

- [ ] Convert from/until to across loops
- [ ] Add postconditions to storage operations
- [ ] Document magic numbers with constants

---

## Files Reviewed

### Core Library
- `src/storage/task_store.e` - Storage layer
- `src/storage/solution_store.e` - Solution storage
- `src/facade/simple_rosetta.e` - Main facade

### Solutions (Sample)
- `solutions/tier1_trivial/empty_program.e`
- `solutions/tier2_easy/fizzbuzz.e`
- `solutions/tier2_easy/execute_system_command.e`
- `solutions/tier3_moderate/stack_operations.e`
- `solutions/tier4_complex/quicksort.e`
- `solutions/tier4_complex/binary_search.e`

---

*Generated by Claude Code three-hat review process*
