<template>
  <div>
    <h1>Nice work!</h1>
    For level session: {{this.courseInstanceID}},
    stage: {{this.capstoneStage}}
    <br />
    Final cinematic link: TODO :)
  </div>
</template>

<script>
  export default {
    name: 'CapstoneVictoryModal',
    props: {
      courseInstanceID: {
        type: String,
        required: true
      },
      capstoneStage: {
        type: Number,
        required: true
      }
    }
  }
</script>
