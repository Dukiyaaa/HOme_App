import {SceneBlockItemList,SeceneBlockItem} from '../models/SceneBlock'
import {router} from '@kit.ArkUI'

@Component
export struct SecondComp {
  @State selects: SelectOption[] = [{ value: '用户1' }, { value: '用户2' }]
  //头像
  @State touxiang:Resource=$r('app.media.touxiang')
  //用户名
  @State username:string='海阔天空'

  build() {
    Column(){
      Row({space:10}){
        Button(){
          Image(this.touxiang).width(35).height(35)
        }
        .width(42).height(42).backgroundColor(Color.Transparent)
        Text(this.username)
        Blank()
        Button('联系客服').margin({right:10}).backgroundColor('5686E1')
        Button(){
          Image($r('app.media.add')).width(30)
        }.backgroundColor(Color.Transparent)
      }
      .height(50)
      .width('100%')
      Tabs(){
            TabContent() {
                Column({ space: 10 }) {
                  this.SceneBlockBuilder(SceneBlockItemList[0], 0)
                  this.SceneBlockBuilder(SceneBlockItemList[1], 1)
                  this.SceneBlockBuilder(SceneBlockItemList[2], 2)
                  this.SceneBlockBuilder(SceneBlockItemList[3], 3)
                }.height('100%')

            }.tabBar('推荐')
            TabContent() {
                Stack(){
                  Column(){
                    Image($r('app.media.startIcon')).width(30)
                    Text('未创建场景，点击"+"添加')
                    Blank().height(100)
                  }.height('100%').justifyContent(FlexAlign.Center)
                  Flex({
                    direction:FlexDirection.ColumnReverse,
                    alignItems:ItemAlign.End
                  }){
                    Blank().height(80)
                    Button('+')
                      .height(50)
                      .width(50)
                      .borderRadius('50%')
                      .fontSize(30)
                      .margin({right:15})
                      .onClick(()=>{
                        router.pushUrl({
                          url:'pages/SceneSet'
                        },router.RouterMode.Single,(err) => {
                          if (err) {
                            console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                            return;
                          }
                          console.info('Invoke pushUrl succeeded.');
                        })
                      })
                  }.width('100%').height('100%')
                }.height('100%')
            }.tabBar('我的')
      }
    }.width('100%')
    .margin(15).height('100%')
  }

  @Builder
  SceneBlockBuilder(item: SeceneBlockItem, index: number) {
    Column({ space: 10 }) {
      Row({ space: 10 }) {
        Text(item.title)
        Blank()
        Text('>')
      }.height('22%').width('95%')

      Row({ space: 10 }) {
        Column() {
          Row() {
            Image(item.img1).width(30)
            Text(item.title2)
          }
        }.backgroundColor(Color.Orange).width('47%').height('65%').borderRadius(10)
        Blank()
        Column() {
          Row() {
            Image(item.img1).width(30)
            Text(item.title3)
          }
        }.backgroundColor(Color.Orange).width('47%').height('65%').borderRadius(10)
      }.width('95%')
    }
    .shadow(ShadowStyle.OUTER_DEFAULT_SM)
    .backgroundColor(Color.White)
    .width('95%')
    .height(120)
    .borderRadius(10)
    .onClick(()=>{
      router.pushUrl({
        url:item.routeTo
      },router.RouterMode.Single,(err) => {
        if (err) {
          console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
          return;
        }
        console.info('Invoke pushUrl succeeded.');
      })
    })
  }
}