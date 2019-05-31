import ModalComponent from 'views/core/ModalComponent'
import CapstoneProgressComponent from './CapstoneProgressComponent'

class CapstoneProgressModal extends ModalComponent {
  // Runs before the constructor is called.
  initialize() {
    this.propsData = {
      courseInstanceID: null,
      capstoneStage: null,
      remainingGoals: null
    }
  }

  constructor(options) {
    super(options)
    if (options) {
      this.propsData = {
        courseInstanceID: options.courseInstanceID,
        capstoneStage: options.capstoneStage,
        remainingGoals: options.remainingGoals,
      }
    }
  }

  destroy() {
    if (this.onDestroy) {
      this.onDestroy()
    }
  }
}

CapstoneProgressModal.id = 'capstone-progress-modal'
CapstoneProgressModal.template = require('templates/core/modal-base-flat')
CapstoneProgressModal.VueComponent = CapstoneProgressComponent

export default CapstoneProgressModal
