import { application } from "controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Register the calendar controller manually if not using eager loading
import CalendarController from "./calendar_controller"
application.register("calendar", CalendarController)

import BookingController from "./booking_controller"
application.register("booking", BookingController)
