import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["notification"]

  connect() {
    // Automatically dismiss notification after 5 seconds
    setTimeout(() => {
      this.close()
    }, 5000)
  }

  close() {
    this.notificationTarget.classList.add('opacity-0')
    setTimeout(() => {
      this.notificationTarget.remove()
    }, 300)
  }
}
