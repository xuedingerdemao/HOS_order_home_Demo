import router from '@ohos.router'
import { util } from '@kit.ArkTS'
import { Log } from '@abner/log'
import { DeviceItem, UnBindProductItem } from '../model/moduels/DeviceModel'
import { getUnbindDeviceListAPI } from '../api/DeviceApI'
import { getDeviceMap, ProductNameMap, ResManager, RouterConfig } from '@orderHome/common/basic'
import { deviceParamsStore, ecBlueAuth } from '../utils'


@Entry
@Component
struct BindDevicePage {
  @StorageProp('topHeight')
  topHeight: number = 0
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  // 1. 列表
  @State
  list: UnBindProductItem[] = []
  // 加载数据
  load = async () => {
    const list = await getUnbindDeviceListAPI()
    this.list = list
  }
  // 2. 产品选择和折叠
  // 加载更多和收起
  @State
  flag: number = 0
  /**
   *
   * @param item 当前选择产品
   * @param device 当前点击产品下的某个设备
   */
  @State
  selectedProd: UnBindProductItem | null = null
  // 选择某个产品下设备
  selectedDevice: DeviceItem | null = null

  toggle(item: UnBindProductItem) {
    // 方式 1
    // this.list = this.list.map((prod) => {
    //   if (item.productId === prod.productId) {
    //     // 控制当前点击的产品的折叠按钮
    //     return {
    //       isExpand: !prod.isExpand,
    //       deviceList: prod.deviceList,
    //       productId: prod.productId,
    //       productName: prod.productName
    //     }
    //   } else {
    //     return prod
    //   }
    // })
    //   方式 2
    item.isExpand = !item.isExpand
    // 触发列表刷新
    this.flag = Date.now()
  }

  selectDevice(item: UnBindProductItem, device: DeviceItem) {
    // 1. 取消之前的选中
    this.list.forEach((prod) => {
      prod.deviceList.forEach((dev) => {
        if (dev.isSelected) {
          dev.isSelected = false
        }
      })
    })
    //   2. 把当前点击的选中
    device.isSelected = !device.isSelected

    // 存储选中的设备数据
    this.selectedProd = item
    this.selectedDevice = device


    this.flag = Date.now()
  }

