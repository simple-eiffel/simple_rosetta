note
	description: "[
		Rosetta Code: Quote string
		https://rosettacode.org/wiki/Quote_string

		Add quotes around a string and escape internal quotes.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Quote_string"
	tier: "2"

class
	QUOTE_STRING

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string quoting.
		do
			print ("Quote String%N")
			print ("============%N%N")

			demo ("Hello")
			demo ("He said %"Hello%"")
			demo ("It's a test")
			demo ("")
		end

feature -- Demo

	demo (a_str: STRING)
			-- Show quoted result.
		do
			print ("Original: " + a_str + "%N")
			print ("Quoted:   " + quote (a_str) + "%N%N")
		end

feature -- Operations

	quote (a_str: STRING): STRING
			-- String surrounded by double quotes with escaping.
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
			l_c: CHARACTER
		do
			create Result.make (a_str.count + 2)
			Result.append_character ('"')
			from l_i := 1 until l_i > a_str.count loop
				l_c := a_str [l_i]
				if l_c = '"' then
					Result.append ("\%"")
				elseif l_c = '\' then
					Result.append ("\\")
				else
					Result.append_character (l_c)
				end
				l_i := l_i + 1
			end
			Result.append_character ('"')
		ensure
			result_exists: Result /= Void
			has_quotes: Result.count >= 2
		end

	unquote (a_str: STRING): STRING
			-- Remove quotes and unescape.
		require
			str_exists: a_str /= Void
			is_quoted: a_str.count >= 2 and then (a_str [1] = '"' and a_str [a_str.count] = '"')
		local
			l_i: INTEGER
			l_c: CHARACTER
			l_inner: STRING
		do
			l_inner := a_str.substring (2, a_str.count - 1)
			create Result.make (l_inner.count)
			from l_i := 1 until l_i > l_inner.count loop
				l_c := l_inner [l_i]
				if l_c = '\' and l_i < l_inner.count then
					l_i := l_i + 1
					Result.append_character (l_inner [l_i])
				else
					Result.append_character (l_c)
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
		end

end