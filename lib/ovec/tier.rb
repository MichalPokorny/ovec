#!/usr/bin/ruby -w

module Ovec
	class Tier < TextManipulator
		# The last character this regex matches is changed to a tilde.
		REGEX = /(
			((\p{Z}|\~|\n)[KkSsVvZzOoUu]\p{Z})|   # KSVZOU jako samostatne slovo
			([\.\?\!](\p{Z}|\~)+[KSVZOUAI]\p{Z})| # KSVZOUAI na zacatku vety
			(\A[KSVZOUAI]\p{Z})|                  # KSVZOUAI na zacatku textu
			(\p{Z}(?=--\p{Z}))|                   # mezera, za kterou je pomlcka
			(,(\p{Z}|\~|\n)+a\p{Z})               # ... modulo 10, a~timto prvkem ...; TODO: plati tohle i pro "i"?
		)/x

		# TODO: generally tie "5.~batalion", ...
		# All changes within this regex are changed to a tilde.
		DATE_REGEX = /(
			(?<=\p{Z})\p{Nd}{1,2}\.\p{Z}
			(\p{Nd}{1,2}\.|leden|únor|březen|duben|květen|červen|červenec|srpen|září|říjen|listopad|prosinec|
				ledna|února|března|dubna|května|června|července|srpna|září|října|listopadu|prosince)\p{Z}
			\p{Nd}{4}(?=\p{Z}) # Datum jako "1. 5. 2013"
		)/x

		def run
			# ~ neni mezi \p{Z}.
			# TODO: moznosti na dvojpismenne predlozky
			matches = @joined.to_enum(:scan, REGEX).map { Regexp.last_match }

			# Matches may overlap, find all matches with more scans.
			# TODO: optimize
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

			# Dates can't overlap. 1 scan is enough.
			matches = @joined.to_enum(:scan, DATE_REGEX).map { Regexp.last_match }
			for i in 0...matches.length
				match = matches[i]
				for j in match.begin...match.end
					if @joined[j] == ' '
						chunk, offset = _find_chunk_and_offset(j)
						chunk[offset] = '~'
					end
				end
			end
		end
	end
end
