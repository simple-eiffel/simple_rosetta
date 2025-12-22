note
	description: "[
		Rosetta Code: Natural sorting
		https://rosettacode.org/wiki/Natural_sorting

		Sort strings with embedded numbers naturally.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Natural_sorting"
	tier: "2"

class
	NATURAL_SORTING

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate natural sorting.
		local
			l_strings: ARRAYED_LIST [STRING]
		do
			print ("Natural Sorting%N")
			print ("===============%N%N")

			create l_strings.make_from_array (<<
				"file10.txt", "file2.txt", "file1.txt", "file20.txt",
				"img12.png", "img1.png", "img2.png">>)

			print ("Original:%N")
			across l_strings as l_s loop
				print ("  " + l_s + "%N")
			end

			natural_sort (l_strings)

			print ("%NNaturally sorted:%N")
			across l_strings as l_s loop
				print ("  " + l_s + "%N")
			end
		end

feature -- Sorting

	natural_sort (a_list: ARRAYED_LIST [STRING])
			-- Sort list using natural order.
		require
			list_exists: a_list /= Void
		local
			l_i, l_j: INTEGER
			l_temp: STRING
		do
			from l_i := 1 until l_i >= a_list.count loop
				from l_j := l_i + 1 until l_j > a_list.count loop
					if natural_compare (a_list [l_j], a_list [l_i]) < 0 then
						l_temp := a_list [l_i]
						a_list [l_i] := a_list [l_j]
						a_list [l_j] := l_temp
					end
					l_j := l_j + 1
				end
				l_i := l_i + 1
			end
		end

	natural_compare (a_s1, a_s2: STRING): INTEGER
			-- Compare strings naturally (-1, 0, 1).
		require
			s1_exists: a_s1 /= Void
			s2_exists: a_s2 /= Void
		local
			l_i1, l_i2, l_n1, l_n2: INTEGER
			l_c1, l_c2: CHARACTER
			l_in_number: BOOLEAN
		do
			l_i1 := 1
			l_i2 := 1
			from until l_i1 > a_s1.count or l_i2 > a_s2.count or Result /= 0 loop
				l_c1 := a_s1 [l_i1]
				l_c2 := a_s2 [l_i2]
				if l_c1.is_digit and l_c2.is_digit then
					l_n1 := extract_number (a_s1, l_i1)
					l_n2 := extract_number (a_s2, l_i2)
					if l_n1 < l_n2 then
						Result := -1
					elseif l_n1 > l_n2 then
						Result := 1
					end
					from until l_i1 > a_s1.count or else not a_s1 [l_i1].is_digit loop
						l_i1 := l_i1 + 1
					end
					from until l_i2 > a_s2.count or else not a_s2 [l_i2].is_digit loop
						l_i2 := l_i2 + 1
					end
				else
					if l_c1 < l_c2 then
						Result := -1
					elseif l_c1 > l_c2 then
						Result := 1
					end
					l_i1 := l_i1 + 1
					l_i2 := l_i2 + 1
				end
			end
			if Result = 0 then
				if l_i1 <= a_s1.count then
					Result := 1
				elseif l_i2 <= a_s2.count then
					Result := -1
				end
			end
		ensure
			valid_result: Result >= -1 and Result <= 1
		end

feature {NONE} -- Helpers

	extract_number (a_str: STRING; a_start: INTEGER): INTEGER
			-- Extract number starting at position.
		local
			l_i: INTEGER
		do
			from l_i := a_start until l_i > a_str.count or else not a_str [l_i].is_digit loop
				Result := Result * 10 + (a_str [l_i].code - ('0').code)
				l_i := l_i + 1
			end
		end

end