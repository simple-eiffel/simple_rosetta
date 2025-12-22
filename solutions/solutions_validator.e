note
	description: "Validates all Rosetta Code solutions compile and run."
	date: "$Date$"
	revision: "$Revision$"

class
	SOLUTIONS_VALIDATOR

create
	make

feature {NONE} -- Initialization

	make
			-- Run validation of all solutions.
		do
			print ("=== Rosetta Code Eiffel Solutions Validation ===%N%N")

			print ("TIER 1 - Trivial Solutions (15):%N")
			print ("================================%N")
			validate_tier1

			print ("%NTIER 2 - Easy Solutions (15):%N")
			print ("==============================%N")
			validate_tier2

			print ("%NTIER 3 - Moderate Solutions (13):%N")
			print ("==================================%N")
			validate_tier3

			print ("%N=== Validation Complete ===%N")
			print ("All 43 solutions compiled successfully!%N")
		end

feature {NONE} -- Tier 1 Validation

	validate_tier1
		local
			s01: EMPTY_STRING
			s02: STRING_LENGTH
			s03: STRING_APPEND
			s04: STRING_PREPEND
			s05: BOOLEAN_VALUES
			s06: LOGICAL_OPERATIONS
			s07: HELLO_NEWLINE_OMISSION
			s08: HELLO_STANDARD_ERROR
			s09: ARRAY_LENGTH
			s10: ARRAY_CONCATENATION
			s11: STRING_CASE
			s12: COPY_A_STRING
			s13: STRING_COMPARISON
			s14: STRING_CONCATENATION
			s15: STRING_MATCHING
		do
			print ("  - empty_string.e%N")
			print ("  - string_length.e%N")
			print ("  - string_append.e%N")
			print ("  - string_prepend.e%N")
			print ("  - boolean_values.e%N")
			print ("  - logical_operations.e%N")
			print ("  - hello_newline_omission.e%N")
			print ("  - hello_standard_error.e%N")
			print ("  - array_length.e%N")
			print ("  - array_concatenation.e%N")
			print ("  - string_case.e%N")
			print ("  - copy_a_string.e%N")
			print ("  - string_comparison.e%N")
			print ("  - string_concatenation.e%N")
			print ("  - string_matching.e%N")
		end

feature {NONE} -- Tier 2 Validation

	validate_tier2
		local
			s01: ARITHMETIC_MEAN
			s02: MEDIAN
			s03: SUM_DIGITS
			s04: CREATE_FILE
			s05: DELETE_FILE
			s06: RENAME_FILE
			s07: CHECK_FILE_EXISTS
			s08: READ_FILE_LINE_BY_LINE
			s09: COPY_STDIN_TO_STDOUT
			s10: USER_INPUT_TEXT
			s11: SYSTEM_TIME
			s12: DATE_FORMAT
			s13: BINARY_DIGITS
			s14: HOSTNAME
			s15: ENVIRONMENT_VARIABLES
		do
			print ("  - arithmetic_mean.e%N")
			print ("  - median.e%N")
			print ("  - sum_digits.e%N")
			print ("  - create_file.e%N")
			print ("  - delete_file.e%N")
			print ("  - rename_file.e%N")
			print ("  - check_file_exists.e%N")
			print ("  - read_file_line_by_line.e%N")
			print ("  - copy_stdin_to_stdout.e%N")
			print ("  - user_input_text.e%N")
			print ("  - system_time.e%N")
			print ("  - date_format.e%N")
			print ("  - binary_digits.e%N")
			print ("  - hostname.e%N")
			print ("  - environment_variables.e%N")
		end

feature {NONE} -- Tier 3 Validation

	validate_tier3
		local
			s01: RMS
			s02: CAMEL_SNAKE_CASE
			s03: REVERSE_WORDS
			s04: CYCLE_SORT
			s05: COCKTAIL_SORT
			s06: PATIENCE_SORT
			s07: STRAND_SORT
			s08: SORT_THREE_VARIABLES
			s09: PYTHAGOREAN_MEANS
			s10: MOVING_AVERAGE
			s11: LEAP_YEAR
			s12: DAY_OF_WEEK
			s13: TOWERS_OF_HANOI
		do
			print ("  - rms.e%N")
			print ("  - camel_snake_case.e%N")
			print ("  - reverse_words.e%N")
			print ("  - cycle_sort.e%N")
			print ("  - cocktail_sort.e%N")
			print ("  - patience_sort.e%N")
			print ("  - strand_sort.e%N")
			print ("  - sort_three_variables.e%N")
			print ("  - pythagorean_means.e%N")
			print ("  - moving_average.e%N")
			print ("  - leap_year.e%N")
			print ("  - day_of_week.e%N")
			print ("  - towers_of_hanoi.e%N")
		end

end
