note
	description: "[
		Rosetta Code: Camel case and snake case
		https://rosettacode.org/wiki/Camel_case_and_snake_case

		Convert between camelCase and snake_case.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Camel_case_and_snake_case"

class
	CAMEL_SNAKE_CASE

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate case conversion.
		local
			test_strings: ARRAY [STRING]
			i: INTEGER
			s: STRING
		do
			test_strings := <<"snakeCase", "snake_case", "variable_10_case", "variable10Case", "ɛrgo rance spance", "hurry-Loss-Loss">>

			print ("Case Conversions:%N")
			print ("=================%N%N")

			from i := test_strings.lower until i > test_strings.upper loop
				s := test_strings [i]
				print ("Original:   %"" + s + "%"%N")
				print ("To snake:   %"" + to_snake_case (s) + "%"%N")
				print ("To camel:   %"" + to_camel_case (s) + "%"%N%N")
				i := i + 1
			end
		end

feature -- Conversion

	to_snake_case (s: STRING): STRING
			-- Convert s to snake_case.
		local
			i: INTEGER
			c: CHARACTER
		do
			create Result.make (s.count + 10)
			from i := 1 until i > s.count loop
				c := s.item (i)
				if c.is_upper then
					if i > 1 and then not s.item (i - 1).is_upper then
						Result.append_character ('_')
					end
					Result.append_character (c.as_lower)
				elseif c = '-' or c = ' ' then
					Result.append_character ('_')
				else
					Result.append_character (c)
				end
				i := i + 1
			end
		end

	to_camel_case (s: STRING): STRING
			-- Convert s to camelCase.
		local
			i: INTEGER
			c: CHARACTER
			capitalize_next: BOOLEAN
		do
			create Result.make (s.count)
			from i := 1 until i > s.count loop
				c := s.item (i)
				if c = '_' or c = '-' or c = ' ' then
					capitalize_next := True
				elseif capitalize_next then
					Result.append_character (c.as_upper)
					capitalize_next := False
				else
					Result.append_character (c.as_lower)
				end
				i := i + 1
			end
		end

end
