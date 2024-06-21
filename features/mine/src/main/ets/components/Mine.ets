import router from '@ohos.router'
import {
  EcDialogTips,
  EcLoading,
  getUserApI,
  ResManager,
  RouterConfig,
  TokenStore,
  UserData,
  UserStore
} from '@orderHome/common/basic'
import { promptAction } from '@kit.ArkUI'
import { Log } from '@abner/log'

@Component
export struct Mine {
  @StorageProp('topHeight')
  topHeight: number = 0
  @State
  userInfo: UserData = {} as UserData
  userStore: UserStore = new UserStore(getContext())
  // 退出登录
  tipsDialog: CustomDialogController = new CustomDialogController({
    builder: EcDialogTips(
      {
        title: '',
        tipsContent: () => {
          this.textItem()
        },
        cancelButton: {
          text: '取消',
          color: ResManager.EC_MID_59,
          cb: () => {
            this.tipsDialog.close()
          }
        },
        confirmButton: {
          text: '确定退出',
          color: ResManager.EC_SUB_RED,
          cb: () => {
            //删除token、用户信息，跳转登录页
            TokenStore.delToken()
            this.userStore.delUserInfo()
            router.replaceUrl({
              url: RouterConfig.LOGIN_URL
            })
            // 清除路由历史记录
            router.clear()
            this.tipsDialog.close()
          }
        }

      }
    ),
    // customStyle: true,
    alignment: DialogAlignment.Center
  })
  //loading
  loading: CustomDialogController = new CustomDialogController({
    builder: EcLoading({
      tip: '加载中...',
    }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  /*-----------------------👇👇 function 👇👇--------------------------------*/
  aboutToAppear(): void {
    this.getUserInfo()
  }

  async getUserInfo() {
    this.loading.open()
    const res = await getUserApI()
    this.loading.close()
    Log.info(res)
    this.userInfo = res
    AppStorage.setOrCreate<UserData>('user', res)
    await this.userStore.setUserInfo(res)
  }

  /*-----------------------👇👇Builder 👇👇--------------------------------*/
  @Builder
  cellItem(title: string, url: string = '') {
    Row() {
      Text(title)
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_MODULE_TITLE_FS)
        .fontWeight(500)
      Row() {
        Image($r('app.media.ic_arrow_black'))
          .width(7)
          .height(16)
      }
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
    .justifyContent(FlexAlign.SpaceBetween)
    .onClick(() => router.pushUrl({ url }))
  }

  @Builder
  textItem() {
    Column() {
      Text('确定要退出吗？')
        .fontSize(18)
    }
  }

  build() {
    Column() {
      // 1. 头部
      Column() {
        // 个人信息
        Column({ space: 5 }) {
          Image(this.userInfo?.avatar ||
            'https://img2.baidu.com/it/u=130573784,2479509663&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=534')
            .width(74)
            .aspectRatio(1)
            .borderRadius(37)
            .border({ width: 5, color: '#AEE8E4' })
            .shadow({
              offsetX: 0,
              offsetY: 2,
              radius: 21,
              color: '#0aa9941f'
            })
          Text(this.userInfo?.nickName)
            .fontSize(ResManager.EC_PAGE_TITLE_FS)
            .fontColor(ResManager.EC_MID_BLACK)
            .fontWeight(500)
          Text(this.userInfo?.username)
            .fontSize(13)
            .fontColor(ResManager.EC_MID_59)

        }
        .margin({ top: 64 - this.topHeight })
        .onClick(() => {
          router.pushUrl({
            url: RouterConfig.USER_SET_URL
          })
        })
      }
      .width('100%')
      .height(330)
      .backgroundImage($r('app.media.pic_wd_bj'))
      .backgroundImageSize(ImageSize.Cover)

      // 2. 快捷导航
      Column() {
        Row({ space: 5 }) {
          Text('设备管理')
            .fontColor(ResManager.EC_MID_19)
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
          // Image($r('app.media.ic_arrow_black'))
          //   .width(7)
          //   .height(16)
        }
        .width('100%')

        // 导航：设备管理
        Row({ space: 10 }) {

        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

      }
      .margin({ top: -80, left: ResManager.EC_CONTENT_SPACE, right: ResManager.EC_CONTENT_SPACE })
      // .width('100%')
      .padding({
        top: ResManager.EC_CONTENT_SPACE,
        left: ResManager.EC_CONTENT_SPACE,
        right: ResManager.EC_CONTENT_SPACE
      })
      .backgroundColor('rgba(255,255,255, 0.6)')
      .borderRadius(ResManager.EC_NORMAL_RD)

      // 3. 快捷导航2
      Column() {
        List() {
          ListItem() {
            this.cellItem('我的消息', 'pages/message/MsgPage')
          }
        }
        .width('100%')
        .height('auto')
        .padding({ left: 14, right: 18, })
        .divider({ strokeWidth: 1, color: ResManager.EC_MID_LINE })
      }
      .margin({
        top: ResManager.EC_CONTENT_SPACE,
        left: ResManager.EC_CONTENT_SPACE,
        right: ResManager.EC_CONTENT_SPACE
      })
      // .width('100%')
      .backgroundColor('#fff')
      .borderRadius(ResManager.EC_NORMAL_RD)

      Button(
        '退出'
      )
        .fontColor(ResManager.EC_MID_19)
        .width(230)
        .height(40)
        .borderRadius(28)
        .backgroundColor('#fff')
        .margin({ top: 50 })
        .onClick(() => {
          this.tipsDialog.open()
        })


    }
    .padding({ top: this.topHeight })
    .width('100%')
    .height('100%')
    .backgroundColor(ResManager.EC_MID_BG)

  }
}