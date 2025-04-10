import { http } from '@kit.NetworkKit'

const ELECTRICITY_DATA_URL = 'http://43.155.36.236:5000/data/latest'

interface ElectricityData {
  power: number;  // 功率，单位：微瓦
  created_at: string;
}

interface ElectricityResponse {
  status: string;
  latest: ElectricityData;
}

// 获取最新用电数据
export async function getLatestElectricityData(): Promise<ElectricityResponse> {
  try {
    const response = await http.createHttp().request(
      ELECTRICITY_DATA_URL,
      {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        }
      }
    )

    if (response.responseCode === 200) {
      const result = response.result as string
      return JSON.parse(result) as ElectricityResponse
    } else {
      throw new Error(`HTTP error! status: ${response.responseCode}`)
    }
  } catch (error) {
    console.error('获取用电数据失败:', error)
    throw new Error('获取用电数据失败')
  }
} 