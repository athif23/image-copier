import { TwoInputs } from '../two-inputs/two-inputs'

export tag SizesField
	prop width default: {
		name: 'width',
		value: "0",
		unit: "px"
	}
	prop height default: {
		name: 'height', 
		value: "0", 
		unit: "px"
	}
	prop spaces default: {
		name: 'spaces', 
		value: "0", 
		unit: "px"
	}
	prop gutter default: {
		name: 'gutter', 
		value: "0", 
		unit: "px"
	}

	def onchange
		data.@sizes = {
			height : { value: @height:value,	unit: @height:unit }
			width  : { value: @width:value, unit: @width:unit }
		}
		data.@spaces = { value: @spaces:value, unit: @spaces:unit }
		data.@gutter = { value: @gutter:value, unit: @gutter:unit }

	def render
		<self>
			<TwoInputs firstI=width secondI=height>
			<TwoInputs firstI=spaces secondI=gutter>
			<.check-field>
				<label.auto-field> "Auto Fill"
					<input[data.@isAutoFill] type="checkbox">
					<span.autofill>
				<.space>
				<label.lock-field> "Lock Ratio"
					<input[data.@isLockRatio] type="checkbox">
					<span.lockratio>
			<.separator> <div>
