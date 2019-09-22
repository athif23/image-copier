export tag GenerateField
	def generateOnEnter(e)
		if e.@event:keyCode === 13
			data.generatePdf()

	def onGenerate
		data.generatePdf()

	def render
		<self>
			<input@filename[data.@filename:value] type="text" :keyup.generateOnEnter placeholder="Generated file name?">
			<button .loading=(data.@paper:_isLoading) :click.onGenerate> 
				if data.@paper:_isLoading
					<div .lds-ellipsis css:margin-top="-10px" css:outline="none">
						<div>
						<div>
						<div>
						<div>
				else
					"GENERATE"