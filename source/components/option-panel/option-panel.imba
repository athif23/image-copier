import { SizesField } from './sizes-field/sizes-field'
import { FilesField } from './files-field/files-field'
import { GenerateField } from './generate-field/generate-field'

export tag OptionPanel
	def render
		<self>
			<div css:display="grid" css:grid-template-rows="0.5fr 1fr 1fr 1fr">
				<#title> 
					<h1 css:font-size="25px" css:padding="18px 0 0 29px" css:font-weight="500"> 
						"IMAGE COPIER"
				<SizesField[data]>
				<FilesField[data]>
				<GenerateField[data]>
			<.footer>
				<#copyright .small-text> 
					<p> 
						"Made by " 
						<a #github href="https://github.com/athif23" css:font-weight="500" css:text-decoration="underline"> "At Indo"
				<#donate> <button> "DONATES"