aboutToAppear() {
  console.info('[Electricity Page] Page aboutToAppear starting...')
  
  // 先获取场景状态
  this.updateSceneStates().then(() => {
    console.info('[Electricity Page] Initial scene states updated, proceeding with data refresh')
    // 获取场景状态后再加载数据
    this.refreshData()
    
    // 设置定时刷新
    this.refreshTimer = setInterval(() => {
      console.info('[Electricity Page] Refresh timer triggered')
      this.refreshData()
    }, 5 * 60 * 1000)
  }).catch(() => {
    console.error('[Electricity Page] Error in aboutToAppear')
  })
}

async refreshData() {
  try {
    console.info('[Electricity Page] Starting data refresh...')
    const latestData = await getLatestElectricityData()
    if (latestData.status === 'success' && latestData.latest) {
      this.currentElectricity = latestData.latest.electricity
      
      // 更新图表URL时添加时间戳
      this.chartImageUrl = `${BASE_URL}/chart/electricity?t=${Date.now()}`
      console.info('[Electricity Page] Data refreshed successfully')
    }

    // 同时更新场景状态
    console.info('[Electricity Page] Updating scene states after data refresh')
    await this.updateSceneStates()
  } catch {
    console.error('[Electricity Page] Error in refreshData')
  }
}

// 更新场景状态
private async updateSceneStates() {
  try {
    console.info('[Electricity Page] Starting to update scene states...')
    const success = await this.sceneManager.fetchAllScenes()
    console.info('[Electricity Page] fetchAllScenes result:', success)
    
    if (success) {
      const acEnabled = this.sceneManager.isSceneEnabled(AUTO_MODE_ELECTRICITY_AC)
      const curtainEnabled = this.sceneManager.isSceneEnabled(AUTO_MODE_ELECTRICITY_CURTAIN)
      
      console.info('[Electricity Page] Previous states - AC:', this.isAirConditionControlEnabled, 'Curtain:', this.isCurtainControlEnabled)
      console.info('[Electricity Page] New states - AC:', acEnabled, 'Curtain:', curtainEnabled)
      
      this.isAirConditionControlEnabled = acEnabled
      this.isCurtainControlEnabled = curtainEnabled
      
      console.info('[Electricity Page] Scene states updated - AC:', this.isAirConditionControlEnabled, 'Curtain:', this.isCurtainControlEnabled)
    } else {
      console.error('[Electricity Page] Failed to fetch scene states')
    }
  } catch {
    console.error('[Electricity Page] Error updating scene states')
  }
} 