note
	description: "[
		Rosetta Code: Text between markers
		https://rosettacode.org/wiki/Text_between_markers

		Extract text between two markers in a string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Text_between_markers"
	tier: "2"

class
	TEXT_BETWEEN_MARKERS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate text extraction.
		do
			print ("Text Between Markers%N")
			print ("====================%N%N")

			demo ("Hello <World> there", "<", ">")
			demo ("The (quick) brown fox", "(", ")")
			demo ("Start [middle] end", "[", "]")
			demo ("No markers here", "[", "]")
			demo ("<tag>content</tag>", "<tag>", "</tag>")
		end

feature -- Demo

	demo (a_text, a_start, a_end: STRING)
			-- Show extraction.
		local
			l_result: detachable STRING
		do
			print ("Text: '" + a_text + "'%N")
			print ("Between '" + a_start + "' and '" + a_end + "': ")
			l_result := text_between (a_text, a_start, a_end)
			if attached l_result as l_r then
				print ("'" + l_r + "'%N")
			else
				print ("(not found)%N")
			end
			print ("%N")
		end

feature -- Extraction

	text_between (a_text, a_start, a_end: STRING): detachable STRING
			-- Text between start and end markers, or Void if not found.
		require
			text_exists: a_text /= Void
			start_exists: a_start /= Void
			end_exists: a_end /= Void
		local
			l_start_pos, l_end_pos: INTEGER
		do
			l_start_pos := a_text.substring_index (a_start, 1)
			if l_start_pos > 0 then
				l_start_pos := l_start_pos + a_start.count
				l_end_pos := a_text.substring_index (a_end, l_start_pos)
				if l_end_pos > 0 then
					Result := a_text.substring (l_start_pos, l_end_pos - 1)
				end
			end
		end

	all_between (a_text, a_start, a_end: STRING): ARRAYED_LIST [STRING]
			-- All occurrences of text between markers.
		require
			text_exists: a_text /= Void
			start_exists: a_start /= Void
			end_exists: a_end /= Void
		local
			l_pos, l_start_pos, l_end_pos: INTEGER
		do
			create Result.make (5)
			l_pos := 1
			from until l_pos > a_text.count loop
				l_start_pos := a_text.substring_index (a_start, l_pos)
				if l_start_pos > 0 then
					l_start_pos := l_start_pos + a_start.count
					l_end_pos := a_text.substring_index (a_end, l_start_pos)
					if l_end_pos > 0 then
						Result.extend (a_text.substring (l_start_pos, l_end_pos - 1))
						l_pos := l_end_pos + a_end.count
					else
						l_pos := a_text.count + 1
					end
				else
					l_pos := a_text.count + 1
				end
			end
		ensure
			result_exists: Result /= Void
		end

end