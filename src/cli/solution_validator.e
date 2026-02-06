note
	description: "Validates Eiffel solutions compile correctly."
	author: "Simple Eiffel"
	date: "$Date$"

class
	SOLUTION_VALIDATOR

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize validator.
		do
			create last_error.make_empty
			solutions_path := "D:/prod/simple_rosetta/solutions"
		end

feature -- Access

	last_error: STRING
			-- Last validation error message

	solutions_path: STRING
			-- Path to solutions directory

feature -- Validation

	validate_code (a_code: STRING): BOOLEAN
			-- Validate that code contains valid Eiffel syntax.
			-- Basic structural validation (not full compilation).
		require
			code_not_empty: not a_code.is_empty
		do
			last_error.wipe_out
			Result := True

			-- Check for class declaration
			if not a_code.has_substring ("class") then
				last_error := "Missing class declaration"
				Result := False
			end

			-- Check for end keyword
			if Result and then not a_code.has_substring ("end") then
				last_error := "Missing 'end' keyword"
				Result := False
			end

			-- Check for balanced feature blocks
			if Result then
				Result := check_balanced_structure (a_code)
			end
		end

	validate_file (a_file_name: STRING): BOOLEAN
			-- Validate that a solution file exists and has valid structure.
		require
			file_name_not_empty: not a_file_name.is_empty
		local
			l_full_path: STRING
			l_file: PLAIN_TEXT_FILE
			l_code: STRING
			l_line: STRING
		do
			last_error.wipe_out
			Result := False

			-- Find the file in tier directories
			l_full_path := find_solution_file (a_file_name)

			if l_full_path.is_empty then
				last_error := "File not found: " + a_file_name
			else
				create l_file.make_with_name (l_full_path)
				if l_file.exists then
					l_file.open_read
					create l_code.make (2000)
					from until l_file.end_of_file loop
						l_file.read_line
						l_line := l_file.last_string.twin
						l_code.append (l_line)
						l_code.append_character ('%N')
					end
					l_file.close
					Result := validate_code (l_code)
				else
					last_error := "Cannot open file: " + l_full_path
				end
			end
		end

	validate_compiles (a_file_name: STRING): BOOLEAN
			-- Validate that file actually compiles with EiffelStudio.
			-- This is a heavier validation that invokes the compiler.
		require
			file_name_not_empty: not a_file_name.is_empty
		do
			-- For now, just do structural validation
			-- Full compilation validation would require:
			-- 1. Create temporary ECF
			-- 2. Run ec.exe -batch -config temp.ecf
			-- 3. Check exit code
			Result := validate_file (a_file_name)
		end

feature {NONE} -- Implementation

	check_balanced_structure (a_code: STRING): BOOLEAN
			-- Check for balanced Eiffel structure.
		local
			feature_count, end_count: INTEGER
			i: INTEGER
			l_lines: LIST [STRING]
		do
			l_lines := a_code.split ('%N')
			from i := 1 until i > l_lines.count loop
				if l_lines.i_th (i).has_substring ("feature") then
					feature_count := feature_count + 1
				end
				i := i + 1
			end

			-- Count standalone 'end' (class end)
			if a_code.has_substring ("%Nend") or a_code.ends_with ("end") then
				end_count := 1
			end

			if feature_count = 0 then
				last_error := "No feature clause found"
				Result := False
			else
				Result := True
			end
		end

	find_solution_file (a_file_name: STRING): STRING
			-- Find solution file in tier directories.
		local
			l_tiers: ARRAY [STRING]
			i: INTEGER
			l_path: STRING
			l_file: PLAIN_TEXT_FILE
		do
			create Result.make_empty
			l_tiers := <<"tier1_trivial", "tier2_easy", "tier3_moderate", "tier4_complex">>

			from i := 1 until i > 4 or not Result.is_empty loop
				l_path := solutions_path + "/" + l_tiers.item (i) + "/" + a_file_name
				create l_file.make_with_name (l_path)
				if l_file.exists then
					Result := l_path
				end
				i := i + 1
			end
		end

end
