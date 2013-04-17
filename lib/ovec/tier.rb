#!/usr/bin/ruby -w

module Ovec
	class Tier < TextManipulator
		# The last character this regex matches is changed to a tilde.
		REGEX = /(
			((\p{Z}|\~|\n)[KkSsVvZzOoUu]\p{Z})|      # KSVZOU jako samostatne slovo
			([\.\?\!](\p{Z}|\~)+[KSVZOUAI]\p{Z})| # KSVZOUAI na zacatku vety
			(\A[KSVZOUAI]\p{Z})|                  # KSVZOUAI na zacatku textu
			(\p{Z}(?=--\p{Z}))|                   # mezera, za kterou je pomlcka
			(,(\p{Z}|\~|\n)+a\p{Z})               # ... modulo 10, a~timto prvkem ...; TODO: plati tohle i pro "i"?
		)/x

		def run
			# ~ neni mezi \p{Z}.
			# TODO: moznosti na dvojpismenne predlozky
			matches = @joined.to_enum(:scan, REGEX).map { Regexp.last_match }

			until matches.empty?
				for i in 0...matches.length
					# TODO: check ze za tim neni tilda nikde (napr. na dalsim radku, par mezer pozdeji, ...)
					match = matches[i]
					change = match.end(0) - 1

					chunk, offset = _find_chunk_and_offset(change)

					chunk[offset] = '~'
				end
			
				_rejoin
				matches = @joined.to_enum(:scan, REGEX).map { Regexp.last_match }
			end
		end
	end
end
