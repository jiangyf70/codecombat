<script>
import { getCinematic } from '../../../api/cinematic'
import CinematicCanvas from '../common/CinematicCanvas'
import LayoutChrome from '../../common/LayoutChrome'
import LayoutCenterCinematic from '../common/LayoutCenterCinematic'

module.exports = Vue.extend({
  props: {
    cinematicIdOrSlug: {
      type: String,
      required: true
    }
  },
  data: () => ({
    cinematicData: null
  }),
  components: {
    'cinematic-canvas': CinematicCanvas,
    'layout-chrome': LayoutChrome,
    'layout-center-cinematic': LayoutCenterCinematic
  },
  watch : {
    cinematicIdOrSlug: async function() {
      await this.getCinematicData()
    }
  },
  async created () {
    if (!me.hasCinematicAccess())  {
      alert('You must be logged in as an admin to use this page.')
      return application.router.navigate('/', { trigger: true })
    }
    await this.getCinematicData()
  },
  methods: {
    completedHandler () {
      this.$emit('completed')
    },
    async getCinematicData() {
      try {
        this.cinematicData = await getCinematic(this.cinematicIdOrSlug)
      } catch (e) {
        console.error(e)
        return noty({
          text: `Error finding cinematic '${this.cinematicIdOrSlug}'.`,
          type:'error',
          timeout: 3000
        })
      }
    }
  },
})
</script>

<template>
  <layout-chrome>
    <layout-center-cinematic>
      <cinematic-canvas
        v-if="cinematicData"
        v-on:completed="completedHandler"
        :cinematicData="cinematicData" />
    </layout-center-cinematic>
  </layout-chrome>
</template>
