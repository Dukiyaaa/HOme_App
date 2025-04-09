import { roomClass } from "./RoomData"

//设备类型
export class typeClass {
  typeId:number=0
  //类型名称
  typeName: string = '灯光'
  //打开时对应的图标
  typeIconOpen: Resource = $r('app.media.app_icon')
  //关闭时对应的图标
  typeIconClose: Resource = $r('app.media.app_icon')

  constructor(typeId:number,typeName: string, typeIconOpen: Resource, typeIconClose: Resource) {
    this.typeId=typeId
    this.typeName = typeName
    this.typeIconOpen = typeIconOpen
    this.typeIconClose = typeIconClose
  }
}

//设备类型常量
export class elecAppTypeClass {
  airCondition: typeClass = new typeClass(0,'空调', $r('app.media.airCondition_blue'), $r('app.media.airCondition_gray'))
  light: typeClass = new typeClass(1,'灯光', $r('app.media.light_blue'), $r('app.media.liight_gray'))
  curtain: typeClass = new typeClass(2,'窗帘', $r('app.media.curtain_blue'), $r('app.media.curtain_gray'))
  lock: typeClass = new typeClass(3,'门锁', $r('app.media.lock_blue'), $r('app.media.lock_gray'))
}
export const elecAppTypeConst: elecAppTypeClass = new elecAppTypeClass()
export const elecAppTypeArrayConst:typeClass[]=[
  new typeClass(0,'空调', $r('app.media.airCondition_blue'), $r('app.media.airCondition_gray')),
  new typeClass(1,'灯光', $r('app.media.light_blue'), $r('app.media.liight_gray')),
  new typeClass(2,'窗帘', $r('app.media.curtain_blue'), $r('app.media.curtain_gray')),
  new typeClass(3,'门锁', $r('app.media.lock_blue'), $r('app.media.lock_gray'))]

//耗电常量
@Observed
export class elecDataClass{
  todayElec:number=0
  monthElec:number=0
  nowElec:number=0
}
export const elecDataConst=new elecDataClass()

//空调类型
@Observed
export class airConditionClass {
  id: number = 0
  title: string = '客厅空调'
  state: number = 0
  belongRoom: roomClass = new roomClass(0, '客厅')
  type: typeClass = elecAppTypeConst.airCondition
  temperature:number=26
  airConditionMode: string = airConditionModeConst.auto
  airConditionWind: string = airConditionWindSpeedConst.auto
  airConditionWindWay: string = airConditionWindWayConst.close
  elecData:elecDataClass=elecDataConst

  constructor(id: number, title: string, belongRoom: roomClass, type: typeClass) {
    this.id = id
    this.title = title
    this.belongRoom = belongRoom
    this.type = type
  }

  // 修改方法返回类型
  getCurrentControlParams(): AirConditionerParams {
    // 确定模式
    const mode: 'cold' | 'hot' = this.airConditionMode === airConditionModeConst.hot ? 'hot' : 'cold'
    
    // 确定风速
    let speed: 1 | 2 | 3 = 1
    switch(this.airConditionWind) {
      case airConditionWindSpeedConst.low: speed = 1; break;
      case airConditionWindSpeedConst.middle: speed = 2; break;
      case airConditionWindSpeedConst.high: speed = 3; break;
      default: speed = 1;
    }

    return { mode, speed }
  }
}

//空调模式常量
@Observed
export class airConditionModeClass {
  auto: string = '自动'
  wind: string = '送风'
  hot: string = '制热'
  cold: string = '制冷'
  humidity: string = '除湿'
}
export const airConditionModeConst: airConditionModeClass = new airConditionModeClass()

//空调风速常量
@Observed
export class airConditionWindSpeedClass {
  auto:string='自动'
  low: string = '低'
  middle: string = '中'
  high: string = '高'
}
export const airConditionWindSpeedConst: airConditionWindSpeedClass = new airConditionWindSpeedClass()

//空调风向常量
@Observed
export class airConditionWindWayClass {
  upAndDown: string = '上下扫风'
  leftAndRigjt: string = '左右扫风'
  close: string = '关闭'
}
export const airConditionWindWayConst: airConditionWindWayClass = new airConditionWindWayClass()

//灯光类型
@Observed
export class lightClass {
  constructor(id: number, title: string, belongRoom: roomClass, type: typeClass) {
    this.id = id
    this.title = title
    this.belongRoom = belongRoom
    this.type = type
  }

