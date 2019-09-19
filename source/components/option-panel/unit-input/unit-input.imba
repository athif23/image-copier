import { UnitsButton } from './units-button/units-button'
const _ = require('../../../helpers'):Utils

export tag UnitInput
	prop inputName
	prop inputI
	prop lastUnit

	def mount
		@lastUnit = 'px'
		@input.@dom.addEventListener('input', self:formatInput, false)
		@input.@dom.addEventListener('blur', self:formatInput, false)

	def onchange
		data.@sizes[@inputName]:value = _.convertTo({from: @lastUnit, to: @inputI:unit}, data.@sizes[@inputName]:value, 72, true)
		data.checkType()
		@lastUnit = data.@sizes[@inputName]:unit

	# Numeral formatter
	def formatInput e
		if e:target:value === "" || e:target:value === 0
			e:target:value = "0"
		if e:target:value === '00'
			e:target:value = "0"
		e:target:value = e:target:value.replace(/[A-Za-z]/g, '').replace(/\-/g, '').replace(/^(-)?0+(?=\d)/, '$1')

	def render
		<self .{@inputName} .input>
			<label.label for="{@inputName}"> "{_.capitalize(@inputName)}"
			<input@input[@inputI:value] .{@inputName} name="{@inputName}" type="text" value="0">
			<UnitsButton dataInput=(@inputI)>
