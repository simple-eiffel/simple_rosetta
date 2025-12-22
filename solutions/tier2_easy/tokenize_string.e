note
	description: "[
		Rosetta Code: Tokenize a string
		https://rosettacode.org/wiki/Tokenize_a_string

		Split a string into tokens using a delimiter.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Tokenize_a_string"
	tier: "2"

class
	TOKENIZE_STRING

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate tokenization.
		local
			l_str: STRING
			l_tokens: LIST [STRING]
		do
			print ("Tokenize a String%N")
			print ("=================%N%N")

			l_str := "Hello,How,Are,You,Today"
			print ("String: '" + l_str + "'%N")
			print ("Delimiter: ','%N")
			print ("Tokens:%N")

			l_tokens := tokenize (l_str, ',')
			across l_tokens as l_t loop
				print ("  [" + @l_t.cursor_index.out + "] '" + l_t + "'%N")
			end

			print ("%NJoined with '.': '" + join (l_tokens, ".") + "'%N")
		end

feature -- Tokenization

	tokenize (a_str: STRING; a_delimiter: CHARACTER): LIST [STRING]
			-- Split `a_str' by `a_delimiter'.
		require
			str_exists: a_str /= Void
		do
			Result := a_str.split (a_delimiter)
		ensure
			result_exists: Result /= Void
		end

	tokenize_string (a_str: STRING; a_delimiter: STRING): ARRAYED_LIST [STRING]
			-- Split `a_str' by string delimiter.
		require
			str_exists: a_str /= Void
			delimiter_exists: a_delimiter /= Void
			delimiter_not_empty: not a_delimiter.is_empty
		local
			l_pos, l_start: INTEGER
		do
			create Result.make (10)
			l_start := 1
			from l_pos := a_str.substring_index (a_delimiter, 1) until l_pos = 0 loop
				Result.extend (a_str.substring (l_start, l_pos - 1))
				l_start := l_pos + a_delimiter.count
				l_pos := a_str.substring_index (a_delimiter, l_start)
			end
			Result.extend (a_str.substring (l_start, a_str.count))
		ensure
			result_exists: Result /= Void
		end

	join (a_tokens: LIST [STRING]; a_separator: STRING): STRING
			-- Join tokens with separator.
		require
			tokens_exist: a_tokens /= Void
			separator_exists: a_separator /= Void
		local
			l_first: BOOLEAN
		do
			create Result.make (100)
			l_first := True
			across a_tokens as l_t loop
				if not l_first then
					Result.append (a_separator)
				end
				Result.append (l_t)
				l_first := False
			end
		ensure
			result_exists: Result /= Void
		end

end