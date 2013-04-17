require_relative '../../test_helper'

module Ovec
	class TexManipulatorTest < Test::Unit::TestCase
		def setup
			@tm = TexManipulator.new
			@tier = Tier.new
			@parser = Parser.new
		end

		def test_commands_reversible
			tex = '\heading{Ahoj}'
			tree = @parser.parse(tex)
			assert_equal tex, tree.to_tex
		end

		private
		def assert_ties_to(input, output)
			tree = @parser.parse(input)
			assert tree.is_a?(CombinedNode)
			@tm.bind(tree)
			@tm.run_text_manipulator(@tier)
			assert_equal output, tree.to_tex
		end

		public
		def test_basic_tex
			input = 'Ahoj svete. \\textbf{I v ceskych luzich dochazi k ubytku s\\textit{ prichodem} podzimu.}'
			output = 'Ahoj svete. \\textbf{I~v~ceskych luzich dochazi k~ubytku s\\textit{~prichodem} podzimu.}'
			assert_ties_to input, output
		end

		def test_with_verb
			input = 'Ahoj. \verb|Tohle % je ve verbatimu, takze to neni komentar. V tomhle se nevlnkuje.| V tomhle kusu se uz zase vlnkuje.'
			output = 'Ahoj. \verb|Tohle % je ve verbatimu, takze to neni komentar. V tomhle se nevlnkuje.| V~tomhle kusu se uz zase vlnkuje.'
			assert_ties_to input, output
		end
	end
end
