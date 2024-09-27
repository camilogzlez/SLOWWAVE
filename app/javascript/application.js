import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

// Automatically import all controllers in the controllers directory
const context = require.context("./controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

export { application }
import "./controllers"
