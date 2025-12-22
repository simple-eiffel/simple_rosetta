note
	description: "[
		Rosetta Code: Squeeze blank lines
		https://rosettacode.org/wiki/Squeeze_blank_lines

		Replace multiple blank lines with single blank line.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Squeeze_blank_lines"
	tier: "2"

class
	SQUEEZE_BLANK_LINES

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate blank line squeezing.
		local
			l_text: STRING
		do
			print ("Squeeze Blank Lines%N")
			print ("===================%N%N")

			l_text := "Line 1%N%N%N%NLine 2%N%NLine 3%N%N%N%N%NLine 4"

			print ("Original (5 lines, multiple blanks):%N")
			print (l_text)
			print ("%N%N----%N%N")
			print ("Squeezed:%N")
			print (squeeze_blanks (l_text))
			print ("%N")
		end

feature -- Operations

	squeeze_blanks (a_text: STRING): STRING
			-- Replace multiple blank lines with single blank.
		require
			text_exists: a_text /= Void
		local
			l_lines: LIST [STRING]
			l_prev_blank: BOOLEAN
		do
			create Result.make (a_text.count)
			l_lines := a_text.split ('%N')
			l_prev_blank := False

			across l_lines as l_line loop
				if is_blank_line (l_line) then
					if not l_prev_blank then
						if not Result.is_empty then
							Result.append_character ('%N')
						end
						l_prev_blank := True
					end
				else
					if not Result.is_empty then
						Result.append_character ('%N')
					end
					Result.append (l_line)
					l_prev_blank := False
				end
			end
		ensure
			result_exists: Result /= Void
		end

	remove_all_blanks (a_text: STRING): STRING
			-- Remove all blank lines.
		require
			text_exists: a_text /= Void
		local
			l_lines: LIST [STRING]
		do
			create Result.make (a_text.count)
			l_lines := a_text.split ('%N')

			across l_lines as l_line loop
				if not is_blank_line (l_line) then
					if not Result.is_empty then
						Result.append_character ('%N')
					end
					Result.append (l_line)
				end
			end
		ensure
			result_exists: Result /= Void
		end

feature {NONE} -- Helpers

	is_blank_line (a_line: STRING): BOOLEAN
			-- Is line empty or only whitespace?
		local
			l_trimmed: STRING
		do
			l_trimmed := a_line.twin
			l_trimmed.left_adjust
			l_trimmed.right_adjust
			Result := l_trimmed.is_empty
		end

end