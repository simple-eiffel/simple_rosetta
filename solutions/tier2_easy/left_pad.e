note
	description: "[
		Rosetta Code: Left pad
		https://rosettacode.org/wiki/Left_pad

		Pad a string on the left to a specified length.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Left_pad"
	tier: "2"

class
	LEFT_PAD

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate left padding.
		do
			print ("Left Pad%N")
			print ("========%N%N")

			demo ("hello", 10, ' ')
			demo ("world", 10, '-')
			demo ("42", 5, '0')
			demo ("long string", 5, '*')
		end

feature -- Demo

	demo (a_str: STRING; a_width: INTEGER; a_char: CHARACTER)
			-- Show padding.
		do
			print ("left_pad('" + a_str + "', " + a_width.out + ", '" + a_char.out + "') = '")
			print (left_pad (a_str, a_width, a_char) + "'%N")
		end

feature -- Operations

	left_pad (a_str: STRING; a_width: INTEGER; a_char: CHARACTER): STRING
			-- Pad string on left to width with character.
		require
			str_exists: a_str /= Void
			positive_width: a_width > 0
		local
			l_padding: INTEGER
		do
			l_padding := a_width - a_str.count
			if l_padding > 0 then
				create Result.make_filled (a_char, l_padding)
				Result.append (a_str)
			else
				Result := a_str.twin
			end
		ensure
			result_exists: Result /= Void
			min_width: Result.count >= a_width.min (a_str.count)
		end

	right_pad (a_str: STRING; a_width: INTEGER; a_char: CHARACTER): STRING
			-- Pad string on right to width with character.
		require
			str_exists: a_str /= Void
			positive_width: a_width > 0
		local
			l_padding: INTEGER
		do
			Result := a_str.twin
			l_padding := a_width - a_str.count
			if l_padding > 0 then
				Result.append (create {STRING}.make_filled (a_char, l_padding))
			end
		ensure
			result_exists: Result /= Void
		end

end