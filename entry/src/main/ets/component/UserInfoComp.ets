import {UserData} from '../models/UserData'
import {router} from '@kit.ArkUI'
//顶部用户信息栏
@Component
export struct UserInfoComp{
  @ObjectLink userData:UserData

  build() {
    Row({space:10}){
      //用户头像
      Button(){
        Image($r('app.media.avator')).width(35).height(35)
      }
      .width(42).height(42).backgroundColor(Color.Transparent)
      //用户名称
      Text(this.userData.userName)
      Blank()
      //联系客服
      Button('联系客服').margin({right:10}).backgroundColor('#5686E1')
      //添加设备按钮
      Button(){
        Image($r('app.media.add')).width(30)
      }
      .onClick(()=>{
        router.pushUrl({
          url:"pages/AddPage"
        },router.RouterMode.Single,(err) => {
          if (err) {
            console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
            return;
          }
          console.info('Invoke pushUrl succeeded.');
        })
      })
      .backgroundColor(Color.Transparent)
    }
    .margin({top:10})
    .height(30)
    .width('96%')
  }
}