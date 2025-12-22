note
	description: "[
		Rosetta Code: Align columns
		https://rosettacode.org/wiki/Align_columns

		Align text columns in a table format.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Align_columns"
	tier: "2"

class
	ALIGN_COLUMNS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate column alignment.
		local
			l_data: ARRAY [STRING]
		do
			print ("Align Columns%N")
			print ("=============%N%N")

			l_data := <<"Given$a$text$file$of$many$lines",
			            "where$fields$within$a$line$",
			            "are$delineated$by$a$single$dollar$character",
			            "write$a$program">>

			print ("Left aligned:%N")
			print (align_left (l_data, '$'))
			print ("%NRight aligned:%N")
			print (align_right (l_data, '$'))
			print ("%NCenter aligned:%N")
			print (align_center (l_data, '$'))
		end

feature -- Alignment

	align_left (a_lines: ARRAY [STRING]; a_delim: CHARACTER): STRING
			-- Align columns left.
		require
			lines_exist: a_lines /= Void
		local
			l_widths: ARRAY [INTEGER]
			l_cells: ARRAYED_LIST [ARRAYED_LIST [STRING]]
			l_row: ARRAYED_LIST [STRING]
			l_i, l_j: INTEGER
		do
			l_cells := parse_cells (a_lines, a_delim)
			l_widths := column_widths (l_cells)
			create Result.make (1000)

			across l_cells as l_r loop
				l_row := l_r
				from l_j := 1 until l_j > l_row.count loop
					if l_j > 1 then
						Result.append (" ")
					end
					Result.append (pad_right (l_row [l_j], l_widths [l_j]))
					l_j := l_j + 1
				end
				Result.append_character ('%N')
			end
		end

	align_right (a_lines: ARRAY [STRING]; a_delim: CHARACTER): STRING
			-- Align columns right.
		require
			lines_exist: a_lines /= Void
		local
			l_widths: ARRAY [INTEGER]
			l_cells: ARRAYED_LIST [ARRAYED_LIST [STRING]]
			l_row: ARRAYED_LIST [STRING]
			l_j: INTEGER
		do
			l_cells := parse_cells (a_lines, a_delim)
			l_widths := column_widths (l_cells)
			create Result.make (1000)

			across l_cells as l_r loop
				l_row := l_r
				from l_j := 1 until l_j > l_row.count loop
					if l_j > 1 then
						Result.append (" ")
					end
					Result.append (pad_left (l_row [l_j], l_widths [l_j]))
					l_j := l_j + 1
				end
				Result.append_character ('%N')
			end
		end

	align_center (a_lines: ARRAY [STRING]; a_delim: CHARACTER): STRING
			-- Align columns center.
		require
			lines_exist: a_lines /= Void
		local
			l_widths: ARRAY [INTEGER]
			l_cells: ARRAYED_LIST [ARRAYED_LIST [STRING]]
			l_row: ARRAYED_LIST [STRING]
			l_j: INTEGER
		do
			l_cells := parse_cells (a_lines, a_delim)
			l_widths := column_widths (l_cells)
			create Result.make (1000)

			across l_cells as l_r loop
				l_row := l_r
				from l_j := 1 until l_j > l_row.count loop
					if l_j > 1 then
						Result.append (" ")
					end
					Result.append (pad_center (l_row [l_j], l_widths [l_j]))
					l_j := l_j + 1
				end
				Result.append_character ('%N')
			end
		end

feature {NONE} -- Helpers

	parse_cells (a_lines: ARRAY [STRING]; a_delim: CHARACTER): ARRAYED_LIST [ARRAYED_LIST [STRING]]
		local
			l_parts: LIST [STRING]
			l_row: ARRAYED_LIST [STRING]
		do
			create Result.make (a_lines.count)
			across a_lines as l_line loop
				l_parts := l_line.split (a_delim)
				create l_row.make (l_parts.count)
				across l_parts as l_p loop
					l_row.extend (l_p)
				end
				Result.extend (l_row)
			end
		end

	column_widths (a_cells: ARRAYED_LIST [ARRAYED_LIST [STRING]]): ARRAY [INTEGER]
		local
			l_max_cols, l_j: INTEGER
		do
			across a_cells as l_row loop
				l_max_cols := l_max_cols.max (l_row.count)
			end
			create Result.make_filled (0, 1, l_max_cols)
			across a_cells as l_row loop
				from l_j := 1 until l_j > l_row.count loop
					Result [l_j] := Result [l_j].max (l_row [l_j].count)
					l_j := l_j + 1
				end
			end
		end

	pad_left (a_str: STRING; a_width: INTEGER): STRING
		do
			create Result.make_filled (' ', (a_width - a_str.count).max (0))
			Result.append (a_str)
		end

	pad_right (a_str: STRING; a_width: INTEGER): STRING
		do
			Result := a_str.twin
			Result.append (create {STRING}.make_filled (' ', (a_width - a_str.count).max (0)))
		end

	pad_center (a_str: STRING; a_width: INTEGER): STRING
		local
			l_left, l_right: INTEGER
		do
			l_left := (a_width - a_str.count) // 2
			l_right := a_width - a_str.count - l_left
			create Result.make_filled (' ', l_left.max (0))
			Result.append (a_str)
			Result.append (create {STRING}.make_filled (' ', l_right.max (0)))
		end

end