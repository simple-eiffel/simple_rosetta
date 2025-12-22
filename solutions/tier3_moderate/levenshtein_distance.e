note
	description: "[
		Rosetta Code: Levenshtein distance
		https://rosettacode.org/wiki/Levenshtein_distance

		Calculate the edit distance between two strings.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Levenshtein_distance"
	tier: "3"

class
	LEVENSHTEIN_DISTANCE

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate Levenshtein distance.
		do
			print ("Levenshtein Distance%N")
			print ("====================%N%N")

			demo ("kitten", "sitting")
			demo ("rosettacode", "raisethysword")
			demo ("hello", "hello")
			demo ("", "abc")
			demo ("abc", "")
			demo ("saturday", "sunday")
		end

feature -- Demo

	demo (a_s1, a_s2: STRING)
			-- Show distance.
		do
			print ("'" + a_s1 + "' -> '" + a_s2 + "': " + distance (a_s1, a_s2).out + "%N")
		end

feature -- Calculation

	distance (a_s1, a_s2: STRING): INTEGER
			-- Levenshtein distance between two strings.
		require
			s1_exists: a_s1 /= Void
			s2_exists: a_s2 /= Void
		local
			l_matrix: ARRAY2 [INTEGER]
			l_i, l_j, l_cost: INTEGER
		do
			if a_s1.is_empty then
				Result := a_s2.count
			elseif a_s2.is_empty then
				Result := a_s1.count
			else
				create l_matrix.make_filled (0, a_s1.count + 1, a_s2.count + 1)

				-- Initialize first column
				from l_i := 0 until l_i > a_s1.count loop
					l_matrix [l_i + 1, 1] := l_i
					l_i := l_i + 1
				end

				-- Initialize first row
				from l_j := 0 until l_j > a_s2.count loop
					l_matrix [1, l_j + 1] := l_j
					l_j := l_j + 1
				end

				-- Fill in the rest
				from l_i := 1 until l_i > a_s1.count loop
					from l_j := 1 until l_j > a_s2.count loop
						if a_s1 [l_i] = a_s2 [l_j] then
							l_cost := 0
						else
							l_cost := 1
						end
						l_matrix [l_i + 1, l_j + 1] := minimum3 (
							l_matrix [l_i, l_j + 1] + 1,
							l_matrix [l_i + 1, l_j] + 1,
							l_matrix [l_i, l_j] + l_cost
						)
						l_j := l_j + 1
					end
					l_i := l_i + 1
				end

				Result := l_matrix [a_s1.count + 1, a_s2.count + 1]
			end
		ensure
			non_negative: Result >= 0
		end

feature {NONE} -- Helpers

	minimum3 (a, b, c: INTEGER): INTEGER
			-- Minimum of three integers.
		do
			Result := a.min (b).min (c)
		end

end