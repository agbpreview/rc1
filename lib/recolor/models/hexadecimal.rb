module Recolor
	module Models
		class Hexadecimal < Model
			def rgb(tuple)
				hexadecimal = [
					tuple[0],
					tuple[1],
					tuple[2]
				]

				rgb = hexadecimal.map do |v|
					v = v + v if v.length == 1
					v = v.hex
					v = v / 255
				end

				return rgb
			end
		end
	end
end
