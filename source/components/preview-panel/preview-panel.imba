const _ = require('../../helpers'):Utils
const Konva = require('konva')

export tag PreviewPanel
	def mount
		@timer = 0
		let changeWidth = window.matchMedia('(min-width : 950px)')
		self.onChangeWidth(changeWidth)
		changeWidth.addListener(do self:onChangeWidth(changeWidth))
		window.addEventListener('resize', do |e| self.resizeCanvas(e))

		const selfH = self.@dom:clientHeight
		const selfW = self.@dom:clientWidth

		data.@stage = Konva.Stage.new({
			container: 'container',
			width: selfW,
			height: selfH,
			draggable: true
		})

		data.@layer = Konva.Layer.new()
		data.@layer.add(data.@paper)
		data.@stage.add(data.@layer)
		data.@layer.draw()

		# Zoom feature
		data.@stage.on('wheel', do |e|
			e:evt.preventDefault()
			var state = (e:evt:deltaY > 0) ? "out" : "in"
			data.@paper._zoom(state)
		)

		data.@stage.on('touchmove', do |e|
			data.@paper._zoomMobile(e)
		)

		data.@stage.on('touchend', do |e|
			data.@paper:_lastDist = 0
			data.@paper:_point = undefined
		)

	def onChangeWidth(x)
		let previewPanel = document.querySelector('.PreviewPanel')
		if x:matches
			previewPanel:style:display = "flex"
			data.@optionVisible = true
			Imba.commit()
		else
			previewPanel:style:display = "none" if data.@optionVisible = true

	def resizeCanvas(e)
		clearTimeout(@timer)
		@timer = setTimeout(&, 550) do
			const selfW = self.@dom:clientWidth
			const selfH = self.@dom:clientHeight

			data.@stage.width(selfW)
			data.@stage.height(selfH)
			data.@stage.batchDraw()

	def backToOption
		let previewPanel = document.querySelector('.PreviewPanel')
		if (_.isVisible(previewPanel))
			previewPanel:style:display = "none"
			data.@optionVisible = true
			Imba.commit()

	def render
		<self>
			<button.back-option :click.backToOption> "Back"
			<#container>
			<.zoom-tools>
				<button.out :click=(do data.@paper._zoom('out', true))> "-"
				<button.in :click=(do data.@paper._zoom('in', true))> "+"
