import { http } from '@kit.NetworkKit'

const BASE_URL = 'http://43.155.36.236:5000'

interface TemperatureRecord {
  temperature_indoor: number;
  created_at: string;
}

interface CSVData {
  temperature_indoor: number;
  created_at: string;
}

// 解析CSV数据
function parseCSV(csvText: string): Array<TemperatureRecord> {
  const lines = csvText.split('\n')
  const headers = lines[0].split(',')
  const tempIndex = headers.indexOf('temperature_indoor')
  const timeIndex = headers.indexOf('created_at')
  
  return lines.slice(1)  // 跳过表头
    .filter(line => line.trim())  // 过滤空行
    .map(line => {
      const values = line.split(',')
      const record: CSVData = {
        temperature_indoor: parseFloat(values[tempIndex]),
        created_at: values[timeIndex].replace(/"/g, '')  // 移除引号
      }
      return record
    })
    .filter(data => !isNaN(data.temperature_indoor))  // 过滤无效数据
}

// 获取温度历史数据
export async function getTemperatureHistory(): Promise<Array<TemperatureRecord>> {
  try {
    const response = await http.createHttp().request(
      `${BASE_URL}/data/export`,
      {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'text/csv'
        }
      }
    )

    if (response.responseCode === 200) {
      const csvData = response.result as string
      console.info('获取到的CSV数据:', csvData)
      return parseCSV(csvData)
    } else {
      throw new Error(`HTTP error! status: ${response.responseCode}`)
    }
  } catch (error) {
    console.error('获取温度历史数据失败:', error)
    throw new Error('获取温度历史数据失败')
  }
} 