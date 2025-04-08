export class CloseAndYesButtonItem{
  title:string=''
  image:Resource=$r('app.media.close')
  routeTo:string=''
}

export class CloseAndYesButton{
  constructor(title: string, image: Resource, routeTo: string) {
    this.title = title
    this.image = image
    this.routeTo = routeTo
  }
  title:string=''
  image:Resource=$r('app.media.close')
  routeTo:string=''


}

export const SceneSetItemList:CloseAndYesButtonItem[]=[
  {
    title:'',
    image:$r('app.media.close'),
    routeTo:'pages/Index'
  },
  {
    title:'',
    image:$r('app.media.yes'),
    routeTo:'pages/Index'
  }
]

export const EquipItemList:CloseAndYesButtonItem[]=[
  {
    title:'',
    image:$r('app.media.close'),
    routeTo:'pages/SceneSet'
  },
  {
    title:'',
    image:$r('app.media.yes'),
    routeTo:'pages/SceneSet'
  }
]

export const EquipSpecItemList:CloseAndYesButtonItem[]=[
  {
    title:'',
    image:$r('app.media.close'),
    routeTo:'pages/SceneSet'
  },
  {
    title:'',
    image:$r('app.media.yes'),
    routeTo:'pages/SceneSet'
  }
]

export const AirConditionBackItemList:CloseAndYesButtonItem[]=[
  {
    title:'空调列表',
    image:$r('app.media.close'),
    routeTo:'pages/Index'
  }
]

export const EquipListBackItemList:CloseAndYesButtonItem[]=[
  {
    title:'选择设备',
    image:$r('app.media.close'),
    routeTo:'pages/SceneSet'
  }
]

export const CurtainBackItemList:CloseAndYesButtonItem[]=[
  {
    title:'窗帘列表',
    image:$r('app.media.close'),
    routeTo:'pages/Index'
  }
]

export const LightBackItemList:CloseAndYesButtonItem[]=[
  {
    title:'灯光列表',
    image:$r('app.media.close'),
    routeTo:'pages/Index'
  }
]

export const LockBackItemList:CloseAndYesButtonItem[]=[
  {
    title:'门锁列表',
    image:$r('app.media.close'),
    routeTo:'pages/Index'
  }
]

export const AirConditionSpecBackItemList:CloseAndYesButtonItem[]=[
  {
    title:'空调1',
    image:$r('app.media.close'),
    routeTo:'pages/AirConditionPage'
  }
]

export const CurtainSpecBackItemList:CloseAndYesButtonItem[]=[
  {
    title:'窗帘1',
    image:$r('app.media.close'),
    routeTo:'pages/CurtainSpecPage'
  }
]

export const LightSpecBackItemList:CloseAndYesButtonItem[]=[
  {
    title:'灯光1',
    image:$r('app.media.close'),
    routeTo:'pages/LightPage'
  }
]

export const LockSpecBackItemList:CloseAndYesButtonItem[]=[
  {
    title:'门锁1',
    image:$r('app.media.close'),
    routeTo:'pages/LockPage'
  }
]

export const AddBackPageButton:CloseAndYesButtonItem[]=[
  {
    title:'添加设备',
    image:$r('app.media.close'),
    routeTo:'pages/Index'
  }
]

export const AddSpecEquipButton:CloseAndYesButtonItem[]=[
  {
    title:'',
    image:$r('app.media.close'),
    routeTo:'pages/AddPage'
  },
  {
    title:'',
    image:$r('app.media.yes'),
    routeTo:'pages/Index'
  }
]