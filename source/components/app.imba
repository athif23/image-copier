import { OptionPanel } from './option-panel/option-panel'
import { PreviewPanel } from './preview-panel/preview-panel'

export tag App
	def render
		<self>
			<div css:height="100%" css:display="grid">
				<OptionPanel[data]>
			<PreviewPanel[data]>