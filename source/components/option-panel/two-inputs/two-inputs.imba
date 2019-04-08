import { UnitsButton } from '../units-button/units-button'
const _ = require('../../../helpers'):Utils

export tag TwoInputs
	prop firstI
	prop secondI

	def render
		<self>
			<.{@firstI:name} .input>
				<label.label for="{@firstI:name}"> "{_.capitalize(@firstI:name)}"
				<input@first[@firstI:value] name="{@firstI:name}" type="text" value="0">
				<UnitsButton data=@firstI>
			<.space>
			<.{@secondI:name} .input>
				<label.label for="{@secondI:name}"> "{_.capitalize(@secondI:name)}"
				<input@second[@secondI:value] name="{@secondI:name}" type="text" value="0">
				<UnitsButton data=@secondI>
