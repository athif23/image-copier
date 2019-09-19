const _ = require('../../../helpers'):Utils
import { FileInput } from './file-input/file-input'

export tag FilesField
	def mount
		self.@dom.addEventListener('input', do |e| self.checkType(e))

	def checkType e
		data.@paper.dpi = parseInt(data.@density:value)
		data.@paper.copies = parseInt(data.@copies:value)
		data.@stage.batchDraw()
		data.checkError()

	def render
		<self css:padding="5px 0">
			<.files-field .two-inputs>
				<.density .double css:grid-column="2">
					<label.label for="density"> "DPI"
					<input@density[data.@density:value] .hidden-input name="density" type="text" maxlength="4">
				<#space>
				<.copies .double css:grid-column="4">
					<label.label for="copies"> "Copies"
					<input@copies[data.@copies:value] .hidden-input name="copies" type="text" maxlength="4" disabled=(data.@autoFill)>
				if data.@isError === 'copies'
					<.warning-box>
						<p> "{data.@errorMessage}"
			<.format>
				<label.label for="format"> "Format"
				<input@formatpaper[data.@format:value] name="format" type="text" maxlength="4">
			<FileInput[data]>