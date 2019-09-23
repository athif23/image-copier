import { SizesField } from './sizes-field/sizes-field'
import { FilesField } from './files-field/files-field'
import { GenerateField } from './generate-field/generate-field'

export tag OptionPanel
	def render
		<self>
			<div .header>
				<#title> 
					<h1 css:font-size="25px" css:padding="18px 0 0 29px" css:font-weight="500"> 
						"IMAGE COPIER"
				<SizesField[data]>
				<FilesField[data]>
				<GenerateField[data]>
			<.footer>
				<#copyright .small-text> 
					<a href="https://github.com/athif23/image-copier/"> 
						<svg:svg width="20" height="20" viewBox="0 0 34 33" fill="none" xmlns="http://www.w3.org/2000/svg">
							<svg:path fill="#1B1F23" fill-rule="evenodd" clip-rule="evenodd" d="M17 0C7.6075 0 0 7.57051 0 16.9173C0 24.4033 4.86625 30.7261 11.6237 32.9677C12.4737 33.1157 12.7925 32.6082 12.7925 32.1641C12.7925 31.7623 12.7713 30.4301 12.7713 29.0133C8.5 29.7957 7.395 27.9771 7.055 27.0255C6.86375 26.5391 6.035 25.0377 5.3125 24.6359C4.7175 24.3187 3.8675 23.5363 5.29125 23.5151C6.63 23.494 7.58625 24.7416 7.905 25.2491C9.435 27.8079 11.8788 27.0889 12.8563 26.6448C13.005 25.5452 13.4512 24.8051 13.94 24.3821C10.1575 23.9592 6.205 22.5001 6.205 16.0292C6.205 14.1894 6.86375 12.6669 7.9475 11.4827C7.7775 11.0597 7.1825 9.32569 8.1175 6.99955C8.1175 6.99955 9.54125 6.55547 12.7925 8.73358C14.1525 8.35294 15.5975 8.16262 17.0425 8.16262C18.4875 8.16262 19.9325 8.35294 21.2925 8.73358C24.5438 6.53433 25.9675 6.99955 25.9675 6.99955C26.9025 9.32569 26.3075 11.0597 26.1375 11.4827C27.2213 12.6669 27.88 14.1683 27.88 16.0292C27.88 22.5212 23.9063 23.9592 20.1238 24.3821C20.74 24.9108 21.2713 25.9258 21.2713 27.5118C21.2713 29.7745 21.25 31.5931 21.25 32.1641C21.25 32.6082 21.5688 33.1369 22.4188 32.9677C29.1338 30.7261 34 24.3821 34 16.9173C34 7.57051 26.3925 0 17 0Z">
				<#report> <a href="https://github.com/athif23/image-copier/issues"> "Found issue?"
