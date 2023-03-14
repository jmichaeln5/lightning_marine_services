import { Application } from "@hotwired/stimulus"
// Import 3rd party packages here
import Dropdown from 'stimulus-dropdown'


const application = Application.start()
// Register 3rd party packages here
application.register('dropdown', Dropdown)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
