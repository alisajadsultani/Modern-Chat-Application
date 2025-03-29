import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

ApplicationWindow {
    id: loginWindow
    width: 1450
    height: 850
    visible: true
    title: "Modern Chat"

    Image {
        id: backgroun_image
        source: "https://i.redd.it/new-and-slightly-older-discord-login-screen-as-a-png-v0-nnd20frfve3d1.png?width=1600&format=png&auto=webp&s=53d372d13bd1af47f24b8069e239aa3870fc6b78"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        width: 750
        height: 400
        radius: 2
        anchors.centerIn: parent
        color: "#313338"

        Rectangle {
            width: 250
            height: 325
            color: "transparent"
            anchors.right: parent.right
            anchors.rightMargin: 34
            anchors.verticalCenter: parent.verticalCenter

            // Outer shadow (lightest & widest)
            Rectangle {
                width: parent.width + 40
                height: parent.height + 40
                color: "black"
                opacity: 0.06 // Lightest glow
                anchors.centerIn: parent
            }

            // Middle shadow (medium opacity)
            Rectangle {
                width: parent.width + 25
                height: parent.height + 25
                color: "black"
                opacity: 0.12
                anchors.centerIn: parent
            }

            // Inner shadow (darkest & smallest)
            Rectangle {
                width: parent.width + 15
                height: parent.height + 15
                color: "black"
                opacity: 0.18 // Stronger glow near image
                anchors.centerIn: parent
            }

            // The actual image
            AnimatedImage {
                source: "https://i.redd.it/7d1mr75y0r471.gif"
                width: parent.width
                height: parent.height
                playing: true
                anchors.centerIn: parent
            }
        }

        Text {
            text: "Welcome back!"
            color: "white"
            font.pixelSize: 24
            font.bold: true
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.leftMargin: 145
        }

        Text {
            text: "We're so excited to see you again!"
            color: "#B0B0B0" // Light gray text
            font.pixelSize: 15
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 60
            anchors.leftMargin: 115
        }

        Column {
            width: parent.width - 100
            height: parent.height - 50
            spacing: 5
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 100 // Move the form DOWN
            anchors.leftMargin: 30 // Move the form RIGHT

            Text {
                text: "EMAIL OR PHONE NUMBER *"
                color: "#D3D3D3"
                font.pixelSize: 13
                font.bold: true
            }

            // Email Input
            TextField {
                id: emailInput
                width: parent.width - 250 // Make it slightly narrower
                height: 45
                color: "white"

                horizontalAlignment: TextInput.AlignLeft
                leftPadding: 11
                topPadding: 12

                font.pixelSize: 15

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

            // Password Input
            TextField {
                id: passwordInput
                width: parent.width - 250
                height: 45
                //echoMode: TextInput.Password // Hides password characters
                color: "white"

                horizontalAlignment: TextInput.AlignLeft
                leftPadding: 11
                topPadding: 12

                font.pixelSize: 15

                background: Rectangle {
                    color: "#1E1F22"
                    radius: 3
                }
            }

            Text {
                text: "Forgot your password?"
                color: "#0085FF"
                font.pixelSize: 12
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor // Change cursor on hover
                    onClicked: {
                        console.log("Link clicked")
                    }
                }
            }

            Rectangle {
                width: 1
                height: 15 // Space only between password input and login button
                color: "transparent"
            }

            // Enter Key
            Keys.onPressed: event => {
                                if (event.key === Qt.Key_Return
                                    || event.key === Qt.Key_Enter) {
                                    openNewWindow()
                                    event.accepted = true
                                }
                            }

            // Login Button and
            Button {
                text: "Log in"
                width: parent.width - 250
                height: 45
                anchors.topMargin: 300

                background: Rectangle {
                    color: "#5865F2"
                    radius: 3
                }

                contentItem: Text {
                    text: "Log in"
                    font.pixelSize: 14
                    font.bold: true
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        openNewWindow()
                    }
                }

                hoverEnabled: true
                onPressed: background.color = "#31398f"
                onReleased: background.color = "#5865F2"
            }

            Row {
                spacing: 10

                Text {
                    text: "Need an account?"
                    color: "#D3D3D3"
                    font.pixelSize: 12
                }

                Text {
                    text: "Register"
                    color: "#0085FF"
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            console.log("Link Clicked")
                            console.log("Continue button clicked")
                            var component = Qt.createComponent(
                                        "RegisterWindow.qml")
                            if (component.status === Component.Ready) {
                                var newWindow = component.createObject(null)
                                newWindow.show()
                                loginWindow.close()
                            } else {
                                console.log("Failed to load new window")
                            }
                        }
                    }
                }
            }
        }
    }

    function openNewWindow() {
        console.log("Login Clicked. Email entered:",
                    emailInput.text)

        var userLogin = dbManager.loginUser(emailInput.text,
                                            passwordInput.text)

        if (userLogin === true) {
            console.log("Login successful, storing email:",
                        emailInput.text)

            var component = Qt.createComponent("Main.qml")
            if (component.status === Component.Ready) {
                var newWindow = component.createObject(null, {
                                                           "userEmail": emailInput.text
                                                       })
                // Pass email as property
                newWindow.show()
                loginWindow.close()
            } else {
                console.log("Window not found")
            }
        } else {
            console.log("User not found, login failed.")
        }
    }
}
