note
	description: "SQLite storage for Rosetta Code tasks and solutions"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	TASK_STORE

create
	make,
	make_with_path

feature {NONE} -- Initialization

	make
			-- Create store with default database path.
		do
			make_with_path (Default_db_path)
		end

	make_with_path (a_path: STRING)
			-- Create store with database at `a_path'.
		require
			path_not_empty: not a_path.is_empty
		do
			db_path := a_path
			create db.make (a_path)
			create last_error.make_empty
			ensure_schema
		ensure
			path_set: db_path.same_string (a_path)
		end

feature -- Access

	db_path: STRING
			-- Path to SQLite database

	last_error: STRING
			-- Last error message

feature -- Status

	has_error: BOOLEAN
			-- Did the last operation produce an error?
		do
			Result := not last_error.is_empty
		end

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

feature -- Statistics

	task_count: INTEGER
			-- Total number of tasks
		local
			l_sql_result: SIMPLE_SQL_RESULT
		do
			l_sql_result := db.query ("SELECT COUNT(*) as cnt FROM tasks")
			if not l_sql_result.is_empty then
				Result := l_sql_result.first.integer_value ("cnt")
			end
		end

	eiffel_count: INTEGER
			-- Number of tasks with Eiffel solutions
		local
			l_sql_result: SIMPLE_SQL_RESULT
		do
			l_sql_result := db.query ("SELECT COUNT(*) as cnt FROM tasks WHERE has_eiffel = 1")
			if not l_sql_result.is_empty then
				Result := l_sql_result.first.integer_value ("cnt")
			end
		end

	validated_count: INTEGER
			-- Number of tasks with validated Eiffel solutions
		local
			l_sql_result: SIMPLE_SQL_RESULT
		do
			l_sql_result := db.query ("SELECT COUNT(*) as cnt FROM tasks WHERE eiffel_validated = 1")
			if not l_sql_result.is_empty then
				Result := l_sql_result.first.integer_value ("cnt")
			end
		end

	solution_count: INTEGER
			-- Total number of solutions
		local
			l_sql_result: SIMPLE_SQL_RESULT
		do
			l_sql_result := db.query ("SELECT COUNT(*) as cnt FROM solutions")
			if not l_sql_result.is_empty then
				Result := l_sql_result.first.integer_value ("cnt")
			end
		end

feature -- Task Operations

	save_task (a_task: ROSETTA_TASK)
			-- Save or update `task'.
		require
			task_valid: not a_task.name.is_empty
		do
			last_error.wipe_out
			if a_task.id > 0 then
				update_task (a_task)
			else
				insert_task (a_task)
			end
		end

	find_task_by_name (a_name: STRING): detachable ROSETTA_TASK
			-- Find task by `a_name'.
		require
			name_not_empty: not a_name.is_empty
		local
			l_sql_result: SIMPLE_SQL_RESULT
		do
			l_sql_result := db.query_with_args ("SELECT id, name, description, category, has_eiffel, eiffel_validated, eiffel_validation_level FROM tasks WHERE name = ?", <<a_name>>)
			if not l_sql_result.is_empty then
				Result := task_from_row (l_sql_result.first)
			end
		end

	find_task_by_id (a_id: INTEGER): detachable ROSETTA_TASK
			-- Find task by `a_id'.
		require
			positive_id: a_id > 0
		local
			l_sql_result: SIMPLE_SQL_RESULT
		do
			l_sql_result := db.query_with_args ("SELECT id, name, description, category, has_eiffel, eiffel_validated, eiffel_validation_level FROM tasks WHERE id = ?", <<a_id>>)
			if not l_sql_result.is_empty then
				Result := task_from_row (l_sql_result.first)
			end
		end

	all_tasks: ARRAYED_LIST [ROSETTA_TASK]
			-- All tasks in database.
		local
			l_sql_result: SIMPLE_SQL_RESULT
			i: INTEGER
		do
			create Result.make (1500)
			l_sql_result := db.query ("SELECT id, name, description, category, has_eiffel, eiffel_validated, eiffel_validation_level FROM tasks ORDER BY name")
			from i := 1 until i > l_sql_result.count loop
				if attached task_from_row (l_sql_result.item (i)) as al_task then
					Result.extend (al_task)
				end
				i := i + 1
			end
		end

	tasks_without_eiffel: ARRAYED_LIST [ROSETTA_TASK]
			-- Tasks that do not have Eiffel solutions.
		local
			l_sql_result: SIMPLE_SQL_RESULT
			i: INTEGER
		do
			create Result.make (1200)
			l_sql_result := db.query ("SELECT id, name, description, category, has_eiffel, eiffel_validated, eiffel_validation_level FROM tasks WHERE has_eiffel = 0 ORDER BY name")
			from i := 1 until i > l_sql_result.count loop
				if attached task_from_row (l_sql_result.item (i)) as al_task then
					Result.extend (al_task)
				end
				i := i + 1
			end
		end

	tasks_with_eiffel: ARRAYED_LIST [ROSETTA_TASK]
			-- Tasks that have Eiffel solutions.
		local
			l_sql_result: SIMPLE_SQL_RESULT
			i: INTEGER
		do
			create Result.make (200)
			l_sql_result := db.query ("SELECT id, name, description, category, has_eiffel, eiffel_validated, eiffel_validation_level FROM tasks WHERE has_eiffel = 1 ORDER BY name")
			from i := 1 until i > l_sql_result.count loop
				if attached task_from_row (l_sql_result.item (i)) as al_task then
					Result.extend (al_task)
				end
				i := i + 1
			end
		end

	search_tasks (a_query: STRING): ARRAYED_LIST [ROSETTA_TASK]
			-- Search tasks by name or description.
		require
			query_not_empty: not a_query.is_empty
		local
			l_sql_result: SIMPLE_SQL_RESULT
			l_pattern: STRING
			i: INTEGER
		do
			create Result.make (100)
			l_pattern := "%%" + a_query + "%%"
			l_sql_result := db.query_with_args ("SELECT id, name, description, category, has_eiffel, eiffel_validated, eiffel_validation_level FROM tasks WHERE name LIKE ? OR description LIKE ? ORDER BY name", <<l_pattern, l_pattern>>)
			from i := 1 until i > l_sql_result.count loop
				if attached task_from_row (l_sql_result.item (i)) as al_task then
					Result.extend (al_task)
				end
				i := i + 1
			end
		end

