export class Utils
	###
	* Capitalize a given string, like, from "test" to "Test"
	* @string (str) -> Text to capitalize
	* >> @string
	###
	def self.capitalize(str)
		str[0].toUpperCase + str.slice(1)

	# * Numeral formatter
	def formatInput e
		if e:target:value === "" || e:target:value === 0
			e:target:value = "0"
		if e:target:value === '00'
			e:target:value = "0"
		e:target:value = e:target:value.replace(/[A-Za-z]/g, '').replace(/\-/g, '').replace(/^(-)?0+(?=\d)/, '$1')
		
	### 
	* Convert to any unit
	* @number sizes   -> Object of the sizes to be converted
	* @number density -> Number to determine the density of the file we want
	* @object options -> "from" unit and "to" unit to select which unit to convert to
	* >> @number
	###
	def self.convertTo(options = {  from: "cm", to: "px" }, number = 1, dpi = 72, rounded = false)
		if number isa String || dpi isa String
			number = parseFloat(number) || 0
			dpi = parseFloat(dpi) || 0

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
					return !rounded ? ((dpi / 2.54) * number) : Math.round((dpi / 2.54) * number)
				when "mm"
					return (number * 10)
				else
					return number

		# Convert from "mm"
		elif options:from === "mm"
			switch options:to
				when "px"
					return !rounded ? ((dpi / 25.4) * number) : Math.round((dpi / 25.4) * number)
				when "cm"
					return (number / 10)
				else
					return number