import {CloseAndYesButtonComp} from '../component/HeadBackAndTitleComp'
import {AddSpecEquipButton,CloseAndYesButtonItem} from '../models/CloseAndYesButton'
import {router} from '@kit.ArkUI'
@Entry
@Component
struct SpecEquipAddPage {
  @State closeAndYesButtonData:CloseAndYesButtonItem[]=[]
  aboutToAppear(): void {
    const params=router.getParams()
    if (params) {
      this.closeAndYesButtonData=params as CloseAndYesButtonItem[]
    }
  }

  build() {
    Column(){
      CloseAndYesButtonComp({
        closeAndYesButtonItem:this.closeAndYesButtonData
      })
      Blank().height(30)
      TextInput({placeholder:'请输入设备名称'})
    }
  }
}