feature -- Solution Operations

	save_solution (a_solution: ROSETTA_SOLUTION)
			-- Save or update `solution'.
		require
			solution_valid: not a_solution.language.is_empty and not a_solution.code.is_empty
		do
			last_error.wipe_out
			if a_solution.id > 0 then
				update_solution (a_solution)
			else
				insert_solution (a_solution)
			end
		end

	find_solution (a_task_id: INTEGER; a_language: STRING): detachable ROSETTA_SOLUTION
			-- Find solution for `a_task_id' in `a_language'.
		require
			valid_task_id: a_task_id > 0
			language_not_empty: not a_language.is_empty
		local
			l_sql_result: SIMPLE_SQL_RESULT
		do
			l_sql_result := db.query_with_args ("SELECT id, task_id, language, code, source, validated, validation_log FROM solutions WHERE task_id = ? AND language = ?", <<a_task_id, a_language>>)
			if not l_sql_result.is_empty then
				Result := solution_from_row (l_sql_result.first)
			end
		end

	solutions_for_task (a_task_id: INTEGER): ARRAYED_LIST [ROSETTA_SOLUTION]
			-- All solutions for `a_task_id'.
		require
			valid_task_id: a_task_id > 0
		local
			l_sql_result: SIMPLE_SQL_RESULT
			i: INTEGER
		do
			create Result.make (10)
			l_sql_result := db.query_with_args ("SELECT id, task_id, language, code, source, validated, validation_log FROM solutions WHERE task_id = ? ORDER BY language", <<a_task_id>>)
			from i := 1 until i > l_sql_result.count loop
				if attached solution_from_row (l_sql_result.item (i)) as al_sol then
					Result.extend (al_sol)
				end
				i := i + 1
			end
		end

	eiffel_solution_for_task (a_task_id: INTEGER): detachable ROSETTA_SOLUTION
			-- Eiffel solution for `a_task_id', if any.
		require
			valid_task_id: a_task_id > 0
		do
			Result := find_solution (a_task_id, "Eiffel")
		end

feature {NONE} -- Database Operations

	insert_task (a_task: ROSETTA_TASK)
			-- Insert new task.
		do
			db.execute_with_args ("INSERT INTO tasks (name, description, category, has_eiffel, eiffel_validated, eiffel_validation_level) VALUES (?, ?, ?, ?, ?, ?)", <<a_task.name, a_task.description, a_task.category,
				  bool_to_int (a_task.has_eiffel), bool_to_int (a_task.is_eiffel_validated), a_task.eiffel_validation_level>>)
			a_task.set_id (db.last_insert_rowid.to_integer_32)
		end

	update_task (a_task: ROSETTA_TASK)
			-- Update existing task.
		require
			has_id: a_task.id > 0
		do
			db.execute_with_args ("UPDATE tasks SET name = ?, description = ?, category = ?, has_eiffel = ?, eiffel_validated = ?, eiffel_validation_level = ? WHERE id = ?", <<a_task.name, a_task.description, a_task.category,
				  bool_to_int (a_task.has_eiffel), bool_to_int (a_task.is_eiffel_validated), a_task.eiffel_validation_level, a_task.id>>)
		end

	insert_solution (a_solution: ROSETTA_SOLUTION)
			-- Insert new solution.
		do
			db.execute_with_args ("INSERT OR REPLACE INTO solutions (task_id, language, code, source, validated, validation_log) VALUES (?, ?, ?, ?, ?, ?)", <<a_solution.task_id, a_solution.language, a_solution.code,
				  a_solution.source, bool_to_int (a_solution.is_validated), a_solution.validation_log>>)
			a_solution.set_id (db.last_insert_rowid.to_integer_32)
		end

	update_solution (a_solution: ROSETTA_SOLUTION)
			-- Update existing solution.
		require
			has_id: a_solution.id > 0
		do
			db.execute_with_args ("UPDATE solutions SET code = ?, source = ?, validated = ?, validation_log = ? WHERE id = ?", <<a_solution.code, a_solution.source, bool_to_int (a_solution.is_validated), a_solution.validation_log, a_solution.id>>)
		end

