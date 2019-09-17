const _ = require('../../../helpers'):Utils
import { FileInput } from './file-input/file-input'

export tag FilesField
	def mount
		self.@dom.addEventListener('keyup', do |e| self.checkType(e))

	def checkType e
		data.@paper.dpi = parseInt(data.@density:value)
		data.@paper.copies = parseInt(data.@copies:value)
		self.checkAlert()
		data.@stage.batchDraw()

	# Check function if copies is over limit
	def checkAlert
		if parseInt(data.@copies:value) > data.@paper:_copiesLimit
			data.@paper._showAlertBox("copies")
		else
			let alertBox = @copies.@dom:parentNode.querySelector('.alertBox')
			alertBox && alertBox.remove()
			@copies.@dom:parentNode:classList.remove('warning')
			
	def render
		<self>
			<.images-input .two-inputs>
				<.density .double>
					<label.label for="density"> "DPI"
					<input@density[data.@density:value] .hidden-input name="density" type="text" maxlength="4">
				<.space>
				<.copies .double>
					<label.label for="copies"> "Copies"
					<input@copies[data.@copies:value] :click.checkAlert .hidden-input name="copies" type="text" maxlength="4">
			<.format>
				<label.label for="format"> "Format"
				<input@formatpaper[data.@format:value] name="format" type="text" maxlength="4">
			<FileInput[data]>