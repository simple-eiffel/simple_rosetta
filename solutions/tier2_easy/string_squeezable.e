note
	description: "[
		Rosetta Code: Determine if a string is squeezable
		https://rosettacode.org/wiki/Determine_if_a_string_is_squeezable

		Squeeze (collapse) only specific consecutive duplicate characters.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Determine_if_a_string_is_squeezable"
	tier: "2"

class
	STRING_SQUEEZABLE

create
	make

feature {NONE} -- Initialization

	make
			-- Test squeezing various strings with different characters.
		do
			test_squeeze ("", ' ')
			test_squeeze ("%"If I were two-faced, would I be wearing this one?%" --- Abraham Lincoln ", '-')
			test_squeeze ("..1111111111111111111111111111111111111111111111111111111111111117telemarketing.telemarketer..", '.')
			test_squeeze ("The better the 4-wheel drive, the further you'll be from help when ya get stuck!", 'e')
			test_squeeze ("headmistressship", 's')
		end

feature -- Squeeze

	test_squeeze (a_str: STRING; a_char: CHARACTER)
			-- Test squeezing a specific character.
		local
			l_squeezed: STRING
		do
			l_squeezed := squeeze (a_str, a_char)
			print ("Squeeze '" + a_char.out + "':%N")
			print ("  Original (" + a_str.count.out + "): <<<" + a_str + ">>>%N")
			print ("  Squeezed (" + l_squeezed.count.out + "): <<<" + l_squeezed + ">>>%N%N")
		end

	squeeze (a_str: STRING; a_char: CHARACTER): STRING
			-- Squeeze only consecutive occurrences of `a_char'.
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
			l_last: CHARACTER
			l_in_squeeze: BOOLEAN
		do
			create Result.make (a_str.count)
			from l_i := 1 until l_i > a_str.count loop
				if a_str [l_i] = a_char then
					if not l_in_squeeze then
						Result.append_character (a_str [l_i])
						l_in_squeeze := True
					end
				else
					Result.append_character (a_str [l_i])
					l_in_squeeze := False
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
		end

end
