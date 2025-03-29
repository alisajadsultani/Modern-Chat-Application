import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtWebSockets 1.1


ApplicationWindow {
    id: mainWindow
    width: 1450
    height: 850
    visible: true
    title: "Modern Chat"
    color: "#2b2d42" // Dark theme background

    property string userEmail: "" // Receive email from LoginWindow.qml

    // Rectangle {
    //     id: sidebar
    //     width: 250
    //     color: "#2b2d42"  // Dark sidebar color
    //     anchors.top: parent.top
    //     anchors.bottom: parent.bottom
    //     anchors.left: parent.left

    //     Column {
    //         anchors.fill: parent
    //         spacing: 10
    //         padding: 10

    //         Text {
    //             text: "Friends"
    //             color: "white"
    //             font.pixelSize: 18
    //             font.bold: true
    //             horizontalAlignment: Text.AlignHCenter
    //             anchors.horizontalCenter: parent.horizontalCenter
    //         }

    //         ListView {
    //             id: friendsListView
    //             width: parent.width
    //             height: parent.height - 40
    //             model: ListModel { id: friendsModel }

    //             delegate: Rectangle {
    //                 width: parent.width
    //                 height: 50
    //                 color: "#3b3e54"
    //                 border.color: "#444"
    //                 radius: 5
    //                 anchors.horizontalCenter: parent.horizontalCenter

    //                 Text {
    //                     text: name
    //                     color: "white"
    //                     anchors.centerIn: parent
    //                 }

    //                 MouseArea {
    //                     anchors.fill: parent
    //                     onClicked: {
    //                         console.log("Clicked on friend:", name)
    //                         // Open chat with the friend (Future feature)
    //                     }
    //                 }
    //             }
    //         }
    //     }

    //     // Fetch Friends from Backend on Startup
    //     Component.onCompleted: {
    //         loadFriends();
    //     }
    // }


    Rectangle {
        width: parent.width - 170
        height: parent.height - 50
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

    Component.onCompleted: {
        console.log("User Email received in Main.qml:", userEmail)

        if (userEmail.trim() !== "") {
            var displayName = dbManager.getDisplayName(userEmail)
            console.log("Retrieved Display Name:", displayName)
        } else {
            console.log("ERROR: No email received from LoginWindow.")
        }
    }

    function sendMessage() {
        if (messageInput.text.trim() !== "") {
            console.log("Email sent to dbManager:", userEmail)

            if (userEmail.trim() !== "") {
                var displayName = dbManager.getDisplayName(userEmail)
                console.log("Retrieved Display Name:", displayName)

                chatList.model.append({
                                          "sender": displayName,
                                          "message": messageInput.text
                                      })
            } else {
                console.log("ERROR: No email found.")
            }

            messageInput.text = ""
        }
    }
}
