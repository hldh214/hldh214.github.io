---
title: PyQt5-Beginner-tutorial-part 3
date: 2016-04-19 21:13:43
---
[原文链接](http://www.thehackeruniversity.com/2014/02/20/pyqt5-beginner-tutorial-part-3/)

# 引言 #
这篇文章是前作的续篇(part 3), 为了达到最好的教学效果, 请务必先阅读前作.
在这篇续作当中, 我们将要开发一个简易文本阅读器, 简单起见, 这个阅读器只能阅读文本文档的内容, 但是, 只需要经过一些简单的修改就能成为一个全能的编辑器啦.

# 代码 #

``` Python
import sys 
import os
from PyQt5.QtCore import *
from PyQt5.QtWidgets import *

class Notepad(QMainWindow):
    def __init__(self):
        super(Notepad, self).__init__()
        self.initUI()

    def initUI(self):        
        openAction = QAction('Open', self)
        openAction.setShortcut('Ctrl+O')
        openAction.setStatusTip('Open a file')
        openAction.triggered.connect(self.openFile)

        closeAction = QAction('Close', self)
        closeAction.setShortcut('Ctrl+Q')
        closeAction.setStatusTip('Close Notepad')
        closeAction.triggered.connect(self.close)

        menubar = self.menuBar()
        fileMenu = menubar.addMenu('&File')
        fileMenu.addAction(openAction)        
        fileMenu.addAction(closeAction)

        self.textEdit = QTextEdit(self)
        self.textEdit.setFocus()
        self.textEdit.setReadOnly(True)

        self.resize(700, 800)
        self.setWindowTitle('Notepad')
        self.setCentralWidget(self.textEdit)
        self.show()

    def openFile(self):
        filename, _ = QFileDialog.getOpenFileName(self, 'Open File', os.getenv('HOME'))

        fh = ''

        if QFile.exists(filename):
            fh = QFile(filename)

        if not fh.open(QFile.ReadOnly):
            QtGui.qApp.quit()

        data = fh.readAll()
        codec = QTextCodec.codecForUtfText(data)
        unistr = codec.toUnicode(data)

        tmp = ('Notepad: %s' % filename)
        self.setWindowTitle(tmp)

        self.textEdit.setText(unistr)

def main():
    app = QApplication(sys.argv)
    notepad = Notepad()
    sys.exit(app.exec_())

if __name__ == '__main__':
    main()
```

# 代码分析 #
其实你应该能看懂绝大部分的代码, 我们定义的类继承与 `QMainWindow` 这个基类, 这样可以让我们把菜单栏放置到窗体的顶部.
12-15行: 使用信号和槽来让对象互相之间进行通讯, 这是Qt众多核心特征之一, 当一个事件发生的时候, 将会发出一个信号, 而槽则是Python里面的可调用的对象, 如果一个信号和一个槽相连接的话, 这个槽所指的对象将会在收到信号的时候被调用, 反之亦然.
当按下 Open 的时候, 相当于给 `openFile` 这个对象发出了调用信号, 同样的, 通过键盘快捷键来完成这一事件同样在代码中定义了.
22-25行: 定义了一个菜单组件, 并且给这个菜单组件添加了两个动作, 这样一来, 用户将会看到一个 File 菜单, 快捷键是 Alt+F, 当其被点击的时候, 将会出现含有两个选项的菜单.
第37行: 弹出一个浏览文件的对话框, 其中第二个参数是浏览文件对话框的标题内容, 第三个参数则是默认打开的目录, 这个目录默认是这个代码所在目录.
41-42行: 检测这个文件是否存在, 如果存在则把其赋值给fh这个变量.
44-45行: 尝试打开这个文件, 如果打开失败则退出程序.
47-49行: 把这个文件对象里面的内容全部读取出来, 然后尝试设置文件编码, 我们最先尝试Unicode编码, 如果失败了则使用Latin-1编码.
51-52行: 把窗体的标题改为文件路径, 并在前面加上 'Notepad' .

# 总结 #
我在底部留了一个状态栏的坑, 欢迎大家前来填坑~
希望你能喜欢这篇文章 :-)
