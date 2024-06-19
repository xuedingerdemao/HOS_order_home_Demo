import router from '@ohos.router'
import { EcList, ResManager } from '@orderHome/common/basic'

class Params {
  page: number = 1
  pageSize: number = 10
}

@Component
export struct Duty {
  @StorageProp('topHeight')
  topHeight: number = 0
  @State
  list: number[] = []
  // 请求参数
  params: Params = { page: 1, pageSize: 10 }
  // 加载状态
  @State
  finished: boolean = false
  // 加载中loading
  @State
  loading: boolean = false
  // 刷新中
  @State
  isRefreshing: boolean = false
  /*-----------------------👇👇 function 👇👇--------------------------------*/
  // 触底加载数据
  load = () => {
    if (this.loading || this.finished) {
      return
    }
    this.loading = true
    // 请求数据
    setTimeout(() => {
      for (let index = 0; index < this.params.pageSize; index++) {
        this.list.push(this.list.length + 1)
      }
      this.loading = false
      // 判断是否还有更多
      if (this.list.length === 30) {
        this.finished = true
      } else {
        this.params.page++
      }

    }, 1000)
  }
  // 刷新列表
  refresh = () => {
    setTimeout(() => {
      //  重置列表和状态
      this.loading = false
      this.finished = false
      // 重置请求参数
      this.params.page = 1
      this.list = Array.from(new Array(10))
        .map((item: null, i: number) => i + 1)
      // 关闭刷新状态
      this.isRefreshing = false
    }, 2000)
  }

  build() {
    Column() {
      // 标题
      Row() {
        Text('负责老人')
          .fontSize(24)
          .fontColor('#000')
          .fontWeight(500)
      }
      .padding({
        left: 24,
        right: 24,
        bottom: 10,
        top: 10
      })
      .width('100%')
      .justifyContent(FlexAlign.Start)

      // 列表
      Column() {
        EcList({
          loading: this.loading,
          finished: this.finished,
          isRefreshing: $isRefreshing,
          load: this.load,
          refresh: this.refresh
        }) {
          ForEach(this.list, (item: number) => {
            ListItem() {
              Row({ space: 14 }) {
                // 头像
                Image('https://img1.baidu.com/it/u=1944934302,3144710326&fm=253&fmt=auto&app=138&f=JPEG?w=190&h=190')
                  .width(80)
                  .height(80)
                  .borderRadius(ResManager.EC_NORMAL_RD)
                // 信息
                Column({ space: 6 }) {
                  Row({ space: 15 }) {
                    Text('李玉虎')
                      .fontColor(ResManager.EC_MID_BLACK)
                      .fontSize(ResManager.EC_PAGE_TITLE_FS)
                      .fontWeight(500)
                      .margin({ bottom: 5 })
                    Text('64岁')
                      .fontColor(ResManager.EC_MID_59)
                      .fontSize(13)
                    Text('男')
                      .width(36)
                      .height(20)
                      .borderRadius(10)// 女bg：#FFF0D9
                      .backgroundColor('#DBF0FF')
                      .textAlign(TextAlign.Center)
                      .fontColor(ResManager.EC_SUB_BLUE)
                      .fontSize(ResManager.EC_SMALL_FS)
                  }

                  Text('床位：四人间-1012床')
                    .fontColor(ResManager.EC_MID_59)
                    .fontSize(13)
                  Text('护理等级：特级护理')
                    .fontColor(ResManager.EC_MID_59)
                    .fontSize(13)

                  // 操作
                  Row() {
                    Button('健康数据')
                      .height(28)
                      .backgroundColor(ResManager.EC_MAIN_COLOR)
                      .fontSize(ResManager.EC_NORMAL_FS)
                      .margin({ right: 13 })
                      .onClick(() => {
                        router.pushUrl({
                          url: 'pages/duty/HealthDataPage'
                        })
                      })
                    Button('护理任务')
                      .height(28)
                      .backgroundColor(ResManager.EC_MAIN_COLOR)
                      .fontSize(ResManager.EC_NORMAL_FS)
                      .onClick(() => {
                        router.pushUrl({
                          url: 'pages/duty/CareTaskPage',
                          params: this.params
                        })
                      })
                  }
                  .margin({ top: 17 })
                  .width('100%')
                  .justifyContent(FlexAlign.End)
                }
                // .width('100%')
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
              }
              .width('100%')
              .alignItems(VerticalAlign.Top)
              .borderRadius(ResManager.EC_NORMAL_RD)
              .backgroundColor(ResManager.EC_MID_WHITE)
              .padding({
                left: 14,
                right: 14,
                top: 16,
                bottom: 16
              })
            }
          })
        }
      }
      .layoutWeight(1)
      .padding({ left: 15, right: 15 })
    }
    .width('100%')
    .height('100%')
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}
