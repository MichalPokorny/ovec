module Ovec
	class TexManipulator
		def bind(root)
			@root = root
		end

		private
		def load_text_chunks_dfs(node)
			case node
			when Ovec::TextCommandsNode then
				load_text_chunks_dfs(node.content) if node.text?
			when Ovec::TextNode	then
				@text_chunks << node.text
			when Ovec::CombinedNode then
				node.content.each { |subnode| 
					load_text_chunks_dfs(subnode)
				}
			end
		end

		public
		def run_text_manipulator(manipulator)
			@text_chunks = []
			load_text_chunks_dfs(@root)
			manipulator.bind(@text_chunks)	
			manipulator.run
		end
	end
end
