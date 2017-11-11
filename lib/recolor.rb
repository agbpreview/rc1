require "recolor/version"

module Recolor
	require "recolor/color"
	require "recolor/models"
	require "recolor/models/hexadecimal"
	require "recolor/models/hsluv"
	require "recolor/models/hpluv"
	require "recolor/models/lch"
	require "recolor/models/luv"
	require "recolor/models/rgb"
	require "recolor/models/xyz"
	require "recolor/converter"

	class Recolor
		attr_accessor :converter
		attr_accessor :models

		def initialize
			@models = {}
			@models[:hexadecimal] = Models::Hexadecimal.new
			@models[:hpluv] = Models::HPLuv.new
			@models[:hsluv] = Models::HSLuv.new
			@models[:lch] = Models::LCh.new
			@models[:luv] = Models::Luv.new
			@models[:rgb] = Models::RGB.new
			@models[:xyz] = Models::XYZ.new
			@converter = Converter.new
			@converter.models[:hexadecimal] = @models[:hexadecimal]
			@converter.models[:hpluv] = @models[:hpluv]
			@converter.models[:hsluv] = @models[:hsluv]
			@converter.models[:lch] = @models[:lch]
			@converter.models[:luv] = @models[:luv]
			@converter.models[:rgb] = @models[:rgb]
			@converter.models[:xyz] = @models[:xyz]
		end

		def color(model, tuple)
			@color = Color.new(model, tuple)

			return self.clone
		end

		def to(model)
			raise Exception.new("Color definition not found.") unless @color

			source = @color.model
			tuple = @color.tuple
			tuple = @converter.convert(tuple, source, model)

			return color(model, tuple)
		end

		def model
			return @color.model
		end

		def tuple
			return @color.tuple
		end

		def format
			yield @color.tuple
		end

		def to_s
			return @models[model].print(tuple)
		end
	end
end
