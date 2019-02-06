---
title: PyQt5-Beginner-tutorial-part 2
date: 2016-04-18 21:09:34
---
[原文链接](http://www.thehackeruniversity.com/2014/01/26/pyqt5-beginner-tutorial-part-2/)

# 引言 #
这篇文章是前作的续篇(part 2), 为了达到最好的教学效果, 请务必先阅读前作.

在这篇续作当中, 我们依旧是通过实例代码来学习PyQt5, 我会涉及到下一篇教程(part 3)的一些内容.

# 代码 #

``` python
from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import (QGridLayout, QHBoxLayout, QLabel, QLineEdit,
        QMessageBox, QPushButton, QTextEdit, QVBoxLayout, QWidget)

class SortedDict(dict):
    class Iterator(object):
        def __init__(self, sorted_dict):
            self._dict = sorted_dict
            self._keys = sorted(self._dict.keys())
            self._nr_items = len(self._keys)
            self._idx = 0

        def __iter__(self):
            return self

        def next(self):
            if self._idx >= self._nr_items:
                raise StopIteration

            key = self._keys[self._idx]
            value = self._dict[key]
            self._idx += 1

            return key, value

        __next__ = next

    def __iter__(self):
        return SortedDict.Iterator(self)

    iterkeys = __iter__

class AddressBook(QWidget):
    def __init__(self, parent=None):
        super(AddressBook, self).__init__(parent)

        self.contacts = SortedDict()
        self.oldName = ''
        self.oldAddress = ''

        nameLabel = QLabel("Name:")
        self.nameLine = QLineEdit()
        self.nameLine.setReadOnly(True)

        addressLabel = QLabel("Address:")
        self.addressText = QTextEdit()
        self.addressText.setReadOnly(True)

        self.addButton = QPushButton("&Add")
        self.addButton.show()
        self.submitButton = QPushButton("&Submit")
        self.submitButton.hide()
        self.cancelButton = QPushButton("&Cancel")
        self.cancelButton.hide()
        self.nextButton = QPushButton("&Next")
        self.nextButton.setEnabled(False)
        self.previousButton = QPushButton("&Previous")
        self.previousButton.setEnabled(False)

        self.addButton.clicked.connect(self.addContact)
        self.submitButton.clicked.connect(self.submitContact)
        self.cancelButton.clicked.connect(self.cancel)
        self.nextButton.clicked.connect(self.next)
        self.previousButton.clicked.connect(self.previous)

        buttonLayout1 = QVBoxLayout()
        buttonLayout1.addWidget(self.addButton, Qt.AlignTop)
        buttonLayout1.addWidget(self.submitButton)
        buttonLayout1.addWidget(self.cancelButton)
        buttonLayout1.addStretch()

        buttonLayout2 = QHBoxLayout()
        buttonLayout2.addWidget(self.previousButton)
        buttonLayout2.addWidget(self.nextButton)

        mainLayout = QGridLayout()
        mainLayout.addWidget(nameLabel, 0, 0)
        mainLayout.addWidget(self.nameLine, 0, 1)
        mainLayout.addWidget(addressLabel, 1, 0, Qt.AlignTop)
        mainLayout.addWidget(self.addressText, 1, 1)
        mainLayout.addLayout(buttonLayout1, 1, 2)
        mainLayout.addLayout(buttonLayout2, 3, 1)

        self.setLayout(mainLayout)
        self.setWindowTitle("Simple Address Book")

    def addContact(self):
        self.oldName = self.nameLine.text()
        self.oldAddress = self.addressText.toPlainText()

        self.nameLine.clear()
        self.addressText.clear()

        self.nameLine.setReadOnly(False)
        self.nameLine.setFocus(Qt.OtherFocusReason)
        self.addressText.setReadOnly(False)

        self.addButton.setEnabled(False)
        self.nextButton.setEnabled(False)
        self.previousButton.setEnabled(False)
        self.submitButton.show()
        self.cancelButton.show()

    def submitContact(self):
        name = self.nameLine.text()
        address = self.addressText.toPlainText()

        if name == "" or address == "":
            QMessageBox.information(self, "Empty Field",
                    "Please enter a name and address.")
            return

        if name not in self.contacts:
            self.contacts[name] = address
            QMessageBox.information(self, "Add Successful",
                    "\"%s\" has been added to your address book." % name)
        else:
            QMessageBox.information(self, "Add Unsuccessful",
                    "Sorry, \"%s\" is already in your address book." % name)
            return

        if not self.contacts:
            self.nameLine.clear()
            self.addressText.clear()

        self.nameLine.setReadOnly(True)
        self.addressText.setReadOnly(True)
        self.addButton.setEnabled(True)

        number = len(self.contacts)
        self.nextButton.setEnabled(number > 1)
        self.previousButton.setEnabled(number > 1)

        self.submitButton.hide()
        self.cancelButton.hide()

    def cancel(self):
        self.nameLine.setText(self.oldName)
        self.addressText.setText(self.oldAddress)

        if not self.contacts:
            self.nameLine.clear()
            self.addressText.clear()

        self.nameLine.setReadOnly(True)
        self.addressText.setReadOnly(True)
        self.addButton.setEnabled(True)

        number = len(self.contacts)
        self.nextButton.setEnabled(number > 1)
        self.previousButton.setEnabled(number > 1)

        self.submitButton.hide()
        self.cancelButton.hide()

    def next(self):
        name = self.nameLine.text()
        it = iter(self.contacts)

        try:
            while True:
                this_name, _ = it.next()

                if this_name == name:
                    next_name, next_address = it.next()
                    break
        except StopIteration:
            next_name, next_address = iter(self.contacts).next()

        self.nameLine.setText(next_name)
        self.addressText.setText(next_address)

    def previous(self):
        name = self.nameLine.text()

        prev_name = prev_address = None
        for this_name, this_address in self.contacts:
            if this_name == name:
                break

            prev_name = this_name
            prev_address = this_address
        else:
            self.nameLine.clear()
            self.addressText.clear()
            return

        if prev_name is None:
            for prev_name, prev_address in self.contacts:
                pass

        self.nameLine.setText(prev_name)
        self.addressText.setText(prev_address)

if __name__ == '__main__':
    import sys

    from PyQt5.QtWidgets import QApplication

    app = QApplication(sys.argv)

    addressBook = AddressBook()
    addressBook.show()

    sys.exit(app.exec_())
```

# 代码分析 #
我将会从第33行 `Addressbook` 这个类开始讲解, 因为大部分代码我在前作有讲解过, 我只会讲解前作没有涉及到的地方.

38-39行: 预先声明两个变量 `oldName` 和 `oldAddress` 以便后续代码调用.
42-43行: 我们声明一个文本编辑控件, 并且设置其只读属性为真, 当我们点击这个文本框的时候, 是无论如何都无法输入任何内容的.
49-58行: 我们为窗体添加一些按钮控件, 在第50行, show()方法会使 `addButton` 可见. 另外, `submitButton` 和 `cancelButton` 将会被我们隐式的创建. `nextButton` 和 `previousButton` 将会在窗体中显示出来, 但是他俩是灰色不可用的状态, 用户不能点击.
60-64行: 我们为控件添加点击触发的事件. 
对于学习过前作的你来说, 看懂剩下的类简直是易如反掌了.
当我们第一次运行这个程序, 只有 `Add` 按钮是可以点击的, 这个按钮触发事件的代码在第87行.
88-89行: 还记得我们在38-39行定义的俩变量吗? 现在把 `nameLine` 和 `addressText` 的值赋给他俩.
91-96行: 我们把 `nameLine` 和 `addressText` 的文本框内容清空, 并且使用`setReadOnly(false)` 来让这俩变成可输入的状态, 最后把输入光标聚焦到`nameLine` 这里.
98-102行: 我们把` Add` , `Previous` 和 `Next` 这三个按钮禁用掉, 然后吧 `Submit` 和 `Cancel` 按钮设置为可见状态. 其中 `cancel` 按钮的出发事件代码从第137行开始.
138-139行: 还记得88-89行的那俩变量吗? 现在把 `nameLine` 和 `addressText` 的值赋回去.
141-143行: 但如果这些变量并没有存放任何数据, 我们便相应的设置文本框为空.
149-151行: `self.contacts` 是一个包含了我们的 address book 输入值的字典, 我们获取这个字典的大小并且赋给一个叫做 `number` 的变量, 如果输入的变量大于2个的话, 我们就把 `nextButton` 和 `previousButton` 设置为可用. 其中, `Submit` 按钮的触发事件代码在第104行开始.
105-106行: 把 `name` 和 `address` 这俩变量的值赋给文本框.
108-110行: 只要这些变量其中有为空值的, 我们就会报错.
113-120行: 这个字典的一个属性必须是唯一的键值对, 如果这个键值对不在我们的字典里面, 我们将会加到字典里并且显示一个 "success" 对话框. 同样的, 如果这个键值对存在于这个字典了, 我们就会显示错误. 其中, 字典的触发事件代码从第5行开始, 这个类会生成一个有序字典, 在代码的第36行被调用了.
7-11行: 初始化一些私有变量, `_idx` 是字典的索引, `_nr_items` 存放着字典的大小.
16-24行: 把列表进行排序, 当 `_idx` 比 `_nr_items` 大的时候, 将会触发一个exception, 而正常情况我们会步进字典, 这个方法返回以index为索引, 自增长为1的键值对.
如果你想了解更多关于Python字典的内容, [see this page](http://www.tutorialspoint.com/python/python_dictionary.htm)
 157-158行: 这个方法会在我们点击 `next` 按钮的时候触发, 输入框的值会赋给 `name` 变量, `iter()` 方法会给字典存在的变量赋值, 返回不在字典的键.
 160-168行: 我们同样准备了 try-catch 代码, 在第162行的try语句里, 我们给键值对赋值.
 170-171行: 我们把 `next_name` , `next_address` 的值赋给 `nameLine` 和 `addressText`. 其中 `previous` 按钮的触发事件代码从第173行开始.
 第176行: 初始化 `prev_name` , `prev_address` 这两个变量, 并赋值为None.
177-182行: 我们迭代字典来储存 `this_name` , `this_address` 这两个变量的值, 如果 `this_name` 等于 `nameLine` 里面的值, 我们就退出迭代, 反之则把 `prev_name` , `prev_address` 赋给我们得到的变量.

189-190行: `pass` 这条语句本身毫无意义, 只是确保语法正确, 所以当 `prev_name` 为空时, 我们默认设置其值为空字符串.

# 总结 #

希望你能喜欢这篇文章 :-)
