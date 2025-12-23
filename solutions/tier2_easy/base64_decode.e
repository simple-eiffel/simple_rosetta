note
	description: "[
		Rosetta Code: Base64 decode data
		https://rosettacode.org/wiki/Base64_decode_data

		Decode Base64 encoded strings back to original data.
	]"

class
	BASE64_DECODE

feature -- Decoding

	decode (encoded: STRING): STRING
			-- Decode Base64 string to original
		require
			not_empty: not encoded.is_empty
		local
			i, j, value, padding: INTEGER
			chunk: ARRAY [INTEGER]
			c: CHARACTER
		do
			create Result.make (encoded.count * 3 // 4)
			create chunk.make_filled (0, 1, 4)

			-- Count padding
			if encoded.count >= 1 and then encoded [encoded.count] = '=' then
				padding := padding + 1
			end
			if encoded.count >= 2 and then encoded [encoded.count - 1] = '=' then
				padding := padding + 1
			end

			from i := 1 until i > encoded.count loop
				-- Collect 4 characters
				from j := 1 until j > 4 or i > encoded.count loop
					c := encoded [i]
					if c /= '=' then
						chunk [j] := char_to_value (c)
					else
						chunk [j] := 0
					end
					i := i + 1
					j := j + 1
				end

				if j > 4 then
					-- Decode to 3 bytes
					value := chunk [1].bit_shift_left (18) + chunk [2].bit_shift_left (12) + chunk [3].bit_shift_left (6) + chunk [4]
					Result.append_character ((value.bit_shift_right (16).bit_and (0xFF)).to_character_8)
					if i - 1 <= encoded.count - padding or padding < 2 then
						Result.append_character ((value.bit_shift_right (8).bit_and (0xFF)).to_character_8)
					end
					if i - 1 <= encoded.count - padding or padding < 1 then
						Result.append_character ((value.bit_and (0xFF)).to_character_8)
					end
				end
			end

			-- Remove padding-induced extra bytes
			if padding > 0 then
				Result := Result.substring (1, Result.count - padding + 1)
			end
		end

	encode (data: STRING): STRING
			-- Encode string to Base64
		require
			not_void: data /= Void
		local
			i, j, value, padding: INTEGER
			bytes: ARRAY [INTEGER]
		do
			create Result.make ((data.count * 4 + 2) // 3)
			create bytes.make_filled (0, 1, 3)

			from i := 1 until i > data.count loop
				-- Collect up to 3 bytes
				from j := 1 until j > 3 loop
					if i + j - 1 <= data.count then
						bytes [j] := data [i + j - 1].code
					else
						bytes [j] := 0
						padding := padding + 1
					end
					j := j + 1
				end

				-- Encode to 4 characters
				value := bytes [1].bit_shift_left (16) + bytes [2].bit_shift_left (8) + bytes [3]
				Result.append_character (value_to_char (value.bit_shift_right (18).bit_and (0x3F)))
				Result.append_character (value_to_char (value.bit_shift_right (12).bit_and (0x3F)))
				if padding < 2 then
					Result.append_character (value_to_char (value.bit_shift_right (6).bit_and (0x3F)))
				else
					Result.append_character ('=')
				end
				if padding < 1 then
					Result.append_character (value_to_char (value.bit_and (0x3F)))
				else
					Result.append_character ('=')
				end

				i := i + 3
				padding := 0
			end
		end

feature {NONE} -- Implementation

	Base64_chars: STRING = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

	char_to_value (c: CHARACTER): INTEGER
			-- Convert Base64 character to 6-bit value
		do
			if c >= 'A' and c <= 'Z' then
				Result := c.code - ('A').code
			elseif c >= 'a' and c <= 'z' then
				Result := c.code - ('a').code + 26
			elseif c >= '0' and c <= '9' then
				Result := c.code - ('0').code + 52
			elseif c = '+' then
				Result := 62
			elseif c = '/' then
				Result := 63
			end
		end

	value_to_char (v: INTEGER): CHARACTER
			-- Convert 6-bit value to Base64 character
		require
			valid_value: v >= 0 and v < 64
		do
			Result := Base64_chars [v + 1]
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			encoded, decoded: STRING
		do
			encoded := "VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCiAgICAtLSBQYXVsIFIuIEVocmxpY2g="

			print ("Base64 Decode Demo:%N%N")
			print ("Encoded:%N" + encoded + "%N%N")

			decoded := decode (encoded)
			print ("Decoded:%N" + decoded + "%N")

			print ("%NRoundtrip test:%N")
			print ("Original: Hello, World!%N")
			print ("Encoded:  " + encode ("Hello, World!") + "%N")
			print ("Decoded:  " + decode (encode ("Hello, World!")) + "%N")
		end

end