  @Builder
  productItem(item: UnBindProductItem) {
    Column({ space: 18 }) {
      // 1. 产品分类
      Row() {
        Text(getDeviceMap(item.productName)?.cn)
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_MODULE_TITLE_FS)
          .fontWeight(500)
        // 点击查看更多后显示
        if (item.isExpand) {
          Text() {
            Span('收起')
            ImageSpan($r('app.media.ic_arrow_up'))
              .width(12.8)
              .height(5.6)
              .verticalAlign(ImageSpanAlignment.CENTER)
              .margin({ bottom: 2 })
          }
          .fontColor(ResManager.EC_MAIN_COLOR)
          .fontSize(ResManager.EC_SMALL_FS)
          .onClick(() => {
            this.toggle(item)
          })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      //  2. 设备列表
      GridRow({ columns: 2, gutter: 10 }) {
        // 数据超出 6 同时没有点击查看更多
        if (item.deviceList?.length! > 6 && !item.isExpand) {
          ForEach(item.deviceList?.slice(0, 6), (device: DeviceItem, i: number) => {
            GridCol() {
              // Column() {
              if (i < 5) {
                Column() {
                  // 选择设备
                  Text(device.deviceName)
                    .fontColor(device.isSelected ? '#fff' : ResManager.EC_MID_19)
                    .fontSize(ResManager.EC_SMALL_FS)
                }
                .width('100%')
                .padding({
                  left: 15,
                  right: 15,
                  top: 10,
                  bottom: 10
                })
                .borderRadius(ResManager.EC_NORMAL_RD)
                .backgroundColor(device.isSelected && i < 5 ? ResManager.EC_MAIN_COLOR : '#fff')
                .onClick(() => {
                  this.selectDevice(item, device)
                })
              } else {
                Column() {
                  // 数据超出 6条 显示
                  Text() {
                    Span('查看更多')
                    ImageSpan($r('app.media.ic_arrow_down'))
                      .width(12.8)
                      .height(5.6)
                      .verticalAlign(ImageSpanAlignment.CENTER)
                      .margin({ bottom: 2 })
                  }
                  .fontColor(ResManager.EC_MAIN_COLOR)
                  .fontSize(ResManager.EC_SMALL_FS)
                }
                .width('100%')
                .padding({
                  left: 15,
                  right: 15,
                  top: 10,
                  bottom: 10
                })
                .borderRadius(ResManager.EC_NORMAL_RD)
                .backgroundColor(device.isSelected && i < 5 ? ResManager.EC_MAIN_COLOR : '#fff')
                .onClick(() => {
                  this.toggle(item)
                })
              }
            }
          }
          )
        } else {
          ForEach(item.deviceList, (device: DeviceItem) => {
            GridCol() {
              Column() {
                Text(device.deviceName)
                  .fontColor(device.isSelected ? '#fff' : ResManager.EC_MID_19)
                  .fontSize(ResManager.EC_SMALL_FS)
              }
              .width('100%')
              .padding({
                left: 15,
                right: 15,
                top: 10,
                bottom: 10
              })
              .borderRadius(ResManager.EC_NORMAL_RD)
              .backgroundColor(device.isSelected ? ResManager.EC_MAIN_COLOR : '#fff')
              .onClick(() => {
                this.selectDevice(item, device)
              })
            }
          }
          )
        }

      }

    }
    .width('100%')

  }

  aboutToAppear() {
    this.load()
  }

  check() {
    // 绑定设备之前： 1. 检查蓝牙权限 2. 蓝牙开关=》进入绑定页面
    ecBlueAuth.checkBluePermission(() => {
      // 满足条件后执行
      deviceParamsStore.setDeviceId(this.selectedDevice?.iotId!, this.selectedDevice?.nodeId!)
      if (this.selectedProd?.productName === ProductNameMap.Access_control) {
        // 如果选择绑定的是门禁设备=》门禁绑定的页面
        router.pushUrl({
          url: RouterConfig.DEVICE_NEAR_URL,
          // params: {
          //   iotId: this.selectedDevice?.iotId
          // }
        })
      } else if (this.selectedProd?.productName === ProductNameMap.Blood_glucose_meter) {
        // 跳转血糖绑定页面
        router.pushUrl({
          url: RouterConfig.DEVICE_BIND_BLOOD_URL,
          // params: {
          //   iotId: this.selectedDevice?.iotId
          // }
        })
      } else {
        AlertDialog.show({
          message: '暂不支持的设备类型！'
        })
      }
    })
  }

  build() {
    Navigation() {
      Stack({ alignContent: Alignment.Bottom }) {
        // 产品列表
        Column() {
          List({
            space: 10
          }) {
            ForEach(this.list, (item: UnBindProductItem) => {
              ListItem() {
                this.productItem(item)
              }
            },
              (item: UnBindProductItem) => this.flag + JSON.stringify(item)
            )
          }
          .width('100%')
          .height('100%')
          .scrollBar(BarState.Off)
        }
        .margin({ top: 18 })
        .padding({ bottom: 72, left: 15, right: 15 })

        // 确认选择
        Column() {
          Button('确认')
            .enabled(!!this.selectedProd)// .enabled(this.selectedProd ? true : false)
            .width(312)
            .backgroundColor(ResManager.EC_MAIN_COLOR)
            .onClick(() => {
              this.check()
            })
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height(72)
        .backgroundColor('#fff')
        .shadow({
          offsetX: 0,
          offsetY: -2,
          radius: 60,
          color: '#0F000000'
        })

      }
    }
    .title('设备绑定')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight, bottom: this.bottomHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}