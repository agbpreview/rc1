module Recolor
	class Converter
		attr_accessor :models

		def initialize
			@models = {}
		end

		def convert(tuple, source, destination)
			return tuple unless source != destination

			raise ArgumentError.new("No #{source} model found.") unless @models.include?(source)

			@steps = []
			resolve(source, destination, @models)

			raise ArgumentError.new("Unable to convert from #{source} to #{destination}.") if @steps.empty?

			model = @models[source]

			@steps.each do |step|
				tuple = model.send(step, tuple)
				model = @models[step]
			end

			return tuple
		end

		private

		def resolve(source, destination, models)
			model = models[source]
			models = models.reject { |name| name == source }

			models.keys.each do |name|
				if model.respond_to?(destination)
					@steps << destination
				end

				if @steps.include?(destination)
					break
				end

				if model.respond_to?(name)
					@steps << name
					resolve(name, destination, models)
				end
			end

			@steps = @steps.reject { |name| name == source } unless @steps.include?(destination)
		end
	end
end
