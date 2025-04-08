export class SeceneBlockItem{
  index:number=0
  title:string=''
  title2:string=''
  title3:string=''
  img1:Resource=$r('app.media.startIcon')//选中的图片
  img2:Resource=$r('app.media.startIcon')//默认的图片
  routeTo:string=''

}

export const SceneBlockItemList: SeceneBlockItem[]=[
  {
    index:0,
    title:'日常生活',
    title2:'回家',
    title3:'离家',
    img1:$r('app.media.startIcon'),
    img2:$r('app.media.startIcon'),
    routeTo:'pages/DailyLifePage'
  },
  {
    index:1,
    title:'',
    title2:'燃气超标提醒',
    title3:'',
    img1:$r('app.media.startIcon'),
    img2:$r('app.media.startIcon'),
    routeTo:''
  },
  {
    index:2,
    title:'老人关怀',
    title2:'跌倒检测',
    title3:'定时服药',
    img1:$r('app.media.startIcon'),
    img2:$r('app.media.startIcon'),
    routeTo:''
  },
  {
    index:2,
    title:'独居女性关怀',
    title2:'门窗打开提醒',
    title3:'经期跟踪',
    img1:$r('app.media.startIcon'),
    img2:$r('app.media.startIcon'),
    routeTo:''
  }

]