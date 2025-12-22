note
	description: "[
		Rosetta Code: Strip comments from a string
		https://rosettacode.org/wiki/Strip_comments_from_a_string

		Remove comments from a string based on comment markers.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Strip_comments_from_a_string"
	tier: "2"

class
	STRIP_COMMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate comment stripping.
		do
			print ("Strip Comments from a String%N")
			print ("============================%N%N")

			demo ("apples, pears # and bananas", "#")
			demo ("apples, pears ; and bananas", ";")
			demo ("  apples, pears # and bananas", "#")
			demo ("no comment here", "#")
			demo ("# whole line is comment", "#")
		end

feature -- Demo

	demo (a_str, a_marker: STRING)
			-- Show stripped result.
		do
			print ("Original: '" + a_str + "'%N")
			print ("Stripped: '" + strip_comment (a_str, a_marker) + "'%N%N")
		end

feature -- Operations

	strip_comment (a_str: STRING; a_marker: STRING): STRING
			-- Remove comment starting at `a_marker' and trailing whitespace.
		require
			str_exists: a_str /= Void
			marker_exists: a_marker /= Void
		local
			l_pos: INTEGER
		do
			Result := a_str.twin
			l_pos := Result.substring_index (a_marker, 1)
			if l_pos > 0 then
				Result := Result.substring (1, l_pos - 1)
			end
			Result.right_adjust
		ensure
			result_exists: Result /= Void
		end

	strip_multi_markers (a_str: STRING; a_markers: ARRAY [STRING]): STRING
			-- Remove comment starting at any marker.
		require
			str_exists: a_str /= Void
			markers_exist: a_markers /= Void
		local
			l_pos, l_min: INTEGER
		do
			Result := a_str.twin
			l_min := Result.count + 1
			across a_markers as l_m loop
				l_pos := Result.substring_index (l_m, 1)
				if l_pos > 0 and l_pos < l_min then
					l_min := l_pos
				end
			end
			if l_min <= Result.count then
				Result := Result.substring (1, l_min - 1)
			end
			Result.right_adjust
		ensure
			result_exists: Result /= Void
		end

end