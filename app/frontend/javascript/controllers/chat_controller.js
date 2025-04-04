import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = ["input", "messages", "typingIndicator"]
  static values = { threadId: Number }

  connect() {
    if (!this.hasThreadIdValue) return

    this.setupSubscription()
    this.typingTimer = null
    this.isTyping = false
  }

  disconnect() {
    if (this.channel) {
      this.channel.unsubscribe()
    }
  }

  setupSubscription() {
    this.channel = consumer.subscriptions.create(
      {
        channel: "DirectMessageChannel",
        thread_id: this.threadIdValue
      },
      {
        connected: this._connected.bind(this),
        disconnected: this._disconnected.bind(this),
        received: this._received.bind(this)
      }
    )
  }

  _connected() {
    console.log("Connected to DirectMessageChannel")
  }

  _disconnected() {
    console.log("Disconnected from DirectMessageChannel")
  }

  _received(data) {
    console.log("Received:", data)
    if (data.action === "typing" && data.thread_id === this.threadIdValue) {
      this.showTypingIndicator(data.username)
    } else if (data.action === "stopped_typing" && data.thread_id === this.threadIdValue) {
      this.hideTypingIndicator()
    }
  }

  typing() {
    if (!this.isTyping) {
      this.isTyping = true
      this.channel.perform("typing", { thread_id: this.threadIdValue })
    }

    // Clear existing timer
    clearTimeout(this.typingTimer)

    // Set new timer
    this.typingTimer = setTimeout(() => {
      this.isTyping = false
      this.channel.perform("stopped_typing", { thread_id: this.threadIdValue })
    }, 3000)
  }

  showTypingIndicator(username) {
    if (this.hasTypingIndicatorTarget) {
      this.typingIndicatorTarget.textContent = `${username} is typing...`
      this.typingIndicatorTarget.classList.remove("hidden")
    }
  }

  hideTypingIndicator() {
    if (this.hasTypingIndicatorTarget) {
      this.typingIndicatorTarget.classList.add("hidden")
    }
  }
}
