--[[
The MIT License (MIT)

Copyright (c) 2016 WilhanTian  田伟汉

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

utf8 = require "utf8"
class = require "libs.catui.libs.30log"

require "libs.catui.Core.UIDefine"

theme = require "libs.catui.UITheme"

point = require "libs.catui.Utils.Utils"
Rect = require "libs.catui.Core.Rect"
UIEvent = require "libs.catui.Core.UIEvent"
UIControl = require "libs.catui.Core.UIControl"
UIRoot = require "libs.catui.Core.UIRoot"
UIManager = require "libs.catui.Core.UIManager"
UILabel = require "libs.catui.Control.UILabel"
UIButton = require "libs.catui.Control.UIButton"
UIImage = require "libs.catui.Control.UIImage"
UIScrollBar = require "libs.catui.Control.UIScrollBar"
UIContent = require "libs.catui.Control.UIContent"
UICheckBox = require "libs.catui.Control.UICheckBox"
UIProgressBar = require "libs.catui.Control.UIProgressBar"
UIEditText = require "libs.catui.Control.UIEditText"
UIDropDown = require "libs.catui.Control.UIDropdown"
