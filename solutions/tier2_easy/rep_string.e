note
	description: "[
		Rosetta Code: Rep-string
		https://rosettacode.org/wiki/Rep-string

		Find the shortest repeating unit in a string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Rep-string"
	tier: "2"

class
	REP_STRING

create
	make

feature {NONE} -- Initialization

	make
			-- Test rep-string detection.
		do
			test_string ("1001110011")
			test_string ("1110111011")
			test_string ("0010010010")
			test_string ("1010101010")
			test_string ("1111111111")
			test_string ("0100101101")
			test_string ("0100100")
			test_string ("101")
			test_string ("11")
			test_string ("00")
			test_string ("1")
		end

feature -- Analysis

	test_string (a_str: STRING)
			-- Test and report rep-string.
		local
			l_rep: detachable STRING
		do
			l_rep := find_rep_string (a_str)
			print ("String: " + a_str + " -> ")
			if attached l_rep as r then
				print ("Rep: %"" + r + "%"%N")
			else
				print ("Not a rep-string%N")
			end
		end

	find_rep_string (a_str: STRING): detachable STRING
			-- Find shortest repeating unit, or Void if not a rep-string.
		require
			str_exists: a_str /= Void
			not_empty: not a_str.is_empty
		local
			l_len, l_i: INTEGER
			l_candidate: STRING
			l_found: BOOLEAN
		do
			-- Try each possible rep length from 1 to half the string
			from l_len := 1 until l_len > a_str.count // 2 or l_found loop
				if a_str.count \\ l_len = 0 then
					l_candidate := a_str.substring (1, l_len)
					if is_rep_of (a_str, l_candidate) then
						Result := l_candidate
						l_found := True
					end
				end
				l_len := l_len + 1
			end
		end

	is_rep_of (a_str, a_unit: STRING): BOOLEAN
			-- Is `a_str' made entirely of repetitions of `a_unit'?
		require
			str_exists: a_str /= Void
			unit_exists: a_unit /= Void
		local
			l_i: INTEGER
		do
			Result := True
			from l_i := 1 until l_i > a_str.count or not Result loop
				if a_str [l_i] /= a_unit [((l_i - 1) \\ a_unit.count) + 1] then
					Result := False
				end
				l_i := l_i + 1
			end
		end

end
