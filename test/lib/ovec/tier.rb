require_relative '../../test_helper'

module Ovec
	class TierTest < Test::Unit::TestCase
		def setup
			@tier = Tier.new
		end

		private
		def assert_ties_to(input, output)
			parser = Ovec::Parser.new(debug: false)
			tree = parser.parse(input.dup)

			tm = Ovec::TexManipulator.new
			tm.bind(tree)

			tm.run_text_manipulator(@tier)

			text = tree.to_tex

			assert_equal output, text
		end

		public
		def test_basic_without_ties
			text = "Ahoj. Jak se máš?"
			text_duplicate = text.dup
			assert_ties_to text, text_duplicate
		end

		def test_simple_tie
			assert_ties_to "K blabla u blabla s blabla.", "K~blabla u~blabla s~blabla."
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
			assert_ties_to "Pojednavani pojednavajici\no pojednavani.", "Pojednavani pojednavajici\no~pojednavani."
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

		def test_tie_in_newline
			assert_ties_to "V\nrámci\ntohohle", "V~rámci\ntohohle"
			assert_ties_to "V\nrámci tohohle", "V~rámci tohohle"
			assert_ties_to "medved\nv\nulu", "medved\nv~ulu"
			assert_ties_to "v\nulu", "v~ulu"
		end

		def test_date_regex_ok
			assert "10" =~ /\A\p{Nd}*\Z/
			assert "1. 3. 2013" =~ Tier::DATE_REGEX
			assert "Bylo zrovna 1. 3. 2013." =~ Tier::DATE_REGEX
		end
	end
end
