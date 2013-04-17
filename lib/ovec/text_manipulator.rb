module Ovec
	class TextManipulator
		# Subclasses, note: once you change the length of a chunk, delimiters will no longer be correct.

		def bind(chunks)
			@chunks = chunks
			@delimiters = [0]
			chunks.each do |chunk|
				@delimiters << @delimiters.last + chunk.length
			end

			_rejoin
		end

		protected

		# Given an offset in the original string, returns the chunk and chunk offset
		# that contains the refers to the same character.
		def _find_chunk_and_offset(offset)
			j = 0
			while j < @delimiters.size - 1
				break if @delimiters[j + 1] > offset
				j += 1
			end

			return [ @chunks[j], offset - @delimiters[j] ]
		end

		def _rejoin
			@joined = @chunks.join('')
		end
	end
end
