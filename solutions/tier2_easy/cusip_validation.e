note
	description: "[
		Rosetta Code: CUSIP
		https://rosettacode.org/wiki/CUSIP

		Validate Committee on Uniform Securities Identification Procedures codes.
		9-character alphanumeric identifier for US and Canadian securities.
	]"

class
	CUSIP_VALIDATION

feature -- Validation

	is_valid (cusip: STRING): BOOLEAN
			-- Is CUSIP valid?
		require
			not_void: cusip /= Void
		local
			i, v, sum: INTEGER
			c: CHARACTER
		do
			if cusip.count = 9 then
				sum := 0
				from i := 1 until i > 8 loop
					c := cusip [i].as_upper
					if c >= '0' and c <= '9' then
						v := c.code - ('0').code
					elseif c >= 'A' and c <= 'Z' then
						v := c.code - ('A').code + 10
					elseif c = '*' then
						v := 36
					elseif c = '@' then
						v := 37
					elseif c = '#' then
						v := 38
					else
						v := -1  -- Invalid character
					end

					if v >= 0 then
						if i \\ 2 = 0 then
							v := v * 2
						end
						sum := sum + (v // 10) + (v \\ 10)
					else
						sum := -1000  -- Force invalid
					end
					i := i + 1
				end

				if sum >= 0 then
					Result := cusip [9] = ('0').code.to_character_8 + ((10 - (sum \\ 10)) \\ 10)
				end
			end
		end

	compute_check_digit (cusip_8: STRING): CHARACTER
			-- Compute check digit for 8-character CUSIP
		require
			correct_length: cusip_8.count = 8
		local
			i, v, sum: INTEGER
			c: CHARACTER
		do
			sum := 0
			from i := 1 until i > 8 loop
				c := cusip_8 [i].as_upper
				if c >= '0' and c <= '9' then
					v := c.code - ('0').code
				elseif c >= 'A' and c <= 'Z' then
					v := c.code - ('A').code + 10
				elseif c = '*' then
					v := 36
				elseif c = '@' then
					v := 37
				elseif c = '#' then
					v := 38
				else
					v := 0
				end

				if i \\ 2 = 0 then
					v := v * 2
				end
				sum := sum + (v // 10) + (v \\ 10)
				i := i + 1
			end
			Result := ('0').code.to_character_8 + ((10 - (sum \\ 10)) \\ 10)
		ensure
			is_digit: Result >= '0' and Result <= '9'
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			test_cusips: ARRAY [STRING]
		do
			test_cusips := <<"037833100", "17275R102", "38259P508", "594918104",
							  "68389X106", "68389X105">>

			print ("CUSIP Validation Demo:%N%N")

			across test_cusips as cusip loop
				print (cusip + ": ")
				if is_valid (cusip) then
					print ("Valid%N")
				else
					print ("INVALID%N")
				end
			end

			print ("%NCheck digit computation:%N")
			print ("037833100: check digit = " + compute_check_digit ("03783310").out + "%N")
		end

end
