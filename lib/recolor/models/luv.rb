module Recolor
	module Models
		class Luv < Model
			REFERENCE_U = 0.19783000664283
			REFERENCE_V = 0.46831999493879

			def xyz(tuple)
				l = tuple[0]
				u = tuple[1]
				v = tuple[2]

				return [0.0, 0.0, 0.0] if l == 0.0

				y = l > 8 ? XYZ::REFERENCE_Y * ((l + 16.0) / 116.0)**3.0 : XYZ::REFERENCE_Y * l / KAPPA
				u = u / (13.0 * l) + REFERENCE_U
				v = v / (13.0 * l) + REFERENCE_V
				x = 0.0 - (9.0 * y * u) / ((u - 4.0) * v - u * v)
				z = (9.0 * y - (15.0 * v * y) - (v * x)) / (3.0 * v)

				return [x, y, z]
			end

			def lch(tuple)
				l = tuple[0]
				u = tuple[1]
				v = tuple[2]
				c = Math.sqrt(u * u + v * v)
				h = Math.atan2(v, u) * 180 / Math::PI
				h = h < 0.0 ? h + 360.0 : h

				return [l, c, h]
			end
		end
	end
end
