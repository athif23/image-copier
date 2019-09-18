import { UnitsButton } from './units-button/units-button'
const _ = require('../../../helpers'):Utils

export tag UnitInput
	prop inputName
	prop inputI

	def mount
		@input.@dom.addEventListener('input', self:formatInput)
		@input.@dom.addEventListener('blur', self:formatInput)

	# Numeral formatter
	def formatInput e
		if e:target:value === "" || e:target:value === 0
			e:target:value = "0"
		if e:target:value === '00'
			e:target:value = "0"
		e:target:value = e:target:value.replace(/[A-Za-z]/g, '').replace(/\-/g, '').replace(/^(-)?0+(?=\d)/, '$1')

	def render
		<self>
			<.{@inputName} .input>
				<label.label for="{@inputName}"> "{_.capitalize(@inputName)}"
				<input@input[@inputI:value] .{@inputName} name="{@inputName}" type="text" value="0">
				<UnitsButton data=(@inputI)>
