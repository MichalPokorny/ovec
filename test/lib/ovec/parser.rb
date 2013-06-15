require_relative '../../test_helper'

module Ovec
	class ParserTest < Test::Unit::TestCase
		def setup
			@parser = Parser.new
		end

		def test_basic_text_parsing
			text = "Hello world!"
			node, eaten = @parser.eat_node(text, 0)
			assert_equal text.length, eaten
			assert node.is_a?(TextNode)
			assert_equal text.length, node.length
		end

		def test_basic_math_parsing
			text = "$10+5=7$"
			node, eaten = @parser.eat_node(text, 0)
			assert_equal text.length, eaten
			assert node.is_a?(MathNode)
			assert_equal node.type, MathNode::INLINE
			assert_equal node.content, text[1...(text.length - 1)]
		end

		def test_basic_display_math_parsing
			text = "$$10+5=7$$"
			node, eaten = @parser.eat_node(text, 0)
			assert_equal text.length, eaten
			assert node.is_a?(MathNode)
			assert_equal node.type, MathNode::DISPLAY
			assert_equal node.content, text[2...(text.length - 2)]
		end

		def test_basic_composite_parsing
			text = "Ahoj světe. $10 + 5 = 3$\n\n\tSbohem. $$X \geq 4$$"
			result = @parser.parse(text)
			assert result.is_a?(CombinedNode)
			assert_equal text, result.to_tex
		end

		def test_escaped_dollar_math
			input = "$$Ahoj\\$$Svete$$"
			result = @parser.parse(input)
			assert result.length == 1
			assert result[0].is_a? MathNode
			assert result[0].content == "Ahoj\\$$Svete"
		end

		def test_text_command_parsing
			text = '\textbf{Ahoj. Tohle je \textit{text}, ktery se bude vlnkovat.}'
			result = @parser.parse(text)
			assert result.is_a?(CombinedNode)
			assert result.length == 1	

			node = result[0]
			assert node.is_a?(TextCommandsNode)
			assert node.command == "textbf"

			node2 = node.content
			assert node2.is_a?(CombinedNode)
			assert node2.length == 3
			assert node2[0].is_a?(TextNode)
			assert node2[0].text == "Ahoj. Tohle je "
			assert node2[1].is_a?(TextCommandsNode)
			assert node2[1].command == "textit"
			assert node2[1].content[0].text == "text"
			assert node2[2].text == ", ktery se bude vlnkovat."
		end

		def test_command_parsed
			text = '\blabla'
			result = @parser.parse(text)
			assert_equal text, result.to_tex
		end

		def test_weird_commands_parsed
			text = '\%\ \\\ \ahoj\~\^\,\:\$\&'
			result = @parser.parse(text)
			assert_equal text, result.to_tex
		end
	end
end
