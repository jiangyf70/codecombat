import ModalComponent from 'views/core/ModalComponent'
import CapstoneVictoryComponent from './CapstoneVictoryComponent'

class CapstoneVictoryModal extends ModalComponent {
  // Runs before the constructor is called.
  initialize() {
    return this.propsData = {
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

CapstoneVictoryModal.id = 'capstone-victory-modal'
CapstoneVictoryModal.template = require('templates/core/modal-base-flat')
CapstoneVictoryModal.VueComponent = CapstoneVictoryComponent
CapstoneVictoryModal.propsData = null

export default CapstoneVictoryModal
