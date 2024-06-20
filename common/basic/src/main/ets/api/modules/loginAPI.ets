import { LoginParams } from '../../models'
import { request } from '../../utils'

/**
 * 登录 api
 * @param data
 * @returns
 */
export const LoginApI = (data: LoginParams) => {
  return request<string, LoginParams>({ url: '/employee/login', method: 'post', data })
}

