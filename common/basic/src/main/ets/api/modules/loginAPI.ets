import { LoginParams, UpdateUserParams, UserData } from '../../models'
import { request } from '../../utils'

/**
 * 登录 api
 * @param data
 * @returns
 */
export const LoginApI = (data: LoginParams) => {
  return request<string, LoginParams>({ url: '/employee/login', method: 'post', data })
}

export const getUserApI = () => {
  return request<UserData>({ url: '/employee/user' })
}


export const updateUserPhotoApi = (avatar: string) => {
  return request<null, UpdateUserParams>({
    url: '/employee/user/updateAvatar', method: 'put', params: {
      avatar
    }
  })
}