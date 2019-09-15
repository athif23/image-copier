import { UnitsButton } from '../units-button/units-button'
const _ = require('../../../helpers'):Utils

export tag TwoInputs
	prop firstName
	prop firstI
	prop secondName
	prop secondI

	def mount
		@first.@dom.addEventListener('input', self:formatInput)
		@first.@dom.addEventListener('blur', self:formatInput)
		@second.@dom.addEventListener('input', self:formatInput)
		@second.@dom.addEventListener('blur', self:formatInput)

	# Numeral formatter
	def formatInput e
		if e:target:value === "" || e:target:value === 0
			e:target:value = "0"
		if e:target:value === '00'
			e:target:value = "0"
		e:target:value = e:target:value.replace(/[A-Za-z]/g, '').replace(/\-/g, '').replace(/^(-)?0+(?=\d)/, '$1')

	def render
		<self>
			<.{@firstName} .input>
				<label.label for="{@firstName}"> "{_.capitalize(@firstName)}"
				<input@first[@firstI:value] .{@firstName} name="{@firstName}" type="text" value="0">
				<UnitsButton data=(@firstI)>
			<.space>
			<.{@secondName} .input>
				<label.label for="{@secondName}"> "{_.capitalize(@secondName)}"
				<input@second[@secondI:value] .{@secondName} name="{@secondName}" type="text" value="0">
				<UnitsButton data=(@secondI)>
