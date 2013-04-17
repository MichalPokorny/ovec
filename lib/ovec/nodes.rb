module Ovec
	class Node
	end

	class CommentNode < Node
		def initialize(content)
			@content = content
		end

		def to_tex
			content
		end

		attr_reader :content
	end

	class TextCommandsNode < Node
		# If verbatim, do not interpret content as actual text.
		def initialize(command, content, text: true)
			@command = command
			@content = content
			@text = text
		end

		def to_tex
			"\\#@command{#{@content.to_tex}}"
		end

		def text?; @text; end

		attr_reader :command
		attr_reader :content
	end

	class VerbatimNode < Node
		def initialize(command, delimiter, content)
			@command = command
			@delimiter = delimiter
			@content = content
		end

		def left_delimiter
			@delimiter
		end

		def right_delimiter
			Parser.delimiter_right_side @delimiter
		end

		def to_tex
			"\\#@command#{left_delimiter}#@content#{right_delimiter}"
		end
	end

	class CommandsNode < Node
		def initialize(content)
			@content = content
		end

		def to_tex
			"\\#{content}"
		end

		attr_reader :content
	end

	class MathNode < Node
		INLINE = :inline
		DISPLAY = :display

		def initialize(type, content)
			@type = type
			@content = content
		end

		def to_tex
			if type == INLINE
				"$#{content}$"
			else
				"$$#{content}$$"
			end
		end

		attr_reader :type
		attr_reader :content
	end

	class TextNode < Node
		def initialize(text)
			@text = text
		end

		def length
			text.length
		end

		def to_tex
			text
		end

		attr_reader :text
	end

	class CombinedNode < Node
		def initialize(content = [])
			@content = content
		end

		def <<(thing)
			@content << thing
		end

		def to_tex()
			content.map(&:to_tex).join('')
		end

		def length
			@content.length
		end

		def [](index)
			@content[index]
		end

		attr_reader :content
	end
end
