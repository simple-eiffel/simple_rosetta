note
	description: "[
		Rosetta Code: Averages/Simple moving average
		https://rosettacode.org/wiki/Averages/Simple_moving_average

		Calculate a simple moving average over a sliding window.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Averages/Simple_moving_average"

class
	MOVING_AVERAGE

create
	make,
	make_with_period

feature {NONE} -- Initialization

	make
			-- Demonstrate moving average.
		local
			sma3, sma5: MOVING_AVERAGE
			values: ARRAY [REAL_64]
			i: INTEGER
		do
			-- Initialize self for invariant (default period 1)
			period := 1
			create window.make (1)

			values := <<1.0, 2.0, 3.0, 4.0, 5.0, 5.0, 4.0, 3.0, 2.0, 1.0>>

			create sma3.make_with_period (3)
			create sma5.make_with_period (5)

			print ("Value%TSMA(3)%TSMA(5)%N")
			print ("=====%T======%T======%N")

			from i := values.lower until i > values.upper loop
				sma3.add (values [i])
				sma5.add (values [i])
				print (values [i].out + "%T" + sma3.average.out + "%T" + sma5.average.out + "%N")
				i := i + 1
			end
		end

	make_with_period (n: INTEGER)
			-- Create moving average calculator with window size n.
		require
			positive_period: n > 0
		do
			period := n
			create window.make (n)
		ensure
			period_set: period = n
		end

feature -- Access

	period: INTEGER
			-- Size of the moving window.

	average: REAL_64
			-- Current moving average.
		do
			if window.is_empty then
				Result := 0.0
			else
				Result := sum / window.count
			end
		end

	count: INTEGER
			-- Number of values added.
		do
			Result := window.count
		end

feature -- Element change

	add (value: REAL_64)
			-- Add value to the moving average calculation.
		do
			if window.count >= period then
				-- Remove oldest value
				sum := sum - window.first
				window.start
				window.remove
			end
			-- Add new value
			window.extend (value)
			sum := sum + value
		ensure
			count_bounded: window.count <= period
		end

	reset
			-- Clear all values.
		do
			window.wipe_out
			sum := 0.0
		ensure
			empty: window.is_empty
			zero_sum: sum = 0.0
		end

feature {NONE} -- Implementation

	window: ARRAYED_LIST [REAL_64]
			-- Sliding window of values.

	sum: REAL_64
			-- Running sum of window values.

invariant
	window_exists: window /= Void
	window_bounded: window.count <= period
	positive_period: period > 0

end
