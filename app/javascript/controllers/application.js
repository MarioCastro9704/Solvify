import { application } from "controllers/application"
import { definitionsFromContext } from "@hotwired/stimulus-loading"
import "@popperjs/core"
import "bootstrap"
const context = require.context("controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

export { application }
