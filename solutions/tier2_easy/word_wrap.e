note
	description: "[
		Rosetta Code: Word wrap
		https://rosettacode.org/wiki/Word_wrap

		Wrap text at a specified line width.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Word_wrap"
	tier: "2"

class
	WORD_WRAP

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate word wrapping.
		local
			l_text: STRING
		do
			print ("Word Wrap%N")
			print ("=========%N%N")

			l_text := "In olden times when wishing still helped one, there lived a king whose daughters were all beautiful, but the youngest was so beautiful that the sun itself, which has seen so much, was astonished whenever it shone in her face."

			print ("Original text:%N" + l_text + "%N%N")

			print ("Wrapped at 40 characters:%N")
			print (word_wrap (l_text, 40) + "%N%N")

			print ("Wrapped at 72 characters:%N")
			print (word_wrap (l_text, 72) + "%N")
		end

feature -- Wrapping

	word_wrap (a_text: STRING; a_width: INTEGER): STRING
			-- Wrap `a_text' at `a_width' characters.
		require
			text_exists: a_text /= Void
			positive_width: a_width > 0
		local
			l_words: LIST [STRING]
			l_line_len: INTEGER
		do
			create Result.make (a_text.count + a_text.count // a_width)
			l_words := a_text.split (' ')
			l_line_len := 0

			across l_words as l_w loop
				if not l_w.is_empty then
					if l_line_len = 0 then
						Result.append (l_w)
						l_line_len := l_w.count
					elseif l_line_len + 1 + l_w.count > a_width then
						Result.append_character ('%N')
						Result.append (l_w)
						l_line_len := l_w.count
					else
						Result.append_character (' ')
						Result.append (l_w)
						l_line_len := l_line_len + 1 + l_w.count
					end
				end
			end
		ensure
			result_exists: Result /= Void
		end

end