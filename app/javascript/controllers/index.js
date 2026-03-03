// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

import NestedController from "./nested_controller"
import SettleController from "./settle_controller"

eagerLoadControllersFrom("controllers", application)

application.register("nested", NestedController)
application.register("settle", SettleController)
