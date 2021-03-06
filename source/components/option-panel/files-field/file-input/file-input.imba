export tag FileInput
	prop labelText default: "Select File"

	def fileSelected(event)
		if event.target.@dom:files && event.target.@dom:files:length > 0
			let name = event.target.@dom:value.split("\\").pop()
			
			# When too long, cut it until 33 char and add ellipses at the end
			@labelText = name.substring(0, 15):length >= 15 ? "{name.substring(0, 15)}..." : name
			
			let reader = FileReader.new()
			reader.readAsDataURL(event.target.@dom:files[0])
			reader:onload = do |e|
				if data.@paper:image:file !== reader
					data.@paper:image:file = Image.new()
					data.@paper:image:file:src = reader:result

					data.@paper:image:file:onload = do |e|
						let width = data.@paper:image:file:width
						let height = data.@paper:image:file:height

						data.@paper:image:origWidth = width
						data.@paper:image:origHeight = height
						data.@sizes:width:value = "{width / 2}"
						data.@sizes:height:value = "{height / 2}"
						data.@paper.imageSize = {
							width: width / 2,
							height: height / 2
						}
						
						Imba.commit()
						data.@paper.@isChanged = true
						data.@stage.batchDraw()

					data.@paper:image:file:onerror = do |e|
						console.log(e)

	def render
		<self>
			<input#files name="files"  type="file" :change.fileSelected>
			<label for="files"> 
				<svg:svg width="14" height="13" viewBox="0 0 14 13" fill="none" xmlns="http://www.w3.org/2000/svg">
					<svg:path d="M10.5683 4.52518L7.04317 1L3.51799 4.52518M7.04317 8.05035V1.5036V8.05035Z" stroke="white" stroke-width="1.33" stroke-linecap="round" stroke-linejoin="round">
					<svg:path d="M1 8.11511V11C1 11.5523 1.44771 12 2 12H12.0863C12.6386 12 13.0863 11.5523 13.0863 11V8.11511" stroke="white" stroke-width="1.33">
				"{@labelText}"
			<button.crop-image :click=(do data.@cropBoxVisible = true)>
				<svg:svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#000000" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
					<svg:polygon points="14 2 18 6 7 17 3 17 3 13 14 2">
					<svg:line x1="3" y1="22" x2="21" y2="22">