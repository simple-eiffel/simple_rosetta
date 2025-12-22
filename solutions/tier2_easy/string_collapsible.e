note
	description: "[
		Rosetta Code: Determine if a string is collapsible
		https://rosettacode.org/wiki/Determine_if_a_string_is_collapsible

		Collapse consecutive duplicate characters to single character.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Determine_if_a_string_is_collapsible"
	tier: "2"

class
	STRING_COLLAPSIBLE

create
	make

feature {NONE} -- Initialization

	make
			-- Test collapsing various strings.
		do
			test_string ("")
			test_string ("%"If I were two-faced, would I be wearing this one?%" --- Abraham Lincoln ")
			test_string ("..1telemarketing.telemarketer..")
			test_string ("AAA   BBB   CCC")
			test_string ("aaaaaaaaaa")
			test_string ("The better the 4-wheel drive, the further you'll be from help when ya get stuck!")
		end

feature -- Collapse

	test_string (a_str: STRING)
			-- Test and show collapsed string.
		local
			l_collapsed: STRING
		do
			l_collapsed := collapse (a_str)
			print ("Original (" + a_str.count.out + "): <<<" + a_str + ">>>%N")
			print ("Collapsed (" + l_collapsed.count.out + "): <<<" + l_collapsed + ">>>%N%N")
		end

	collapse (a_str: STRING): STRING
			-- Collapse consecutive duplicate characters.
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
			l_last: CHARACTER
		do
			create Result.make (a_str.count)
			from l_i := 1 until l_i > a_str.count loop
				if l_i = 1 or else a_str [l_i] /= l_last then
					Result.append_character (a_str [l_i])
					l_last := a_str [l_i]
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
			no_longer: Result.count <= a_str.count
		end

end
