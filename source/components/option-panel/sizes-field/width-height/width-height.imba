import { UnitInput } from '../../unit-input/unit-input'
const _ = require('../../../../helpers'):Utils

export tag WidthHeight
	def render
		let isLock = data.@lockRatio ? '8M4 4V8' : '8'
		<self.two-inputs>
			<UnitInput[data] .warning=(data.@isError is 'width' || data.@isError is true) inputName="width" inputI=(data.@sizes:width) css:grid-column="2">
			<#space .lock-sign=(data.@lockRatio)>
			<UnitInput[data] .warning=(data.@isError is 'height' || data.@isError is true) inputName="height" inputI=(data.@sizes:height) css:grid-column="4">
			<#lock-box css:display="flex" css:justify-content="center" css:align-items="center">
				<label.lock-field> 
					<input[data.@lockRatio] type="checkbox">
					<span.lock-icon>
						<svg:svg width="13" height="16" viewBox="0 0 8 12" fill="none" xmlns="http://www.w3.org/2000/svg">
							<svg:path d="M1.02449 5C1.02449 5 0.528579 1 4 1C7.47143 1 6.97551 5 6.97551 5M1.02449 8C1.02449 8 0.528568 11 4 11C7.47143 11 6.97551 8 6.97551 {isLock}" stroke="black">
