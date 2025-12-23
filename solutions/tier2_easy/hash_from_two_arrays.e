note
	description: "[
		Rosetta Code: Hash from two arrays
		https://rosettacode.org/wiki/Hash_from_two_arrays

		Create a hash/dictionary/map from parallel arrays of keys and values.
	]"

class
	HASH_FROM_TWO_ARRAYS

feature -- Construction

	create_hash (keys: ARRAY [STRING]; values: ARRAY [ANY]): HASH_TABLE [ANY, STRING]
			-- Create hash table from parallel arrays
		require
			same_count: keys.count = values.count
		local
			i: INTEGER
		do
			create Result.make (keys.count)
			from i := keys.lower until i > keys.upper loop
				Result.put (values [i - keys.lower + values.lower], keys [i])
				i := i + 1
			end
		ensure
			correct_count: Result.count = keys.count
		end

	create_string_hash (keys, values: ARRAY [STRING]): HASH_TABLE [STRING, STRING]
			-- Create string-to-string hash table
		require
			same_count: keys.count = values.count
		local
			i: INTEGER
		do
			create Result.make (keys.count)
			from i := keys.lower until i > keys.upper loop
				Result.put (values [i - keys.lower + values.lower], keys [i])
				i := i + 1
			end
		ensure
			correct_count: Result.count = keys.count
		end

	create_integer_hash (keys: ARRAY [STRING]; values: ARRAY [INTEGER]): HASH_TABLE [INTEGER, STRING]
			-- Create string-to-integer hash table
		require
			same_count: keys.count = values.count
		local
			i: INTEGER
		do
			create Result.make (keys.count)
			from i := keys.lower until i > keys.upper loop
				Result.put (values [i - keys.lower + values.lower], keys [i])
				i := i + 1
			end
		ensure
			correct_count: Result.count = keys.count
		end

feature -- Utility

	zip_integers (keys: ARRAY [STRING]; values: ARRAY [INTEGER]): ARRAY [TUPLE [key: STRING; value: INTEGER]]
			-- Combine string keys and integer values into array of tuples
		require
			same_count: keys.count = values.count
		local
			i, ki, vi: INTEGER
		do
			create Result.make_filled ([keys [keys.lower], values [values.lower]], 1, keys.count)
			ki := keys.lower
			vi := values.lower
			from i := 1 until i > keys.count loop
				Result [i] := [keys [ki], values [vi]]
				ki := ki + 1
				vi := vi + 1
				i := i + 1
			end
		ensure
			correct_count: Result.count = keys.count
		end

	zip_strings (keys, values: ARRAY [STRING]): ARRAY [TUPLE [key: STRING; value: STRING]]
			-- Combine two string arrays into array of tuples
		require
			same_count: keys.count = values.count
		local
			i, ki, vi: INTEGER
		do
			create Result.make_filled ([keys [keys.lower], values [values.lower]], 1, keys.count)
			ki := keys.lower
			vi := values.lower
			from i := 1 until i > keys.count loop
				Result [i] := [keys [ki], values [vi]]
				ki := ki + 1
				vi := vi + 1
				i := i + 1
			end
		ensure
			correct_count: Result.count = keys.count
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			keys: ARRAY [STRING]
			str_values: ARRAY [STRING]
			int_values: ARRAY [INTEGER]
			str_hash: HASH_TABLE [STRING, STRING]
			int_hash: HASH_TABLE [INTEGER, STRING]
		do
			print ("Hash from Two Arrays Demo:%N%N")

			keys := <<"name", "city", "country">>
			str_values := <<"Alice", "Paris", "France">>

			print ("Keys: ")
			across keys as k loop print (k + " ") end
			print ("%N")

			print ("Values: ")
			across str_values as v loop print (v + " ") end
			print ("%N%N")

			str_hash := create_string_hash (keys, str_values)

			print ("Hash table contents:%N")
			from str_hash.start until str_hash.after loop
				print ("  " + str_hash.key_for_iteration + " => " + str_hash.item_for_iteration + "%N")
				str_hash.forth
			end

			print ("%N--- Integer values example ---%N%N")

			keys := <<"one", "two", "three", "four", "five">>
			int_values := <<1, 2, 3, 4, 5>>

			int_hash := create_integer_hash (keys, int_values)

			print ("Hash table contents:%N")
			from int_hash.start until int_hash.after loop
				print ("  " + int_hash.key_for_iteration + " => " + int_hash.item_for_iteration.out + "%N")
				int_hash.forth
			end
		end

end
