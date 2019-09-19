export tag GenerateField
	def render
		<self>
			<input@filename[data.@filename:value] type="text" :keyup.data.generatePdf placeholder="Generated file name?">
			<button .loading=(data.@paper:_isLoading) :click.data.generatePdf> 
				if data.@paper:_isLoading
					<div .lds-ellipsis css:margin-top="-10px" css:outline="none">
						<div>
						<div>
						<div>
						<div>
				else
					"GENERATE"