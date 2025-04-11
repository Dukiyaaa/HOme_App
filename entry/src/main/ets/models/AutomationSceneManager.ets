import { http } from '@kit.NetworkKit'

// 基础自动化功能（0~7位）
export const AUTO_MODE_MOTION_LIGHT = 1 << 0;            // 有人自动开灯
export const AUTO_MODE_TEMP_AC = 1 << 1;                 // 温度控制空调
export const AUTO_MODE_SMOKE_ALARM = 1 << 2;             // 烟雾/燃气报警
export const AUTO_MODE_NFC_HOME_MODE = 1 << 3;           // NFC触发回家模式
export const AUTO_MODE_LIGHT_CURTAIN = 1 << 4;           // 光照控制窗帘
export const AUTO_MODE_AUTO_LOCK = 1 << 5;               // 离家自动锁门
export const AUTO_MODE_LIGHT_LIGHTNESS = 1 << 6;         // 光照控制光亮
export const AUTO_MODE_HUMI_AC = 1 << 7;                 // 湿度控制空调

// 高级环境与状态联动（8~15位）
export const AUTO_MODE_TEMP_CURTAIN = 1 << 8;           // 温度控制窗帘
export const AUTO_MODE_ENERGY_SAVER = 1 << 9;           // 节能模式
export const AUTO_MODE_HUMI_CURTAIN = 1 << 10;          // 湿度控制窗帘
export const AUTO_MODE_SILENT_ALARM = 1 << 11;          // 静音报警
export const AUTO_MODE_LOW_VOLTAGE_PROTECT = 1 << 12;   // 电压过低自动关大负载
export const AUTO_MODE_NIGHT_MODE = 1 << 13;            // 晚间自动进入夜间模式
export const AUTO_MODE_IDLE_SLEEP_MODE = 1 << 14;       // 无人自动休眠/关设备
export const AUTO_MODE_TIME_BLOCK_LIGHTING = 1 << 15;   // 固定时间段控制灯光

// 预设场景组合
export const SCENE_LIGHT_CTRL = AUTO_MODE_MOTION_LIGHT | AUTO_MODE_LIGHT_LIGHTNESS;  // 人体感应 + 光照控制
export const SCENE_TEMP_CTRL = AUTO_MODE_TEMP_AC | AUTO_MODE_TEMP_CURTAIN;  // 温度控制
export const SCENE_HUMI_CTRL = AUTO_MODE_HUMI_AC | AUTO_MODE_HUMI_CURTAIN;  // 湿度控制
export const SCENE_SECURITY_ALARM = AUTO_MODE_SMOKE_ALARM | AUTO_MODE_NFC_HOME_MODE | AUTO_MODE_AUTO_LOCK | AUTO_MODE_SILENT_ALARM;  // 安防报警
export const SCENE_ENERGY_SAVER = AUTO_MODE_ENERGY_SAVER | AUTO_MODE_LOW_VOLTAGE_PROTECT;  // 节能模式

//操控设备url
const BASE_URL = 'http://43.155.36.236:5000'
const ControlUrl = "https://8a2e4d6e89.st1.iotda-app.cn-east-3.myhuaweicloud.com/v5/iot/40897786db2246109d1ece684eea957b/devices/67cc67268a63120625169e01_Home_hi3861/commands"

// 定义接口
interface LatestData {
  automation_mode_scene: number
}

interface DatabaseResponse {
  status: string
  latest: LatestData
}

interface CommandParams {
  automation_mode_scene: number
}

interface CommandBody {
  service_id: string
  command_name: string
  paras: CommandParams
}

interface SceneResponse {
  status: string
  scenes: number
}

class AutomationSceneManager {
  private static instance: AutomationSceneManager;
  private currentScenes: number = 0;  // 当前启用的场景位图

  private constructor() {}

  public static getInstance(): AutomationSceneManager {
    if (!AutomationSceneManager.instance) {
      AutomationSceneManager.instance = new AutomationSceneManager();
    }
    return AutomationSceneManager.instance;
  }

