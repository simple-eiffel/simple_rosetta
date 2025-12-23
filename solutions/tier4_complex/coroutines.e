note
	description: "[
		Rosetta Code: Concurrent computing
		https://rosettacode.org/wiki/Concurrent_computing

		Simulate coroutine-like behavior using state machines and agents.
		True coroutines require language-level support, but we can
		simulate cooperative multitasking patterns.
	]"

class
	COROUTINES

feature -- Coroutine State Machine

	create_coroutine (steps: ARRAY [PROCEDURE]): TUPLE [resume: PROCEDURE; is_done: FUNCTION [BOOLEAN]]
			-- Create a coroutine from a sequence of steps
		local
			step_index: CELL [INTEGER]
		do
			create step_index.put (1)
			Result := [
				agent resume_coroutine (steps, step_index),
				agent coroutine_done (steps, step_index)
			]
		end

feature {NONE} -- Coroutine Helpers

	resume_coroutine (steps: ARRAY [PROCEDURE]; step_index: CELL [INTEGER])
		do
			if step_index.item <= steps.count then
				steps [step_index.item].call ([])
				step_index.put (step_index.item + 1)
			end
		end

	coroutine_done (steps: ARRAY [PROCEDURE]; step_index: CELL [INTEGER]): BOOLEAN
		do
			Result := step_index.item > steps.count
		end

feature -- Producer/Consumer Pattern

	producer_consumer_demo
			-- Demonstrate producer/consumer coroutines
		local
			buffer: ARRAYED_LIST [INTEGER]
			producer, consumer: TUPLE [resume: PROCEDURE; is_done: FUNCTION [BOOLEAN]]
			prod_steps, cons_steps: ARRAY [PROCEDURE]
			i: INTEGER
		do
			create buffer.make (10)

			-- Producer produces 5 items
			prod_steps := <<
				agent produce_item (buffer, 1),
				agent produce_item (buffer, 2),
				agent produce_item (buffer, 3),
				agent produce_item (buffer, 4),
				agent produce_item (buffer, 5)
			>>

			-- Consumer consumes 5 items
			cons_steps := <<
				agent consume_item (buffer),
				agent consume_item (buffer),
				agent consume_item (buffer),
				agent consume_item (buffer),
				agent consume_item (buffer)
			>>

			producer := create_coroutine (prod_steps)
			consumer := create_coroutine (cons_steps)

			-- Interleave execution
			print ("Producer/Consumer interleaved:%N")
			from i := 1 until producer.is_done.item ([]) and consumer.is_done.item ([]) loop
				if not producer.is_done.item ([]) then
					producer.resume.call ([])
				end
				if not consumer.is_done.item ([]) and buffer.count > 0 then
					consumer.resume.call ([])
				end
				i := i + 1
			end
		end

feature {NONE} -- Producer/Consumer Helpers

	produce_item (buffer: ARRAYED_LIST [INTEGER]; item: INTEGER)
		do
			buffer.extend (item)
			print ("  Produced: " + item.out + "%N")
		end

	consume_item (buffer: ARRAYED_LIST [INTEGER])
		local
			item: INTEGER
		do
			if buffer.count > 0 then
				item := buffer.first
				buffer.start
				buffer.remove
				print ("  Consumed: " + item.out + "%N")
			end
		end

feature -- Generator Coroutine

	create_generator (producer: PROCEDURE [PROCEDURE [INTEGER]]): TUPLE [next: FUNCTION [INTEGER]; has_next: FUNCTION [BOOLEAN]]
			-- Create generator from yielding procedure
		local
			value_cell: CELL [INTEGER]
			has_value: CELL [BOOLEAN]
			done: CELL [BOOLEAN]
		do
			create value_cell.put (0)
			create has_value.put (False)
			create done.put (False)

			-- Start producer with yield callback
			producer.call ([agent yield_value (value_cell, has_value, ?)])

			Result := [
				agent get_next_value (value_cell, has_value),
				agent generator_has_next (has_value, done)
			]
		end

feature {NONE} -- Generator Helpers

	yield_value (value_cell: CELL [INTEGER]; has_value: CELL [BOOLEAN]; val: INTEGER)
		do
			value_cell.put (val)
			has_value.put (True)
		end

	get_next_value (value_cell: CELL [INTEGER]; has_value: CELL [BOOLEAN]): INTEGER
		do
			Result := value_cell.item
			has_value.put (False)
		end

	generator_has_next (has_value, done: CELL [BOOLEAN]): BOOLEAN
		do
			Result := has_value.item and not done.item
		end

feature -- Cooperative Scheduler

	create_scheduler: TUPLE [add_task: PROCEDURE [PROCEDURE]; run: PROCEDURE]
			-- Simple round-robin task scheduler
		local
			tasks: ARRAYED_LIST [PROCEDURE]
		do
			create tasks.make (10)
			Result := [
				agent add_task (tasks, ?),
				agent run_scheduler (tasks)
			]
		end

feature {NONE} -- Scheduler Helpers

	add_task (tasks: ARRAYED_LIST [PROCEDURE]; task: PROCEDURE)
		do
			tasks.extend (task)
		end

	run_scheduler (tasks: ARRAYED_LIST [PROCEDURE])
		do
			from tasks.start until tasks.after loop
				tasks.item.call ([])
				tasks.forth
			end
		end

feature -- State Machine Coroutine

	state_machine_demo
			-- Demonstrate state machine pattern for coroutines
		local
			state: INTEGER
			done: BOOLEAN
		do
			print ("%NState machine coroutine:%N")
			from state := 1 until done loop
				inspect state
				when 1 then
					print ("  State 1: Initialize%N")
					state := 2
				when 2 then
					print ("  State 2: Process%N")
					state := 3
				when 3 then
					print ("  State 3: Validate%N")
					state := 4
				when 4 then
					print ("  State 4: Complete%N")
					done := True
				end
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			coro: TUPLE [resume: PROCEDURE; is_done: FUNCTION [BOOLEAN]]
			scheduler: TUPLE [add_task: PROCEDURE [PROCEDURE]; run: PROCEDURE]
		do
			print ("Coroutines Demo:%N%N")

			-- Simple coroutine
			print ("Simple coroutine:%N")
			coro := create_coroutine (<<
				agent print ("  Step 1: Hello%N"),
				agent print ("  Step 2: World%N"),
				agent print ("  Step 3: Done!%N")
			>>)

			from until coro.is_done.item ([]) loop
				print ("Resuming...%N")
				coro.resume.call ([])
			end

			-- Producer/Consumer
			print ("%N")
			producer_consumer_demo

			-- State machine
			state_machine_demo

			-- Cooperative scheduler
			print ("%NCooperative scheduler:%N")
			scheduler := create_scheduler
			scheduler.add_task.call ([agent print ("  Task A%N")])
			scheduler.add_task.call ([agent print ("  Task B%N")])
			scheduler.add_task.call ([agent print ("  Task C%N")])
			scheduler.run.call ([])
		end

end
