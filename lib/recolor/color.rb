module Recolor
	class Color
		attr_accessor :model
		attr_accessor :tuple

		def initialize(model, tuple)
			@model = model
			@tuple = tuple
		end
	end
end
