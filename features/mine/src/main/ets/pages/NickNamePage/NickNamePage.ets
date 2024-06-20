import { router } from '@kit.ArkUI';
import { ResManager, UserData } from '@orderHome/common/basic';

@Entry
@Component
struct NickNamePage {
  @StorageProp('topHeight')
  topHeight: number = 0
  // 1. 回填修改用户数据
  @StorageLink('user')
  user: UserData = {} as UserData

  // 提交
  save() {
    router.back()
  }

  build() {
    Navigation() {
      Column() {
        // Text(this.nickname)
        TextInput({ text: this.user.nickName, placeholder: '请输入昵称' })
          .height(50)
          .borderRadius(ResManager.EC_NORMAL_RD)
          .backgroundColor('#fff')
          .placeholderColor(ResManager.EC_MID_99)
        //   提交
        Button('保存', { type: ButtonType.Capsule })
          .margin({ top: 50 })
          .width(230)
          .enabled(!!this.user?.nickName)
          .onClick(() => {
            this.save()
          })
      }
      .margin({ left: 15, right: 15 })

    }
    .title('昵称')
    .padding({ top: this.topHeight })
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor(ResManager.EC_MID_BG)
  }
}