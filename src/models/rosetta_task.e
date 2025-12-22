note
	description: "Rosetta Code programming task data model"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	ROSETTA_TASK

create
	make,
	make_from_api

feature {NONE} -- Initialization

	make (a_name: STRING)
			-- Create task with `a_name'.
		require
			name_not_empty: not a_name.is_empty
		do
			name := a_name
			create description.make_empty
			create category.make_empty
			create languages.make (10)
			create created_at.make_now
		ensure
			name_set: name.same_string (a_name)
			not_has_eiffel: not has_eiffel
			not_validated: not is_eiffel_validated
		end

	make_from_api (a_name, a_pageid: STRING)
			-- Create task from MediaWiki API response.
		require
			name_not_empty: not a_name.is_empty
		do
			make (a_name)
			page_id := a_pageid
		ensure
			name_set: name.same_string (a_name)
			page_id_set: attached page_id as pid implies pid.same_string (a_pageid)
		end

feature -- Access

	id: INTEGER
			-- Database ID (0 if not persisted)

	name: STRING
			-- Task name (e.g., "Bubble sort", "Fibonacci sequence")

	description: STRING
			-- Task description from wiki

	category: STRING
			-- Primary category (e.g., "Sorting", "Mathematics")

	page_id: detachable STRING
			-- MediaWiki page ID

	languages: ARRAYED_LIST [STRING]
			-- Languages with solutions for this task

	created_at: SIMPLE_DATE_TIME
			-- When task was imported

feature -- Status

	has_eiffel: BOOLEAN
			-- Does this task have an Eiffel solution?

	is_eiffel_validated: BOOLEAN
			-- Has the Eiffel solution been validated (compiled + DBC)?

	eiffel_validation_level: INTEGER
			-- 0=none, 1=compiles, 2=contracts pass, 3=tests pass

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

	set_description (a_description: STRING)
			-- Set task `description'.
		do
			description := a_description
		ensure
			description_set: description.same_string (a_description)
		end

	set_category (a_category: STRING)
			-- Set task `category'.
		do
			category := a_category
		ensure
			category_set: category.same_string (a_category)
		end

	add_language (a_language: STRING)
			-- Add `a_language' to available languages.
		require
			language_not_empty: not a_language.is_empty
		do
			if not has_language (a_language) then
				languages.extend (a_language)
			end
			if a_language.same_string ("Eiffel") then
				has_eiffel := True
			end
		ensure
			has_language: has_language (a_language)
			eiffel_detected: a_language.same_string ("Eiffel") implies has_eiffel
		end

	set_eiffel_validated (a_level: INTEGER)
			-- Mark Eiffel solution as validated at `a_level'.
		require
			valid_level: a_level >= 0 and a_level <= 3
			has_eiffel: has_eiffel
		do
			is_eiffel_validated := a_level >= 2
			eiffel_validation_level := a_level
		ensure
			validated_if_level_2_plus: is_eiffel_validated = (a_level >= 2)
			level_set: eiffel_validation_level = a_level
		end

feature -- Query

	language_count: INTEGER
			-- Number of languages with solutions
		do
			Result := languages.count
		end

	has_language (a_language: STRING): BOOLEAN
			-- Does task have solution in `a_language'?
		local
			i: INTEGER
		do
			from i := 1 until i > languages.count or Result loop
				if languages.i_th (i).same_string (a_language) then
					Result := True
				end
				i := i + 1
			end
		end

	url: STRING
			-- Rosetta Code URL for this task
		do
			create Result.make_from_string ("https://rosettacode.org/wiki/")
			Result.append (name.twin)
			Result.replace_substring_all (" ", "_")
		end

feature -- Output

	to_string: STRING
			-- String representation
		do
			create Result.make (100)
			Result.append (name)
			Result.append (" [")
			Result.append_integer (language_count)
			Result.append (" languages")
			if has_eiffel then
				Result.append (", Eiffel")
				if is_eiffel_validated then
					Result.append (" (validated L")
					Result.append_integer (eiffel_validation_level)
					Result.append (")")
				end
			end
			Result.append ("]")
		end

invariant
	name_not_empty: not name.is_empty
	valid_validation_level: eiffel_validation_level >= 0 and eiffel_validation_level <= 3
	validated_implies_has_eiffel: is_eiffel_validated implies has_eiffel
	validated_implies_level_2_plus: is_eiffel_validated implies eiffel_validation_level >= 2

end
