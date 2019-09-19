const _ = require('../../../helpers'):Utils
import { WidthHeight } from './width-height/width-height'
import { SpaceMargin } from './space-margin/space-margin'

export tag SizesField
	def mount
		self.@dom.addEventListener('keyup', do |e| data.checkType(e))
		self.@dom.querySelector('input.width').addEventListener('focus', do |e| self.selectInput(e))
		self.@dom.querySelector('input.height').addEventListener('focus', do |e| self.selectInput(e))
		self.@dom.querySelector('label.lock-field').addEventListener('click', do |e| self.checkRatio(e))

	# Need to know current input right now, to act as relative for lockRatio
	def selectInput e
		if e:target:className === "input height"
			data.@currentInput = "height"
		else
			data.@currentInput = "width"

	# Check when lock ratio button checked
	def checkRatio
		if !data.@lockRatio
			if (data.@paper:image:origWidth <= 0) && (data.@paper:image:origHeight <= 0)
				return
			let width = _.convertTo({from: data.@sizes:width:unit, to: 'px'}, data.@sizes:width:value, data.@density:value)
			let height = _.convertTo({from: data.@sizes:height:unit, to: 'px'}, data.@sizes:height:value, data.@density:value)
			if @currentInput === "width"
				data.@sizes:height:value = "{data.@sizes:width:value * data.@paper:image:origHeight / data.@paper:image:origWidth}"
			elif @currentInput === "height"
				data.@sizes:width:value = "{data.@sizes:height:value * data.@paper:image:origWidth / data.@paper:image:origHeight}"
			Imba.commit

		data.checkType()

	def onchange
		data.@paper.autoFill = data.@autoFill
		data.@paper.lockAspectRatio = data.@lockRatio
		data.@paper.justifyContent = data.@justifyContent

		data.@stage.batchDraw()

	def render
		<self>
			<WidthHeight[data]>
			if data.@isError !== false && data.@isError !== 'copies'
				<.warning-box>
					<p> "{data.@errorMessage}"
			<SpaceMargin[data]>
			<.checkbox-field>
				<label #auto-fill> "Auto Fill"
					<input[data.@autoFill] type="checkbox">
					<span>
				<#space>
				<label #justify-content> "Justify Images"
					<input[data.@justifyContent] type="checkbox">
					<span>
			<.separator>
