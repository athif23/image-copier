import { OptionPanel } from './option-panel/option-panel'
import { PreviewPanel } from './preview-panel/preview-panel'

export tag App
	def render
		<self>
			<OptionPanel[data]>
			<PreviewPanel>