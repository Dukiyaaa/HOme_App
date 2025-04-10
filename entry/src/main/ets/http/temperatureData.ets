import { http } from '@kit.NetworkKit'

const BASE_URL = 'http://43.155.36.236:5000'

interface TemperatureDataItem {
  temperature_indoor: number
  created_at: string
}

interface LatestTemperatureResponseData {
  status: string
  latest: TemperatureDataItem
}

class TemperatureRecord {
  temperature_indoor: number
  created_at: string

  constructor(temperature: number, time: string) {
    this.temperature_indoor = temperature
    this.created_at = time
  }
}

class HttpResponse {
  responseCode: number
  result: string | Object | ArrayBuffer

  constructor(responseCode: number, result: string | Object | ArrayBuffer) {
    this.responseCode = responseCode
    this.result = result
  }
}

class TemperatureData {
  temperature_indoor: number
  created_at: string

  constructor(temperature: number, time: string) {
    this.temperature_indoor = temperature
    this.created_at = time
  }
}

class LatestTemperatureResponse {
  status: string
  latest: TemperatureData

  constructor(status: string, latest: TemperatureData) {
    this.status = status
    this.latest = latest
  }
}

// 从数组中均匀采样指定数量的数据
function sampleData(data: Array<TemperatureRecord>, sampleCount: number): Array<TemperatureRecord> {
  if (data.length <= sampleCount) return data;
  
  const result: Array<TemperatureRecord> = [];
  const step = Math.floor(data.length / sampleCount);
  
  for (let i = 0; i < sampleCount; i++) {
    const index = Math.min(i * step, data.length - 1);
    result.push(data[index]);
  }
  
  // 确保最新的数据一定会被包含
  if (data.length > 0 && result[result.length - 1] !== data[data.length - 1]) {
    result[result.length - 1] = data[data.length - 1];
  }
  
  return result;
}

// 获取温度历史数据
export async function getTemperatureHistory(): Promise<Array<TemperatureRecord>> {
  try {
    console.info('[Temperature Data] Fetching temperature history')
    const response = await http.createHttp().request(
      `${BASE_URL}/data`,
      {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        }
      }
    )

    if (response.responseCode === 200) {
      const rawData: Array<TemperatureDataItem> = JSON.parse(response.result.toString())
      console.info('[Temperature Data] Received data count:', rawData.length)
      
      if (!Array.isArray(rawData)) {
        throw new Error('返回数据格式错误')
      }

      // 将数据转换为TemperatureRecord对象
      const records = rawData.map(item => new TemperatureRecord(
        item.temperature_indoor,
        item.created_at
      ))

      // 获取20分钟前的时间戳
      const twentyMinutesAgo = new Date(Date.now() - 20 * 60 * 1000)
      
      // 过滤出20分钟内的数据
      const recentData = records.filter(record => {
        const recordTime = new Date(record.created_at)
        return recordTime >= twentyMinutesAgo
      })

      // 如果20分钟内的数据不足10条，则从所有数据中采样
      if (recentData.length < 10) {
        console.info('[Temperature Data] Not enough recent data, sampling from all data')
        const sampledData = sampleData(records, 10)
        console.info('[Temperature Data] Sampled data count:', sampledData.length)
        return sampledData
      }

      console.info('[Temperature Data] Using recent data count:', recentData.length)
      // 如果20分钟内的数据超过10条，进行采样
      return sampleData(recentData, 10)
    } else {
      throw new Error(`HTTP error! status: ${response.responseCode}`)
    }
  } catch (error) {
    console.error('[Temperature Data] Failed to get temperature history:', error)
    throw new Error('获取温度历史数据失败')
  }
}

// 获取最新温度数据
export async function getLatestTemperature(): Promise<TemperatureRecord> {
  try {
    const response = await http.createHttp().request(
      `${BASE_URL}/data/latest`,
      {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        }
      }
    )

    if (response.responseCode === 200) {
      const rawResult: LatestTemperatureResponseData = JSON.parse(response.result.toString())
      console.info('[Temperature Data] Latest temperature data:', rawResult)
      
      if (rawResult.status === 'success' && rawResult.latest) {
        return new TemperatureRecord(
          rawResult.latest.temperature_indoor,
          rawResult.latest.created_at
        )
      } else {
        throw new Error('无温度数据')
      }
    } else {
      throw new Error(`HTTP error! status: ${response.responseCode}`)
    }
  } catch (error) {
    console.error('[Temperature Data] Failed to get latest temperature:', error)
    throw new Error('获取最新温度数据失败')
  }
} 