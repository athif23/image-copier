const _ = require('../helpers'):Utils
const jsPDF = require('jspdf')
const Paper = require('../js/Paper'):PaperS
const Image = require('../js/Image'):ImageS

export class Stores
	prop filename     # -> Generated file name
	prop sizes-list   # -> A list of paper's size
	prop sizes        # -> Sizes of the images, if 'default' will default to imageProps
	prop space        # -> Determine the space of each copy of the images in the layou
	prop margin       # -> Determine the margin of the sides layout or paper
	prop copies       # -> Number of the copy to make
	prop density      # -> Density of the resulted images
	prop format       # -> A page format ex. A4, A5, Legal, Letter, etc.
	prop autoFill     # -> Check if auto fill is true, if it's then fill the space automatically
	prop lockRatio    # -> Check if lock ratio is true, if it's then lock ratio of the images
	prop paper        # -> An Instance of Paper class to pass to the canvas
	prop isError	  # -> Is error happened?
	prop errorMessage # -> What's the message
	prop justifyContent	# -> Make sure the space between images is balanced
	prop optionVisible  # -> Check whether option panel visible or not
	prop cropBoxVisible # -> Check whether crop box visible or not

	# * Initialize the store
	def initialize
		@timer = 0 # for debounce function 
		@currentInput = 'width'

		@sizes-list = [
			{ title: 'A4 - 210 x 297 mm', value: "A4", width: 210, height: 297, unit: 'mm' },
			{ title: 'A3 - 297 x 420 mm', value: "A3", width: 297, height: 420, unit: 'mm' },
			{ title: 'A2 - 420 x 594 mm', value: "A2", width: 420, height: 594, unit: 'mm' },
			{ title: 'A1 - 594 x 841 mm', value: "A1", width: 594, height: 841, unit: 'mm' },
			{ title: 'Legal - 216 x 356 mm', value: "Legal", width: 216, height: 356, unit: 'mm' },
			{ title: 'Letter - 216 x 279 mm', value: "Letter", width: 216, height: 279, unit: 'mm' },
			{ title: 'Half-Letter - 140 x 216 mm', value: "Half-Letter", width: 140, height: 216, unit: 'mm' }
		]
		@sizes = {
			height: { value: "10", unit: "px" },
			width:  { value: "10", unit: "px" }
		}
		@filename = { value: "" }
		@space = { value: "1", unit: "px" }
		@margin = { value: "35", unit: "px" }
		@copies = { value: "323" }
		@density = { value: "72" }
		@format = { title: 'A4 - 210 x 297 mm', value: 'A4', width: 210, height: 297, unit: 'mm' }

		@errorMessage = "Paper is too small!"
		@isError = false
		@lockRatio = false
		@autoFill = false
		@justifyContent = false

		@optionVisible = true
		@cropBoxVisible = false

		@image = Image.new({
			width: _.convertTo({from: @sizes:width:unit, to: 'px'}, @sizes:width:value, @density:value),
			height: _.convertTo({from: @sizes:height:unit, to: 'px'}, @sizes:height:value, @density:value)
		})
		@paper = Paper.new({
			x: 10,
			y: 10,
			color: "white",
			fill: "white",
			stroke: "black",
			image: @image,
			dpi: parseInt(@density:value),
			copies: parseInt(@copies:value),
			width: _.convertTo({from: @format:unit, to: 'px'}, @format:width, @density:value),
			height:  _.convertTo({from: @format:unit, to: 'px'}, @format:height, @density:value),
			margin: {
				x: _.convertTo({from: @margin:unit, to: 'px'}, @margin:value, @density:value),
				y: _.convertTo({from: @margin:unit, to: 'px'}, @margin:value, @density:value)
			},
			space: {
				x: _.convertTo({from: @space:unit, to: 'px'}, @space:value, @density:value),
				y: _.convertTo({from: @space:unit, to: 'px'}, @space:value, @density:value)
			},
			autoFill: @autoFill,
			justifyContent: @justifyContent,
			lockAspectRatio: @lockRatio,
			unit: @format:unit
		})

	# * Generates a pdf file
	def generatePdf 
		@paper._printPDF(@filename:value)

	# * Checking if there's something we don't want to be inputted
	def checkError
		let width = _.convertTo({from: @sizes:width:unit, to: 'px'}, @sizes:width:value, @density:value)
		let height = _.convertTo({from: @sizes:height:unit, to: 'px'}, @sizes:height:value, @density:value)

		if @autoFill then return @isError = false

		if (width <= 0) && (height <= 0)
			@errorMessage = "Image sizes can't be zero or less!"
			return @isError = true
		elif width <= 0
			@errorMessage = "Width can't be zero or less!"
			return @isError = 'width'
		elif height <= 0
			@errorMessage = "Height can't be zero or less!"
			return @isError = 'height'
		elif parseInt(@copies:value) > @paper:_copiesLimit
			@errorMessage = "Paper is too small!"
			return @isError = 'copies'

		return @isError = false

	# * Check typing in sizes (width and height) input
	def checkType
		self.checkError()
		Imba.commit

		let width = _.convertTo({from: @sizes:width:unit, to: 'px'}, @sizes:width:value, @density:value)
		let height = _.convertTo({from: @sizes:height:unit, to: 'px'}, @sizes:height:value, @density:value)
		if (width <= 0) || (height <= 0)
			return

		# Debounced the render function
		clearTimeout(@timer)
		@timer = setTimeout(&, 550) do
			if @lockRatio && @currentInput === "width"
				@sizes:height:value = "{width * @paper:image:origHeight / @paper:image:origWidth}"
			elif @lockRatio && @currentInput === "height"
				@sizes:width:value = "{height * @paper:image:origWidth / @paper:image:origHeight}"
			
			@paper.imageSize = {
				width: _.convertTo({from: @sizes:width:unit, to: 'px'}, @sizes:width:value, @density:value),
				height: _.convertTo({from: @sizes:height:unit, to: 'px'}, @sizes:height:value, @density:value)
			}
			@paper.margin = {
				x: _.convertTo({from: @margin:unit, to: 'px'}, @margin:value, @density:value),
				y: _.convertTo({from: @margin:unit, to: 'px'}, @margin:value, @density:value)
			}
			@paper.space = {
				x: _.convertTo({from: @space:unit, to: 'px'}, @space:value, @density:value),
				y: _.convertTo({from: @space:unit, to: 'px'}, @space:value, @density:value)
			}
			@stage.batchDraw()
			Imba.commit()
