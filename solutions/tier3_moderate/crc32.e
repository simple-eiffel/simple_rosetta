note
	description: "[
		Rosetta Code: CRC-32
		https://rosettacode.org/wiki/CRC-32

		Calculate CRC-32 checksum for data.
		Uses polynomial 0xEDB88320 (bit-reversed 0x04C11DB7).
	]"

class
	CRC32

feature -- Constants

	Polynomial: NATURAL_32 = 0xEDB88320
			-- CRC-32 polynomial (bit-reversed)

feature -- Computation

	crc32 (data: STRING): NATURAL_32
			-- CRC-32 checksum of `data`
		require
			not_void: data /= Void
		local
			i: INTEGER
			byte: NATURAL_32
		do
			ensure_table_initialized
			Result := 0xFFFFFFFF
			from i := 1 until i > data.count loop
				byte := data [i].code.to_natural_32
				Result := crc_table [((Result.bit_xor (byte)).bit_and (0xFF)).to_integer_32] .bit_xor (Result.bit_shift_right (8))
				i := i + 1
			end
			Result := Result.bit_xor (0xFFFFFFFF)
		end

	crc32_bytes (data: ARRAY [NATURAL_8]): NATURAL_32
			-- CRC-32 checksum of byte array
		require
			not_void: data /= Void
		local
			i: INTEGER
			byte: NATURAL_32
		do
			ensure_table_initialized
			Result := 0xFFFFFFFF
			from i := data.lower until i > data.upper loop
				byte := data [i].to_natural_32
				Result := crc_table [((Result.bit_xor (byte)).bit_and (0xFF)).to_integer_32] .bit_xor (Result.bit_shift_right (8))
				i := i + 1
			end
			Result := Result.bit_xor (0xFFFFFFFF)
		end

feature -- Output

	crc32_hex (data: STRING): STRING
			-- CRC-32 as 8-character hex string
		local
			crc: NATURAL_32
		do
			crc := crc32 (data)
			Result := crc.to_hex_string
			-- Ensure 8 characters
			from until Result.count >= 8 loop
				Result.prepend ("0")
			end
		end

feature {NONE} -- Implementation

	crc_table: ARRAY [NATURAL_32]
			-- Precomputed CRC table
		once
			create Result.make_filled (0, 0, 255)
		end

	table_initialized: BOOLEAN
			-- Has table been initialized?

	ensure_table_initialized
			-- Initialize CRC table if needed
		local
			i, j: INTEGER
			crc: NATURAL_32
		do
			if not table_initialized then
				from i := 0 until i > 255 loop
					crc := i.to_natural_32
					from j := 0 until j >= 8 loop
						if crc.bit_and (1) = 1 then
							crc := Polynomial.bit_xor (crc.bit_shift_right (1))
						else
							crc := crc.bit_shift_right (1)
						end
						j := j + 1
					end
					crc_table [i] := crc
					i := i + 1
				end
				table_initialized := True
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			test_string: STRING
		do
			test_string := "The quick brown fox jumps over the lazy dog"
			print ("CRC-32 Demo:%N%N")
			print ("String: %"" + test_string + "%"%N")
			print ("CRC-32: 0x" + crc32_hex (test_string) + "%N")
			print ("(Expected: 0x414FA339)%N")
			print ("%N")

			test_string := "123456789"
			print ("String: %"" + test_string + "%"%N")
			print ("CRC-32: 0x" + crc32_hex (test_string) + "%N")
			print ("(Expected: 0xCBF43926)%N")
		end

end
