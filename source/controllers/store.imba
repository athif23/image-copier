const _ = require('../helpers'):Utils
const jsPDF = require('jspdf')

export class Stores
	prop sizes       # -> Sizes of the images, if 'default' will default to imageProps
	prop spaces      # -> Determine the spaces of each copy of the images in the layou
	prop gutter      # -> Determine the margin of the sides layout or paper
	prop copies      # -> Number of the copy to make
	prop density     # -> Density of the resulted images
	prop format      # -> A page format ex. A4, A5, Legal, Letter, etc.
	prop isAutoFill  # -> Check if auto fill is true, if it's then fill the space automatically
	prop isLockRatio # -> Check if lock ratio is true, if it's then lock ratio of the images

	# * Initialize the store
	def initialize
		@sizes = {
			height: { value: "0", unit: "px"	}
			width:  { value: "0", unit: "px" }
		}
		@spaces      = { value: "0", unit: "px" }
		@gutter      = { value: "0", unit: "px" }
		@copies      = { value: "0" }
		@density     = { value: "96" }
		@isLockRatio = false
		@isAutoFill  = true

	# * Generates a pdf file
	def generatePdf 
		const doc = jsPDF.new({
			orientation: 'potrait',
			unit: 'mm',
			format: "{@format.toLowerCase}"
		})
		const data       = await _.convertFileToBase64(@file.@dom:files)
		const imageProps = doc.getImageProperties(data)
		const sizesInMM  = _.convertPXtoMM({ width: imageProps:width, height: imageProps:height }, 300)
		
		if @sizes !== 'default'
			imageProps:width  = @sizes:width
			imageProps:height = @sizes:height 

		doc.addImage("{data}", "{imageProps:fileType}", 0, 0, sizesInMM:width, sizesInMM:height)
		doc.save('a4.pdf')