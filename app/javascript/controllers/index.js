// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import ClickHiddenController from "./click_hidden_controller"
application.register("click-hidden", ClickHiddenController)

import CounterController from "./counter_controller"
application.register("counter", CounterController)

import NumberFieldInputController from "./number_field_input_controller"
application.register("number-field-input", NumberFieldInputController)

import OrdersBulkController from "./orders_bulk_controller"
application.register("orders-bulk", OrdersBulkController)

import SearchController from "./search_controller"
application.register("search", SearchController)

import ToggleController from "./toggle_controller"
application.register("toggle", ToggleController)

import TurboModalController from "./turbo_modal_controller"
application.register("turbo-modal", TurboModalController)

import VisibilityController from "./visibility_controller"
application.register("visibility", VisibilityController)
