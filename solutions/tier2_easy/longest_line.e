note
	description: "[
		Rosetta Code: Longest string challenge
		https://rosettacode.org/wiki/Longest_string_challenge

		Find the longest string without using conditionals.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Longest_string_challenge"
	tier: "2"

class
	LONGEST_LINE

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate longest line finding.
		local
			l_lines: ARRAY [STRING]
		do
			print ("Longest Line%N")
			print ("============%N%N")

			l_lines := <<"short", "medium length", "the longest line here", "tiny">>

			print ("Lines:%N")
			across l_lines as l_line loop
				print ("  '" + l_line + "' (" + l_line.count.out + ")%N")
			end

			print ("%NLongest: '" + longest (l_lines) + "'%N")
		end

feature -- Operations

	longest (a_strings: ARRAY [STRING]): STRING
			-- Find longest string.
		require
			strings_exist: a_strings /= Void
			not_empty: a_strings.count > 0
		local
			l_max: INTEGER
		do
			Result := ""
			l_max := 0
			across a_strings as l_s loop
				if l_s.count > l_max then
					l_max := l_s.count
					Result := l_s
				end
			end
		ensure
			result_exists: Result /= Void
		end

	shortest (a_strings: ARRAY [STRING]): STRING
			-- Find shortest string.
		require
			strings_exist: a_strings /= Void
			not_empty: a_strings.count > 0
		local
			l_min: INTEGER
		do
			Result := a_strings [a_strings.lower]
			l_min := Result.count
			across a_strings as l_s loop
				if l_s.count < l_min then
					l_min := l_s.count
					Result := l_s
				end
			end
		ensure
			result_exists: Result /= Void
		end

	all_longest (a_strings: ARRAY [STRING]): ARRAYED_LIST [STRING]
			-- Find all strings with maximum length.
		require
			strings_exist: a_strings /= Void
		local
			l_max: INTEGER
		do
			create Result.make (5)
			across a_strings as l_s loop
				if l_s.count > l_max then
					l_max := l_s.count
					Result.wipe_out
					Result.extend (l_s)
				elseif l_s.count = l_max then
					Result.extend (l_s)
				end
			end
		ensure
			result_exists: Result /= Void
		end

end