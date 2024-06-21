import { request } from '@orderHome/common/basic'
import { DeviceStatusData, UnBindProductItem } from '../model/moduels/DeviceModel'

/**
 * iot 平台 API
 * 查询未绑定设备产品列表
 * @returns
 */
export function getUnbindDeviceListAPI() {
  return request<UnBindProductItem[]>({ url: '/employee/iot/deviceTree' })
}

/**
 * 获取我的设备列表
 * @returns
 */
export function getMyDeviceListAPI() {
  return request<UnBindProductItem[]>({ url: `/employee/iot/listDeviceByCurrentUser` })
}

/**
 * 解绑设备
 * @param iotId 物联网设备id
 * @returns
 */
export function unbindDeviceAPI(iotId: string) {
  return request({ url: `/employee/iot/unBindingDevice/${iotId}`, method: 'put' })
}

/**
 * 绑定设备
 * @param iotId 物联网设备id
 * @returns
 */
export function bindDeviceAPI(iotId: string) {
  return request({ url: `/employee/iot/bindingDevice/${iotId}`, method: 'put' })
}

/**
 * 获取设备状态
 * @param iotId 物联网设备id
 * @returns
 */
export function getDeviceStatusAPI(iotId: string) {
  return request<DeviceStatusData>({ url: `/employee/iot/getDeviceStatus/${iotId}` })
}