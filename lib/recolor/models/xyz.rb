module Recolor
	module Models
		class XYZ < Model
			MATRIX = Matrix[
				[0.41239079926595, 0.35758433938387, 0.18048078840183],
				[0.21263900587151, 0.71516867876775, 0.072192315360733],
				[0.019330818715591, 0.11919477979462, 0.95053215224966]
			]
			REFERENCE_X = 0.95045592705167
			REFERENCE_Y = 1.0
			REFERENCE_Z = 1.089057750759878

			def rgb(tuple)
				xyz = Matrix[tuple].transpose
				rgb = RGB::MATRIX * xyz

				rgb = rgb.map do |v|
					v <= 0.0031308 ? 12.92 * v : (1.055 * (v**(1.0 / 2.4)) - 0.055)
				end

				rgb = rgb.transpose
				rgb = rgb.row(0)
				rgb = rgb.to_a

				return rgb
			end

			def luv(tuple)
				x = tuple[0]
				y = tuple[1]
				z = tuple[2]
				l = y > EPSILON ? l = 116.0 * ((y / REFERENCE_Y)**(1.0 / 3.0)) - 16.0 : l = y / REFERENCE_Y * KAPPA

				return [0.0, 0.0, 0.0] if l == 0.0

				u = (4.0 * x) / (x + (15.0 * y) + (3.0 * z))
				v = (9.0 * y) / (x + (15.0 * y) + (3.0 * z))
				u = 13.0 * l * (u - Luv::REFERENCE_U)
				v = 13.0 * l * (v - Luv::REFERENCE_V)

				return [l, u, v]
			end
		end
	end
end
