import { http } from '@kit.NetworkKit'

//常量定义
const base_url:string='https://iam.cn-east-3.myhuaweicloud.com/'
//操控设备url
const ControlUrl="https://8a2e4d6e89.st1.iotda-app.cn-east-3.myhuaweicloud.com/v5/iot/40897786db2246109d1ece684eea957b/devices/67cc67268a63120625169e01_Home_hi3861/commands"

//获取token的body
export class getTokenBodyScopeName{
  name:string= "cn-east-3"
}
export class getTokenBodyScope {
  project: getTokenBodyScopeName=new getTokenBodyScopeName()
}
export class getTokenBodyAuthIdentityPasswordUserDomain {
  name:string= "hid_kpe4xoth-3z51rv" //IAM用户所属账号名
}
export class getTokenBodyAuthIdentityPasswordUser {
  name:string= "HOme3" //IAM用户名
  password: string="h123456@" //IAM用户密码
  domain: getTokenBodyAuthIdentityPasswordUserDomain=new getTokenBodyAuthIdentityPasswordUserDomain()
}
export class getTokenBodyAuthIdentityPassword {
  user: getTokenBodyAuthIdentityPasswordUser=new getTokenBodyAuthIdentityPasswordUser()

}
export class getTokenBodyAuthIdentity{
  methods: string[]=[
    "password"
  ]
  password:getTokenBodyAuthIdentityPassword=new getTokenBodyAuthIdentityPassword()
}
export class getTokenBodyAuth {
  identity:getTokenBodyAuthIdentity=new getTokenBodyAuthIdentity()
  scope:getTokenBodyScope=new getTokenBodyScope()
}
export class getTokenBody{
  auth:getTokenBodyAuth=new getTokenBodyAuth()
}
export class Token{
  xSubjectToken:string=""
}

//获取token
export async function getToken(body: getTokenBody): Promise<string | null> {
  const req = http.createHttp();
  const url = base_url + "v3/auth/tokens?nocatalog=true"; // 确保 base_url 已定义

  try {
    // 正确配置请求参数（url 需包含在 options 内）
    const response = await req.request(url,{
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': 'application/json;charset=utf8'
      },
      extraData: JSON.stringify(body) // 确保 body 被序列化为 JSON 字符串
    });

    // 检查 HTTP 状态码（通常认证成功返回 201）
    if (response.responseCode !== 201) {
      console.error(`认证失败，状态码: ${response.responseCode}`);
      return null;
    }

    // 使用 getHeader 方法获取字段（不区分大小写）
    const token:string = response.header['x-subject-token']
    return token ? String(token) : null;

  } catch (error) {
    console.error('请求异常:', error);
    return null;
  } finally {
    req.destroy(); // 确保销毁请求对象
  }
}

export class color_RGBParas {
  color_RGB: number = 0;

  constructor(brightness: number = 0, r: number = 255, g: number = 255, b: number = 255) {
    // 将亮度从0-100范围映射到0-15
    const mappedBrightness = Math.round((brightness / 100) * 15);
    
    // 构造32位控制命令
    // 0xA0000000 作为基础命令
    // 将亮度值放在第二个4位
    this.color_RGB = (0xA0000000 >>> 0);  // 基础命令
    this.color_RGB = ((this.color_RGB | (mappedBrightness << 24)) >>> 0);  // 亮度值左移24位
    this.color_RGB = ((this.color_RGB | ((r & 0xFF) << 16)) >>> 0);  // R值左移16位
    this.color_RGB = ((this.color_RGB | ((g & 0xFF) << 8)) >>> 0);   // G值左移8位
    this.color_RGB = ((this.color_RGB | (b & 0xFF)) >>> 0);          // B值

    // 添加调试日志
    console.info(`[Light Control] Constructing command:
      Original values:
      - brightness: ${brightness}
      - mapped brightness: ${mappedBrightness}
      - R: ${r}
      - G: ${g}
      - B: ${b}
      Final command: 0x${this.color_RGB.toString(16).toUpperCase()}
    `);
  }

  // 辅助方法：将色温值转换为RGB
  static colorTempToRGB(colorTemp: number): RGBColor {
    // 将0-100的色温值映射到冷色(6500K)到暖色(2700K)
    const temp = Math.round(6500 - (colorTemp / 100) * (6500 - 2700));
    
    let r: number = 255;
    let g: number = 255;
    let b: number = 255;
    
    // 简化的色温到RGB转换算法
    if (temp <= 4000) {
      // 暖色调
      r = 255;
      g = Math.round(255 * (temp - 2700) / 1300);
      b = 0;
    } else {
      // 冷色调
      r = Math.round(255 * (6500 - temp) / 2500);
      g = 255;
      b = Math.round(255 * (temp - 4000) / 2500);
    }
    
    return new RGBColor(r, g, b);
  }
}

