/**
 * 存储设备绑定相关参数
 */
interface DeviceParamsModel {
  // 设备 Id
  iotId?: string
  // 设备标识
  nodeId?: string
}

class DeviceParamsStore {
  private data: DeviceParamsModel = {}

  // 1. 获取参数
  getParams() {
    return this.data
  }

  // 2. 存储参数
  setDeviceId(iotId: string, nodeId: string) {
    this.data.iotId = iotId
    this.data.nodeId = nodeId
  }

  //   3. 清空参数
  clear() {
    this.data = {}
  }
}

export const deviceParamsStore = new DeviceParamsStore()