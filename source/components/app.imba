import { OptionPanel } from './option-panel/option-panel'
import { PreviewPanel } from './preview-panel/preview-panel'
const Cropper = require('../js/cropperjs/cropper.min')

tag CropBox
	def mount
		if data.@paper:image:file && document.contains(@image-container.@dom)
			let child = @image-container.@dom:lastElementChild  
			while child
				@image-container.@dom.removeChild(child)
				child = @image-container.@dom:lastElementChild
			let	img = Image.new()
			if data.@paper:image:file isa Image
				img:src = data.@paper:image:file:src
			else
				img:src = data.@paper:image:file.toDataURL()
			img:style:width = "{data.@paper:image:origWidth / 2}px"
			@image-container.@dom.appendChild(img)
			@cropper = Cropper.new(@image-container.@dom:firstElementChild, {
				minContainerWidth: 300,
				minContainerHeight: 300
			})

	def getCroppedImage
		@cropped-img = @cropper.getCroppedCanvas()
		if @cropped-img
			data.@paper:image:file = @cropped-img
			data.@sizes:width:value = "{@cropped-img:width / 2}"
			data.@sizes:height:value = "{@cropped-img:height / 2}"
			Imba.commit()
			data.@paper.imageSize = {
				width: @cropped-img:width / 2,
				height: @cropped-img:height / 2
			}
			data.@paper:image:origWidth = @cropped-img:width
			data.@paper:image:origHeight = @cropped-img:height

			data.@paper.@isChanged = true
			data.@stage.batchDraw()

	def close
		data.@cropBoxVisible = false

	def unmount
		self.@dom.remove()

	def render
		<self>
			<.crop-box :click.close>
			<.crop-image-box>
				if data.@paper:image:file
					<div@image-container css:max-width="{window:innerWidth - 25}px" css:max-height="{window:innerHeight - 110}px">
					<.option-buttons .btn--combine-2>
						<button.btn :click.close> "Close"
						<button.btn .btn--secondary :click.getCroppedImage> "Apply"
				else
					<h2 css:font-weight="200" css:font-size="18px"> "You didn't have image to crop."
					<p css:font-size="15px" css:margin-top="5px"> "Select image first."
					<button.btn .btn--secondary :click.close> "Okay"

export tag App
	def render
		<self>
			if data.@cropBoxVisible
				<CropBox[data]>
			if data.@optionVisible
				<.option-container>
					<OptionPanel[data]>
			<PreviewPanel[data]>