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

export class color_RGBParas{
  constructor(color_RGB?: number) {
    this.color_RGB = color_RGB
  }
  color_RGB?:number=1
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
  constructor(door_state?: number) {
    this.door_state = door_state
  }
  door_state?:number=1
}
export class airConditioner_stateParas{
  constructor(airConditioner_state?: number) {
    this.airConditioner_state = airConditioner_state
  }
  airConditioner_state?:number=1
}

export class responseParas{
  result:string= "ON"
}

//设备操控body
export class equipControl{
  constructor(service_id: string, command_name: string, paras: color_RGBParas|open_percentParas|close_percentParas|door_stateParas|airConditioner_stateParas) {
    this.service_id = service_id
    this.command_name = command_name
    this.paras = paras
  }

  service_id:string= "attribute"
  command_name:string="ON_OFF"
  paras : color_RGBParas|open_percentParas|close_percentParas|door_stateParas|airConditioner_stateParas=new color_RGBParas()
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

export async function postEquipControl(body:equipControl){
  const req = http.createHttp();
  const response =await req.request(ControlUrl, {
    method: http.RequestMethod.POST,
    header: {
      'Content-Type': 'application/json',
      'X-Auth-Token': AppStorage.get('token')
    },
    extraData: body
  });
  console.info(response.responseCode.toString())
  console.info(response.result.toString())
}


