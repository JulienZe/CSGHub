<template>
  <div class="flex bg-[#fff] flex-col pr-[20px]">
    <div class="">
      <span class="mr-[4px] py-[8px] px-[12px] text-[14px] text-[#667085] cursor-pointer hover:bg-gray-50"
            data-type="Task"
            :class="activeNavItem === 'Task' ? 'text-[#344054] active-type font-[600] shadow-outline-gray-400 shadow-outline-4' : ''"
            @click="changeActiveItem"
      >
        任务
      </span>
      <span v-show="type === 'model'"
            class="mr-[4px] py-[8px] px-[12px] text-[14px] text-[#667085] cursor-pointer hover:bg-gray-50"
            data-type="Framework"
            :class="activeNavItem === 'Framework' ? 'text-[#344054] active-type font-[600] shadow-outline-gray-400 shadow-outline-4' : ''"
            @click="changeActiveItem"
      >
        框架
      </span>
      <span class="mr-[4px] py-[8px] px-[12px] text-[14px] text-[#667085] cursor-pointer hover:bg-gray-50"
            data-type="License"
            :class="activeNavItem === 'License' ? 'text-[#344054] active-type font-[600] shadow-outline-gray-400 shadow-outline-4' : ''"
            @click="changeActiveItem"
      >
      License
      </span>
    </div>
    <div>
      <!-- task tags -->
      <div v-show="showTask">
        <el-input
          v-model="taskTagFilterInput"
          class="!w-[80%] mt-[28px]"
          size="large"
          placeholder="筛选标签"
          :prefix-icon="Search"
          @input = "filterTaskTags"
        />
        <div class="">
          <div v-for="tagField in theTaskTags">
            <h3 class="text-[#909399] text-[12px] my-[16px]">{{ tagField.zh_name }}</h3>
            <div class="flex gap-[8px] flex-wrap">
              <span v-for="tag in tagField.tags"
                    class="text-[14px] text-[#303133] px-[8px] py-[4px] rounded-[4px] cursor-pointer"
                    :data-tag_name="tag.name"
                    :style="setTagColor(tag.name, tagField.color)"
                    @click="setActiveTaskTag"
              >
                {{ tag.zh_name }}
              </span>
            </div>
          </div>
        </div>
      </div>
      <!-- framework tags -->
      <div v-show="showFramework">
        <el-input
          v-model="frameworkTagFilterInput"
          class="!w-[80%] mt-[28px] mb-[16px]"
          size="large"
          placeholder="筛选标签"
          :prefix-icon="Search"
          @input = "filterFrameworkTags"
        />
        <div class="flex gap-[8px] flex-wrap">
          <PyTorch v-show="frameworkTagExist('PyTorch')"
                 @setActiveFrameworkTag="setActiveFrameworkTag"
                 :activeTag="activeFrameworkTag" />
          <TensorFlow v-show="frameworkTagExist('TensorFlow')"
                      @setActiveFrameworkTag="setActiveFrameworkTag"
                      :activeTag="activeFrameworkTag" />
          <Safetensors v-show="frameworkTagExist('Safetensors')"
                      @setActiveFrameworkTag="setActiveFrameworkTag"
                      :activeTag="activeFrameworkTag" />
          <ONNX v-show="frameworkTagExist('ONNX')"
                @setActiveFrameworkTag="setActiveFrameworkTag"
                :activeTag="activeFrameworkTag" />
          <JAX v-show="frameworkTagExist('JAX')"
              @setActiveFrameworkTag="setActiveFrameworkTag"
              :activeTag="activeFrameworkTag" />
          <PaddlePaddle v-show="frameworkTagExist('PaddlePaddle')"
                        @setActiveFrameworkTag="setActiveFrameworkTag"
                        :activeTag="activeFrameworkTag" />
          <Joblib v-show="frameworkTagExist('Joblib')"
                  @setActiveFrameworkTag="setActiveFrameworkTag"
                  :activeTag="activeFrameworkTag" />
          <GGUF v-show="frameworkTagExist('GGUF')"
                @setActiveFrameworkTag="setActiveFrameworkTag"
                :activeTag="activeFrameworkTag" />
        </div>
      </div>

      <div v-show="showLicense">
        <el-input
          v-model="licenseTagFilterInput"
          class="!w-[80%] mt-[28px] mb-[16px]"
          size="large"
          placeholder="筛选标签"
          :prefix-icon="Search"
          @input = "filterLicenseTags"
        />
        <div class="flex gap-[8px] flex-wrap">
          <span v-for="licenseTag in theLicenseTags" class="text-[14px] text-[#303133] px-[8px] py-[4px] rounded-[4px] cursor-pointer flex items-center gap-[4px] border border-gray-200"
                :data-tag_name="licenseTag.name"
                :style="setLicenseTagColor(licenseTag.name)"
                @click="setActiveLicenseTag"
          >
            <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 12 12" fill="none"> <path d="M6 2.99995V11M6 2.99995H4.28328C4.17763 2.99995 4.12481 2.99995 4.07307 3.00719C4.02712 3.01362 3.98186 3.02431 3.93789 3.0391C3.88837 3.05576 3.84112 3.07939 3.74663 3.12664L3 3.49995M6 2.99995H7.71672C7.82237 2.99995 7.87519 2.99995 7.92693 3.00719C7.97288 3.01362 8.01814 3.02431 8.06211 3.0391C8.11163 3.05576 8.15888 3.07939 8.25337 3.12664L9 3.49995M6 2.99995V1M6 11H8.5M6 11H3.5M1 3.99995H1.71672C1.82237 3.99995 1.87519 3.99995 1.92693 3.9927C1.97288 3.98627 2.01814 3.97559 2.06211 3.96079C2.11163 3.94413 2.15888 3.92051 2.25337 3.87326L3 3.49995M11 3.99995H10.2833C10.1776 3.99995 10.1248 3.99995 10.0731 3.9927C10.0271 3.98627 9.98186 3.97559 9.93789 3.96079C9.88837 3.94413 9.84112 3.92051 9.74663 3.87326L9 3.49995M3 3.49995L1.93102 7.06321C1.80356 7.48809 1.73982 7.70054 1.76796 7.87165C1.80739 8.11139 1.9605 8.31718 2.1788 8.42383C2.33461 8.49995 2.55641 8.49995 3 8.49995V8.49995C3.44359 8.49995 3.66539 8.49995 3.8212 8.42383C4.0395 8.31718 4.19261 8.11139 4.23204 7.87165C4.26018 7.70054 4.19644 7.48809 4.06898 7.06321L3 3.49995ZM9 3.49995L7.93102 7.06321C7.80356 7.48809 7.73982 7.70054 7.76796 7.87165C7.80739 8.11139 7.9605 8.31718 8.1788 8.42383C8.33461 8.49995 8.55641 8.49995 9 8.49995V8.49995V8.49995C9.44359 8.49995 9.66539 8.49995 9.8212 8.42383C10.0395 8.31718 10.1926 8.11139 10.232 7.87165C10.2602 7.70054 10.1964 7.48809 10.069 7.06321L9 3.49995Z" stroke="#606266" stroke-linecap="round" stroke-linejoin="round"/> </svg>
            {{ licenseTag.zh_name }}
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
  import { ref, onMounted } from 'vue'
  import { Search } from '@element-plus/icons-vue'
  import PyTorch from './frameworks/PyTorch.vue'
  import TensorFlow from './frameworks/TensorFlow.vue'
  import Safetensors from './frameworks/Safetensors.vue'
  import JAX from './frameworks/JAX.vue'
  import ONNX from './frameworks/ONNX.vue'
  import PaddlePaddle from './frameworks/PaddlePaddle.vue'
  import Joblib from './frameworks/Joblib.vue'
  import GGUF from './frameworks/GGUF.vue'

  const props = defineProps({
    taskTags: String,
    frameworkTags: String,
    licenseTags: String,
    type: String,
    selectedTag: String,
    selectedTagType: String
  })

  const emit = defineEmits(['resetTags'])

  const activeNavItem = ref('Task')
  const theTaskTags = ref(JSON.parse(props.taskTags))
  const theFrameworkTags = ref(JSON.parse(props.frameworkTags))
  const theLicenseTags = ref(JSON.parse(props.licenseTags))
  const activeTaskTag = ref('')
  const activeFrameworkTag = ref('')
  const activeLicenseTag = ref('')
  const taskTagFilterInput = ref('')
  const frameworkTagFilterInput = ref('')
  const licenseTagFilterInput = ref('')
  const showTask = ref(true)
  const showFramework = ref(false)
  const showLicense = ref(false)

  const changeActiveItem = (e) => {
    activeNavItem.value = e.target.dataset.type
    toggleTagType()
  }

  const toggleTagType = () => {
    if (activeNavItem.value === 'Task') {
      showTask.value = true
      showFramework.value = false
      showLicense.value = false
    } else if (activeNavItem.value === 'Framework') {
      showTask.value = false
      showFramework.value = true
      showLicense.value = false
    } else if (activeNavItem.value === 'License') {
      showTask.value = false
      showFramework.value = false
      showLicense.value = true
    }
  }

  const setActiveTaskTag = (e) => {
    if (activeTaskTag.value === e.target.dataset.tag_name) {
      activeTaskTag.value = ''
    } else {
      activeTaskTag.value = e.target.dataset.tag_name
    }
    emitTag()
  }

  const setActiveFrameworkTag = (tagName) => {
    if (activeFrameworkTag.value === tagName) {
      activeFrameworkTag.value = ''
    } else {
      activeFrameworkTag.value = tagName
    }
    emitTag()
  }

  const setActiveLicenseTag = (e) => {
    if (activeLicenseTag.value === e.target.dataset.tag_name) {
      activeLicenseTag.value = ''
    } else {
      activeLicenseTag.value = e.target.dataset.tag_name
    }
    emitTag()
  }

  const setTagColor = (tagName, tagFieldColor) => {
    if(activeTaskTag.value === tagName) {
      return `color: white; background-color: ${tagFieldColor}`
    } else {
      return `color: ${tagFieldColor}; background-color: #d3d3d354`
    }
  }

  const setLicenseTagColor = (tagName) => {
    if (activeLicenseTag.value === tagName) {
      return "color: white; background-color: #4D6AD6"
    } else {
      return `color: #303133`
    }
  }

  const filterTaskTags = (keywords) => {
    const keywordsRegex = new RegExp(keywords, 'i');
    const newTags = JSON.parse(props.taskTags)
    const result = removeNotMatchedTags(newTags, keywordsRegex)
    theTaskTags.value = result
  }

  const filterFrameworkTags = (keywords) => {
    const keywordsRegex = new RegExp(keywords, 'i');
    const newTags = JSON.parse(props.frameworkTags)
    const result = removeNotMatchedFrameworkTags(newTags, keywordsRegex)
    theFrameworkTags.value = result
  }

  const filterLicenseTags = (keywords) => {
    const keywordsRegex = new RegExp(keywords, 'i');
    const newTags = JSON.parse(props.licenseTags)
    const result = removeNotMatchedFrameworkTags(newTags, keywordsRegex)
    theLicenseTags.value = result
  }

  const removeNotMatchedFrameworkTags = (tags, regex) => {
    const matchedTags = tags.filter((tag) => regex.test(tag.zh_name))
    return matchedTags
  }

  const frameworkTagExist = (tagName) => {
    result = theFrameworkTags.value.find(ftag => ftag.name.toLowerCase() === tagName.toLowerCase())
    return result
  }

  const removeNotMatchedTags = (json, regex) => {
    const newJson = {}
    for (const [field, { color, zh_name, tags }] of Object.entries(json)) {
      const matchedTags = tags.filter((tag) => regex.test(tag.zh_name))
      newJson[field] = { color, zh_name, tags: matchedTags }
    }
    return newJson
  }

  const emitTag = () => {
    emit('resetTags', activeTaskTag.value, activeFrameworkTag.value, activeLicenseTag.value)
  }

  const setTagNameFromParams = () => {
    if (props.selectedTagType === 'Task') {
      activeTaskTag.value = props.selectedTag
    } else if (props.selectedTagType === 'Framework') {
      activeFrameworkTag.value = props.selectedTag
    } else if (props.selectedTagType === 'License') {
      activeLicenseTag.value = props.selectedTag
    }
  }

  const setTagTypeFromParams = () => {
    activeNavItem.value = props.selectedTagType
    toggleTagType()
  }

  const emitTagFromParams = () => {
    setTagTypeFromParams()
    setTagNameFromParams()
    emitTag()
  }

  onMounted(() => {
    emitTagFromParams()
  })

</script>

<style scoped>
  .active-type {
    box-shadow: 0px 0px 0px 4px rgba(152, 162, 179, 0.14);
    border-radius: 6px;
  }
</style>