note
	description: "Main facade for simple_rosetta - Rosetta Code cross-language database"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_ROSETTA

create
	make,
	make_with_db

feature {NONE} -- Initialization

	make
			-- Create with default database.
		do
			create store.make
			create client.make
			create wiki_parser
			create last_error.make_empty
			create progress_callback.make_empty
		ensure
			no_error: not has_error
		end

	make_with_db (db_path: STRING)
			-- Create with database at `db_path'.
		require
			path_not_empty: not db_path.is_empty
		do
			create store.make_with_path (db_path)
			create client.make
			create wiki_parser
			create last_error.make_empty
			create progress_callback.make_empty
		ensure
			no_error: not has_error
		end

feature -- Access

	last_error: STRING
			-- Last error message

	progress_callback: STRING
			-- Progress message (for UI updates)

feature -- Status

	has_error: BOOLEAN
			-- Did the last operation produce an error?
		do
			Result := not last_error.is_empty
		end

	close
			-- Close database connection.
		do
			store.close
		end

feature -- Statistics

	stats: STRING
			-- Database statistics.
		do
			create Result.make (200)
			Result.append ("Rosetta Code Database Statistics%N")
			Result.append ("================================%N")
			Result.append ("Total tasks: ")
			Result.append_integer (store.task_count)
			Result.append ("%NTasks with Eiffel: ")
			Result.append_integer (store.eiffel_count)
			Result.append ("%NValidated Eiffel: ")
			Result.append_integer (store.validated_count)
			Result.append ("%NTotal solutions: ")
			Result.append_integer (store.solution_count)
			Result.append ("%N%NCoverage: ")
			if store.task_count > 0 then
				Result.append_double ((store.eiffel_count / store.task_count * 100).truncated_to_real)
			else
				Result.append ("0")
			end
			Result.append ("%%")
		end

feature -- Import Operations

	import_all_tasks
			-- Import all task names from Rosetta Code.
		local
			tasks: ARRAYED_LIST [ROSETTA_TASK]
			count, i: INTEGER
		do
			last_error.wipe_out
			progress_callback := "Fetching task list from Rosetta Code..."

			tasks := client.fetch_all_task_names
			if client.has_error then
				last_error := client.last_error
			else
				progress_callback := "Saving " + tasks.count.out + " tasks..."
				from i := 1 until i > tasks.count loop
					store.save_task (tasks.i_th (i))
					count := count + 1
					if count \\ 100 = 0 then
						progress_callback := "Saved " + count.out + " tasks..."
					end
					i := i + 1
				end
				progress_callback := "Import complete: " + tasks.count.out + " tasks"
			end
		end

	import_task (task_name: STRING)
			-- Import single task with all solutions.
		require
			name_not_empty: not task_name.is_empty
		local
			content: detachable STRING
			task: ROSETTA_TASK
			solutions: ARRAYED_LIST [TUPLE [language: STRING; code: STRING]]
			solution: ROSETTA_SOLUTION
			i: INTEGER
		do
			last_error.wipe_out
			progress_callback := "Fetching: " + task_name

			content := client.fetch_task_content (task_name)
			if client.has_error then
				last_error := client.last_error
			elseif attached content as c then
				-- Create or update task
				if attached store.find_task_by_name (task_name) as existing then
					task := existing
				else
					create task.make (task_name)
				end

				task.set_description (wiki_parser.extract_description (c))

				-- Extract solutions
				solutions := wiki_parser.extract_solutions (c)

				-- First pass: add languages to task
				from i := 1 until i > solutions.count loop
					if attached {STRING} solutions.i_th (i).language as l then
						task.add_language (l)
					end
					i := i + 1
				end

				-- Save task to get ID
				store.save_task (task)

				-- Save solutions with correct task_id
				if task.id > 0 then
					from i := 1 until i > solutions.count loop
						if attached {STRING} solutions.i_th (i).language as l then
							if attached {STRING} solutions.i_th (i).code as co then
								create solution.make (task.id, l, co)
								store.save_solution (solution)
							end
						end
						i := i + 1
					end
				end

				progress_callback := "Imported: " + task_name + " (" + solutions.count.out + " solutions)"
			else
				last_error := "No content returned for: " + task_name
			end
		end

	import_tasks_with_solutions (limit: INTEGER)
			-- Import first `limit' tasks with full solutions.
		require
			positive_limit: limit > 0
		local
			tasks: ARRAYED_LIST [ROSETTA_TASK]
			count, i: INTEGER
		do
			last_error.wipe_out

			-- First get task list if not already imported
			if store.task_count = 0 then
				import_all_tasks
			end

			if not has_error then
				tasks := store.all_tasks
				from i := 1 until i > tasks.count or count >= limit loop
					import_task (tasks.i_th (i).name)
					count := count + 1
					progress_callback := "Imported " + count.out + "/" + limit.out + " tasks"
					i := i + 1
				end
			end
		end

