note
	description: "[
		Rosetta Code: Longest common prefix
		https://rosettacode.org/wiki/Longest_common_prefix

		Find the longest common prefix of a list of strings.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Longest_common_prefix"
	tier: "3"

class
	LONGEST_COMMON_PREFIX

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate longest common prefix.
		do
			print ("Longest Common Prefix%N")
			print ("=====================%N%N")

			demo (<<"interspecies", "interstellar", "interstate">>)
			demo (<<"throne", "dungeon">>)
			demo (<<"throne", "throne">>)
			demo (<<"cheese">>)
			demo (<<"prefix", "precompute", "preview">>)
			demo (<<>>)
			demo (<<"", "abc">>)
		end

feature -- Demo

	demo (a_strings: ARRAY [STRING])
			-- Show prefix.
		do
			print ("Input: [")
			across a_strings as l_s loop
				if l_s.cursor_index > 1 then
					print (", ")
				end
				print ("%"" + l_s + "%"")
			end
			print ("]%N")
			print ("Prefix: %"" + longest_prefix (a_strings) + "%"%N%N")
		end

feature -- Operations

	longest_prefix (a_strings: ARRAY [STRING]): STRING
			-- Find longest common prefix.
		require
			strings_exist: a_strings /= Void
		local
			l_i: INTEGER
			l_match: BOOLEAN
			l_c: CHARACTER
		do
			create Result.make (100)
			if a_strings.count > 0 and then not a_strings [a_strings.lower].is_empty then
				from l_i := 1; l_match := True until l_i > a_strings [a_strings.lower].count or not l_match loop
					l_c := a_strings [a_strings.lower] [l_i]
					across a_strings as l_s loop
						if l_i > l_s.count or else l_s [l_i] /= l_c then
							l_match := False
						end
					end
					if l_match then
						Result.append_character (l_c)
					end
					l_i := l_i + 1
				end
			end
		ensure
			result_exists: Result /= Void
		end

end