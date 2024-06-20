import router from '@ohos.router'
import { ResManager, RouterConfig } from '@orderHome/common/basic'
import { getMessageCountAPI } from '../api'
import { MessageCountData } from '../model'
import { promptAction } from '@kit.ArkUI'

// 模块排列位置
enum Pos {
  x = 'x',
  y = 'y'
}

@Component
export struct Home {
  tabsController: TabsController = new TabsController()
  /*-----------------------👇👇 Styles 👇👇--------------------------------*/

  @State
  msgCount: MessageCountData | null = null

  /*-----------------------👇👇 Builder 👇👇--------------------------------*/
  // 消息

  // 可复用样式
  @Styles
  modStyle() {
    .borderRadius(8)
    .layoutWeight(1)
    .backgroundColor(ResManager.EC_MID_WHITE)
  }

  // 模块item

  /**
   *
   * @param title
   * @param icon
   * @param url
   */
  @Builder
  msgItem(title: string, icon: Resource | string, num: number) {
    Column() {
      Badge({
        count: num,
        position: BadgePosition.RightTop, style: {
          badgeColor: '#FF6363',
          borderColor: '#fff',
          borderWidth: 2,
          badgeSize: 20
        }
      }) {
        Image(icon)
          .width(40)
          .aspectRatio(1)
          .margin({ bottom: 10 })
      }

      Text(title)
        .fontSize(ResManager.EC_SMALL_FS)
        .fontColor(ResManager.EC_MID_19)
    }
    .layoutWeight(1)
    .borderRadius(8)
    .padding({ top: 20, bottom: 23 })
    .backgroundColor(ResManager.EC_MID_WHITE)
    .onClick(() => {

    })
  }

  /**
   *
   * @param title
   * @param icon
   * @param pos
   * @param url
   */
  @Builder
  careItem(title: string, icon: ResourceStr, pos: Pos, url: string = '') {
    if (pos === Pos.x) {
      // 护理工作台
      Row({ space: 10 }) {
        Image(icon)
          .width(48)
          .aspectRatio(1)
        Text(title)
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_NORMAL_FS)
      }
      .padding({
        top: 20,
        bottom: 23,
        left: 13,
        right: 13
      })
      // .borderRadius(8)
      // .layoutWeight(1)
      // .backgroundColor(ResManager.EC_MID_WHITE)
      .modStyle()
      .onClick(() => {
        if (url) {
          router.pushUrl({
            url
          })
        } else {
          this.tabsController.changeIndex(2)
        }
      })
    } else {
      // 设备管理
      Column({ space: 10 }) {
        Image(icon)
          .width(40)
          .aspectRatio(1)
        Text(title)
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_SMALL_FS)
      }
      .padding({ top: 23, bottom: 23 })
      // .borderRadius(8)
      // .layoutWeight(1)
      // .backgroundColor(ResManager.EC_MID_WHITE)
      .modStyle()
      .onClick(() => {
        router.pushUrl({
          url
        })
      })
    }
  }

  /*-----------------------👇👇 function 👇👇--------------------------------*/
  async getMsgCount() {
    const data = await getMessageCountAPI()
    promptAction.showDialog({ message: JSON.stringify(data) })
  }

  aboutToAppear(): void {
    this.getMsgCount()
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column({ space: 25 }) {
        Column() {
          // 1.1 广告图
          Image($r('app.media.img_banner'))
            .width('100%')
            .aspectRatio(1.32)

          //  1.2 消息提醒
          Column() {
            Row({ space: 10 }) {
              this.msgItem('老人报警消息', $r("app.media.ic_home_jkbj"), 1)
              this.msgItem('任务提醒消息', $r("app.media.ic_home_rwtx"), 0)
            }
          }
          .margin({
            top: -50,
            left: ResManager.EC_CONTENT_SPACE,
            right: ResManager.EC_CONTENT_SPACE,
          })
        }
        .width('100%')

        Column({ space: 25 }) {
          //  1.3 护理工作台
          Column() {
            // 标题
            Text('护理工作台')
              .fontColor(ResManager.EC_MID_19)
              .fontSize(ResManager.EC_MODULE_TITLE_FS)
              .fontWeight(500)
              .margin({ bottom: 13 })
            // 内容
            Row({ space: 10 }) {
              // 护理任务跳转第三个标签页
              this.careItem('护理任务', $r('app.media.icon_home_hlrw'), Pos.x, '')
              this.careItem('护理记录', $r('app.media.icon_home_hljl'), Pos.x, RouterConfig.STAGE_NURSE_RECORDS_URL)

            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)

          //  1.4 设备管理
          Column() {
            // 标题
            Text('设备管理')
              .fontColor(ResManager.EC_MID_19)
              .fontSize(ResManager.EC_MODULE_TITLE_FS)
              .fontWeight(500)
              .margin({ bottom: 13 })
            // 内容
            Row({ space: 10 }) {
              this.careItem('设备安装', $r('app.media.icon_home_sbaz'), Pos.y, RouterConfig.DEVICE_SETUP_URL)
              this.careItem('设备绑定', $r('app.media.icon_home_sbkz'), Pos.y, RouterConfig.DEVICE_BIND_URL)
              this.careItem('我的设备', $r('app.media.icon_home_wdsb'), Pos.y, RouterConfig.DEVICE_MY_URL)
              this.careItem('报警设备', $r('app.media.icon_home_bjsb'), Pos.y, RouterConfig.DEVICE_ALARM_URL)

            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)

        }
        .width('100%')
        .padding({ left: 15, right: 15 })

      }
      .width('100%')
      .height('100%')

      // 2. 服务口号
      Row() {
        Image($r('app.media.img_home_kouhao'))
          .width(211)
          .height(15)
      }
      .margin({ bottom: 28 })
      .onClick(() => router.pushUrl({ url: 'pages/test/TestPage' }))
    }
    .width('100%')
    .height('100%')
    .backgroundColor(ResManager.EC_MID_BG)
  }
}
