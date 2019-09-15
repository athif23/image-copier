export class Utils
	###
	* Capitalize a given string, like, from "test" to "Test"
	* @string (str) -> Text to capitalize
	* >> @string
	###
	def self.capitalize(str)
		str[0].toUpperCase + str.slice(1)
		
	### 
	* Convert to any unit
	* @number sizes   -> Object of the sizes to be converted
	* @number density -> Number to determine the density of the file we want
	* @object options -> "from" unit and "to" unit to select which unit to convert to
	* >> @number
	###
	def self.convertTo(options = {  from: "cm", to: "px" }, number = 1, dpi = 72)
		if number isa String || dpi isa String
			number = parseInt(number)
			dpi = parseInt(dpi)

		# Convert to "px"
		if options:from === "px"
			switch options:to
				when "cm"
					return (number * (2.54 / dpi))
				when "mm"
					return (number * (25.4 / dpi))
				else
					return number

		# Convert from "cm"
		elif options:from === "cm"
			switch options:to
				when "px"
					return ((dpi / 2.54) * number)
				when "mm"
					return (number * 10)
				else
					return number

		# Convert from "mm"
		elif options:from === "mm"
			switch options:to
				when "px"
					return ((dpi / 25.4) * number)
				when "cm"
					return (number / 10)
				else
					return number