feature {NONE} -- Row Conversion

	task_from_row (a_row: SIMPLE_SQL_ROW): detachable ROSETTA_TASK
			-- Create task from database `row'.
		local
			l_id, l_level: INTEGER
			l_name, l_description, l_category: STRING
			l_has_eiffel_int, l_validated_int: INTEGER
		do
			l_id := a_row.integer_value ("id")
			l_name := a_row.string_value ("name").to_string_8
			l_description := a_row.string_value ("description").to_string_8
			l_category := a_row.string_value ("category").to_string_8
			l_has_eiffel_int := a_row.integer_value ("has_eiffel")
			l_validated_int := a_row.integer_value ("eiffel_validated")
			l_level := a_row.integer_value ("eiffel_validation_level")

			if not l_name.is_empty then
				create Result.make (l_name)
				Result.set_id (l_id)
				Result.set_description (l_description)
				Result.set_category (l_category)
				if l_has_eiffel_int /= 0 then
					Result.add_language ("Eiffel")
					if l_validated_int /= 0 then
						Result.set_eiffel_validated (l_level)
					end
				end
			end
		end

	solution_from_row (a_row: SIMPLE_SQL_ROW): detachable ROSETTA_SOLUTION
			-- Create solution from database `row'.
		local
			l_id, l_task_id, l_validated_int: INTEGER
			l_language, l_code, l_source, l_log: STRING
		do
			l_id := a_row.integer_value ("id")
			l_task_id := a_row.integer_value ("task_id")
			l_language := a_row.string_value ("language").to_string_8
			l_code := a_row.string_value ("code").to_string_8
			l_source := a_row.string_value ("source").to_string_8
			l_validated_int := a_row.integer_value ("validated")
			l_log := a_row.string_value ("validation_log").to_string_8

			if not l_language.is_empty and not l_code.is_empty then
				create Result.make (l_task_id, l_language, l_code)
				Result.set_id (l_id)
				if not l_source.is_empty then
					Result.set_source (l_source)
				end
				if l_validated_int /= 0 then
					Result.set_validated (2, l_log)
				end
			end
		end

	bool_to_int (a_b: BOOLEAN): INTEGER
			-- Convert boolean to integer (0 or 1)
		do
			if a_b then Result := 1 else Result := 0 end
		end

feature {NONE} -- Schema

	ensure_schema
			-- Create tables if they do not exist.
		do
			db.execute (Schema_tasks)
			db.execute (Schema_solutions)
			db.execute (Schema_instruction_pairs)
			db.execute (Schema_validation_runs)
		end

	Schema_tasks: STRING = "[
		CREATE TABLE IF NOT EXISTS tasks (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			name TEXT UNIQUE NOT NULL,
			description TEXT,
			category TEXT,
			has_eiffel INTEGER DEFAULT 0,
			eiffel_validated INTEGER DEFAULT 0,
			eiffel_validation_level INTEGER DEFAULT 0,
			created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		)
	]"

	Schema_solutions: STRING = "[
		CREATE TABLE IF NOT EXISTS solutions (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			task_id INTEGER REFERENCES tasks(id),
			language TEXT NOT NULL,
			code TEXT NOT NULL,
			source TEXT DEFAULT 'rosetta',
			validated INTEGER DEFAULT 0,
			validation_log TEXT,
			created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
			UNIQUE(task_id, language)
		)
	]"

	Schema_instruction_pairs: STRING = "[
		CREATE TABLE IF NOT EXISTS instruction_pairs (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			task_id INTEGER REFERENCES tasks(id),
			instruction TEXT NOT NULL,
			input TEXT,
			output TEXT NOT NULL,
			pair_type TEXT,
			source_languages TEXT,
			created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		)
	]"

	Schema_validation_runs: STRING = "[
		CREATE TABLE IF NOT EXISTS validation_runs (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			solution_id INTEGER REFERENCES solutions(id),
			compile_success INTEGER,
			compile_errors TEXT,
			contract_violations TEXT,
			test_passed INTEGER,
			run_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		)
	]"

feature {NONE} -- Implementation

	db: SIMPLE_SQL_DATABASE
			-- Database connection

	Default_db_path: STRING = "rosetta.db"
			-- Default database path

end
