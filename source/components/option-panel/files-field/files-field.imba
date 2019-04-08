import { FileInput } from '../file-input/file-input'

export tag FilesField
	def render
		<self>
			<.images-input .two-inputs>
				<.density .double>
					<label.label for="density"> "Density"
					<input@density[data.@density:value] .hidden-input name="density" type="text" value="96" maxlength="4">
				<.space>
				<.copies .double>
					<label.label for="copies"> "Copies"
					<input@copies[data.@copies:value] .hidden-input name="copies" type="text" value="96" maxlength="4">
			<.format>
				<label.label for="format"> "Format"
				<input@formatpaper name="format" type="text" value="96" maxlength="4">
			<FileInput>