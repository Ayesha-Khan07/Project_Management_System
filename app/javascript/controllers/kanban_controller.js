// app/javascript/controllers/kanban_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["task", "column"]

  connect() {
    this.taskTargets.forEach(task => {
      task.draggable = true
      task.addEventListener("dragstart", this.dragStart)
      task.addEventListener("dragend", this.dragEnd)
    })

    this.columnTargets.forEach(column => {
      column.addEventListener("dragover", this.dragOver)
      column.addEventListener("drop", this.drop)
    })
  }

  dragStart(event) {
    event.dataTransfer.setData("text/plain", event.target.dataset.taskId)
    event.target.classList.add("opacity-50")
  }

  dragOver(event) {
    event.preventDefault()
    event.currentTarget.classList.add("drag-over")
  }

  dragEnd(event) {
    event.target.classList.remove("opacity-50")
    document.querySelectorAll("[data-kanban-target='column']").forEach(col => {
      col.classList.remove("drag-over")
    })
  }

  drop(event) {
    event.preventDefault()
    event.currentTarget.classList.remove("drag-over")

    const taskId = event.dataTransfer.getData("text/plain")
    const taskElement = document.querySelector(`[data-task-id='${taskId}']`)
    if (!taskElement) return

    const projectId = taskElement.dataset.projectId
    const newStatus = event.currentTarget.dataset.status

    fetch(`/projects/${projectId}/tasks/${taskId}/update_status`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ task: { task_status: newStatus } })
    })
      .then(response => {
        if (!response.ok) throw new Error("Server error")
        return response.json()
      })
      .then(data => {
        if (data.success) {
          // ✅ ALWAYS find the correct container by status
          const targetContainer = document.querySelector(
            `.tasks-container[data-status='${newStatus}']`
          )

          if (targetContainer) {
            targetContainer.appendChild(taskElement)
          }
        } else {
          alert("Failed to update task: " + data.errors.join(", "))
        }
      })
      .catch(error => {
        alert("Failed to update task: " + error.message)
      })
  }
}
