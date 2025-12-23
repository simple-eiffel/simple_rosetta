note
	description: "Helper class for range iteration - used by GENERATOR_PATTERN"

class
	RANGE_GENERATOR

inherit
	ITERATION_CURSOR [INTEGER]

create
	make

feature {NONE} -- Initialization

	make (a_from, a_to, a_step: INTEGER)
		do
			from_val := a_from
			to_val := a_to
			step := a_step
			current_val := from_val
		end

feature -- Access

	item: INTEGER
		do
			Result := current_val
		end

feature -- Status

	after: BOOLEAN
		do
			if step > 0 then
				Result := current_val > to_val
			else
				Result := current_val < to_val
			end
		end

feature -- Cursor movement

	forth
		do
			current_val := current_val + step
		end

feature {NONE} -- Implementation

	from_val, to_val, step, current_val: INTEGER

end
