note
	description: "Test solution database population and querying."
	date: "$Date$"

class
	SOLUTION_DB_TEST

inherit
	EQA_TEST_SET

feature -- Tests

	test_import_solutions
			-- Import all solutions and verify counts.
		local
			store: SOLUTION_STORE
			importer: SOLUTION_IMPORTER
			summary: ARRAYED_LIST [TUPLE [tier: INTEGER; solution_count: INTEGER]]
			i: INTEGER
		do
			create store.make ("rosetta_solutions.db")
			create importer.make (store, "D:/prod/simple_rosetta/solutions")
			importer.import_all

			print ("Imported " + importer.imported_count.out + " solutions%N%N")

			-- Verify counts
			assert ("has solutions", store.solution_count > 0)
			print ("Total in database: " + store.solution_count.out + "%N")

			-- Show tier summary
			print ("%NTier Summary:%N")
			summary := store.tier_summary
			from i := 1 until i > summary.count loop
				print ("  TIER " + summary.i_th (i).tier.out + ": " + summary.i_th (i).solution_count.out + " solutions%N")
				i := i + 1
			end

			store.close
		end

	test_search_solutions
			-- Test solution searching.
		local
			store: SOLUTION_STORE
			results: ARRAYED_LIST [TUPLE [task: STRING; tier: INTEGER; class_name: STRING]]
			i: INTEGER
		do
			create store.make ("rosetta_solutions.db")

			-- Search for sorting solutions
			results := store.search_solutions ("sort")
			print ("Search 'sort': " + results.count.out + " results%N")
			from i := 1 until i > results.count loop
				print ("  - " + results.i_th (i).task + " (TIER " + results.i_th (i).tier.out + ")%N")
				i := i + 1
			end

			-- Search for string solutions
			results := store.search_solutions ("string")
			print ("%NSearch 'string': " + results.count.out + " results%N")

			store.close
		end

	test_wiki_format
			-- Test wiki formatting of solutions.
		local
			store: SOLUTION_STORE
			wiki: detachable STRING
		do
			create store.make ("rosetta_solutions.db")

			wiki := store.solution_as_wiki ("Fibonacci_sequence")
			if attached wiki as w then
				print ("Wiki format for Fibonacci:%N")
				print (w.substring (1, w.count.min (500)))
				print ("...%N")
			else
				print ("Fibonacci not found%N")
			end

			store.close
		end

end
