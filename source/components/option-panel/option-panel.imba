import { SizesField } from './sizes-field/sizes-field'
import { FilesField } from './files-field/files-field'

export tag OptionPanel
	def render
		<self>
			<.title> <h1> "IMAGE COPIER"
			<SizesField[data]>
			<FilesField[data]>
			<.generate-field>
				<input@filename type="text" placeholder="Generated file name?">
				<button :click=(do data.generatePdf())> "GENERATE"
			<.footer>
				<.copyright> <p> "Made by At Indo"
				<.donate> <button> "DONATES"