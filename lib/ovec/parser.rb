module Ovec
	class ParseError < StandardError
	end

	# TODO: verbatimy; TeX prikazy obsahujici kusy k ovlnkovani

	class Parser
		NORMAL_REGEX = /\A([^\\$%])+/
		# TODO: more escapes: there are probably 10x more...
		COMMAND_REGEX = /\A\\([a-zA-Z0-9]+|[%:,\\])/
		COMMENT_REGEX = /\A%.*$/

		TEXT_COMMANDS = %w(textit textbf textsc title author)
		# TODO: seznam prikazu, ve kterych se nevlnkuje
	
		NONTEXT_CONTENT_COMMANDS = %w() # TODO: treba \begin, \end, ...
		
		VERBATIM_COMMANDS = %w(verbatim verb)

		private
		def debug(*args)
			$stderr.puts(*args)
		end

		def find_other_side(string, start, left = '{', right = '}')
			level = 0
			for i in start...string.length
				if string[i] == left && (right != left || i == start)
					level += 1 
				elsif string[i] == right
					level -= 1
				end

				return i if level == 0
			end

			raise ParseError, "No matching #{right} found for #{left} in #{string} from index #{start}."
		end

		public
		def self.delimiter_right_side(left)
			{
				'{' => '}', '[' => ']', '(' => ')', '<' => '>'
			}[left] || left
		end

		def eat_node(code, index)
			to_eat = code[index...code.length]

			if to_eat.empty?
				raise ParseError, "Parsing an empty string"
			end

			# Cut off comments
			match = COMMENT_REGEX.match(to_eat)
			unless match.nil?
				match = match[0]
				node = CommentNode.new(match)

				debug "Eaten #{match.length} chars of comments."
				return node, match.length
			end

			# Cut off normal text
			match = NORMAL_REGEX.match(to_eat)
			unless match.nil?
				match = match[0]
				node = TextNode.new(match)

				debug "Eaten #{match.length} chars of normal text."
				return node, match.length
			end

			# Parse a command. If the command looks like a text-command, try to eat everything between { and }.
			match = COMMAND_REGEX.match(to_eat)
			unless match.nil?
				command = match[1]
				match_len = match[0].length
				debug "Eating command #{command}."

				if TEXT_COMMANDS.include?(command) || NONTEXT_CONTENT_COMMANDS.include?(command)
					if to_eat.length > match_len && to_eat[match_len] == '{'
						debug "Looks like a text command, trying to parse recursively."
						begin
							other_side = find_other_side(to_eat, match_len, '{', '}')

							content = parse(code[index + match_len + 1...index + other_side])
							# TODO: rename textcommands to something better: command with params?
							node = TextCommandsNode.new(command, content, text: TEXT_COMMANDS.include?(command))

							debug "Eaten #{other_side + 1} chars of text command."
							return node, (other_side + 1)
						rescue ParseError
							debug "Parse error encountered. Giving up on this node."
						end
					end
				end

				if VERBATIM_COMMANDS.include?(command)
					if to_eat.length <= match_len
						raise ParseError, "Verbatim at EOF with no delimiter."
					end

					left_delimiter = to_eat[match_len]
					right_delimiter = self.class.delimiter_right_side(left_delimiter)

					# TODO: nesting in verbatims ???
					other_side = find_other_side(to_eat, match_len, left_delimiter, right_delimiter)

					content = to_eat[match_len + 1...other_side]

					node = VerbatimNode.new(command, left_delimiter, content)

					debug "Eaten #{other_side + 1} chars of verbatim."
					return node, (other_side + 1)
				end

				node = CommandsNode.new(command)
				
				debug "Eaten #{match_len} chars of commands."
				return node, match_len
			end

			if to_eat.length > 1 && to_eat[0..1] == "$$"
				# Lookaround assertion to handle escaped dollars in math.
				ending = to_eat[2...to_eat.length].index(/(?<!\\)\$\$/)
				
				if ending.nil?
					raise ParseError, "Unterminated $$ starting at #{index}"
				end

				node = MathNode.new(MathNode::DISPLAY, to_eat[2...ending+2])
				eaten = ending + 4
				debug "Eaten #{eaten} chars of inline math."
				return node, eaten
			end

			if to_eat[0] == '$'
				# Lookaround assertion to handle escaped dollars in math.
				ending = to_eat[1...to_eat.length].index(/(?<!\\)\$/)

				if ending.nil?
					raise ParseError, "Unterminated $ starting at #{index}"
				end

				node = MathNode.new(MathNode::INLINE, to_eat[1...ending+1])
				eaten = ending + 2
				debug "Eaten #{eaten} chars of inline math."
				return node, eaten
			end

			raise ParseError, "Don't know how to parse '#{to_eat}'."
		end

		def parse(code)
			result = CombinedNode.new

			index = 0
			while index < code.length
				node, shift = eat_node(code, index)
				index += shift

				result << node
			end

			return result
		end
	end
end
