---
title: PyQt5-Beginner-tutorial
date: 2015-12-11 20:43:01
---
[原文链接](http://www.thehackeruniversity.com/2014/01/23/pyqt5-beginner-tutorial/%20%5D%28http://www.thehackeruniversity.com/2014/01/23/pyqt5-beginner-tutorial/)

# 引言 #

这是一篇启蒙级的PyQt5教程,其目的是让你在很短的时间内入门PyQt.需要具备一些Python的基本知识.

PyQt是跨平台GUI工具包Qt的Python版本.是Python的GUI编程众多选择之一.其余的选择有PySide, PyGTK, wxPython, 和 Tkinter.

PyQt是开发非营利性(GPL协议)程序的利器.而如果你需要开发营利性程序,PySide很适合你,并且它是遵循LGPL协议的

# 安装 PyQt #

你需要Python的最新版本(现在是 3.3.3 *注1* ).确认安装完毕且添加了环境变量,添加环境变量在安装Python的时候可以选择添加.

以上完成以后,去Riverbank官网下载合适版本的可执行文件,安装的时候选择默认安装.

# 编写你的第一段代码 #

	from PyQt5.QtCore import *
	from PyQt5.QtWidgets import *

	class Form(QWidget):
	    def __init__(self, parent=None):
	        super(Form, self).__init__(parent)

	        nameLabel = QLabel("Name:")
	        self.nameLine = QLineEdit()
	        self.submitButton = QPushButton("&amp;Submit")

	        buttonLayout1 = QVBoxLayout()
	        buttonLayout1.addWidget(nameLabel)
	        buttonLayout1.addWidget(self.nameLine)
	        buttonLayout1.addWidget(self.submitButton)

	        self.submitButton.clicked.connect(self.submitContact)

	        mainLayout = QGridLayout()
	        # mainLayout.addWidget(nameLabel, 0, 0)
	        mainLayout.addLayout(buttonLayout1, 0, 1)

	        self.setLayout(mainLayout)
	        self.setWindowTitle("Hello Qt")

	    def submitContact(self):
	        name = self.nameLine.text()

	        if name == "":
	            QMessageBox.information(self, "Empty Field",
	                                    "Please enter a name and address.")
	            return
	        else:
	            QMessageBox.information(self, "Success!",
	                                    "Hello %s!" % name)

	if __name__ == '__main__':
	    import sys

	    app = QApplication(sys.argv)

	    screen = Form()
	    screen.show()

	    sys.exit(app.exec_())

# 代码分析 #

1-2行: import必要的模块

第4行: QWidget是PyQt5里面关于用户界面的基类,所以你通过继承QWidget这个基类来创建一个新Form类.

5-6行: QWidget的构造函数.构造函数无父类,这将被定义为一个窗口.

7-9行: 添加一个标签,一个文本编辑框和一个提交按钮.

12-15行: 添加一个QVBoxLayout.QVBoxLayout类可以使widgets竖直显示.

第17行: 为提交按钮添加一个事件,事件为函数submitContact().

19-21行: 添加一个QGridLayout.

23-24行: 在设置完窗口标题之后设置QGridLayout为主窗口默认布局.

第27行: 使用`nameLine`变量表示文本输入框内容.

29-35行: 当`nameLine`无内容时通过弹窗提示,当其有内容时则弹窗输出内容文本.

至于剩下的代码就容易理解了.我们实例化一个`Form`对象叫做`screen`.使用`show()`方法在屏幕上显示窗口.

然后我们开始程序主循环.这个循环会等待事件来处理,直到程序调用`exit()`方法或主窗口被销毁.`sys.exit()` *注2* 方法可以完成一个完美的退出,释放内存资源.

执行这个脚本只需要输入

python <name of script>

来完成:

# 总结 #

这是一篇入门级的教程.想要看看综合参考请[点我](http://pyqt.sourceforge.net/Docs/PyQt5/class_reference.html)


----------

# 注解 #

注1. 原文发表于January 23, 2014

注2. [有关app.exec_()的下划线问题](https://hosiet.me/blog/2015/08/17/pyqt5-learning-notes/)

