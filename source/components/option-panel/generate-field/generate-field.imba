export tag GenerateField
	def onGenerate e
		data.@paper._printPDF(data.@filename:value)

	def render
		<self>
			<input@filename[data.@filename:value] type="text" :keyup.onGenerate placeholder="Generated file name?">
			<button .loading=(data.@paper:_isLoading) :click.onGenerate> 
				if data.@paper:_isLoading
					<div .lds-ellipsis css:margin-top="-10px" css:outline="none">
						<div>
						<div>
						<div>
						<div>
				else
					"GENERATE"