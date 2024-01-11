import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from "stimulus-use"

/*
 * Usage
 * =====
 *
 * add data-controller="toggle" to common ancestor
 * data: { controller: 'toggle' }
 *
 * Action (add this to your button):
 * data-action="toggle#toggle"
 * data: { action: 'toggle#toggle' }
 *

 * Targets (add this to the item to be shown/hidden):
 * data-toggle-target="toggleable" data-css-class="class-to-toggle"
 * data: { "toggle-target": "toggleable", "css-class": "class-to-toggle" }

 *
 */
export default class extends Controller {
  static targets = ["toggleable"]

  connect() {
    // Any clicks outside the controller’s element can
    // be setup to either add a 'hidden' class or
    // remove a 'open' class etc.

    useClickOutside(this);
  }

  toggle(e) {
    e.preventDefault();

    this.toggleableTargets.forEach((target) => {
    target.classList.toggle(target.dataset.cssClass)
    });
  }

  clickOutside(event) {
    console.log('\n   data-controller="toggle" toggle(event)\n')

    if (this.data.get("clickOutside") === "add") {
      this.toggleableTargets.forEach((target) => {
      target.classList.add(target.dataset.cssClass);
      });
    } else if (this.data.get("clickOutside") === "remove") {
      this.toggleableTargets.forEach((target) => {
        target.classList.remove(target.dataset.cssClass)
      });
    }
  }

}
