import { App } from './components/app'
import { Stores } from './controllers/store'

const states = Stores.new()

require('offline-plugin/runtime').install()

Imba.mount <App[states]>