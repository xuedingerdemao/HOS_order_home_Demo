export class Device {
  name: string = ''
  icon: Resource | string=''
}

export class DeviceCate {
  title: string = ''
  list: Device[]=[]
  cb?: () => void = () => {
  }
}


//  2. 未绑定设备列表
export interface DeviceItem {
  iotId: string
  nodeId: string
  deviceName: string
  isSelected: boolean
}

export interface UnBindProductItem {
  productId: string
  productName: string
  // 是否展开：false 没有点击查看更多 | true 点击了查看更多
  isExpand: boolean
  deviceList: DeviceItem[]
}

// 设备状态查询
export interface DeviceStatusData {
  /**
   * 设备名称
   */
  name: string;

  /**
   * 设备状态，设备状态，ONLINE：设备在线，OFFLINE：设备离线，ABNORMAL：设备异常，INACTIVE：设备未激活，FROZEN：设备冻结
   */
  status: string;
}