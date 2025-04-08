//定义首页电器数据和电器按钮点进后的列表数据
import {LightSpecData,PowerConsumption} from '../models/ElecAppSpecData'

export class LightButtonSpecItem{
  lightSpecData:LightSpecData=new LightSpecData(0,'灯光',false,0,0,new PowerConsumption(20,2,50))
  image:Resource=$r('app.media.app_icon')
  routeTo:string='pages/AirConditionSpecPage'

  constructor(lightSpecData:LightSpecData,image:Resource,routeTo:string) {
    this.lightSpecData=lightSpecData
    this.image=image
    this.routeTo=routeTo
  }
}

export class ElecAppButtonSpecItem{
      index:number=0
      title:string='客厅空调'
      img1:Resource=$r('app.media.startIcon')
      routeTo:string='pages/AirConditionSpecPage'
}



export const AirConditionSpecItemList: ElecAppButtonSpecItem[]=[
  {
    index:0,
    title:'客厅空调',
    img1:$r('app.media.startIcon'),
    routeTo:'pages/AirConditionSpecPage'
  },
  {
    index:1,
    title:'卧室1空调',
    img1:$r('app.media.startIcon'),
    routeTo:'pages/AirConditionPage'
  },
  {
    index:2,
    title:'卧室2空调',
    img1:$r('app.media.startIcon'),
    routeTo:'pages/CurtainPage'
  },
  {
    index:3,
    title:'卧室3空调',
    img1:$r('app.media.startIcon'),
    routeTo:'pages/LockPage'
  }
]

export const CurtainnSpecItemList: ElecAppButtonSpecItem[]=[
  {
    index:0,
    title:'客厅窗帘',
    img1:$r('app.media.startIcon'),
    routeTo:'pages/CurtainSpecPage'
  },
  {
    index:1,
    title:'卧室1空调',
    img1:$r('app.media.startIcon'),
    routeTo:'pages/AirConditionPage'
  },
  {
    index:2,
    title:'卧室2空调',
    img1:$r('app.media.startIcon'),
    routeTo:'pages/CurtainPage'
  },
  {
    index:3,
    title:'卧室3空调',
    img1:$r('app.media.startIcon'),
    routeTo:'pages/LockPage'
  }
]

export const LightSpecItemList: ElecAppButtonSpecItem[]=[
  {
    index:0,
    title:'客厅灯光',
    img1:$r('app.media.startIcon'),
    routeTo:'pages/LightSpecPage'
  },
  {
    index:1,
    title:'卧室1空调',
    img1:$r('app.media.startIcon'),
    routeTo:'pages/AirConditionPage'
  },
  {
    index:2,
    title:'卧室2空调',
    img1:$r('app.media.startIcon'),
    routeTo:'pages/CurtainPage'
  },
  {
    index:3,
    title:'卧室3空调',
    img1:$r('app.media.startIcon'),
    routeTo:'pages/LockPage'
  }
]

export const LockSpecItemList: ElecAppButtonSpecItem[]=[
  {
    index:0,
    title:'客厅门锁',
    img1:$r('app.media.startIcon'),
    routeTo:'pages/LockSpecPage'
  },
  {
    index:1,
    title:'卧室1空调',
    img1:$r('app.media.startIcon'),
    routeTo:'pages/LockSpecPage'
  },
  {
    index:2,
    title:'卧室2空调',
    img1:$r('app.media.startIcon'),
    routeTo:'pages/CurtainPage'
  },
  {
    index:3,
    title:'卧室3空调',
    img1:$r('app.media.startIcon'),
    routeTo:'pages/LockPage'
  }
]
