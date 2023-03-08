import { Controller } from "stimulus"
import CheckboxSelectAll from "stimulus-checkbox-select-all"
import { FetchRequest, put, get, post, patch, destroy } from "@rails/request.js"

export default class extends CheckboxSelectAll {
  connect() {
    console.log("orders_bulk#connect()")
    super.connect()
  };

  destroy(event) {
    event.preventDefault()

    if (this.checked.length === 0 ) {
      alert("No orders selected")
      return
    }

    let data = new FormData()

    if (this.checked.length == this.checkboxTargets.length) {
      data.append("all", true)
    } else {
      this.checked.forEach((checkbox) => data.append("ids[]", checkbox.value))
    }

    let token = document.querySelector('meta[name="csrf-token"]').content
    fetch("/orders/bulk", {
      method: "DELETE",
      headers: {
        "X-CSRF-Token": token,
      },
      body: data,
    })
    .then((response) => {
      if (response.redirected) {
      window.location.href = response.url
    }
    })
  };

};
