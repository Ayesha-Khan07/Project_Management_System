import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    console.log("Modal controller connected!")
  }

  open() {
    console.log("Opening modal")
    this.containerTarget.classList.remove("hidden")
  }

  close() {
    console.log("Closing modal")
    this.containerTarget.classList.add("hidden")
  }

  handleKeydown(event) {
    console.log("Key pressed:", event.key)
    
    // Only close if modal is visible
    if (!this.containerTarget.classList.contains("hidden")) {
      if (event.key === "Escape" || event.key === "q" || event.key === "x") {
        this.close()
      }
    }
  }
}