import { http } from '@kit.NetworkKit'

const TEMPERATURE_HUMIDITY_URL = 'http://localhost:5000/data/latest'

interface LatestData {
  temperature_indoor: number;
  humidity_indoor: number;
  created_at: string;
}

interface TemperatureHumidityResponse {
  status: string;
  latest: LatestData;
}

// 获取最新温湿度数据
export async function getLatestTemperatureHumidity(): Promise<TemperatureHumidityResponse> {
  try {
    const response = await http.createHttp().request(
      TEMPERATURE_HUMIDITY_URL,
      {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        }
      }
    )

    if (response.responseCode === 200) {
      const result = response.result as string
      return JSON.parse(result) as TemperatureHumidityResponse
    } else {
      throw new Error(`HTTP error! status: ${response.responseCode}`)
    }
  } catch (error) {
    console.error('获取温湿度数据失败:', error)
    throw new Error('获取温湿度数据失败')
  }
}
