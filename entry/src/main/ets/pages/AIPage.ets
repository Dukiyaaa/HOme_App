// =====================================================
// 📦 模块一：导入依赖模块
// =====================================================
import { chatPop } from '../models/ChatPop'
import { http } from '@kit.NetworkKit'
import { UserInfoComp } from '../component/UserInfoComp'
import { UserData } from '../models/UserData'

// =====================================================
// 🧾 模块二：类型接口定义
// =====================================================
interface ChatReply {
  reply?: string
}
// =====================================================
// 🤖 模块三：AI 聊天页面组件定义
// =====================================================
@Entry
@Component
export struct AIPage {

  // =====================================================
  // 📊 状态变量定义
  // =====================================================
  @State message: string = 'Hello World'
  @State touxiang: Resource = $r('app.media.touxiang')
  @State username: string = 'SystemAI'
  @State hasContent: number = 0
  @State chatMessages: chatPop[] = []
  @State inputMessage: string = ''
  @State nowId: number = 0
  //用户信息数据
  @State userData:UserData=new UserData()

  // =====================================================
  // 🏗️ 页面构建函数 build()
  // =====================================================
  build() {
    Column() {

      // 🧱 顶部区域
      //用户信息栏
      UserInfoComp({userData:this.userData})

      // 💬 聊天内容区域
      Stack({ alignContent: Alignment.Center }) {

        // 📭 无聊天内容提示
        if (this.hasContent == 0) {
          Text('我能帮助你什么？').fontSize(20)
        }

        // 📋 有聊天内容展示
        if (this.hasContent != 0) {
          List({ space: 10 }) {
            ForEach(this.chatMessages, (messages: chatPop) => {
              ListItem() {
                Row() {
                  if (messages.username != 'SystemAI') {
                    Blank()
                  }

                  Text(messages.message)
                    .width('fit-content')
                    .padding({ left: 15, right: 15, top: 10, bottom: 10 })
                    .backgroundColor('#E0F7FA')
                    .borderRadius(
                      messages.username == 'SystemAI'
                        ? { topLeft: 15, bottomLeft: 0, topRight: 15, bottomRight: 15 }
                        : { topLeft: 15, bottomLeft: 15, topRight: 15, bottomRight: 0 }
                    )
                    .margin({ left: 15, right: 15, top: 5, bottom: 5 })
                }.width('100%')
              }
            }, (messages: chatPop) => messages.id.toString())
          }
          .width('100%')
          .height('90%')
        }

        // ⌨️ 输入框 + 发送按钮
        Row() {
          TextArea({
            placeholder: '请输入消息',
            text: this.inputMessage,
          })
            .onChange((value: string) => {
              this.inputMessage = value
            })
            .width('82%')

          Button('发送')
            .width('18%')
            .onClick(() => {
              if (this.inputMessage.trim() !== '') {
                const userText = this.inputMessage

                // 1️⃣ 添加用户消息
                this.chatMessages.push({
                  id: this.nowId,
                  username: this.username,
                  message: userText
                })
                this.nowId++
                this.hasContent = 1
                this.inputMessage = ''
                // 2️⃣ 调用 AI 接口获取回复
                const req = http.createHttp()
                req.request('http://43.155.36.236:5000/chat', {
                  method: http.RequestMethod.POST,
                  header: {
                    'Content-Type': 'application/json'
                  },
                  extraData: JSON.stringify({ message: userText }),
                  readTimeout: 100000
                })
                  .then((res: http.HttpResponse) => {
                    let replyMsg: string = '无回复'

                    if (typeof res.result === 'string') {
                      try {
                        const json = JSON.parse(res.result) as ChatReply
                        if (json && typeof json.reply === 'string') {
                          replyMsg = json.reply
                        }
                      } catch (e) {
                        console.error('解析 AI 回复失败：', e)
                      }
                    }

                    this.chatMessages.push({
                      id: this.nowId,
                      username: 'AI助手',
                      message: replyMsg
                    })
                    this.nowId++
                  })
                  .catch(() => {
                    this.chatMessages.push({
                      id: this.nowId,
                      username: 'AI助手',
                      message: '请求失败，请检查服务器是否在线'
                    })
                    this.nowId++
                  })
                  .finally(() => {
                    req.destroy()
                  })
              }
            })
        }
        .height('10%')
        .alignItems(VerticalAlign.Center)
        .position({ bottom: 0 })
      }
      .width('95%')
      .height('90%')

    }
    .width('100%')
    .height('100%')
  }
}
