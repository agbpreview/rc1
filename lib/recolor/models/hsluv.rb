module Recolor
	module Models
		class HSLuv < Model
			def lch(tuple)
				h = tuple[0]
				s = tuple[1]
				l = tuple[2]

				return [100, 0.0, h] if l > 99.9999999
				return [0.0, 0.0, h] if l < 0.00000001

				chroma = HSLuv.chroma(l, h)
				c = chroma / 100.0 * s

				return [l, c, h]
			end

			def HSLuv.bounds(l)
				s = ((l + 16)**3) / 1560896.0
				s = s > EPSILON ? s : l / KAPPA
				matrix = RGB::MATRIX.to_a
				lines = []

				matrix.each do |m1, m2, m3|
					[0, 1].each do |d|
						bottom = (632260 * m3 - 126452 * m2) * s + 126452 * d
						m = ((284517 * m1 - 94839 * m3) * s) / bottom
						b = ((838422 * m3 + 769860 * m2 + 731718 * m1) * l * s - 769860 * d * l) / bottom
						lines << [m, b]
					end
				end

				return lines
			end

			def HSLuv.chroma(l, h)
				angle = h / 360.0 * Math::PI * 2.0
				lengths = []

				HSLuv.bounds(l).each do |line|
					m = line[0]
					b = line[1]
					length = b / (Math.sin(angle) - m * Math.cos(angle))
					lengths << length if length > 0
				end

				return lengths.min
			end
		end
	end
end
