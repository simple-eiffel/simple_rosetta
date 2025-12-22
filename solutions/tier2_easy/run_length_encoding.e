note
	description: "[
		Rosetta Code: Run-length encoding
		https://rosettacode.org/wiki/Run-length_encoding

		Compress repeated characters in a string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Run-length_encoding"
	tier: "2"

class
	RUN_LENGTH_ENCODING

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate run-length encoding.
		local
			l_text, l_encoded, l_decoded: STRING
		do
			print ("Run-Length Encoding%N")
			print ("===================%N%N")

			l_text := "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB"
			print ("Original: " + l_text + "%N")
			print ("Length: " + l_text.count.out + "%N%N")

			l_encoded := encode (l_text)
			print ("Encoded: " + l_encoded + "%N")
			print ("Length: " + l_encoded.count.out + "%N%N")

			l_decoded := decode (l_encoded)
			print ("Decoded: " + l_decoded + "%N")
			print ("Match: " + l_decoded.same_string (l_text).out + "%N")
		end

feature -- Encoding

	encode (a_str: STRING): STRING
			-- Run-length encode string.
		require
			str_exists: a_str /= Void
		local
			l_i, l_count: INTEGER
			l_current: CHARACTER
		do
			create Result.make (a_str.count)
			if not a_str.is_empty then
				l_current := a_str [1]
				l_count := 1
				from l_i := 2 until l_i > a_str.count loop
					if a_str [l_i] = l_current then
						l_count := l_count + 1
					else
						Result.append (l_count.out)
						Result.append_character (l_current)
						l_current := a_str [l_i]
						l_count := 1
					end
					l_i := l_i + 1
				end
				Result.append (l_count.out)
				Result.append_character (l_current)
			end
		ensure
			result_exists: Result /= Void
		end

	decode (a_encoded: STRING): STRING
			-- Decode run-length encoded string.
		require
			encoded_exists: a_encoded /= Void
		local
			l_i, l_count: INTEGER
			l_num: STRING
		do
			create Result.make (a_encoded.count * 2)
			create l_num.make (10)
			from l_i := 1 until l_i > a_encoded.count loop
				if a_encoded [l_i].is_digit then
					l_num.append_character (a_encoded [l_i])
				else
					l_count := l_num.to_integer
					Result.append (create {STRING}.make_filled (a_encoded [l_i], l_count))
					l_num.wipe_out
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
		end

end