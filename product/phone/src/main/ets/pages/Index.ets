import { Log } from '@abner/log'
import { TabBarItem } from '../model'
import { Home } from '@orderHome/features/home'
import { Duty } from '@orderHome/features/duty'
import { Stage } from '@orderHome/features/stage'
import { Mine } from '@orderHome/features/mine'
import { promptAction } from '@kit.ArkUI'


interface Data {
  name: string
  age: number
}

// 首页
@Entry
@Component
struct Index {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @StorageProp('topHeight')
  topHeight: number = 0
  @State
  activeIndex: number = 0
  tabBars: TabBarItem[] = [
    {
      defaultIcon: $r('app.media.icon_tab_home_nor'),
      activeIcon: $r('app.media.icon_tab_home_sel'),
      label: '首页'
    },
    {
      defaultIcon: $r('app.media.icon_tab_laoren_nor'),
      activeIcon: $r('app.media.icon_tab_laoren_sel'),
      label: '负责对象'
    },
    {
      defaultIcon: $r('app.media.icon_tab_hl_nor'),
      activeIcon: $r('app.media.icon_tab_hl_sel'),
      label: '护理工作台'
    },
    {
      defaultIcon: $r('app.media.icon_tab_mine_nor'),
      activeIcon: $r('app.media.icon_tab_mine_sel'),
      label: '我的'
    }
  ]
  tabsController: TabsController = new TabsController()

  @Builder
  TabBarBuilder(item: TabBarItem, index: number) {
    Column() {
      // 图标
      Image(this.activeIndex === index ? item.activeIcon : item.defaultIcon)
        .width(24)
        .aspectRatio(1)
      // 文字
      Text(item.label)
        .fontSize(10)
        .margin({ top: 4 })
        .lineHeight(12)
        .fontColor(this.activeIndex === index ? '#000' : '#aaa')
    }
  }

  build() {
    Tabs({
      index: $$this.activeIndex,
      controller: this.tabsController
    }) {
      ForEach(this.tabBars, (item: TabBarItem, index: number) => {
        TabContent() {
          // tab 内容=》切换子组件
          if (index === 0) {
            Home()
          } else if (index === 1) {
            Duty()
          } else if (index === 2) {
            Stage()
          } else {
            Mine()
          }
        }
        .tabBar(this.TabBarBuilder(item, index))
      })
    }
    .barPosition(BarPosition.End)
    .barBackgroundColor('#fff')
    .padding({
      // top: this.topHeight,
      bottom: this.bottomHeight
    })
  }
}