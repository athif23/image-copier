import { SizesField } from './sizes-field/sizes-field'
import { FilesField } from './files-field/files-field'

export tag OptionPanel
	def render
		<self>
			<div css:display="grid" css:grid-template-rows="0.5fr 1fr 1fr 1fr">
				<.title> <h1> "IMAGE COPIER"
				<SizesField[data]>
				<FilesField[data]>
				<.generate-field>
					<input@filename[data.@filename:value] type="text" placeholder="Generated file name?">
					<button.generate-button :click=(do data.@paper._printPDF(data.@filename:value))> 
						if data.@paper:_isLoading
							<div .lds-ellipsis css:margin-top="-10px" css:outline="none">
								<div>
								<div>
								<div>
								<div>
						else
							"GENERATE"
			<.footer>
				<.copyright> 
					<p> 
					"Made by " 
					<a href="https://github.com/athif23" .github> "At Indo"
				<.donate> <button> "DONATES"