import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

//scan all files of _controller.js format inside the app/JS/controllers, and register them with stimulus
eagerLoadControllersFrom("controllers", application)
