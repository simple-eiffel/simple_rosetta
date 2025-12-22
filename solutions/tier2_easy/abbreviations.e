note
	description: "[
		Rosetta Code: Abbreviations, simple
		https://rosettacode.org/wiki/Abbreviations,_simple

		Match commands using minimum abbreviations.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Abbreviations,_simple"
	tier: "2"

class
	ABBREVIATIONS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate abbreviation matching.
		local
			l_commands: ARRAY [STRING]
		do
			print ("Abbreviations%N")
			print ("=============%N%N")

			l_commands := <<"add", "alter", "backup", "copy", "delete", "exit">>
			print ("Commands: ")
			across l_commands as l_c loop
				print (l_c + " ")
			end
			print ("%N%N")

			test (l_commands, "a")
			test (l_commands, "ad")
			test (l_commands, "add")
			test (l_commands, "al")
			test (l_commands, "alt")
			test (l_commands, "b")
			test (l_commands, "cop")
			test (l_commands, "d")
			test (l_commands, "del")
			test (l_commands, "e")
			test (l_commands, "ex")
			test (l_commands, "xyz")
		end

feature -- Testing

	test (a_commands: ARRAY [STRING]; a_abbrev: STRING)
			-- Test abbreviation match.
		local
			l_matches: ARRAYED_LIST [STRING]
		do
			l_matches := find_matches (a_commands, a_abbrev)
			print ("'" + a_abbrev + "' -> ")
			if l_matches.is_empty then
				print ("*no match*%N")
			elseif l_matches.count > 1 then
				print ("*ambiguous* (")
				across l_matches as l_m loop
					print (l_m)
					if not @l_m.is_last then
						print (", ")
					end
				end
				print (")%N")
			else
				print (l_matches.first + "%N")
			end
		end

feature -- Matching

	find_matches (a_commands: ARRAY [STRING]; a_abbrev: STRING): ARRAYED_LIST [STRING]
			-- Find all commands matching abbreviation.
		require
			commands_exist: a_commands /= Void
			abbrev_exists: a_abbrev /= Void
		do
			create Result.make (5)
			across a_commands as l_cmd loop
				if l_cmd.starts_with (a_abbrev) then
					Result.extend (l_cmd)
				end
			end
		ensure
			result_exists: Result /= Void
		end

	find_unique_match (a_commands: ARRAY [STRING]; a_abbrev: STRING): detachable STRING
			-- Find unique matching command, or Void if none/ambiguous.
		require
			commands_exist: a_commands /= Void
			abbrev_exists: a_abbrev /= Void
		local
			l_matches: ARRAYED_LIST [STRING]
		do
			l_matches := find_matches (a_commands, a_abbrev)
			if l_matches.count = 1 then
				Result := l_matches.first
			end
		end

end