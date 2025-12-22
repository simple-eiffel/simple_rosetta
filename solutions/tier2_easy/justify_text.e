note
	description: "[
		Rosetta Code: Justify text
		https://rosettacode.org/wiki/Justify_text

		Justify text to a specified width.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Justify_text"
	tier: "2"

class
	JUSTIFY_TEXT

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate text justification.
		local
			l_text: STRING
		do
			print ("Text Justification%N")
			print ("==================%N%N")

			l_text := "This is a sample text to demonstrate text justification. The goal is to adjust spacing so each line reaches the specified width."

			print ("Width: 40 characters%N")
			print (justify (l_text, 40) + "%N%N")

			print ("Width: 50 characters%N")
			print (justify (l_text, 50) + "%N")
		end

feature -- Justification

	justify (a_text: STRING; a_width: INTEGER): STRING
			-- Justify `a_text' to `a_width'.
		require
			text_exists: a_text /= Void
			positive_width: a_width > 0
		local
			l_words: LIST [STRING]
			l_line: ARRAYED_LIST [STRING]
			l_line_len: INTEGER
		do
			create Result.make (a_text.count * 2)
			create l_line.make (10)
			l_words := a_text.split (' ')
			l_line_len := 0

			across l_words as l_w loop
				if not l_w.is_empty then
					if l_line_len = 0 then
						l_line.extend (l_w)
						l_line_len := l_w.count
					elseif l_line_len + 1 + l_w.count <= a_width then
						l_line.extend (l_w)
						l_line_len := l_line_len + 1 + l_w.count
					else
						Result.append (justify_line (l_line, a_width))
						Result.append_character ('%N')
						l_line.wipe_out
						l_line.extend (l_w)
						l_line_len := l_w.count
					end
				end
			end

			-- Last line (left-aligned)
			if not l_line.is_empty then
				across l_line as l_lw loop
					if l_lw.cursor_index > 1 then
						Result.append_character (' ')
					end
					Result.append (l_lw)
				end
			end
		ensure
			result_exists: Result /= Void
		end

feature {NONE} -- Helpers

	justify_line (a_words: LIST [STRING]; a_width: INTEGER): STRING
			-- Create justified line from words.
		local
			l_text_len, l_gaps, l_extra, l_base, l_i: INTEGER
		do
			create Result.make (a_width)
			if a_words.count = 1 then
				Result.append (a_words.first)
			else
				l_text_len := 0
				across a_words as l_w loop
					l_text_len := l_text_len + l_w.count
				end
				l_gaps := a_words.count - 1
				l_extra := a_width - l_text_len
				l_base := l_extra // l_gaps
				l_extra := l_extra \ l_gaps

				l_i := 0
				across a_words as l_w loop
					Result.append (l_w)
					if l_i < l_gaps then
						Result.append (spaces (l_base + (if l_i < l_extra then 1 else 0 end)))
					end
					l_i := l_i + 1
				end
			end
		end

	spaces (a_n: INTEGER): STRING
			-- String of n spaces.
		do
			create Result.make_filled (' ', a_n.max (0))
		end

end