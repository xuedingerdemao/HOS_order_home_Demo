import { request } from '@orderHome/common/basic'
import { MessageCountData } from '../../model'

export const getMessageCountApI = () => {
  return request<MessageCountData>({ url: '/employee/message/statisticsUnreadByType' })
}