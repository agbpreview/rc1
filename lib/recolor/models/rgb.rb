require "matrix"

module Recolor
	module Models
		class RGB < Model
			MATRIX = Matrix[
				[3.240969941904521, -1.537383177570093, -0.498610760293],
				[-0.96924363628087, 1.87596750150772, 0.041555057407175],
				[0.055630079696993, -0.20397695888897, 1.056971514242878]
			]

			def hexadecimal(tuple)
				hexadecimal = tuple.map do |v|
					v = v * 255
					v = v.round
					v = v.to_s(16)
					v = v.length == 1 ? "0" + v : v
				end

				return hexadecimal
			end

			def xyz(tuple)
				rgb = tuple.map do |v|
					v < 0.04045 ? v / 12.92 : ((v + 0.055) / 1.055)**2.4
				end

				rgb = Matrix[rgb].transpose
				xyz = XYZ::MATRIX * rgb
				xyz = xyz.transpose
				xyz = xyz.row(0)
				xyz = xyz.to_a

				return xyz
			end
		end
	end
end
