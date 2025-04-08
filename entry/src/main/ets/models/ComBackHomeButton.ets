export class ComeBackHomeButtonItem{
  title:string=''
  mainImg:Resource=$r('app.media.leave_home')
  img1:Resource=$r('app.media.light_blue')
  img2:Resource=$r('app.media.airCondition_blue')
}

export const ComeBackHomeItemList:ComeBackHomeButtonItem[]=[
  {  title:'回家模式',
    mainImg:$r('app.media.back_home'),
    img1:$r('app.media.light_blue'),
    img2:$r('app.media.airCondition_blue')
  },
  {  title:'离家模式',
    mainImg:$r('app.media.leave_home'),
    img1:$r('app.media.light_blue'),
    img2:$r('app.media.airCondition_blue')
  }
]