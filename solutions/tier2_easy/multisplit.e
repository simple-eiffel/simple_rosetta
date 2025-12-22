note
	description: "[
		Rosetta Code: Multisplit
		https://rosettacode.org/wiki/Multisplit

		Split a string using multiple delimiters.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Multisplit"
	tier: "2"

class
	MULTISPLIT

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate multisplit.
		local
			l_delims: ARRAY [STRING]
			l_parts: ARRAYED_LIST [STRING]
		do
			l_delims := <<"==", "!=", "=">>

			print ("String: %"a]!=|[b==|==c=|=d%"%N")
			print ("Delimiters: ==, !=, =%N%N")

			l_parts := multisplit ("a!=b=c==d", l_delims)
			print ("Split parts:%N")
			across l_parts as l_p loop
				print ("  [" + l_p + "]%N")
			end
		end

feature -- Split

	multisplit (a_str: STRING; a_delims: ARRAY [STRING]): ARRAYED_LIST [STRING]
			-- Split `a_str' using any of `a_delims' as separators.
		require
			str_exists: a_str /= Void
			delims_exist: a_delims /= Void
		local
			l_pos, l_start: INTEGER
			l_found: BOOLEAN
			l_delim: STRING
			l_match_pos, l_match_len: INTEGER
		do
			create Result.make (10)
			l_start := 1

			from l_pos := 1 until l_pos > a_str.count loop
				l_found := False
				l_match_len := 0

				-- Check each delimiter at current position
				across a_delims as l_d loop
					if l_pos + l_d.count - 1 <= a_str.count then
						if a_str.substring (l_pos, l_pos + l_d.count - 1).same_string (l_d) then
							-- Take longest match
							if l_d.count > l_match_len then
								l_found := True
								l_match_len := l_d.count
							end
						end
					end
				end

				if l_found then
					-- Add part before delimiter
					if l_pos > l_start then
						Result.extend (a_str.substring (l_start, l_pos - 1))
					else
						Result.extend ("")
					end
					l_start := l_pos + l_match_len
					l_pos := l_start
				else
					l_pos := l_pos + 1
				end
			end

			-- Add final part
			if l_start <= a_str.count then
				Result.extend (a_str.substring (l_start, a_str.count))
			end
		ensure
			result_exists: Result /= Void
		end

end
