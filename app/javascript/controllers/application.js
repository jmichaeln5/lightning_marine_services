import { Application } from "@hotwired/stimulus"
// Import 3rd party packages here
import Dropdown from 'stimulus-dropdown'
import Reveal from 'stimulus-reveal-controller'
import Notification from 'stimulus-notification'
import CheckboxSelectAll from 'stimulus-checkbox-select-all'

const application = Application.start()
// Register 3rd party packages here
application.register('dropdown', Dropdown)
application.register('reveal', Reveal)
application.register('notification', Notification)
application.register('checkbox-select-all', CheckboxSelectAll)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
