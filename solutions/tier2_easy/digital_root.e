note
	description: "[
		Rosetta Code: Digital root
		https://rosettacode.org/wiki/Digital_root
		
		Calculate the digital root of a number.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Digital_root"

class
	DIGITAL_ROOT

create
	make

feature {NONE} -- Initialization

	make
		do
			print ("Digital root of 627615: " + digital_root (627615).out + "%N")
			print ("Digital root of 39390: " + digital_root (39390).out + "%N")
			print ("Digital root of 588225: " + digital_root (588225).out + "%N")
			print ("Digital root of 9: " + digital_root (9).out + "%N")
		end

feature -- Computation

	digital_root (n: INTEGER): INTEGER
			-- Digital root of `n'.
		require
			non_negative: n >= 0
		local
			sum, num: INTEGER
		do
			num := n
			from until num < 10 loop
				sum := 0
				from until num = 0 loop
					sum := sum + num \ 10
					num := num // 10
				end
				num := sum
			end
			Result := num
		ensure
			single_digit: Result >= 0 and Result <= 9
		end

end
