module Recolor
	module Models
		class Model
			attr_accessor :format

			KAPPA = 903.2962962962963
			EPSILON = 0.0088564516790356308

			def initialize
				@format = lambda do |tuple|
					return tuple
				end
			end

			def print(tuple)
				return "#{@format.call(tuple)}"
			end
		end
	end
end
