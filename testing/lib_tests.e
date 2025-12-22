note
	description: "Test suite for simple_rosetta"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"
	testing: "covers"

class
	LIB_TESTS

inherit
	TEST_SET_BASE

feature -- Task Tests

	test_rosetta_task_creation
			-- Test basic task creation.
		local
			task: ROSETTA_TASK
		do
			create task.make ("Bubble sort")
			assert ("name set", task.name.same_string ("Bubble sort"))
			assert ("no eiffel initially", not task.has_eiffel)
			assert ("not validated", not task.is_eiffel_validated)
			assert ("zero languages", task.language_count = 0)
		end

	test_rosetta_task_languages
			-- Test adding languages to task.
		local
			task: ROSETTA_TASK
		do
			create task.make ("Fibonacci sequence")
			task.add_language ("Python")
			task.add_language ("Java")
			task.add_language ("Eiffel")

			assert ("has python", task.has_language ("Python"))
			assert ("has java", task.has_language ("Java"))
			assert ("has eiffel", task.has_eiffel)
			assert ("three languages", task.language_count = 3)
		end

feature -- Solution Tests

	test_rosetta_solution_creation
			-- Test solution creation.
		local
			solution: ROSETTA_SOLUTION
		do
			create solution.make (1, "Python", "def fib(n):%N    pass")
			assert ("task_id set", solution.task_id = 1)
			assert ("language set", solution.language.same_string ("Python"))
			assert ("not eiffel", not solution.is_eiffel)
			assert ("source is rosetta", solution.is_from_rosetta)
			assert ("not validated", not solution.is_validated)
		end

feature -- Wiki Parser Tests

	test_wiki_parser_extract_languages
			-- Test extracting languages from wiki content.
		local
			parser: WIKI_PARSER
			languages: ARRAYED_LIST [STRING]
		do
			create parser
			languages := parser.extract_languages (Sample_wiki_content)

			assert ("found python", string_list_has (languages, "Python"))
			assert ("found java", string_list_has (languages, "Java"))
			assert ("found eiffel", string_list_has (languages, "Eiffel"))
		end

	test_wiki_parser_extract_description
			-- Test extracting description from wiki content.
		local
			parser: WIKI_PARSER
			desc: STRING
		do
			create parser
			desc := parser.extract_description (Sample_wiki_content)

			assert ("description not empty", not desc.is_empty)
			assert ("contains task text", desc.has_substring ("Sort an array"))
		end

	test_wiki_parser_extract_code
			-- Test extracting code blocks.
		local
			parser: WIKI_PARSER
			solutions: ARRAYED_LIST [TUPLE [language: STRING; code: STRING]]
			found_python: BOOLEAN
			i: INTEGER
		do
			create parser
			solutions := parser.extract_solutions (Sample_wiki_content)

			assert ("found solutions", solutions.count > 0)

			from i := 1 until i > solutions.count loop
				if attached {STRING} solutions.i_th (i).language as lang then
					if lang.same_string ("Python") then
						found_python := True
						if attached {STRING} solutions.i_th (i).code as co then
							assert ("python code not empty", not co.is_empty)
						end
					end
				end
				i := i + 1
			end

			assert ("found python solution", found_python)
		end

feature -- Store Tests

	test_task_store_save_and_find
			-- Test saving and finding tasks.
		local
			store: TASK_STORE
			task, found: detachable ROSETTA_TASK
			file: RAW_FILE
		do
			-- Clean up old test database
			create file.make_with_name (test_db_path)
			if file.exists then
				file.delete
			end

			create store.make_with_path (test_db_path)

			create task.make ("Test Task")
			task.set_description ("A test task for unit testing")
			task.add_language ("Python")
			task.add_language ("Eiffel")

			store.save_task (task)
			assert ("task has id", task.id > 0)

			found := store.find_task_by_name ("Test Task")
			assert ("found task", attached found)
			if attached found as f then
				assert ("same name", f.name.same_string ("Test Task"))
				assert ("has eiffel", f.has_eiffel)
			end

			store.close
			-- Cleanup
			create file.make_with_name (test_db_path)
			if file.exists then
				file.delete
			end
		end

feature -- Facade Tests

	test_simple_rosetta_facade
			-- Test the main facade.
		local
			rosetta: SIMPLE_ROSETTA
			file: RAW_FILE
		do
			-- Clean up old test database
			create file.make_with_name (test_db_path)
			if file.exists then
				file.delete
			end

			create rosetta.make_with_db (test_db_path)
			assert ("no initial error", not rosetta.has_error)

			-- Test stats (should show zeros)
			assert ("stats not empty", not rosetta.stats.is_empty)

			-- Close before cleanup
			rosetta.close

			-- Cleanup
			create file.make_with_name (test_db_path)
			if file.exists then
				file.delete
			end
		end

feature {NONE} -- Helpers

	string_list_has (a_list: ARRAYED_LIST [STRING]; a_string: STRING): BOOLEAN
			-- Does a_list contain a_string (using same_string comparison)?
		local
			i: INTEGER
		do
			from i := 1 until i > a_list.count or Result loop
				if a_list.i_th (i).same_string (a_string) then
					Result := True
				end
				i := i + 1
			end
		end

feature {NONE} -- Test Data

	Test_db_path: STRING = "test_rosetta.db"
			-- Path to test database

	Sample_wiki_content: STRING = "[
Sort an array of elements using the bubble sort algorithm.

=={{header|Python}}==
<syntaxhighlight lang=%"python%">
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        for j in range(0, n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
    return arr
</syntaxhighlight>

=={{header|Java}}==
<syntaxhighlight lang=%"java%">
public static void bubbleSort(int[] arr) {
    int n = arr.length;
    for (int i = 0; i < n-1; i++)
        for (int j = 0; j < n-i-1; j++)
            if (arr[j] > arr[j+1]) {
                int temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
}
</syntaxhighlight>

=={{header|Eiffel}}==
<syntaxhighlight lang=%"eiffel%">
feature -- Sorting

    bubble_sort (arr: ARRAY [INTEGER])
        local
            i, j, temp: INTEGER
        do
            from i := arr.lower until i >= arr.upper loop
                from j := arr.lower until j >= arr.upper - i + arr.lower loop
                    if arr[j] > arr[j + 1] then
                        temp := arr[j]
                        arr[j] := arr[j + 1]
                        arr[j + 1] := temp
                    end
                    j := j + 1
                end
                i := i + 1
            end
        end
</syntaxhighlight>
]"

end
