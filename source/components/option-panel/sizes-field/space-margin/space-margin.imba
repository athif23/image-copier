import { UnitInput } from '../../unit-input/unit-input'
const _ = require('../../../../helpers'):Utils

export tag SpaceMargin
	def render
		<self.two-inputs>
			<UnitInput[data] inputName="space" inputI=(data.@space) css:grid-column="2">
			<#space>
			<UnitInput[data] inputName="margin" inputI=(data.@margin) css:grid-column="4">