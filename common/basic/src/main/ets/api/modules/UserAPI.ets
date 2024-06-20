import { UpdateUserParams, UserData } from '../../models'
import { request } from '../../utils'

export const getUserApI = () => {
  return request<UserData>({ url: '/employee/user' })
}


export const updateUserPhotoApI = (avatar: string) => {
  return request<null, UpdateUserParams>({
    url: '/employee/user/updateAvatar', method: 'put', params: {
      avatar
    }
  })
}