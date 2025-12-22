note
	description: "Test application for simple_rosetta"
	author: "Larry Rix"

class
	TEST_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Run the tests.
		do
			print ("Running simple_rosetta tests...%N%N")
			passed := 0
			failed := 0

			run_lib_tests
			run_solution_db_tests

			print ("%N========================%N")
			print ("Results: " + passed.out + " passed, " + failed.out + " failed%N")

			if failed > 0 then
				print ("TESTS FAILED%N")
			else
				print ("ALL TESTS PASSED%N")
			end
		end

feature {NONE} -- Test Runners

	run_lib_tests
		do
			create lib_tests
			run_test (agent lib_tests.test_rosetta_task_creation, "test_rosetta_task_creation")
			run_test (agent lib_tests.test_rosetta_task_languages, "test_rosetta_task_languages")
			run_test (agent lib_tests.test_rosetta_solution_creation, "test_rosetta_solution_creation")
			run_test (agent lib_tests.test_wiki_parser_extract_languages, "test_wiki_parser_extract_languages")
			run_test (agent lib_tests.test_wiki_parser_extract_description, "test_wiki_parser_extract_description")
			run_test (agent lib_tests.test_wiki_parser_extract_code, "test_wiki_parser_extract_code")
			run_test (agent lib_tests.test_task_store_save_and_find, "test_task_store_save_and_find")
			run_test (agent lib_tests.test_simple_rosetta_facade, "test_simple_rosetta_facade")
		end

	run_solution_db_tests
		do
			create solution_db_tests
			run_test (agent solution_db_tests.test_import_solutions, "test_import_solutions")
			run_test (agent solution_db_tests.test_search_solutions, "test_search_solutions")
			run_test (agent solution_db_tests.test_wiki_format, "test_wiki_format")
		end

feature {NONE} -- Implementation

	lib_tests: LIB_TESTS
	solution_db_tests: SOLUTION_DB_TEST

	passed: INTEGER
	failed: INTEGER

	run_test (a_test: PROCEDURE; a_name: STRING)
			-- Run a single test and update counters.
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				a_test.call (Void)
				print ("  PASS: " + a_name + "%N")
				passed := passed + 1
			end
		rescue
			print ("  FAIL: " + a_name + "%N")
			failed := failed + 1
			l_retried := True
			retry
		end

end
