<template>
  <div>
    <h1>All done! Much victory, very celebration!</h1>
    For level session: {{this.courseInstanceID}},
    stage: {{this.capstoneStage}},
    remaining goals: {{this.remainingGoals}}
    <br />
    Next cinematic link: TODO :)
  </div>
</template>

<script>
  export default {
    name: 'CapstoneProgressModal',
    props: {
      courseInstanceID: {
        type: String,
        required: true
      },
      capstoneStage: {
        type: Number,
        required: true
      },
      remainingGoals: {
        type: Array,
        required: true
      }
    }
  }
</script>
