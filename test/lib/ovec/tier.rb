require_relative '../../test_helper'

module Ovec
	class TierTest < Test::Unit::TestCase
		def setup
			@tier = Tier.new
		end

		def test_basic_without_ties
			text = "Ahoj. Jak se máš?"
			text_duplicate = text.dup
			@tier.bind([text_duplicate])
			@tier.run
			assert_equal text, text_duplicate
		end

		private
		def assert_ties_to(input, output)
			input = [input] if input.is_a? String
			output = [output] if output.is_a? String
			text = input.dup
			@tier.bind(test)
			@tier.run
			assert_equal text, outpu
		end

		def test_simple_tie
			assert_ties_to "K blabla u blabla s blabla.", "K~blabla u~blabla s~blabla."
		end

		def test_array_tie
			assert_ties_to [ "K blabla u", " blabla ", "s blabla.", " A blabla?" ], [ "K~blabla u", "~blabla ", "s~blabla.", " A~blabla?" ]
		end

		def test_regex_works
			regex = Tier::REGEX
			assert !("ahoj" =~ regex)
			assert "~v " =~ regex
			assert "Cau. A hrdy bud, zes vytrval." =~ regex
		end

		def test_hard_tie
			assert_ties_to "I v ceskych luzich dochazi k ubytku s prichodem podzimu.",
				             "I~v~ceskych luzich dochazi k~ubytku s~prichodem podzimu."
		end

		def test_tie_dash
			assert_ties_to "Ach -- pomlcka!", "Ach~-- pomlcka!"
			assert_ties_to "Ach --\npomlcka!", "Ach~--\npomlcka!"
		end

		def test_tie_across_newline
			assert_ties_to "Pojednani pojednavajici\no pojednavani.", "Pojednavani pojednavajici\no~pojednavani."
		end

		def test_tie_a_after_pause
			assert_ties_to "Kone se pasou, a ovce se pasou.", "Kone se pasou, a~ovce se pasou."
		end

		def test_tie_date
			assert_ties_to "3. 4. 2012", "3.~4.~2012"
			assert_ties_to "1. leden 1950", "1.~leden~1950"
		end

		def test_tie_various
			assert_ties_to "Je-li x sudé, je dělitelné dvěma (v opačném případě není).", "Je-li x sudé, je dělitelné dvěma (v~opačném případě není)."
		end
	end
end
