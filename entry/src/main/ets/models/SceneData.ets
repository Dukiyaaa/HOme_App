import {airConditionModeConst,
  airConditionWindSpeedConst,
  airConditionWindWayConst,
  elecAppTypeConst,
  elecAppTypeConst2,
  typeClass} from './EquipData'
import { AUTO_MODE_MOTION_LIGHT, AUTO_MODE_LIGHT_LIGHTNESS, AUTO_MODE_TEMP_AC, AUTO_MODE_TEMP_CURTAIN,
  AUTO_MODE_HUMI_AC, AUTO_MODE_HUMI_CURTAIN, AUTO_MODE_SMOKE_ALARM, AUTO_MODE_NFC_HOME_MODE,
  AUTO_MODE_AUTO_LOCK, AUTO_MODE_SILENT_ALARM, AUTO_MODE_ENERGY_SAVER, AUTO_MODE_LOW_VOLTAGE_PROTECT } from './AutomationSceneManager'

export class SceneButtonItem{
  index:number=0
  title:string=''
  img:Resource=$r('app.media.startIcon')//选中的图片

}

export const SceneButtonList: SceneButtonItem[]=[
  {
    index:0,
    title:'',
    img:$r('app.media.startIcon')
  },
  {
    index:1,
    title:'智能场景',
    img:$r('app.media.startIcon')
  },
  {
    index:2,
    title:'AI助手',
    img:$r('app.media.startIcon')
  },
  {
    index:2,
    title:'我的',
    img:$r('app.media.startIcon')
  }

]

//设备动作信息
@Observed
export class elecAppAction{
  airConditionAction?:airConditionAction[]
  lightAction?:lightAction[]
  curtainAction?:curtainAction[]
  lockAction?:lockAction[]
  delayAction?:delayAction

