import React from "react"
import { Button } from ".."

export default function Alert(props) {
  const {msg, btns} = props
  return (
    <div className="u-alert-wrapper">
        <div className="u-mask" />
        <div className="u-alert">
          <div className="alert-body">{msg}</div>
          {btns &&
            btns.length > 0 && (
              <div className="alert-footer">
                {btns.map((item, index) => {
                  return (
                    <Button
                      key={index}
                      className={item.clsName}
                      onClick={() => item.onClick()}
                    >
                      {item.label}
                    </Button>
                  );
                })}
              </div>
            )}
        </div>
      </div>
  )
}