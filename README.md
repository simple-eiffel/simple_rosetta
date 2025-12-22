<p align="center">
  <img src="https://raw.githubusercontent.com/simple-eiffel/claude_eiffel_op_docs/main/artwork/LOGO.png" alt="simple_rosetta logo" width="400">
</p>

# simple_rosetta

**[Documentation](https://simple-eiffel.github.io/simple_rosetta/)** | **[GitHub](https://github.com/simple-eiffel/simple_rosetta)**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Eiffel](https://img.shields.io/badge/Eiffel-25.02-blue.svg)](https://www.eiffel.org/)
[![Design by Contract](https://img.shields.io/badge/DbC-enforced-orange.svg)]()
[![Tests](https://img.shields.io/badge/tests-11%20passing-brightgreen.svg)]()

Rosetta Code cross-language database and solution management for Eiffel.

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Status

**Beta** - 102 solutions, CLI tool, solution database

## Overview

simple_rosetta provides tools for managing Eiffel solutions on Rosetta Code. It includes a SQLite database for storing/searching solutions, a CLI for generating wiki-ready submissions, and 100+ ready-to-submit Eiffel solutions organized by difficulty tier.

```eiffel
-- Search for sorting solutions
local
    rosetta: SIMPLE_ROSETTA
    results: ARRAYED_LIST [ROSETTA_SOLUTION]
do
    create rosetta.make
    results := rosetta.search_solutions ("sort")
    across results as r loop
        print (r.task_name + "%N")
    end
end
```

## Features

- **102 Eiffel Solutions** across 4 difficulty tiers (trivial/easy/moderate/complex)
- **Solution Database** with SQLite storage and full-text search
- **Wiki Generator** produces copy-paste-ready Rosetta Code submissions
- **CLI Tool** for managing, searching, and validating solutions
- **Tier Organization**: TIER1 (28), TIER2 (40), TIER3 (19), TIER4 (12)
- **Design by Contract** on all solution code

## CLI Usage

```bash
# Generate wiki format for submission
rosetta wiki Fibonacci_sequence

# Search solutions by keyword
rosetta search sort

# List solutions by tier
rosetta list 1

# Show statistics
rosetta stats

# Validate solutions compile
rosetta validate
```

## Installation

1. Set environment variable:
```bash
export SIMPLE_EIFFEL=/path/to/simple_eiffel_root
```

2. Add to ECF:
```xml
<library name="simple_rosetta" location="$SIMPLE_EIFFEL/simple_rosetta/simple_rosetta.ecf"/>
```

## Dependencies

- simple_json - JSON parsing
- simple_sql - SQLite database
- simple_regex - Pattern matching
- simple_logger - Logging
- simple_cache - Caching
- simple_process - Process execution

## Solution Tiers

| Tier | Difficulty | Count | Examples |
|------|------------|-------|----------|
| 1 | Trivial | 28 | Hello World, Empty Program, Boolean Values |
| 2 | Easy | 40 | FizzBuzz, File I/O, String Operations |
| 3 | Moderate | 19 | Sorting Algorithms, Data Structures |
| 4 | Complex | 12 | Quicksort, BFS/DFS, Fibonacci with DbC |

## License

MIT License
