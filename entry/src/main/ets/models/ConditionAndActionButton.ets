export class ConditionAndActionButtonItem{
  index:number=0
  title:string=''
  description:string=''
  img:Resource=$r('app.media.startIcon')//选中的图片
  routeTo:string=''
}

export const ConditionAndActionButtonList: ConditionAndActionButtonItem[]=[
  {
    index:0,
    title:'设备',
    description:'如玄关门锁打开',
    img:$r('app.media.equipment_set'),
    routeTo:'pages/DailyLifePage'
  },
  {
    index:1,
    title:'时间',
    description:'如7：30',
    img:$r('app.media.time_set'),
    routeTo:'pages/DailyLifePage'
  },
  {
    index:2,
    title:'温度',
    description:'如温度低至17°C',
    img:$r('app.media.temperature_set'),
    routeTo:'pages/DailyLifePage'
  },
  {
    index:3,
    title:'湿度',
    description:'如湿度高于70%',
    img:$r('app.media.humidity_blue'),
    routeTo:'pages/DailyLifePage'
  },
  {
    index:4,
    title:'设备',
    description:'如客厅灯光',
    img:$r('app.media.equipment_set'),
    routeTo:'pages/DailyLifePage'
  },
  {
    index:5,
    title:'导入',
    description:'如导入已有场景',
    img:$r('app.media.importt'),
    routeTo:'pages/DailyLifePage'
  },
  {
    index:6,
    title:'延时',
    description:'如延时15min后执行',
    img:$r('app.media.delay'),
    routeTo:'pages/DailyLifePage'
  },
  {
    index:7,
    title:'通知',
    description:'如开启后发送通知',
    img:$r('app.media.notice'),
    routeTo:'pages/DailyLifePage'
  }

]