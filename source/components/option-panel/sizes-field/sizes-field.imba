const _ = require('../../../helpers'):Utils
import { TwoInputs } from '../two-inputs/two-inputs'
import { WidthHeight } from './width-height/width-height'

export tag SizesField
	def mount
		@currentInput = "width"
		@timer = 0

		self.@dom.addEventListener('keyup', do |e| self.checkType(e))
		self.@dom.querySelector('input.width').addEventListener('click', do |e| self.checkInput(e))
		self.@dom.querySelector('input.height').addEventListener('click', do |e| self.checkInput(e))
		self.@dom.querySelector('label.lock-field').addEventListener('click', do |e| self.checkRatio(e))

	# Check when lock ratio button checked
	def checkRatio
		if !data.@lockRatio
			if (data.@paper:image:origWidth <= 0) && (data.@paper:image:origHeight <= 0)
				return
			let width = _.convertTo({from: data.@sizes:width:unit, to: 'px'}, data.@sizes:width:value, data.@density:value)
			let height = _.convertTo({from: data.@sizes:height:unit, to: 'px'}, data.@sizes:height:value, data.@density:value)
			if @currentInput === "width"
				data.@sizes:height:value = "{data.@sizes:width:value * data.@paper:image:origHeight / data.@paper:image:origWidth}"
			elif @currentInput === "height"
				data.@sizes:width:value = "{data.@sizes:height:value * data.@paper:image:origWidth / data.@paper:image:origHeight}"
			Imba.commit

		self.checkType

	# Check typing in sizes (width and height) input
	def checkType
		let width = _.convertTo({from: data.@sizes:width:unit, to: 'px'}, data.@sizes:width:value, data.@density:value)
		let height = _.convertTo({from: data.@sizes:height:unit, to: 'px'}, data.@sizes:height:value, data.@density:value)

		if ((data.@paper:image:origWidth <= 0) && (data.@paper:image:origHeight <= 0))
			data.@paper:image:origWidth = width
			data.@paper:image:origHeight = height

		# Debounced the render function
		clearTimeout(@timer)
		@timer = setTimeout(&, 550) do
			if data.@lockRatio && @currentInput === "width"
				data.@sizes:height:value = "{width * data.@paper:image:origHeight / data.@paper:image:origWidth}"
			elif data.@lockRatio && @currentInput === "height"
				data.@sizes:width:value = "{height * data.@paper:image:origWidth / data.@paper:image:origHeight}"
			Imba.commit
			
			data.@paper.imageSize = {
				width: _.convertTo({from: data.@sizes:width:unit, to: 'px'}, data.@sizes:width:value, data.@density:value),
				height: _.convertTo({from: data.@sizes:height:unit, to: 'px'}, data.@sizes:height:value, data.@density:value)
			}
			data.@paper.margin = {
				x: _.convertTo({from: data.@margin:unit, to: 'px'}, data.@margin:value, data.@density:value),
				y: _.convertTo({from: data.@margin:unit, to: 'px'}, data.@margin:value, data.@density:value)
			}
			data.@paper.space = {
				x: _.convertTo({from: data.@space:unit, to: 'px'}, data.@space:value, data.@density:value),
				y: _.convertTo({from: data.@space:unit, to: 'px'}, data.@space:value, data.@density:value)
			}
			data.@stage.batchDraw()

	# Check every input
	def checkInput(evt)
		if evt:target:className === 'first width'
			@currentInput = "width"
		elif evt:target:className === 'second height'
			@currentInput = "height"

		# Check if sizes are bigger than the paper
		if data.@paper:_overSize
			data.@paper._showAlertBox('size', "Size is too big! This paper can't contain it.", "Use bigger paper or just make image smaller.")
		else
			let alertBox = self.@dom.querySelector('.alertBox')
			alertBox && alertBox.remove()
			self.@dom:classList.remove('warning')

		# Check if sizes is lower than 1
		if data.@paper:image.width() <= 0 || data.@paper:image.height() <= 0
			data.@paper._showAlertBox('size', "Sizes is too small.", "Sizes can't be lower than 1. (Not even 0.99)")
		else
			let alertBox = self.@dom.querySelector('.alertBox')
			alertBox && alertBox.remove()
			self.@dom:classList.remove('warning')

	def onchange
		data.@paper.autoFill = data.@autoFill
		data.@paper.lockAspectRatio = data.@lockRatio
		data.@paper.justifyContent = data.@justifyContent

		if data.@autoFill
			document.querySelector('input.copies').setAttribute('disabled', true)
			document.querySelector('input.copies').setAttribute('style', "cursor: not-allowed")
			(data.@paper:_removeCopiesAlert && data.@paper._removeCopiesAlert())
		else
			document.querySelector('input.copies').removeAttribute('disabled')
			document.querySelector('input.copies').setAttribute('style', "cursor: auto")

		let space = self.@dom:firstElementChild.querySelector('.space')
		if data.@lockRatio
			space:classList.add('lock-ratio')
		else
			space:classList.remove('lock-ratio')

		data.@stage.batchDraw()

	def render
		<self>
			<WidthHeight[data] widthName="width" widthI=(data.@sizes:width) heightName="height" heightI=(data.@sizes:height)>
			<TwoInputs firstName="space" firstI=(data.@space) secondName="margin" secondI=(data.@margin)>
			<.check-field>
				<label.auto-field> "Auto Fill"
					<input[data.@autoFill] type="checkbox">
					<span.autofill>
				<.space>
				<label.justify-field> "Justify Images"
					<input[data.@justifyContent] type="checkbox">
					<span.justifycontent>
			<.separator> <div>
