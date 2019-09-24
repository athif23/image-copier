const _ = require('../../../../helpers'):Utils

export tag PaperSizes < details
	prop options
	prop value
	prop mouseDown

	def mount
		@options = self.@dom.querySelectorAll(".select > .select__option")
		@mouseDown = false
		@summary.@dom:textContent = data.@format:title
		@value = @firstOption.value()
		self.addEventListeners()
		self.setAria()

	def addEventListeners
		self.@dom.addEventListener('toggle', do
			if self.@dom:open 
				return
			self.updateValue()
		)

		self.@dom.addEventListener('focusout', do
			if (@mouseDown) 
				return
			self.@dom.removeAttribute('open')
		)

		@options.forEach(do |opt|
			opt.addEventListener('mousedown', do @mouseDown = true)
			opt.addEventListener('mouseup', do
				@mouseDown = false
				self.@dom.removeAttribute('open')
			)
		)

		self.@dom.addEventListener('keyup', &) do |e|
			const keycode = e:which
			const current = [*@options].indexOf(self.@dom.querySelector('.active'))
			switch keycode
				when 27 # ESC
					@self.@dom.removeAttribute('open')
				when 35
					e.preventDefault()
					if !self.@dom:open
						self.@dom.setAttribute('open', '')
					self.setChecked(@options[@options:length - 1].querySelector('input'))
				when 36
					e.preventDefault()
					if !self.@dom:open
						self.@dom.setAttribute('open', '')
					self.setChecked(@options[0].querySelector('input'))
				when 38
					e.preventDefault()
					if !self.@dom:open
						self.@dom.setAttribute('open', '')
					self.setChecked(@options[current > 0 ? current - 1 : 0].querySelector('input'))
				when 40
					e.preventDefault()
					if !self.@dom:open
						self.@dom.setAttribute('open', '')
					self.setChecked(@options[current <= @options:length ? current + 1 : @options:length - 1]?.querySelector('input'))

	def setAria
		self.@dom.setAttribute('aria-haspopup', 'listbox')
		const selectBox = self.@dom.querySelector('.select')
		selectBox.setAttribute('role', 'listbox')
		selectBox.querySelector('[type=radio]').setAttribute('role', 'option')
		
	def updateValue(e)
		const that = self.@dom.querySelector('input:checked')
		if !that 
			return
		self.setValue(that)
		Imba.commit

	def setChecked(el)
		el:checked = true
		self.setValue(el)

	def setValue(that)
		if @value === that:value
			return

		@summary.@dom:textContent = that:parentNode:textContent
		@value = that:value

		@options.forEach(do |opt| opt:classList.remove('active'))
		that:parentNode:classList:add('active')

		let changedOption = data.@sizes-list.filter(do |op| op:value === @value)
		data.@format = changedOption[0]

		data.@paper.width(_.convertTo({from: data.@format:unit, to: 'px'}, data.@format:width, data.@density:value))
		data.@paper.height(_.convertTo({from: data.@format:unit, to: 'px'}, data.@format:height, data.@density:value))

		data.@paper.@isMarginChanged = true
		data.@paper.@isChanged = true

		Imba.commit
		data.@stage.batchDraw()

		self.@dom.dispatchEvent(Event.new('change'))

	def render
		<self>
			<summary@summary> "---"
			<.select>
				for option in data.@sizes-list
					if  data.@sizes-list.indexOf(option) === 0
						<label .select__option .active> "{option['title']}"
							<input@firstOption type="radio" name="option" value="{option['value']}" checked>
					else
						<label .select__option> "{option['title']}"
							<input type="radio" name="option" value="{option['value']}">