feature -- Query Operations

	find_task (name: STRING): detachable ROSETTA_TASK
			-- Find task by `name'.
		require
			name_not_empty: not name.is_empty
		do
			Result := store.find_task_by_name (name)
		end

	search (query: STRING): ARRAYED_LIST [ROSETTA_TASK]
			-- Search tasks by name or description.
		require
			query_not_empty: not query.is_empty
		do
			Result := store.search_tasks (query)
		end

	tasks_without_eiffel: ARRAYED_LIST [ROSETTA_TASK]
			-- Tasks that don't have Eiffel solutions.
		do
			Result := store.tasks_without_eiffel
		end

	tasks_with_eiffel: ARRAYED_LIST [ROSETTA_TASK]
			-- Tasks that have Eiffel solutions.
		do
			Result := store.tasks_with_eiffel
		end

	solutions_for (task_name: STRING): ARRAYED_LIST [ROSETTA_SOLUTION]
			-- All solutions for task with `task_name'.
		require
			name_not_empty: not task_name.is_empty
		do
			create Result.make (10)
			if attached store.find_task_by_name (task_name) as task then
				Result := store.solutions_for_task (task.id)
			end
		end

	eiffel_solution_for (task_name: STRING): detachable ROSETTA_SOLUTION
			-- Eiffel solution for task with `task_name', if any.
		require
			name_not_empty: not task_name.is_empty
		do
			if attached store.find_task_by_name (task_name) as task then
				Result := store.eiffel_solution_for_task (task.id)
			end
		end

feature -- Comparison

	compare_solutions (task_name: STRING; languages: ARRAY [STRING]): STRING
			-- Side-by-side comparison of solutions in `languages'.
		require
			name_not_empty: not task_name.is_empty
			languages_not_empty: not languages.is_empty
		local
			solutions: ARRAYED_LIST [ROSETTA_SOLUTION]
			i, j: INTEGER
		do
			create Result.make (2000)
			Result.append ("Task: " + task_name + "%N")
			Result.append (create {STRING}.make_filled ('=', 50) + "%N%N")

			solutions := solutions_for (task_name)

			from i := languages.lower until i > languages.upper loop
				Result.append ("=== " + languages [i] + " ===%N")
				from j := 1 until j > solutions.count loop
					if solutions.i_th (j).language.same_string (languages [i]) then
						Result.append (solutions.i_th (j).code)
						Result.append ("%N%N")
					end
					j := j + 1
				end
				i := i + 1
			end
		end

feature -- Export

	export_tasks_csv (path: STRING)
			-- Export all tasks to CSV at `path'.
		require
			path_not_empty: not path.is_empty
		local
			file: PLAIN_TEXT_FILE
			tasks: ARRAYED_LIST [ROSETTA_TASK]
			i: INTEGER
			task: ROSETTA_TASK
		do
			last_error.wipe_out
			tasks := store.all_tasks

			create file.make_create_read_write (path)
			file.put_string ("id,name,has_eiffel,validated,languages%N")

			from i := 1 until i > tasks.count loop
				task := tasks.i_th (i)
				file.put_integer (task.id)
				file.put_character (',')
				file.put_string ("%"" + task.name + "%"")
				file.put_character (',')
				file.put_boolean (task.has_eiffel)
				file.put_character (',')
				file.put_boolean (task.is_eiffel_validated)
				file.put_character (',')
				file.put_integer (task.language_count)
				file.put_new_line
				i := i + 1
			end

			file.close
			progress_callback := "Exported " + tasks.count.out + " tasks to " + path
		end

feature {NONE} -- Implementation

	store: TASK_STORE
			-- Database storage

	client: ROSETTA_CLIENT
			-- API client

	wiki_parser: WIKI_PARSER
			-- Wiki markup parser

invariant
	store_attached: store /= Void
	client_attached: client /= Void

end
