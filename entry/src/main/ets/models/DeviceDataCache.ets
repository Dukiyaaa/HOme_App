import { http } from '@kit.NetworkKit'

// 设备数据接口
interface DeviceData {
  temperature_indoor: number
  humidity_indoor: number
  automation_mode_scene: number
  timestamp: number
}

// 缓存数据接口
interface CacheData {
  data: DeviceData
  lastUpdateTime: number
}

// 后端响应接口
interface ApiResponse {
  status: string
  latest: DeviceData
}

class DeviceDataCache {
  private static instance: DeviceDataCache
  private cache: CacheData | null = null
  private refreshTimer: number = -1
  private readonly CACHE_EXPIRY_TIME = 2 * 1000 // 2秒
  private readonly REFRESH_INTERVAL = 2 * 1000 // 2秒刷新一次

  private constructor() {}

  public static getInstance(): DeviceDataCache {
    if (!DeviceDataCache.instance) {
      DeviceDataCache.instance = new DeviceDataCache()
    }
    return DeviceDataCache.instance
  }

  // 初始化缓存
  public async initialize(): Promise<void> {
    try {
      await this.refreshCache()
      this.startRefreshTimer()
    } catch (error) {
      console.error('[DeviceDataCache] Failed to initialize cache:', error)
    }
  }

  // 获取最新数据
  public async getLatestData(): Promise<DeviceData | null> {
    try {
      // 如果缓存为空或已过期，则刷新缓存
      if (!this.cache || Date.now() - this.cache.lastUpdateTime > this.CACHE_EXPIRY_TIME) {
        await this.refreshCache()
      }
      return this.cache?.data || null
    } catch (error) {
      console.error('[DeviceDataCache] Failed to get latest data:', error)
      return null
    }
  }

  // 刷新缓存
  private async refreshCache(): Promise<void> {
    try {
      const req = http.createHttp()
      const response = await req.request('http://43.155.36.236:5000/data/latest', {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        }
      })

      if (response.responseCode === 200) {
        const result: ApiResponse = JSON.parse(response.result as string)
        if (result.status === 'success' && result.latest) {
          const newData: DeviceData = {
            temperature_indoor: result.latest.temperature_indoor,
            humidity_indoor: result.latest.humidity_indoor,
            automation_mode_scene: result.latest.automation_mode_scene,
            timestamp: Date.now()
          }
          this.cache = {
            data: newData,
            lastUpdateTime: Date.now()
          }
          console.info('[DeviceDataCache] Cache refreshed successfully')
        }
      }
    } catch (error) {
      console.error('[DeviceDataCache] Failed to refresh cache:', error)
    }
  }

  // 更新缓存数据
  public updateCache(newData: Partial<DeviceData>): void {
    if (this.cache) {
      const updatedData: DeviceData = {
        temperature_indoor: newData.temperature_indoor ?? this.cache.data.temperature_indoor,
        humidity_indoor: newData.humidity_indoor ?? this.cache.data.humidity_indoor,
        automation_mode_scene: newData.automation_mode_scene ?? this.cache.data.automation_mode_scene,
        timestamp: Date.now()
      }
      this.cache = {
        data: updatedData,
        lastUpdateTime: Date.now()
      }
      console.info('[DeviceDataCache] Cache updated with new data')
    }
  }

  // 启动定时刷新
  private startRefreshTimer(): void {
    if (this.refreshTimer === -1) {
      this.refreshTimer = setInterval(() => {
        this.refreshCache().catch((error: Error) => {
          console.error('[DeviceDataCache] Error in refresh timer:', error)
        })
      }, this.REFRESH_INTERVAL)
    }
  }

  // 停止定时刷新
  public stopRefreshTimer(): void {
    if (this.refreshTimer !== -1) {
      clearInterval(this.refreshTimer)
      this.refreshTimer = -1
    }
  }
}

export default DeviceDataCache 