  constructor(airConditionAction?:airConditionAction[],
    lightAction?:lightAction[],
    curtainAction?:curtainAction[],
    lockAction?:lockAction[],delayAction?:delayAction) {
    this.airConditionAction=airConditionAction
    this.lightAction=lightAction
    this.curtainAction=curtainAction
    this.lockAction=lockAction
    this.delayAction=delayAction
  }
}
//空调动作信息
@Observed
export class airConditionAction{
  constructor(elecAppId: number, title: string, type: typeClass, closeOrOpen: number, temperature: number, mode: string,
    windSpeed: string, windWay: string, timeSet: number) {
    this.elecAppId = elecAppId
    this.title = title
    this.type = type
    this.closeOrOpen = closeOrOpen
    this.temperature = temperature
    this.mode = mode
    this.windSpeed = windSpeed
    this.windWay = windWay
    this.timeSet = timeSet
  }
  //设备id
  elecAppId:number=0
  //设备名称
  title:string='空调'
  //设备类型
  type:typeClass=elecAppTypeConst.airCondition
  //操作
  closeOrOpen:number=0
  //设定温度
  temperature:number=26
  //模式
  mode:string=airConditionModeConst.auto
  //风速
  windSpeed:string=airConditionWindSpeedConst.middle
  //扫风
  windWay:string=airConditionWindWayConst.close
  //定时设置
  timeSet:number=-1
}
//灯光动作信息
@Observed
export class lightAction{
  constructor(elecAppId: number, title: string, type: typeClass, closeOrOpen: number, brightness: number,
    colTemperature: number) {
    this.elecAppId = elecAppId
    this.title = title
    this.type = type
    this.closeOrOpen = closeOrOpen
    this.brightness = brightness
    this.colTemperature = colTemperature
  }
  //设备id
  elecAppId:number=0
  //设备名称
  title:string='灯光'
  //设备类型
  type:typeClass=elecAppTypeConst.light
  //操作
  closeOrOpen:number=0
  //亮度设置
  brightness:number=50
  //色温设置
  colTemperature:number=50
}
//窗帘动作信息
@Observed
export class curtainAction{
  constructor(elecAppId: number, title: string, type: typeClass, closeOrOpen: number) {
    this.elecAppId = elecAppId
    this.title = title
    this.type = type
    this.closeOrOpen = closeOrOpen
  }
  //设备id
  elecAppId:number=0
  //设备名称
  title:string='窗帘'
  //设备类型
  type:typeClass=elecAppTypeConst.curtain
  //开度
  closeOrOpen:number=100
}
//门锁动作信息
@Observed
export class lockAction{
  constructor(elecAppId: number, title: string, type: typeClass, closeOrOpen: number) {
    this.elecAppId = elecAppId
    this.title = title
    this.type = type
    this.closeOrOpen = closeOrOpen
  }
  //设备id
  elecAppId:number=0
  //设备名称
  title:string='门锁'
  //设备类型
  type:typeClass=elecAppTypeConst.lock
  //操作
  closeOrOpen:number=0
}
//延时动作信息
@Observed
export class delayAction{
  constructor(delayTime: Date) {
    this.delayTime = delayTime
  }
  delayTime:Date=new Date
}
//提醒动作信息
@Observed
export class remindAction{
  constructor(remindTime: Date) {
    this.remindTime = remindTime
  }
  remindTime:Date=new Date
  isFestival:boolean=false
  isRepeat:string[]=[]
}
//触发条件信息
@Observed
export class SceneCondition{
  constructor(airConditionCondition?: airConditionAction[], lightCondition?: lightAction[], curtainCondition?: curtainAction[],
    lockCondition?: lockAction[], timeCondition?: timeConditionClass[], temperatureCondition?: temperatureConditionClass,
    humidityCondition?: humidityConditionClass) {
    this.airConditionCondition = airConditionCondition
    this.lightCondition = lightCondition
    this.curtainCondition = curtainCondition
    this.lockCondition = lockCondition
    this.timeCondition = timeCondition
    this.temperatureCondition = temperatureCondition
    this.humidityCondition = humidityCondition
  }
  airConditionCondition?:airConditionAction[]
  lightCondition?:lightAction[]
  curtainCondition?:curtainAction[]
  lockCondition?:lockAction[]
  timeCondition?:timeConditionClass[]
  temperatureCondition?:temperatureConditionClass
  humidityCondition?:humidityConditionClass
}
//时间条件信息
export class timeConditionClass{
  constructor(time: Date, isFestival: boolean, isRepeat: boolean[]) {
    this.time = time
    this.isFestival = isFestival
    this.isRepeat = isRepeat
  }
  time:Date=new Date
  isFestival:boolean=false
  isRepeat:boolean[]=[]
}
//温度条件信息
export class temperatureConditionClass{
  constructor(lowOrHigh: string, temperature: number) {
    this.lowOrHigh = lowOrHigh
    this.temperature = temperature
  }
  lowOrHigh:string='低于'
  temperature:number=26
}
//湿度条件信息
export class humidityConditionClass{
  constructor(lowOrHigh: string, humidity: number) {
    this.lowOrHigh = lowOrHigh
    this.humidity = humidity
  }
  lowOrHigh:string='低于'
  humidity:number=50
}
//场景完整数据
@Observed
export class SceneClass{
  //场景ID
  sceneId:number=0
  //场景名称
  sceneTitle:string=''
  //场景图标
  sceneImageOpen:Resource=$r('app.media.scene_button_icon')
  sceneImageClose:Resource=$r('app.media.scene_button_icon')
  //场景状态
  closeOrOpen:number=0
  //执行动作信息
  sceneAction:elecAppAction=new elecAppAction()
  //触发条件信息
  sceneCondition:SceneCondition=new SceneCondition()

  constructor(sceneId:number,sceneTitle:string,sceneImage:Resource,sceneImageClose:Resource,closeOrOpen:number,sceneAction:elecAppAction) {
    this.sceneId=sceneId
    this.sceneTitle=sceneTitle
    this.sceneImageOpen=sceneImage
    this.sceneImageClose=sceneImageClose
    this.closeOrOpen=closeOrOpen
    this.sceneAction=sceneAction
  }
}
//场景列表数据
@Observed
export class SceneClassList{
  constructor(sceneDataList: SceneClass[]) {
    this.sceneDataList = sceneDataList
  }
  sceneDataList:SceneClass[]=[]
}
//模式完整数据
@Observed
export class ModeClass{
  constructor(modeId: number, modeName: string, sceneListData: SceneClassList) {
    this.modeId = modeId
    this.modeName = modeName
    this.sceneListData = sceneListData
  }
  modeId:number=0
  modeName:string='自定义模式'
  sceneListData:SceneClassList=new SceneClassList([])
}

