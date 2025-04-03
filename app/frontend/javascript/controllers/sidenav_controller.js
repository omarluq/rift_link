import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  connect() {
    const collapsed = localStorage.getItem('sidenavCollapsed') === 'true'
    if (collapsed) {
      this.collapse()
    }
  }

  toggle() {
    if (this.panelTarget.classList.contains('w-64')) {
      this.collapse()
    } else {
      this.expand()
    }
  }

  collapse() {
    this.panelTarget.classList.remove('w-64')
    this.panelTarget.classList.add('w-16')
    localStorage.setItem('sidenavCollapsed', 'true')
  }

  expand() {
    this.panelTarget.classList.remove('w-16')
    this.panelTarget.classList.add('w-64')
    localStorage.setItem('sidenavCollapsed', 'false')
  }
}
