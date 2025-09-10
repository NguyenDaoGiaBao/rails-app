import {Controller} from "@hotwired/stimulus"
import Swal from "sweetalert2"

// Connects to data-controller="front"
export default class extends Controller {

    connect() {
        alert('1111')
    }
    delete(event) {
        const playerId = event.currentTarget.dataset.id

        Swal.fire({
            title: 'Confirm delete',
            text: "Do you really want to delete this record?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, delete it!'
        }).then(result => {
            if (result.isConfirmed) {
                fetch(`/players/${playerId}`, {
                    method: 'DELETE',
                    headers: {
                        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
                        'Accept': 'text/vnd.turbo-stream.html'
                    }
                }).then(response => {
                    if (response.ok) {
                        this.toast("Player was deleted successfully.", "success")
                    } else {
                        throw new Error("Delete failed")
                    }
                }).catch(() => {
                    Swal.fire("Error!", "Opps, has occurred error.", "warning")
                })
            }
        })
    }

  toast(message, icon = "success") {
    const Toast = Swal.mixin({
      toast: true,
      position: "top-end",
      showConfirmButton: false,
      timer: 3000,
      timerProgressBar: true,
      didOpen: toast => {
        toast.addEventListener("mouseenter", Swal.stopTimer)
        toast.addEventListener("mouseleave", Swal.resumeTimer)
      }
    })

    Toast.fire({ icon, title: message })
  }

}
