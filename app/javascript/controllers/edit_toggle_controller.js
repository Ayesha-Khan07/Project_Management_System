import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "form"]

  show() {
    this.displayTarget.classList.add("hidden")
    this.formTarget.classList.remove("hidden")
  }

  hide() {
    this.formTarget.classList.add("hidden")
    this.displayTarget.classList.remove("hidden")
  }
}
