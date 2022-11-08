
import './assets/css/skin/main.less'
// import 'antd/dist/antd.css';

import React from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter, Routes, Route, Navigate, HashRouter } from 'react-router-dom'

import Home from './pages/home'
import Room from './pages/room'


// history.pushState(null, document.title, location.href);
// window.addEventListener('popstate', function (event)
// {
//   history.pushState(null, document.title, location.href);
// });

const container = document.getElementById('app') as HTMLDivElement
const root = createRoot(container)
root.render(
  <HashRouter>
    <Routes>
      <Route path='/' element={<Home />} />
      <Route path='/room/:roomId' element={<Room />} />
      <Route path="*" element={<Home />} />
    </Routes>
  </HashRouter>
)
