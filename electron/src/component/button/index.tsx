/*
 * @Author: lduoduo 
 * @Date: 2018-01-18 14:44:51 
 * @Last Modified by: lduoduo
 * @Last Modified time: 2018-01-27 22:05:46
 * button组件，调用方法
 * <Button title="设置" options={option} />
 * }
 * 
 * 注意：如果点击事件需要使用默认的，不要传click
 */
import React from 'react';

export default function Button(props) {
  const { children, className, onClick, loading, disabled } = props;
  return (
    <button 
      className={`u-btn ${className}`} 
      disabled={disabled ? true : false} 
      onClick={onClick}>
      {loading && <i className="u-loading" />}
      {children}
    </button>
  )
}