import { UnitsButton } from '../../two-inputs/units-button/units-button'
const _ = require('../../../../helpers'):Utils

export tag WidthHeight
	prop widthName
	prop widthI
	prop heightName
	prop heightI

	def mount
		@width.@dom.addEventListener('input', _:formatInput)
		@width.@dom.addEventListener('blur', _:formatInput)
		@height.@dom.addEventListener('input', _:formatInput)
		@height.@dom.addEventListener('blur', _:formatInput)

	def render
		let isLock = data.@lockRatio ? '8M4 4V8' : '8'
		<self>
			<.{@widthName} .input css:grid-column="2">
				<label.label for="{@widthName}"> "{_.capitalize(@widthName)}"
				<input@width[@widthI:value] .{@widthName} name="{@widthName}" type="text" value="0">
				<UnitsButton data=(@widthI)>
			<.space>
			<.{@heightName} .input css:grid-column="4">
				<label.label for="{@heightName}"> "{_.capitalize(@heightName)}"
				<input@height[@heightI:value] .{@heightName} name="{@heightName}" type="text" value="0">
				<UnitsButton data=(@heightI)>
			<.auto-box>
				<label.lock-field> 
					<input[data.@lockRatio] type="checkbox">
					<span.lockratio>
						<svg:svg width="13" height="16" viewBox="0 0 8 12" fill="none" xmlns="http://www.w3.org/2000/svg">
							<svg:path d="M1.02449 5C1.02449 5 0.528579 1 4 1C7.47143 1 6.97551 5 6.97551 5M1.02449 8C1.02449 8 0.528568 11 4 11C7.47143 11 6.97551 8 6.97551 {isLock}" stroke="black">
