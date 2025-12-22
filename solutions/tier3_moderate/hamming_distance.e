note
	description: "[
		Rosetta Code: Hamming distance
		https://rosettacode.org/wiki/Hamming_distance

		Calculate the Hamming distance between two strings of equal length.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Hamming_distance"
	tier: "3"

class
	HAMMING_DISTANCE

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate Hamming distance.
		do
			print ("Hamming Distance%N")
			print ("================%N%N")

			demo ("karolin", "kathrin")
			demo ("karolin", "kerstin")
			demo ("1011101", "1001001")
			demo ("2173896", "2233796")
			demo ("hello", "hello")
		end

feature -- Demo

	demo (a_s1, a_s2: STRING)
			-- Show distance.
		do
			print ("'" + a_s1 + "' vs '" + a_s2 + "': ")
			if a_s1.count = a_s2.count then
				print (distance (a_s1, a_s2).out + "%N")
			else
				print ("(different lengths)%N")
			end
		end

feature -- Calculation

	distance (a_s1, a_s2: STRING): INTEGER
			-- Hamming distance between two equal-length strings.
		require
			s1_exists: a_s1 /= Void
			s2_exists: a_s2 /= Void
			same_length: a_s1.count = a_s2.count
		local
			l_i: INTEGER
		do
			from l_i := 1 until l_i > a_s1.count loop
				if a_s1 [l_i] /= a_s2 [l_i] then
					Result := Result + 1
				end
				l_i := l_i + 1
			end
		ensure
			non_negative: Result >= 0
			max_bounded: Result <= a_s1.count
		end

	binary_distance (a_n1, a_n2: INTEGER): INTEGER
			-- Hamming distance between binary representations.
		local
			l_xor: INTEGER
		do
			l_xor := a_n1.bit_xor (a_n2)
			from until l_xor = 0 loop
				Result := Result + (l_xor.bit_and (1))
				l_xor := l_xor.bit_shift_right (1)
			end
		ensure
			non_negative: Result >= 0
		end

end