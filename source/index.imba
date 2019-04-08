import { App } from './components/app'
import { Stores } from './controllers/store'

const states = Stores.new()

Imba.mount <App[states]>