  id: number = 0
  title: string = '灯光'
  state: number = 0
  belongRoom: roomClass = new roomClass(0, '客厅')
  type: typeClass = elecAppTypeConst.light
  brightness: number = 0
  colTemperatue: number = 0
  elecData:elecDataClass=elecDataConst
}

//窗帘类型
@Observed
export class curtainClass {
  constructor(id: number, title: string, belongRoom: roomClass,type: typeClass) {
    this.id = id
    this.title = title
    this.belongRoom = belongRoom
    this.type = type

  }
  id: number = 0
  title: string = '灯光'
  state: number = 0
  belongRoom: roomClass = new roomClass(0, '客厅')
  type: typeClass = elecAppTypeConst.curtain
  elecData:elecDataClass=elecDataConst
}

//门锁类型
@Observed
export class lockClass {
  constructor(id: number, title: string, belongRoom: roomClass,type: typeClass) {
    this.id = id
    this.title = title
    this.belongRoom = belongRoom
    this.type = type

  }

  id: number = 0
  title: string = '门锁'
  state: number = 0
  type: typeClass = elecAppTypeConst.lock
  belongRoom: roomClass = new roomClass(0, '客厅')
  elecData:elecDataClass=elecDataConst
}

//某类电器列表数据和状态信息
@Observed
export class typeElecAppState{
  constructor(elecAppList: airConditionClass[] | lightClass[] | curtainClass[] | lockClass[], state: number) {
    this.elecAppList = elecAppList
    this.state = state
  }
  elecAppList:airConditionClass[]|lightClass[]|curtainClass[]|lockClass[]=[]
  state:number=0
}
//模拟电器列表数据
export const tempElecAppList:typeElecAppState[]=[
  new typeElecAppState(
  [
    new airConditionClass(0,'客厅空调',new roomClass(0,'客厅'),elecAppTypeConst.airCondition),
    new airConditionClass(1,'卧室1空调',new roomClass(1,'卧室1'),elecAppTypeConst.airCondition),
    new airConditionClass(2,'卧室2空调',new roomClass(2,'卧室2'),elecAppTypeConst.airCondition)
  ],0
)
,
  new typeElecAppState(  [
    new lightClass(0,'客厅灯光1',new roomClass(0,'客厅'),elecAppTypeConst.light),
    new lightClass(1,'客厅灯光2',new roomClass(0,'客厅'),elecAppTypeConst.light),
    new lightClass(2,'卧室1灯光1',new roomClass(1,'卧室1'),elecAppTypeConst.light),
    new lightClass(3,'卧室2灯光1',new roomClass(2,'卧室2'),elecAppTypeConst.light)
  ],1)
,
  new typeElecAppState(
    [
      new curtainClass(0,'客厅窗帘',new roomClass(0,'客厅'),elecAppTypeConst.curtain),
      new curtainClass(1,'卧室1窗帘',new roomClass(1,'卧室1'),elecAppTypeConst.curtain),
      new curtainClass(2,'卧室2窗帘',new roomClass(2,'卧室2'),elecAppTypeConst.curtain)
    ],2
  )
,
  new typeElecAppState(
    [
      new lockClass(0,'门锁',new roomClass(0,'客厅'),elecAppTypeConst.lock,)
    ],0
  )
]
//电器列表路由信息
@Observed
export class elecAppRouteToClass{
  airConditionRouteTo:string='pages/AirConditionPage'
  lightRouteTo:string='pages/LightPage'
  curtainRouteTo:string='pages/CurtainPage'
  lockRouteTo:string='pages/LockPage'
}
export const elecAppRouteToConst=new elecAppRouteToClass()

@Observed
export class elecAppRouteToClass2{
  airConditionRouteTo:string='pages/AirConditionPage2'
  lightRouteTo:string='pages/LightPage2'
  curtainRouteTo:string='pages/CurtainPage2'
  lockRouteTo:string='pages/LockPage2'
}
export const elecAppRouteToConst2=new elecAppRouteToClass2()

// 添加空调控制参数接口
export interface AirConditionerParams {
  mode: 'cold' | 'hot'     // 使用字面量类型
  speed: 0 | 1 | 2 | 3     // 使用字面量类型，0表示关闭
}