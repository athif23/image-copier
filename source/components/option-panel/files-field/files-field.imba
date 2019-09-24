const _ = require('../../../helpers'):Utils
import { FileInput } from './file-input/file-input'
import { PaperSizes } from './paper-sizes/paper-sizes'

export tag FilesField
	def mount
		self.@dom.addEventListener('input', do |e| self.checkType(e))

	def checkType e
		data.@paper.dpi = parseInt(data.@density:value)
		data.@paper.copies = parseInt(data.@copies:value)
		data.@stage.batchDraw()
		data.checkError()

	def showPreview
		let previewPanel = document.querySelector('.PreviewPanel')
		if !(_.isVisible(previewPanel))
			const selfW = self.@owner_.@owner_.@dom:clientWidth
			const selfH = self.@owner_.@owner_.@dom:clientHeight

			data.@stage.width(selfW)
			data.@stage.height(selfH)
			data.@stage.batchDraw()

			previewPanel:style:display = "flex"
			data.@optionVisible = false
			Imba.commit()

	def onPaperChange
		console.log data.@format

	def render
		<self css:padding="5px 0">
			<.files-field .two-inputs>
				<.density .double css:grid-column="2">
					<label.label for="density"> "DPI"
					<input@density[data.@density:value] .hidden-input name="density" type="text" maxlength="4">
				<#space>
				<.copies .double css:grid-column="4">
					<label.label for="copies"> "Copies"
					<input@copies[data.@copies:value] .hidden-input name="copies" type="text" maxlength="4" .last-input disabled=(data.@autoFill)>
				if data.@isError === 'copies'
					<.warning-box>
						<p> "{data.@errorMessage}"
			<.format>
				<label.label for="format"> "Format"
				<PaperSizes[data].format-paper .last-input>
			<FileInput[data]>
			if data.@paper:image:file
				<.preview-container>
					<button.preview :click.showPreview>
						<p> "PREVIEW"