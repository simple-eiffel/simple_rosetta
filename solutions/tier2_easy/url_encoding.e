note
	description: "[
		Rosetta Code: URL encoding
		https://rosettacode.org/wiki/URL_encoding

		Encode special characters in URLs.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "URL_encoding"
	tier: "2"

class
	URL_ENCODING

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate URL encoding.
		do
			print ("URL Encoding%N")
			print ("============%N%N")

			demo ("http://foo bar/")
			demo ("Hello World!")
			demo ("mailto:foo@bar.com")
			demo ("100%% complete")
		end

feature -- Demo

	demo (a_str: STRING)
			-- Show encoding.
		do
			print ("Original: " + a_str + "%N")
			print ("Encoded:  " + url_encode (a_str) + "%N%N")
		end

feature -- Encoding

	url_encode (a_str: STRING): STRING
			-- URL-encode special characters.
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
			l_c: CHARACTER
		do
			create Result.make (a_str.count * 3)
			from l_i := 1 until l_i > a_str.count loop
				l_c := a_str [l_i]
				if is_unreserved (l_c) then
					Result.append_character (l_c)
				else
					Result.append_character ('%%')
					Result.append (to_hex (l_c.code))
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
		end

	url_decode (a_str: STRING): STRING
			-- Decode URL-encoded string.
		require
			str_exists: a_str /= Void
		local
			l_i, l_code: INTEGER
		do
			create Result.make (a_str.count)
			from l_i := 1 until l_i > a_str.count loop
				if a_str [l_i] = '%%' and l_i + 2 <= a_str.count then
					l_code := from_hex (a_str.substring (l_i + 1, l_i + 2))
					Result.append_character (l_code.to_character_8)
					l_i := l_i + 3
				else
					Result.append_character (a_str [l_i])
					l_i := l_i + 1
				end
			end
		ensure
			result_exists: Result /= Void
		end

feature {NONE} -- Helpers

	is_unreserved (a_c: CHARACTER): BOOLEAN
			-- Is character unreserved (no encoding needed)?
		do
			Result := (a_c >= 'A' and a_c <= 'Z') or
			          (a_c >= 'a' and a_c <= 'z') or
			          (a_c >= '0' and a_c <= '9') or
			          a_c = '-' or a_c = '_' or a_c = '.' or a_c = '~'
		end

	to_hex (a_byte: INTEGER): STRING
			-- Convert byte to 2-digit hex.
		do
			Result := a_byte.to_hex_string
			if Result.count > 2 then
				Result := Result.substring (Result.count - 1, Result.count)
			end
			from until Result.count >= 2 loop
				Result.prepend ("0")
			end
		end

	from_hex (a_hex: STRING): INTEGER
			-- Convert 2-digit hex to byte.
		local
			l_i: INTEGER
			l_c: CHARACTER
		do
			from l_i := 1 until l_i > a_hex.count loop
				l_c := a_hex [l_i].as_upper
				Result := Result * 16
				if l_c >= '0' and l_c <= '9' then
					Result := Result + l_c.code - ('0').code
				elseif l_c >= 'A' and l_c <= 'F' then
					Result := Result + l_c.code - ('A').code + 10
				end
				l_i := l_i + 1
			end
		end

end