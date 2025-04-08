export class AddButtonItem{
  image:Resource=$r('app.media.add')
  title:string='添加触发条件'
  routeTo:string=''
}

export const AddButtonItemList:AddButtonItem[]=[
  {
    image:$r('app.media.add'),
    title:'添加触发条件',
    routeTo:'pages/DailyLifePage'
  },
  {
    image:$r('app.media.add'),
    title:'添加执行动作',
    routeTo:'pages/DailyLifePage'
  }
]