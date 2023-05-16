import React, { useState } from "react"
import { useNavigate } from "react-router-dom"
import { Button, Input } from "../../component"

export default function Home() {
  const [roomId, setRoomId] = useState('')
  const [canJoin, setCanJoin] = useState(false)
  const history = useNavigate()

  /**
   * 修改房间ID
   */
  function changeRoomId(e) {
    const roomId = e.target.value.trim()
    setRoomId(roomId)
    setCanJoin(roomId.length > 0)
  }

  /**
   * 跳转至房间中
   */
  function joinRoom() {
    history(`/room/${roomId}`)
    console.log('room');
  }

  return (
    <div className="m-home">
      <div className="part">
        <div className="icon icon-joinroom" />
        <div className="item item-1 f-tac">
          <Input
            name="roomId"
            placeholder={'请输入房间ID'}
            onChange={changeRoomId}
            value={roomId}
          />
        </div>
        <div className="item item-2  f-tac">
          <Button
            className="u-btn-longer"
            onClick={() => { joinRoom() }}
            disabled={!canJoin}
          >
            {'加入房间'}
          </Button>
        </div>
      </div>
    </div>
  )
}