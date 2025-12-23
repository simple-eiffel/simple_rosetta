note
	description: "[
		Rosetta Code: Associative array/Creation
		https://rosettacode.org/wiki/Associative_array/Creation

		Demonstrate creation and use of associative arrays (dictionaries/maps).
	]"

class
	ASSOCIATIVE_ARRAY

feature -- Demonstration

	demo
			-- Standard Rosetta Code demo
		local
			hash: HASH_TABLE [STRING, STRING]
			int_hash: HASH_TABLE [INTEGER, STRING]
		do
			print ("Associative Array Demo:%N%N")

			-- String to String hash
			print ("=== String to String ===%N")
			create hash.make (10)

			-- Insert key-value pairs
			hash.put ("red", "color")
			hash.put ("large", "size")
			hash.put ("round", "shape")

			-- Retrieve values
			if attached hash.item ("color") as v then print ("color => " + v + "%N") end
			if attached hash.item ("size") as v then print ("size => " + v + "%N") end
			if attached hash.item ("shape") as v then print ("shape => " + v + "%N") end

			-- Check for key
			print ("%NHas 'color': " + hash.has ("color").out + "%N")
			print ("Has 'weight': " + hash.has ("weight").out + "%N")

			-- Iterate over all pairs
			print ("%NAll entries:%N")
			from hash.start until hash.after loop
				print ("  " + hash.key_for_iteration + " => " + hash.item_for_iteration + "%N")
				hash.forth
			end

			-- Update value
			hash.force ("blue", "color")
			print ("%NAfter updating color to blue:%N")
			if attached hash.item ("color") as v then print ("color => " + v + "%N") end

			-- Remove entry
			hash.remove ("size")
			print ("%NAfter removing 'size':%N")
			from hash.start until hash.after loop
				print ("  " + hash.key_for_iteration + " => " + hash.item_for_iteration + "%N")
				hash.forth
			end

			-- String to Integer hash
			print ("%N=== String to Integer ===%N")
			create int_hash.make (10)

			int_hash.put (1, "one")
			int_hash.put (2, "two")
			int_hash.put (3, "three")

			print ("one => " + int_hash.item ("one").out + "%N")
			print ("two => " + int_hash.item ("two").out + "%N")
			print ("three => " + int_hash.item ("three").out + "%N")

			print ("%NCount: " + int_hash.count.out + "%N")
		end

feature -- Common Operations

	merge (target, source: HASH_TABLE [STRING, STRING])
			-- Merge source into target (source values overwrite)
		do
			from source.start until source.after loop
				target.force (source.item_for_iteration, source.key_for_iteration)
				source.forth
			end
		end

	keys_array (a_hash: HASH_TABLE [STRING, STRING]): ARRAY [STRING]
			-- Extract all keys as array
		do
			create Result.make_empty
			from a_hash.start until a_hash.after loop
				Result.force (a_hash.key_for_iteration, Result.count + 1)
				a_hash.forth
			end
		end

	values_array (a_hash: HASH_TABLE [STRING, STRING]): ARRAY [STRING]
			-- Extract all values as array
		do
			create Result.make_empty
			from a_hash.start until a_hash.after loop
				Result.force (a_hash.item_for_iteration, Result.count + 1)
				a_hash.forth
			end
		end

end