  // 获取所有场景状态
  public async fetchAllScenes(): Promise<boolean> {
    try {
      console.info('[Scene Manager] Fetching latest data...');
      const req = http.createHttp();
      const response = await req.request(`${BASE_URL}/data/latest`, {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        }
      });

      console.info('[Scene Manager] Response code:', response.responseCode);
      
      if (response.responseCode === 200) {
        console.info('[Scene Manager] Raw response result:', response.result);
        const result: DatabaseResponse = JSON.parse(response.result as string);
        console.info('[Scene Manager] Parsed result:', JSON.stringify(result));
        
        if (result.status === 'success' && result.latest) {
          const sceneValue = result.latest.automation_mode_scene || 0;
          console.info('[Scene Manager] Received automation_mode_scene value:', sceneValue);
          console.info('[Scene Manager] Binary representation:', sceneValue.toString(2).padStart(16, '0'));
          
          this.currentScenes = sceneValue;
          
          // 打印每个场景的状态
          console.info('[Scene Manager] Scene states:');
          console.info('- Temperature AC:', this.isSceneEnabled(AUTO_MODE_TEMP_AC));
          console.info('- Temperature Curtain:', this.isSceneEnabled(AUTO_MODE_TEMP_CURTAIN));
          
          return true;
        } else {
          console.error('[Scene Manager] Invalid response format or status is not success');
        }
      } else {
        console.error('[Scene Manager] Response code is not 200:', response.responseCode);
      }
      return false;
    } catch (error) {
      console.error('[Scene Manager] Failed to fetch scenes:', error);
      return false;
    }
  }

  // 启用场景
  public async enableScene(scenes: number): Promise<boolean> {
    try {
      console.info('[Scene Manager] Enabling scene:', scenes.toString(2).padStart(16, '0'));
      const response = await this.sendCommand('enable_automation_mode_scene', scenes);
      console.info('[Scene Manager] Enable command response:', response.responseCode);
      
      if (response.responseCode === 200) {
        // 获取最新状态
        await this.fetchAllScenes();
        return true;
      }
      return false;
    } catch (error) {
      console.error('[Scene Manager] Enable scene failed:', error);
      return false;
    }
  }

  // 禁用场景
  public async disableScene(scenes: number): Promise<boolean> {
    try {
      console.info('[Scene Manager] Disabling scene:', scenes.toString(2).padStart(16, '0'));
      const response = await this.sendCommand('disable_automation_mode_scene', scenes);
      console.info('[Scene Manager] Disable command response:', response.responseCode);
      
      if (response.responseCode === 200) {
        // 获取最新状态
        await this.fetchAllScenes();
        return true;
      }
      return false;
    } catch (error) {
      console.error('[Scene Manager] Disable scene failed:', error);
      return false;
    }
  }

  // 检查场景是否启用
  public isSceneEnabled(scene: number): boolean {
    const result = (this.currentScenes & scene) === scene;
    console.info(`[Scene Manager] Checking scene ${scene.toString(2).padStart(16, '0')}, current scenes: ${this.currentScenes.toString(2).padStart(16, '0')}, result: ${result}`);
    return result;
  }

  // 发送场景控制命令
  private async sendCommand(command: string, scenes: number): Promise<http.HttpResponse> {
    const body: CommandBody = {
      service_id: "attribute",
      command_name: command,
      paras: {
        automation_mode_scene: scenes
      }
    };

    const req = http.createHttp();
    console.info('[Scene Manager] Sending command:', command);
    console.info('[Scene Manager] Request URL:', ControlUrl);
    console.info('[Scene Manager] Request body:', JSON.stringify(body));

    try {
      const response = await req.request(ControlUrl, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json',
          'X-Auth-Token': AppStorage.get('token')
        },
        extraData: JSON.stringify(body)
      });

      console.info('[Scene Manager] Response code:', response.responseCode);
      console.info('[Scene Manager] Response result:', response.result);

      return response;
    } catch (error) {
      console.error('[Scene Manager] Network error:', error);
      return {
        responseCode: 500,
        result: error?.toString() || 'Unknown error'
      } as http.HttpResponse;
    }
  }
}

export default AutomationSceneManager; 