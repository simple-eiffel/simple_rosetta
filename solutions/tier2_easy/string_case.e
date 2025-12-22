note
	description: "[
		Rosetta Code: String case
		https://rosettacode.org/wiki/String_case

		Demonstrate string case conversion operations.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "String_case"
	tier: "2"

class
	STRING_CASE

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate case conversions.
		local
			l_str: STRING
		do
			print ("String Case Operations%N")
			print ("======================%N%N")

			l_str := "alphaBETA"
			print ("Original:    '" + l_str + "'%N")
			print ("Upper:       '" + to_upper (l_str) + "'%N")
			print ("Lower:       '" + to_lower (l_str) + "'%N")
			print ("Title:       '" + to_title ("hello world") + "'%N")
			print ("Capitalize:  '" + capitalize ("hello world") + "'%N")
			print ("Swap case:   '" + swap_case (l_str) + "'%N%N")

			l_str := "the QUICK brown FOX"
			print ("Original:    '" + l_str + "'%N")
			print ("Title case:  '" + to_title (l_str) + "'%N")
		end

feature -- Conversions

	to_upper (a_str: STRING): STRING
			-- Convert to uppercase.
		require
			str_exists: a_str /= Void
		do
			Result := a_str.twin
			Result.to_upper
		ensure
			result_exists: Result /= Void
		end

	to_lower (a_str: STRING): STRING
			-- Convert to lowercase.
		require
			str_exists: a_str /= Void
		do
			Result := a_str.twin
			Result.to_lower
		ensure
			result_exists: Result /= Void
		end

	to_title (a_str: STRING): STRING
			-- Convert to title case (capitalize first letter of each word).
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
			l_new_word: BOOLEAN
			l_c: CHARACTER
		do
			Result := a_str.as_lower
			l_new_word := True
			from l_i := 1 until l_i > Result.count loop
				l_c := Result [l_i]
				if l_c = ' ' or l_c = '%T' or l_c = '%N' then
					l_new_word := True
				elseif l_new_word then
					Result [l_i] := l_c.as_upper
					l_new_word := False
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
		end

	capitalize (a_str: STRING): STRING
			-- Capitalize first character only.
		require
			str_exists: a_str /= Void
		do
			Result := a_str.as_lower
			if not Result.is_empty then
				Result [1] := Result [1].as_upper
			end
		ensure
			result_exists: Result /= Void
		end

	swap_case (a_str: STRING): STRING
			-- Swap uppercase and lowercase.
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
			l_c: CHARACTER
		do
			create Result.make (a_str.count)
			from l_i := 1 until l_i > a_str.count loop
				l_c := a_str [l_i]
				if l_c >= 'A' and l_c <= 'Z' then
					Result.append_character (l_c.as_lower)
				elseif l_c >= 'a' and l_c <= 'z' then
					Result.append_character (l_c.as_upper)
				else
					Result.append_character (l_c)
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
		end

end
