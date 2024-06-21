import { ProductNameList } from '../../constants'

// 获取产品中英文映射关系
export function getDeviceMap(en:string) {
  return ProductNameList.find(item=>item.en === en)
}