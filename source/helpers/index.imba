export class Utils
	###
	* Capitalize a given string
	* @string (str) -> Text to capitalize
	* >> @string
	###
	def self.capitalize str
		str[0].toUpperCase + str.slice(1)

	### 
	* Convert given files to base 64
	* @array (fileList) -> Array of files to be converted
	* >> @promise
	###
	def self.convertFileToBase64 fileList
		if !fileList || !fileList:length || !fileList[0]:size
			return Promise.reject('Not valid file')

		return Promise.new(do |resolve, reject|
			const reader = FileReader.new()
			reader:onload = do |e| resolve(e:target:result)
			reader:onerror = do |e| reject('Error converting')
			reader:readAsDataURL(fileList[0])
		)

	### 
	* Convert px to mm by a given sizes
	* @object sizes   -> Object of the sizes to be converted
	* @number density -> Number to determine the density of the file we want
	* >> @object
	###
	def self.convertPXtoMM(sizes, density = 96)
		let mmH = sizes:height * (25.4 / density)
		let mmW = sizes:width * (25.4 / density)

		return { height: mmH, width: mmW }