export const TempModeListConst:ModeClass[]=
  [
    new ModeClass(0,'日常生活',new SceneClassList([new SceneClass(
    0,
    '回家模式',
    $r('app.media.leave_home'),
    $r('app.media.leave_home_close'),
    0,
    new elecAppAction(
      [new airConditionAction(0, '客厅空调', elecAppTypeConst.airCondition, 0, 0, airConditionModeConst.auto, airConditionWindSpeedConst.low, airConditionWindWayConst.upAndDown, 0)],
      undefined,
      [new curtainAction(0, '客厅空调', elecAppTypeConst.curtain, 0)],
      [new lockAction(0, '客厅空调', elecAppTypeConst.lock, 0)]
    )),new SceneClass(1,
    '离家模式',
    $r('app.media.leave_home'),
    $r('app.media.leave_home_close'),
    0,
    new elecAppAction([new airConditionAction(0,
      '客厅空调',
      elecAppTypeConst.airCondition,
      0,
      0,
      airConditionModeConst.auto,
      airConditionWindSpeedConst.low,
      airConditionWindWayConst.upAndDown,
      0)],undefined,[new lockAction(0, '客厅空调', elecAppTypeConst.lock, 0)])),new SceneClass(2,
    '模式',
    $r('app.media.leave_home'),
    $r('app.media.leave_home_close'),
    0,
    new elecAppAction([new airConditionAction(0,
      '客厅空调',
      elecAppTypeConst.airCondition,
      0,
      0,
      airConditionModeConst.auto,
      airConditionWindSpeedConst.low,
      airConditionWindWayConst.upAndDown,
      0)])),new SceneClass(3,
    '家模式',
    $r('app.media.back_home'),
    $r('app.media.leave_home_close'),
    1,
    new elecAppAction([new airConditionAction(0,
      '客厅空调',
      elecAppTypeConst.airCondition,
      0,
      0,
      airConditionModeConst.auto,
      airConditionWindSpeedConst.low,
      airConditionWindWayConst.upAndDown,
      0)]))])),
    new ModeClass(1,'节能模式',new SceneClassList([new SceneClass(
    0,
    '提前断电',
    $r('app.media.leave_home'),
    $r('app.media.leave_home_close'),
    0,
    new elecAppAction(
      [new airConditionAction(0, '客厅空调', elecAppTypeConst2.airCondition, 0, 0, airConditionModeConst.auto, airConditionWindSpeedConst.low, airConditionWindWayConst.upAndDown, 0)],
      undefined,
    )),new SceneClass(1,
    '用电提醒',
    $r('app.media.leave_home'),
    $r('app.media.leave_home_close'),
    0,
    new elecAppAction([new airConditionAction(0,
      '客厅空调',
      elecAppTypeConst2.light,
      0,
      0,
      airConditionModeConst.auto,
      airConditionWindSpeedConst.low,
      airConditionWindWayConst.upAndDown,
      0)])),new SceneClass(2,
    '模式',
    $r('app.media.leave_home'),
    $r('app.media.leave_home_close'),
    0,
    new elecAppAction([new airConditionAction(0,
      '客厅空调',
      elecAppTypeConst.airCondition,
      0,
      0,
      airConditionModeConst.auto,
      airConditionWindSpeedConst.low,
      airConditionWindWayConst.upAndDown,
      0)])),new SceneClass(3,
    '家模式',
    $r('app.media.back_home'),
    $r('app.media.leave_home_close'),
    1,
    new elecAppAction([new airConditionAction(0,
      '客厅空调',
      elecAppTypeConst.airCondition,
      0,
      0,
      airConditionModeConst.auto,
      airConditionWindSpeedConst.low,
      airConditionWindWayConst.upAndDown,
      0)]))])),
    new ModeClass(2,'独居女性模式',new SceneClassList([new SceneClass(
      0,
      '开门提醒',
      $r('app.media.menopen'),
      $r('app.media.menopen'),
      0,
      new elecAppAction(
        [new airConditionAction(0, '客厅空调', elecAppTypeConst.lock, 0, 0, airConditionModeConst.auto, airConditionWindSpeedConst.low, airConditionWindWayConst.upAndDown, 0)],
        undefined,
        [new curtainAction(0, '客厅空调', elecAppTypeConst2.light, 0)]
      )),new SceneClass(1,
      '经期跟踪',
      $r('app.media.jingqi2'),
      $r('app.media.jingqi2'),
      0,
      new elecAppAction([new airConditionAction(0,
        '客厅空调',
        elecAppTypeConst2.light,
        0,
        0,
        airConditionModeConst.auto,
        airConditionWindSpeedConst.low,
        airConditionWindWayConst.upAndDown,
        0)])),new SceneClass(2,
      '模式',
      $r('app.media.leave_home'),
      $r('app.media.leave_home_close'),
      0,
      new elecAppAction([new airConditionAction(0,
        '客厅空调',
        elecAppTypeConst.airCondition,
        0,
        0,
        airConditionModeConst.auto,
        airConditionWindSpeedConst.low,
        airConditionWindWayConst.upAndDown,
        0)])),new SceneClass(3,
      '家模式',
      $r('app.media.back_home'),
      $r('app.media.leave_home_close'),
      1,
      new elecAppAction([new airConditionAction(0,
        '客厅空调',
        elecAppTypeConst.airCondition,
        0,
        0,
        airConditionModeConst.auto,
        airConditionWindSpeedConst.low,
        airConditionWindWayConst.upAndDown,
        0)]))])),
    new ModeClass(3,'老人关怀模式',new SceneClassList([new SceneClass(
  0,
  '跌倒检测',
  $r('app.media.diedao'),
  $r('app.media.diedao'),
  0,
  new elecAppAction(
    [new airConditionAction(0, '客厅空调', elecAppTypeConst.lock, 0, 0, airConditionModeConst.auto, airConditionWindSpeedConst.low, airConditionWindWayConst.upAndDown, 0)],
    undefined,
    [new curtainAction(0, '客厅空调', elecAppTypeConst2.curtain, 0)],
  )),new SceneClass(1,
  '定时服药',
  $r('app.media.yaowan'),
  $r('app.media.yaowan'),
  0,
  new elecAppAction([new airConditionAction(0,
    '客厅空调',
    elecAppTypeConst2.curtain,
    0,
    0,
    airConditionModeConst.auto,
    airConditionWindSpeedConst.low,
    airConditionWindWayConst.upAndDown,
    0)])),new SceneClass(2,
  '模式',
  $r('app.media.leave_home'),
  $r('app.media.leave_home_close'),
  0,
  new elecAppAction([new airConditionAction(0,
    '客厅空调',
    elecAppTypeConst.airCondition,
    0,
    0,
    airConditionModeConst.auto,
    airConditionWindSpeedConst.low,
    airConditionWindWayConst.upAndDown,
    0)])),new SceneClass(3,
  '家模式',
  $r('app.media.back_home'),
  $r('app.media.leave_home_close'),
  1,
  new elecAppAction([new airConditionAction(0,
    '客厅空调',
    elecAppTypeConst.airCondition,
    0,
    0,
    airConditionModeConst.auto,
    airConditionWindSpeedConst.low,
    airConditionWindWayConst.upAndDown,
    0)]))]))
  ]

// 预设场景组合
export const SCENE_LIGHT_CTRL = AUTO_MODE_MOTION_LIGHT | AUTO_MODE_LIGHT_LIGHTNESS;  // 人体感应 + 光照控制
export const SCENE_TEMP_CTRL = AUTO_MODE_TEMP_AC | AUTO_MODE_TEMP_CURTAIN;  // 温度控制
export const SCENE_HUMI_CTRL = AUTO_MODE_HUMI_AC | AUTO_MODE_HUMI_CURTAIN;  // 湿度控制
export const SCENE_SECURITY_ALARM = AUTO_MODE_SMOKE_ALARM | AUTO_MODE_NFC_HOME_MODE | AUTO_MODE_AUTO_LOCK | AUTO_MODE_SILENT_ALARM;  // 安防报警
export const SCENE_ENERGY_SAVER = AUTO_MODE_ENERGY_SAVER | AUTO_MODE_LOW_VOLTAGE_PROTECT;  // 节能模式