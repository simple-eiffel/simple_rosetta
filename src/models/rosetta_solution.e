note
	description: "Solution to a Rosetta Code task in a specific language"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	ROSETTA_SOLUTION

create
	make

feature {NONE} -- Initialization

	make (a_task_id: INTEGER; a_language, a_code: STRING)
			-- Create solution for `a_task_id' in `a_language' with `a_code'.
		require
			valid_task_id: a_task_id >= 0
			language_not_empty: not a_language.is_empty
			code_not_empty: not a_code.is_empty
		do
			task_id := a_task_id
			language := a_language
			code := a_code
			source := "rosetta"
			create validation_log.make_empty
			create created_at.make_now
		ensure
			task_id_set: task_id = a_task_id
			language_set: language.same_string (a_language)
			code_set: code.same_string (a_code)
			source_is_rosetta: source.same_string ("rosetta")
			not_validated: not is_validated
		end

feature -- Access

	id: INTEGER
			-- Database ID (0 if not persisted)

	task_id: INTEGER
			-- Foreign key to ROSETTA_TASK

	language: STRING
			-- Programming language (e.g., "Python", "Java", "Eiffel")

	code: STRING
			-- Source code for the solution

	source: STRING
			-- Where this solution came from: "rosetta", "generated", "community"

	validation_log: STRING
			-- Log of validation attempts (compile errors, contract violations)

	created_at: SIMPLE_DATE_TIME
			-- When solution was imported/generated

feature -- Status

	is_validated: BOOLEAN
			-- Has this solution been validated?

	validation_level: INTEGER
			-- 0=not validated, 1=compiles, 2=contracts pass, 3=tests pass

feature -- Query

	is_eiffel: BOOLEAN
			-- Is this an Eiffel solution?
		do
			Result := language.same_string ("Eiffel")
		end

	is_generated: BOOLEAN
			-- Was this solution AI-generated?
		do
			Result := source.same_string ("generated")
		end

	is_from_rosetta: BOOLEAN
			-- Was this solution imported from Rosetta Code?
		do
			Result := source.same_string ("rosetta")
		end

	line_count: INTEGER
			-- Number of lines in code
		local
			i: INTEGER
		do
			Result := 1
			from i := 1 until i > code.count loop
				if code.item (i) = '%N' then
					Result := Result + 1
				end
				i := i + 1
			end
		end

feature -- Modification

	set_id (a_id: INTEGER)
			-- Set database `id'.
		require
			positive: a_id > 0
		do
			id := a_id
		ensure
			id_set: id = a_id
		end

	set_task_id (a_task_id: INTEGER)
			-- Set `task_id'.
		require
			positive: a_task_id > 0
		do
			task_id := a_task_id
		ensure
			task_id_set: task_id = a_task_id
		end

	set_source (a_source: STRING)
			-- Set `source'.
		require
			valid_source: a_source.same_string ("rosetta") or
			              a_source.same_string ("generated") or
			              a_source.same_string ("community")
		do
			source := a_source
		ensure
			source_set: source.same_string (a_source)
		end

	set_code (a_code: STRING)
			-- Set `code'.
		require
			code_not_empty: not a_code.is_empty
		do
			code := a_code
		ensure
			code_set: code.same_string (a_code)
		end

	set_validated (a_level: INTEGER; a_log: STRING)
			-- Mark as validated at `a_level' with `a_log'.
		require
			valid_level: a_level >= 0 and a_level <= 3
		do
			validation_level := a_level
			is_validated := a_level >= 2
			validation_log := a_log
		ensure
			level_set: validation_level = a_level
			validated_if_level_2_plus: is_validated = (a_level >= 2)
			log_set: validation_log.same_string (a_log)
		end

	append_to_log (a_message: STRING)
			-- Append `a_message' to validation log.
		do
			if not validation_log.is_empty then
				validation_log.append ("%N")
			end
			validation_log.append (a_message)
		end

feature -- Output

	to_string: STRING
			-- String representation
		do
			create Result.make (50)
			Result.append (language)
			Result.append (" solution (")
			Result.append_integer (line_count)
			Result.append (" lines, ")
			Result.append (source)
			if is_validated then
				Result.append (", validated L")
				Result.append_integer (validation_level)
			end
			Result.append (")")
		end

	code_preview (a_max_lines: INTEGER): STRING
			-- First `max_lines' of code
		require
			positive_max: a_max_lines > 0
		local
			lines: INTEGER
			i: INTEGER
		do
			create Result.make (200)
			from
				i := 1
				lines := 0
			until
				i > code.count or lines >= a_max_lines
			loop
				if code.item (i) = '%N' then
					lines := lines + 1
				end
				Result.append_character (code.item (i))
				i := i + 1
			end
			if lines >= a_max_lines and i <= code.count then
				Result.append ("%N... (")
				Result.append_integer (line_count - a_max_lines)
				Result.append (" more lines)")
			end
		end

invariant
	language_not_empty: not language.is_empty
	code_not_empty: not code.is_empty
	valid_source: source.same_string ("rosetta") or
	              source.same_string ("generated") or
	              source.same_string ("community")
	valid_validation_level: validation_level >= 0 and validation_level <= 3
	validated_implies_level_2_plus: is_validated implies validation_level >= 2

end
