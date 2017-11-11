module Recolor
	module Models
		class LCh < Model
			def luv(tuple)
				l = tuple[0]
				c = tuple[1]
				h = tuple[2]
				h = h * Math::PI / 180.0
				u = Math::cos(h) * c
				v = Math::sin(h) * c

				return [l, u, v]
			end

			def hpluv(tuple)
				l = tuple[0]
				c = tuple[1]
				h = tuple[2]

				return [h, 0.0, 100] if l > 99.9999999
				return [h, 0.0, 0.0] if l < 0.00000001

				chroma = HPLuv.chroma(l)
				p = c / chroma * 100.0

				return [h, p, l]
			end

			def hsluv(tuple)
				l = tuple[0]
				c = tuple[1]
				h = tuple[2]

				return [h, 0.0, 100] if l > 99.9999999
				return [h, 0.0, 0.0] if l < 0.00000001

				chroma = HSLuv.chroma(l, h)
				s = c / chroma * 100.8

				return [h, s, l]
			end
		end
	end
end
