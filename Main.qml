import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtWebSockets 1.1
import Qt.labs.platform 1.1
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: mainWindow
    width: 1450
    height: 850
    visible: true
    title: "Modern Chat"
    color: "#2b2d42" // Dark theme background

    property string userEmail: "" // Receive email from LoginWindow.qml
    property string profileImage: ""
    property string aboutMe: dbManager.getAboutMe(userEmail)
    property bool showPopup: false

    Item {
        id: profileCardOverlay
        visible: false
        anchors.fill: parent
        z: 999

        MouseArea {
            anchors.fill: parent
            onClicked: profileCardOverlay.visible = false
        }

        Rectangle {
            width: 300
            height: 400
            radius: 12
            color: "#2b2d42"
            z: 1000
            anchors {
                bottom: parent.bottom
                left: parent.left
                bottomMargin: 80
                leftMargin: 5.5
            }

            // Profile Picture
            Rectangle {
                width: 75
                height: 75
                radius: width / 2
                color: "#cccccc"
                clip: true
                border.color: "#3b3e54"
                border.width: 2
                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: 60
                    leftMargin: 25
                }

                Image {
                    source: profileImage !== "" ? profileImage : "defult_pfp.png"
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        profileCardOverlay.visible = false
                        profileEditWindow.visible = true
                    }
                }
            }

            // Display Name
            Text {
                text: dbManager.getDisplayName(userEmail)
                font.bold: true
                font.pixelSize: 20
                color: "white"
                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: 140
                    leftMargin: 20
                }
            }

            // Username
            Text {
                text: dbManager.getUserName(userEmail)
                font.pixelSize: 15
                color: "#dddddd"
                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: 170
                    leftMargin: 20
                }
            }

            // About Me Text
            Text {
                text: aboutMe
                font.pixelSize: 13
                wrapMode: Text.Wrap
                color: "#dddddd"
                width: parent.width - 25
                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: 200
                    leftMargin: 20
                }
            }

            // Edit Profile Button
            Button {
                text: "Edit Profile"
                width: parent.width - 50
                height: 35
                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: 340
                    leftMargin: 20
                }

                background: Rectangle {
                    color: "#5865F2"
                    radius: 5
                }

                contentItem: Text {
                    text: "Edit Profile"
                    font.pixelSize: 14
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        profileCardOverlay.visible = false
                        profileEditWindow.visible = true
                    }
                }

                hoverEnabled: true
                onPressed: background.color = "#31398f"
                onReleased: background.color = "#5865F2"
            }
        }
    }

    Item {
        id: profileEditWindow
        anchors.fill: parent
        visible: false
        z: 997

        MouseArea {
            anchors.fill: parent
            onClicked: profileEditWindow.visible = false
        }

        Rectangle {
            width: 620
            height: 650
            radius: 12
            color: "black"
            anchors {
                top: parent.top
                left: parent.left
                topMargin: 70
                leftMargin: 450
            }
            z: 998

            Row {
                width: parent.width
                height: 100
                spacing: 300
                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: 120
                    leftMargin: 50
                }

                Rectangle {
                    width: 90
                    height: 90
                    radius: width / 2
                    color: "#cccccc"
                    clip: true
                    border.color: "#3b3e54"
                    border.width: 2

                    Image {
                        source: profileImage !== "" ? profileImage : "defult_pfp.png"
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                    }
                }

                Popup {
                    id: inputPopup
                    modal: true
                    focus: true
                    width: 300
                    height: 180
                    x: (parent.width - width) / 2
                    y: (parent.height - height) / 2
                    background: Rectangle {
                        color: "#2b2d42"
                        radius: 10
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        Text {
                            text: "Enter Something"
                            color: "white"
                            font.pixelSize: 18
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter
                        }

                        TextField {
                            id: inputField
                            placeholderText: "Type here..."
                            Layout.fillWidth: true
                        }

                        RowLayout {
                            Layout.alignment: Qt.AlignRight
                            spacing: 10

                            Button {
                                text: "Cancel"
                                onClicked: inputPopup.close()
                            }

                            Button {
                                text: "Save"
                                onClicked: {
                                    dbManager.setAboutMe(userEmail,
                                                         inputField.text)
                                    aboutMe = dbManager.getAboutMe(userEmail)
                                    inputPopup.close()
                                    inputField.text = ""
                                }
                            }
                        }
                    }
                }

                Column {
                    id: popupMenu
                    spacing: 4
                    anchors {
                        horizontalCenter: mainButton.horizontalCenter
                        bottom: mainButton.top
                        left: mainButton.left
                        bottomMargin: 5
                    }
                    visible: showPopup
                    opacity: showPopup ? 1 : 0

                    Button {
                        text: "Edit About Me"
                        width: 120
                        background: Rectangle {
                            color: "#5865F2"
                            radius: 5
                        }
                        onClicked: {
                            showPopup = false
                            inputPopup.open()
                        }
                    }

                    Button {
                        text: "Change Profile"
                        width: 120
                        background: Rectangle {
                            color: "#5865F2"
                            radius: 5
                        }
                        onClicked: {
                            showPopup = false;
                            fileDialog.open()
                        }
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                        }
                    }
                }

                Button {
                    id: mainButton
                    width: 150
                    height: 30
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: 10
                    }

                    background: Rectangle {
                        color: "#5865F2"
                        radius: 5
                    }

                    contentItem: Text {
                        text: "Edit Profile"
                        font.pixelSize: 14
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.fill: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: showPopup = !showPopup
                    }

                    hoverEnabled: true
                    onPressed: background.color = "#31398f"
                    onReleased: background.color = "#5865F2"
                }
            }

            // Display Name
            Text {
                text: dbManager.getDisplayName(userEmail)
                font.bold: true
                font.pixelSize: 25
                color: "white"
                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: 220
                    leftMargin: 25
                }
            }

            // Username
            Text {
                text: dbManager.getUserName(userEmail)
                font.pixelSize: 18
                color: "#dddddd"
                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: 260
                    leftMargin: 25
                }
            }

            // About Me Label
            Text {
                text: "About Me"
                font.pixelSize: 18
                color: "#dddddd"
                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: 300
                    leftMargin: 25
                }
            }

            // About Me Content
            Text {
                text: aboutMe
                wrapMode: Text.Wrap
                font.pixelSize: 14
                color: "#d1d1d1"
                width: parent.width - 35
                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: 340
                    leftMargin: 25
                }
            }
        }
    }

    Rectangle {
        width: parent.width - 170
        height: parent.height - 60
        color: "#3b3e54"
        anchors.left: parent.left
        anchors.leftMargin: 310

        Column {
            width: parent.width
            height: parent.height

            ListView {
                id: chatList
                width: parent.width
                height: parent.height - 10 // Leave space for input box
                model: ListModel {}

                delegate: Rectangle {
                    width: parent.width
                    height: 60
                    color: "#3b3e54"

                    Text {
                        text: Qt.formatTime(new Date(), "hh:mm")
                        color: "#D3D3D3"
                        font.pixelSize: 11
                        topPadding: 10
                        leftPadding: displayNameUser.implicitWidth + 5
                    }

                    Text {
                        id: displayNameUser
                        text: model.sender
                        font.bold: true
                        font.pixelSize: 15
                        color: "white"
                        topPadding: 7
                        leftPadding: 65
                    }

                    Row {
                        width: parent.width
                        height: parent.height
                        spacing: 10

                        Rectangle {
                            width: 50
                            height: 50
                            radius: 25
                            color: "#AAAAAA"
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            anchors.topMargin: 5
                        }

                        Text {
                            text: model.message
                            color: "white"
                            font.pixelSize: 15
                            anchors.verticalCenter: parent.verticalCenter
                            topPadding: 24
                            leftPadding: 65
                        }
                    }
                }
            }

            // Input Box (Wrapped in Rectangle)
            Rectangle {
                width: parent.width
                height: 65
                color: "#2b2d42" // Match background color

                Row {
                    width: parent.width - 60
                    height: parent.height
                    spacing: 10
                    padding: 10

                    TextField {
                        id: messageInput
                        width: parent.width - 155
                        height: 33
                        placeholderText: "Type your message..."
                        color: "white"

                        horizontalAlignment: TextInput.AlignLeft
                        leftPadding: 9
                        topPadding: 7

                        font.pixelSize: 13
                        background: Rectangle {
                            color: "#3b3e54"
                            radius: 8
                        }

                        Keys.onPressed: event => {
                                            if (event.key === Qt.Key_Return
                                                || event.key === Qt.Key_Enter) {
                                                sendMessage()
                                                event.accepted = true
                                            }
                                        }
                    }

                    Button {
                        text: "Send"
                        width: 50
                        height: 35
                        onClicked: sendMessage()
                    }
                }
            }
        }
    }

    function sendMessage() {
        if (messageInput.text.trim() !== "") {
            var message = messageInput.text
            var displayName = dbManager.getDisplayName(userEmail)
            chatList.model.append({
                                      "sender": displayName,
                                      "message": message
                                  })
        }
        messageInput.text = ""
    }

    Rectangle {
        width: parent.width - 1140
        height: parent.height
        color: "grey"

        Rectangle {
            width: parent.width - 10
            height: 70
            color: "white"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.topMargin: 777
            radius: 12

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 12
                anchors.leftMargin: 7

                width: 47
                height: 47
                radius: width / 2
                color: "#cccccc"
                clip: true
                layer.enabled: true
                border.color: "#3b3e54"
                border.width: 2

                Image {
                    source: profileImage !== "" ? profileImage : "defult_pfp.png"
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        profileCardOverlay.visible = true
                    }
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        nameFilters: ["Image files (*.png *.jpg *.jpeg)"]
        onAccepted: {
            if (fileDialog.currentFile !== undefined
                    && fileDialog.currentFile !== "") {
                profileImage = fileDialog.currentFile
            }
        }
    }
}
