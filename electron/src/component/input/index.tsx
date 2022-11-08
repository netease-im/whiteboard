/*
 * @Author: lduoduo 
 * @Date: 2018-01-26 14:21:48 
 * @Last Modified by: lduoduo
 * @Last Modified time: 2018-03-09 13:53:05
 * 输入框的样式
 */

import React from "react"

export default function Input(props) {
  function handleChange(ev) {
    if (props.type === 'file') {
      const file = ev.target.files[0]
      const nameParts = file.name.split('.')
      const suffix = nameParts[nameParts.length - 1]
      const acceptTypes = props.accept.split(',').map(type => {
        if (type[0] === '.') {
          return type.slice(1).toLowerCase()
        } else {
          return type.toLowerCase()
        }
      })
  
      return props.onChange(ev, acceptTypes.includes(suffix.toLowerCase()))
    } else {
      return props.onChange(ev)
    }
  }

  const {
    children,
    className,
    onChange,
    onBlur,
    onFocus,
    onKeyDown,
    placeholder,
    value,
    type,
    name,
    domRef,
    maxLength,
    accept,
    multiple,
  } = props;

  return (
    <input
        name={name}
        className={`u-input ${className}`}
        type={type}
        onChange={handleChange}
        onBlur={onBlur}
        onFocus={onFocus}
        onKeyDown={onKeyDown}
        placeholder={placeholder}
        value={value}
        ref={domRef}
        maxLength={maxLength}
        accept={accept}
        multiple={multiple}
      />
  )
}
