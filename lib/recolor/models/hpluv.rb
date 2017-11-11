module Recolor
	module Models
		class HPLuv < Model
			def lch(tuple)
				h = tuple[0]
				s = tuple[1]
				l = tuple[2]

				return [100, 0.0, h] if l > 99.9999999
				return [0.0, 0.0, h] if l < 0.00000001

				chroma = HPLuv.chroma(l)
				c = chroma / 100.0 * s

				return [l, c, h]
			end

			def HPLuv.chroma(l)
				lengths = []

				HSLuv.bounds(l).each do |line|
					m = line[0]
					b = line[1]
					x = (b - 0.0) / ((-1.0 / m) - m)
					length = Math.sqrt(x**2 + (b + x * m)**2)
					lengths << length
				end

				return lengths.min
			end
		end
	end
end
