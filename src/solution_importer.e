note
	description: "Imports Eiffel solutions from files into the database."
	author: "Simple Eiffel"
	date: "$Date$"

class
	SOLUTION_IMPORTER

create
	make

feature {NONE} -- Initialization

	make (a_store: SOLUTION_STORE; a_base_path: STRING)
			-- Initialize importer with store and base solutions path.
		require
			valid_store: a_store /= Void
			valid_path: a_base_path /= Void and then not a_base_path.is_empty
		do
			store := a_store
			base_path := a_base_path
			imported_count := 0
		ensure
			store_set: store = a_store
			path_set: base_path = a_base_path
		end

feature -- Access

	store: SOLUTION_STORE
			-- Database store.

	base_path: STRING
			-- Base path to solutions directory.

	imported_count: INTEGER
			-- Number of solutions imported.

feature -- Import

	import_all
			-- Import all solutions from all tiers.
		do
			imported_count := 0
			import_tier (1, "tier1_trivial")
			import_tier (2, "tier2_easy")
			import_tier (3, "tier3_moderate")
			import_tier (4, "tier4_complex")
		end

	import_tier (a_tier: INTEGER; a_subdir: STRING)
			-- Import all solutions from a tier subdirectory.
		require
			valid_tier: a_tier >= 1 and a_tier <= 4
			valid_subdir: not a_subdir.is_empty
		local
			dir: DIRECTORY
			dir_path: STRING
			files: ARRAYED_LIST [STRING]
			i: INTEGER
			f: STRING
		do
			dir_path := base_path + "/" + a_subdir
			create dir.make (dir_path)
			if dir.exists then
				files := eiffel_files (dir)
				from i := 1 until i > files.count loop
					f := files.i_th (i)
					if not f.same_string ("solutions_validator.e") then
						import_file (a_tier, dir_path + "/" + f)
					end
					i := i + 1
				end
			end
		end

	import_file (a_tier: INTEGER; a_file_path: STRING)
			-- Import a single solution file.
		require
			valid_tier: a_tier >= 1 and a_tier <= 4
			valid_path: a_file_path /= Void and then not a_file_path.is_empty
		local
			file: PLAIN_TEXT_FILE
			code, task, class_name, desc, url, file_name: STRING
			line: STRING
		do
			create file.make_with_name (a_file_path)
			if file.exists then
				file.open_read
				create code.make (2000)
				from until file.end_of_file loop
					file.read_line
					line := file.last_string.twin
					code.append (line)
					code.append_character ('%N')
				end
				file.close

				-- Extract metadata
				task := extract_rosetta_task (code)
				class_name := extract_class_name (code)
				desc := extract_description (code)
				url := "https://rosettacode.org/wiki/" + task
				file_name := file_name_from_path (a_file_path)

				if not task.is_empty and not class_name.is_empty then
					store.store_solution (task, a_tier, class_name, file_name, code, desc, url)
					imported_count := imported_count + 1
				end
			end
		end

feature {NONE} -- Extraction

	extract_rosetta_task (code: STRING): STRING
			-- Extract rosetta_task from note clause.
		local
			i, j: INTEGER
		do
			i := code.substring_index ("rosetta_task:", 1)
			if i > 0 then
				i := code.index_of ('"', i)
				if i > 0 then
					j := code.index_of ('"', i + 1)
					if j > i then
						Result := code.substring (i + 1, j - 1)
					else
						create Result.make_empty
					end
				else
					create Result.make_empty
				end
			else
				create Result.make_empty
			end
		end

	extract_class_name (code: STRING): STRING
			-- Extract class name from code.
		local
			i, j: INTEGER
		do
			i := code.substring_index ("%Nclass%N", 1)
			if i > 0 then
				i := i + 7  -- Skip past "class\n"
				-- Skip whitespace
				from until i > code.count or else not code.item (i).is_space loop
					i := i + 1
				end
				j := i
				from until j > code.count or else code.item (j).is_space or else code.item (j) = '%N' loop
					j := j + 1
				end
				if j > i then
					Result := code.substring (i, j - 1)
				else
					create Result.make_empty
				end
			else
				create Result.make_empty
			end
		end

	extract_description (code: STRING): STRING
			-- Extract description from note clause.
		local
			i, j: INTEGER
		do
			i := code.substring_index ("description:", 1)
			if i > 0 then
				i := code.index_of ('"', i)
				if i > 0 then
					-- Check for multi-line string
					if i + 1 <= code.count and then code.item (i + 1) = '[' then
						j := code.substring_index ("]%"", i)
						if j > i then
							Result := code.substring (i + 2, j - 1)
							Result.prune_all ('%T')
						else
							create Result.make_empty
						end
					else
						j := code.index_of ('"', i + 1)
						if j > i then
							Result := code.substring (i + 1, j - 1)
						else
							create Result.make_empty
						end
					end
				else
					create Result.make_empty
				end
			else
				create Result.make_empty
			end
		end

	file_name_from_path (a_path: STRING): STRING
			-- Extract file name from full path.
		local
			i: INTEGER
		do
			i := a_path.last_index_of ('/', a_path.count)
			if i = 0 then
				i := a_path.last_index_of ('\', a_path.count)
			end
			if i > 0 then
				Result := a_path.substring (i + 1, a_path.count)
			else
				Result := a_path.twin
			end
		end

feature {NONE} -- Directory scanning

	eiffel_files (dir: DIRECTORY): ARRAYED_LIST [STRING]
			-- List of .e files in directory.
		local
			entries: ARRAYED_LIST [PATH]
			entry_name: STRING
			i: INTEGER
		do
			create Result.make (20)
			dir.open_read
			entries := dir.entries
			from i := 1 until i > entries.count loop
				entry_name := entries.i_th (i).name.to_string_8
				if entry_name.count > 2 and then entry_name.ends_with (".e") then
					Result.extend (entry_name)
				end
				i := i + 1
			end
			dir.close
		end

end
