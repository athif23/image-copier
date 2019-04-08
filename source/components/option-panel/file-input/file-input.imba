export tag FileInput
	prop labelText default: "Select File"

	def fileSelected e
		console.log e.target.@dom:files
		if e.target.@dom:files && e.target.@dom:files:length > 0
			@labelText = e.target.@dom:value.split("\\").pop()

	def render
		<self .files>
			<input@file name="files" #files type="file" :change.fileSelected>
			<label for="files"> 
				<svg:svg width="14" height="13" viewBox="0 0 14 13" fill="none" xmlns="http://www.w3.org/2000/svg">
					<svg:path d="M10.5683 4.52518L7.04317 1L3.51799 4.52518M7.04317 8.05035V1.5036V8.05035Z" stroke="white" stroke-width="1.33" stroke-linecap="round" stroke-linejoin="round">
					<svg:path d="M1 8.11511V11C1 11.5523 1.44771 12 2 12H12.0863C12.6386 12 13.0863 11.5523 13.0863 11V8.11511" stroke="white" stroke-width="1.33">
				"{@labelText}"