import { Application } from "@hotwired/stimulus"
// Import 3rd party packages here
import Dropdown from 'stimulus-dropdown'
import Reveal from 'stimulus-reveal-controller'
import Notification from 'stimulus-notification'

const application = Application.start()
// Register 3rd party packages here
application.register('dropdown', Dropdown)
application.register('reveal', Reveal)
application.register('notification', Notification)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
