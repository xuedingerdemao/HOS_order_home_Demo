import router from '@ohos.router'
import { promptAction } from '@kit.ArkUI'
import { DeviceItem, UnBindProductItem } from '../model'
import { getMyDeviceListAPI, unbindDeviceAPI } from '../api/DeviceApI'
import { deviceParamsStore } from '../utils'
import { getDeviceMap, ProductNameMap, ResManager, RouterConfig } from '@orderHome/common/basic'

// 设备选择
@Entry
@Component
struct MyDevicePage {
  @StorageProp('topHeight')
  topHeight: number = 0
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  scroller: Scroller = new Scroller()
  // 1. 查询设备
  @State
  devices: UnBindProductItem[] = []

  async getMyDevices() {
    const data = await getMyDeviceListAPI()
    this.devices = data
  }

  aboutToAppear(): void {
    this.getMyDevices()
  }

  // 2. 解绑
  unbind(id: string) {
    AlertDialog.show({
      title: '解除确认',
      message: '确认要解除该设备吗？',
      primaryButton: {
        value: '取消',
        fontColor: ResManager.EC_MID_59,
        action: () => {

        }
      },
      secondaryButton: {
        value: '确定',
        fontColor: ResManager.EC_MAIN_COLOR,
        action: async () => {
          await unbindDeviceAPI(id)
          this.getMyDevices()
          promptAction.showToast({ message: '解绑成功' })
        }
      },
      alignment: DialogAlignment.Center
    })
  }

  // 3. 处理设备控制跳转
  handlerControlPage = (selectedProd: UnBindProductItem, iotId: string, nodeId: string) => {
    deviceParamsStore.setDeviceId(iotId, nodeId)
    if (selectedProd.productName === ProductNameMap.Access_control) {
      router.pushUrl({
        url: RouterConfig.DEVICE_DOOR_CONTROL_URL
      })
    } else if (selectedProd.productName === ProductNameMap.Blood_glucose_meter) {
      router.pushUrl({
        url: RouterConfig.DEVICE_ELDER_SEL_URL
      })
    } else {
      AlertDialog.show({
        message: '暂不支持的设备类型！'
      })
    }

  }

  build() {
    // 导航栏
    Navigation() {
      Column() {
        // 设备列表
        Scroll(this.scroller) {
          Column({ space: 20 }) {
            ForEach(this.devices, (item: UnBindProductItem) => {
              Column() {
                // 标题
                Text(getDeviceMap(item.productName)?.cn)
                  .fontColor(ResManager.EC_MID_19)
                  .fontSize(ResManager.EC_MODULE_TITLE_FS)
                  .fontWeight(500)
                  .margin({ bottom: 18 })
                // 内容
                GridRow({ columns: 2, gutter: { x: 10, y: 10 } }) {
                  ForEach(item.deviceList, (dv: DeviceItem, i: number) => {
                    GridCol() {
                      Stack({ alignContent: Alignment.TopEnd }) {
                        Column({ space: 10 }) {
                          Image(getDeviceMap(item.productName)?.icon)
                            .width(80)
                            .aspectRatio(1)
                          Text(dv.deviceName)
                            .fontColor(ResManager.EC_MID_19)
                            .fontSize(ResManager.EC_SMALL_FS)
                        }
                        .width('100%')
                        .padding({ top: 30, bottom: 20 })
                        .borderRadius(8)
                        .backgroundColor(ResManager.EC_MID_WHITE)
                        .onClick(() => {
                          this.handlerControlPage(item, dv.iotId!, dv.nodeId!)
                        })

                        Text('解绑')
                          .fontColor(ResManager.EC_MAIN_COLOR)
                          .fontSize(ResManager.EC_SMALL_FS)
                          .margin({ top: 10, right: 10 })
                          .onClick(() => {
                            this.unbind(dv.iotId)
                          })

                      }
                    }
                    .onClick(() => {
                      router.back()
                    })
                  })
                }
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
            })
          }
          .width('100%')
        }
        .scrollable(ScrollDirection.Vertical) // 滚动方向纵向
        .scrollBar(BarState.Off) // 滚动条常驻显示
      }
      .width('100%')
      .height('100%')
      .backgroundColor(ResManager.EC_MID_BG)
      .padding(15)

    }
    .title('我的设备')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight, bottom: this.bottomHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}