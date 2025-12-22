note
	description: "Stores Eiffel solutions for Rosetta Code tasks in SQLite database."
	author: "Simple Eiffel"
	date: "$Date$"

class
	SOLUTION_STORE

create
	make

feature {NONE} -- Initialization

	make (a_db_path: STRING)
			-- Initialize solution store with database at `a_db_path'.
		require
			path_not_empty: not a_db_path.is_empty
		do
			db_path := a_db_path
			create db.make (a_db_path)
			ensure_solution_table
		ensure
			path_set: db_path.same_string (a_db_path)
		end

feature -- Access

	db_path: STRING
			-- Path to SQLite database

	is_open: BOOLEAN
			-- Is the database open?
		do
			Result := db.is_open
		end

	close
			-- Close database connection.
		do
			db.close
		ensure
			not_open: not is_open
		end

feature -- Schema

	ensure_solution_table
			-- Create solutions table if not exists.
		do
			db.execute (Schema_solutions)
		end

feature -- Storage

	store_solution (a_task: STRING; a_tier: INTEGER; a_class: STRING; a_file: STRING; a_code: STRING; a_desc: STRING; a_url: STRING)
			-- Store a solution in the database.
		require
			valid_task: not a_task.is_empty
			valid_tier: a_tier >= 1 and a_tier <= 4
			valid_class: not a_class.is_empty
			valid_file: not a_file.is_empty
			valid_code: not a_code.is_empty
		do
			db.execute_with_args ("INSERT OR REPLACE INTO solutions (task_name, tier, class_name, file_name, source_code, description, rosetta_url) VALUES (?, ?, ?, ?, ?, ?, ?)",
				<<a_task, a_tier, a_class, a_file, a_code, a_desc, a_url>>)
		end

feature -- Queries

	solution_count: INTEGER
			-- Number of stored solutions.
		local
			sql_result: SIMPLE_SQL_RESULT
		do
			sql_result := db.query ("SELECT COUNT(*) as cnt FROM solutions")
			if not sql_result.is_empty then
				Result := sql_result.first.integer_value ("cnt")
			end
		end

	solutions_by_tier (a_tier: INTEGER): ARRAYED_LIST [TUPLE [task: STRING; class_name: STRING; file: STRING]]
			-- All solutions for given tier.
		require
			valid_tier: a_tier >= 1 and a_tier <= 4
		local
			sql_result: SIMPLE_SQL_RESULT
			i: INTEGER
		do
			create Result.make (20)
			sql_result := db.query_with_args ("SELECT task_name, class_name, file_name FROM solutions WHERE tier = ? ORDER BY task_name", <<a_tier>>)
			from i := 1 until i > sql_result.count loop
				Result.extend ([
					sql_result.item (i).string_value ("task_name").to_string_8,
					sql_result.item (i).string_value ("class_name").to_string_8,
					sql_result.item (i).string_value ("file_name").to_string_8
				])
				i := i + 1
			end
		end

	get_solution_code (a_task: STRING): detachable STRING
			-- Get source code for a task.
		require
			valid_task: not a_task.is_empty
		local
			sql_result: SIMPLE_SQL_RESULT
		do
			sql_result := db.query_with_args ("SELECT source_code FROM solutions WHERE task_name = ?", <<a_task>>)
			if not sql_result.is_empty then
				Result := sql_result.first.string_value ("source_code").to_string_8
			end
		end

	search_solutions (a_keyword: STRING): ARRAYED_LIST [TUPLE [task: STRING; tier: INTEGER; class_name: STRING]]
			-- Search solutions by keyword in task name or description.
		require
			valid_keyword: not a_keyword.is_empty
		local
			sql_result: SIMPLE_SQL_RESULT
			pattern: STRING
			i: INTEGER
		do
			create Result.make (10)
			pattern := "%%" + a_keyword + "%%"
			sql_result := db.query_with_args ("SELECT task_name, tier, class_name FROM solutions WHERE task_name LIKE ? OR description LIKE ? ORDER BY tier, task_name", <<pattern, pattern>>)
			from i := 1 until i > sql_result.count loop
				Result.extend ([
					sql_result.item (i).string_value ("task_name").to_string_8,
					sql_result.item (i).integer_value ("tier"),
					sql_result.item (i).string_value ("class_name").to_string_8
				])
				i := i + 1
			end
		end

	tier_summary: ARRAYED_LIST [TUPLE [tier: INTEGER; solution_count: INTEGER]]
			-- Count of solutions per tier.
		local
			sql_result: SIMPLE_SQL_RESULT
			i: INTEGER
		do
			create Result.make (4)
			sql_result := db.query ("SELECT tier, COUNT(*) as cnt FROM solutions GROUP BY tier ORDER BY tier")
			from i := 1 until i > sql_result.count loop
				Result.extend ([
					sql_result.item (i).integer_value ("tier"),
					sql_result.item (i).integer_value ("cnt")
				])
				i := i + 1
			end
		end

feature -- Wiki Format

	solution_as_wiki (a_task: STRING): detachable STRING
			-- Format solution for Rosetta Code wiki.
		local
			sql_result: SIMPLE_SQL_RESULT
			code, desc: STRING
		do
			sql_result := db.query_with_args ("SELECT source_code, description FROM solutions WHERE task_name = ?", <<a_task>>)
			if not sql_result.is_empty then
				code := sql_result.first.string_value ("source_code").to_string_8
				desc := sql_result.first.string_value ("description").to_string_8
				create Result.make (code.count + 200)
				Result.append ("=={{header|Eiffel}}==%N")
				if not desc.is_empty then
					Result.append (desc + "%N%N")
				end
				Result.append ("<syntaxhighlight lang=%"eiffel%">%N")
				Result.append (code)
				Result.append ("</syntaxhighlight>%N")
			end
		end

feature {NONE} -- Schema

	Schema_solutions: STRING = "[
		CREATE TABLE IF NOT EXISTS solutions (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			task_name TEXT NOT NULL,
			tier INTEGER NOT NULL,
			class_name TEXT NOT NULL,
			file_name TEXT NOT NULL,
			source_code TEXT NOT NULL,
			description TEXT,
			rosetta_url TEXT,
			created_at TEXT DEFAULT CURRENT_TIMESTAMP,
			UNIQUE(task_name)
		)
	]"

feature {NONE} -- Implementation

	db: SIMPLE_SQL_DATABASE
			-- Database connection

end