export class open_percentParas{
  constructor(open_percent?: number) {
    this.open_percent = open_percent
  }
  open_percent?:number=1
}
export class close_percentParas{
  constructor(close_percent?: number) {
    this.close_percent = close_percent
  }
  close_percent?:number=1
}
export class door_stateParas{
  door_state: number = 0
  constructor(door_state: number) {
    this.door_state = door_state
  }
}
export class airConditioner_stateParas {
  airConditioner_state: number = 0

  constructor(mode: 'cold' | 'hot', speed: 0 | 1 | 2 | 3) {
    let state = 0;
    if (mode === 'hot') {
      state |= 0x01;
    }
    state |= ((speed) << 1);
    this.airConditioner_state = state;
  }
}

export class light_stateParas {
  light_state: number = 0
  constructor(state: number) {
    this.light_state = state
  }
}

export class RGBColor {
  r: number;
  g: number;
  b: number;

  constructor(r: number = 255, g: number = 255, b: number = 255) {
    this.r = r;
    this.g = g;
    this.b = b;
  }
}

export class responseParas{
  result:string= "ON"
}

// 修改 CommandParas 类型定义
export class CommandParas {
  color_RGB?: number
  open_percent?: number
  close_percent?: number
  door_state?: number
  airConditioner_state?: number
  light_state?: number
}

export class CommandBody {
  service_id: string
  command_name: string
  paras: CommandParas

  constructor(service_id: string, command_name: string, paras: CommandParas) {
    this.service_id = service_id
    this.command_name = command_name
    this.paras = paras
  }
}

// 修改 equipControl 类
export class equipControl {
  service_id: string = "attribute"
  command_name: string = "led_setLightness_color"
  paras: color_RGBParas|open_percentParas|close_percentParas|door_stateParas|airConditioner_stateParas|light_stateParas

  constructor(service_id: string, command_name: string, paras: color_RGBParas|open_percentParas|close_percentParas|door_stateParas|airConditioner_stateParas|light_stateParas) {
    this.service_id = service_id
    this.command_name = command_name
    this.paras = paras
  }

  toJSON(): CommandBody {
    let commandParas: CommandParas = {}
    
    if (this.paras instanceof color_RGBParas) {
      commandParas.color_RGB = this.paras.color_RGB
    } else if (this.paras instanceof open_percentParas) {
      commandParas.open_percent = this.paras.open_percent
    } else if (this.paras instanceof close_percentParas) {
      commandParas.close_percent = this.paras.close_percent
    } else if (this.paras instanceof door_stateParas) {
      commandParas.door_state = this.paras.door_state
    } else if (this.paras instanceof airConditioner_stateParas) {
      commandParas.airConditioner_state = this.paras.airConditioner_state
    } else if (this.paras instanceof light_stateParas) {
      commandParas.light_state = this.paras.light_state
    }

    return new CommandBody(
      this.service_id,
      this.command_name,
      commandParas
    )
  }
}

export class equipControlRes{
  command_id:string= "b1224afb-e9f0-4916-8220-b6bab568e888"
  response:equipControlResResponse=new equipControlResResponse()
  error_code : string=""
  error_msg : string=""
}

export class equipControlResResponse {
  result_code: number = 0
}

// 重新实现防抖功能
const debounceTimers = new Map<string, number>();

function debounce(key: string, fn: Function, delay: number = 300): void {
  // 如果已经有定时器在运行，先清除它
  if (debounceTimers.has(key)) {
    clearTimeout(debounceTimers.get(key));
  }

  // 设置新的定时器
  const timerId = setTimeout(() => {
    fn();
    debounceTimers.delete(key);
  }, delay);

  debounceTimers.set(key, timerId);
}

export async function postEquipControl(body: equipControl) {
  // 使用防抖来控制命令发送
  debounce('equipControl', async () => {
    const req = http.createHttp();
    
    // 添加请求参数日志
    console.info(`[Light Control] Sending command:
      URL: ${ControlUrl}
      Body: ${JSON.stringify(body, null, 2)}
    `);

    try {
      const response = await req.request(ControlUrl, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json',
          'X-Auth-Token': AppStorage.get('token')
        },
        extraData: JSON.stringify(body)
      });

      // 添加响应日志
      console.info(`[Light Control] Response:
        Status: ${response.responseCode}
        Result: ${response.result}
      `);
    } catch (error) {
      console.error('[Light Control] Error:', error);
    }
  });
}


