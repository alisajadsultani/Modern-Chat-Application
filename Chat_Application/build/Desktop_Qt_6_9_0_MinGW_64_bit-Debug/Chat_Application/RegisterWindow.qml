import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

ApplicationWindow {
    id: registerWindow
    width: 1450
    height: 850
    visible: true
    title: "Modern Chat"
    color: "#2b2d42"

    Image {
        source: "https://i.redd.it/new-and-slightly-older-discord-login-screen-as-a-png-v0-nnd20frfve3d1.png?width=1600&format=png&auto=webp&s=53d372d13bd1af47f24b8069e239aa3870fc6b78"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        width: 465
        height: 600
        color: "#313338"
        radius: 2
        anchors.centerIn: parent

        Text {
            text: "Create an account"
            color: "white"
            font.pixelSize: 24
            font.bold: true
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 25
            anchors.leftMargin: 130
        }

        Column {
            width: parent.width - 60
            height: parent.height - 50
            spacing: 6
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 85
            anchors.leftMargin: 28

            Text {
                text: "EMAIL *"
                color: "#D3D3D3"
                font.pixelSize: 13
                font.bold: true
            }

            TextField {
                id: emailInput
                width: parent.width
                height: 45
                color: "white"
                font.pixelSize: 15

                topPadding: 12

                background: Rectangle {
                    color: "#1E1F22"
                    radius: 3
                }
            }

            Rectangle {
                width: 1
                height: 15 // Space only between password input and login button
                color: "transparent"
            }

            Text {
                text: "DISPLAY NAME *"
                color: "#D3D3D3"
                font.pixelSize: 13
                font.bold: true
            }

            TextField {
                id: displayName
                width: parent.width
                height: 45
                color: "white"
                font.pixelSize: 15

                topPadding: 12

                background: Rectangle {
                    color: "#1E1F22"
                    radius: 3
                }
            }

            Rectangle {
                width: 1
                height: 15 // Space only between password input and login button
                color: "transparent"
            }

            Text {
                text: "USERNAME *"
                color: "#D3D3D3"
                font.pixelSize: 13
                font.bold: true
            }

            TextField {
                id: userName
                width: parent.width
                height: 45
                color: "white"
                font.pixelSize: 15

                topPadding: 12

                background: Rectangle {
                    color: "#1E1F22"
                    radius: 3
                }
            }

            Rectangle {
                width: 1
                height: 15 // Space only between password input and login button
                color: "transparent"
            }

            Text {
                text: "PASSWORD *"
                color: "#D3D3D3"
                font.pixelSize: 13
                font.bold: true
            }

            TextField {
                id: password
                width: parent.width
                height: 45
                color: "white"
                echoMode: TextInput.Password
                font.pixelSize: 15

                topPadding: 12

                background: Rectangle {
                    color: "#1E1F22"
                    radius: 3
                }
            }

            Rectangle {
                width: 1
                height: 20 // Space only between password input and login button
                color: "transparent"
            }


            Keys.onPressed: event => {
                                if (event.key === Qt.Key_Return
                                    || event.key === Qt.Key_Enter) {
                                    registerFunc()
                                    event.accepted = true
                                }
                           }

            Button {
                text: "Continue"
                width: parent.width
                height: 45

                background: Rectangle {
                    color: "#5865F2"
                    radius: 3
                }

                contentItem: Text {
                    text: "Continue"
                    color: "white"
                    font.pixelSize: 15
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        registerFunc()
                    }
                }

                hoverEnabled: true
                onPressed: background.color = "#111436"
                onReleased: background.color = "#5865F2"
            }

            Text {
                text: "Already Have an account?"
                font.pixelSize: 13
                color: "#0085FF"
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        console.log("Continue button clicked")
                        var component = Qt.createComponent("LoginWindow.qml")
                        if (component.status === Component.Ready) {
                            var newWindow = component.createObject(null)
                            newWindow.show()
                            registerWindow.close()
                        } else {
                            console.log("Failed to load new window")
                        }
                    }
                }
            }
        }
    }

    function registerFunc() {
        console.log("Registering user...")

        var success = dbManager.registerUser(emailInput.text,
                                             displayName.text,
                                             userName.text,
                                             password.text)
        if (success) {
            console.log("User registered successfully")
            var component = Qt.createComponent(
                        "LoginWindow.qml")
            if (component.status === Component.Ready) {
                var newWindow = component.createObject(null)
                newWindow.show()
                registerWindow.close()
            }
        } else {
            console.log("Failed to register user")
        }
    }
}
