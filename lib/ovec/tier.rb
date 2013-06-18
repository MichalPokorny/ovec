#!/usr/bin/ruby -w

module Ovec
	class Tier < TextManipulator
		# The last character this regex matches is changed to a tilde.
		REGEX = /(
			((\p{Z}|[~\n(\[\{]|\A)[KkSsVvZzOoUu](\p{Z}|\n|\Z))|   # KSVZOU jako samostatne slovo
			((([\.\?\!](\p{Z}|\~)+)|(\A\p{Z}*))[KSVZOUAI](\p{Z}|\n))| # KSVZOUAI na zacatku vety
			(\p{Z}(?=--(\p{Z}|\n)))|              # mezera, za kterou je pomlcka
			(,(\p{Z}|\~|\n)+a(\p{Z}|\n))               # ... modulo 10, a~timto prvkem ...; TODO: plati tohle i pro "i"?
		)/x

		# TODO: generally tie "5.~batalion", ...
		# All changes within this regex are changed to a tilde.
		DATE_REGEX = /(
			(?<=\p{Z}|\A)\p{Nd}{1,2}\.\p{Z}
			(\p{Nd}{1,2}\.|leden|únor|březen|duben|květen|červen|červenec|srpen|září|říjen|listopad|prosinec| # TODO: plne sklonovani? nebo nejaky wildcard?
				ledna|února|března|dubna|května|června|července|srpna|září|října|listopadu|prosince)\p{Z}
			\p{Nd}{4}(?=(\p{Z}|[.,?!]|\Z)) # Datum jako "1. 5. 2013"
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

					former_character = chunk[offset]

					chunk[offset] = '~'

					if former_character == '\n'
						# If we changed a newline to a tilde, change previous space to a
						# newline -- move the tied word to the other line.
						j = change - 1
						while j >= 0
							break if @joined[j] == '\n' # Don't cross newlines.

							if @joined[j] == ' '
								chunk, offset = _find_chunk_and_offset(j)
								chunk[offset] = '\n'
								break
							end
							j -= 1
						end
					end
				end
			
				_rejoin
				matches = @joined.to_enum(:scan, REGEX).map { Regexp.last_match }
			end

			# Dates can't overlap. 1 scan is enough.
			matches = @joined.to_enum(:scan, DATE_REGEX).map { Regexp.last_match }
			for match in matches
				for i in (match.begin(0))...(match.end(0))
					if @joined[i] == ' '
						chunk, offset = _find_chunk_and_offset(i)
						chunk[offset] = '~'
					end
				end
			end
		end
	end
end
