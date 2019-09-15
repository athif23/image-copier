const _ = require('../../helpers'):Utils
const Konva = require('konva')

export tag PreviewPanel
	def mount
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

	def resizeCanvas(e)
		const selfW = self.@dom:clientWidth
		const selfH = self.@dom:clientHeight

		data.@stage.width(selfW)
		data.@stage.height(selfH)
		data.@stage.batchDraw()

	def render
		<self>
			<#container>
			<.zoom-tools>
				<button.out :click=(do data.@paper._zoom('out', true))> "-"
				<button.in :click=(do data.@paper._zoom('in', true))> "+"
