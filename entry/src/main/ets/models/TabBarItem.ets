export class tabBarItem{
  index:number=0
  title:string=''
  iconSelected:Resource=$r('app.media.startIcon')//选中的图片
  iconNormal:Resource=$r('app.media.startIcon')//默认的图片

}

export const tabBarItemList: tabBarItem[]=[
  {
    index:0,
    title:'首页',
    iconSelected:$r('app.media.index_blue'),
    iconNormal:$r('app.media.index_gray')
  },
  {
    index:1,
    title:'智能场景',
    iconSelected:$r('app.media.Scene_blue'),
    iconNormal:$r('app.media.Scene_gray')
  },
  {
    index:2,
    title:'AI助手',
    iconSelected:$r('app.media.aiChat_blue'),
    iconNormal:$r('app.media.aiChat_gray')
  },
  {
    index:2,
    title:'我的',
    iconSelected:$r('app.media.mine_blue'),
    iconNormal:$r('app.media.mine_gray')
  }

]