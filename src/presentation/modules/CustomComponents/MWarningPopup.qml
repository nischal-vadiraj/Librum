import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import CustomComponents
import Librum.style
import Librum.icons
import Librum.fonts

Popup {
    id: root
    property string leftButtonText: qsTr("Accept")
    property string rightButtonText: qsTr("Decline")
    property string title: qsTr("Do you Accept?")
    property string message: qsTr("Message")
    property int buttonsWidth: -1
    property int messageBottomSpacing: 0
    property bool singleButton: false
    property bool rightButtonRed: false
    property bool richText: false
    signal leftButtonClicked
    signal rightButtonClicked
    signal decisionMade
    property bool keepButtonsSameWidth: true

    implicitWidth: 646
    implicitHeight: layout.height
    padding: 0
    closePolicy: Popup.NoAutoClose | Popup.CloseOnEscape | Popup.CloseOnReleaseOutside
    background: Rectangle {
        color: "transparent"
        radius: 4
    }
    modal: true
    Overlay.modal: Rectangle {
        color: Style.colorPopupDim
        opacity: 1
    }

    MFlickWrapper {
        id: flickWrapper
        anchors.fill: parent
        contentHeight: layout.height

        ColumnLayout {
            id: layout
            width: parent.width
            spacing: -92

            Image {
                id: warningIllustration
                z: 2
                Layout.alignment: Qt.AlignHCenter
                Layout.rightMargin: 10
                source: Icons.attentionPurple
                sourceSize.width: 250
                fillMode: Image.PreserveAspectFit
            }

            Pane {
                id: backgroundRect
                Layout.fillWidth: true
                topPadding: 86
                horizontalPadding: 62
                bottomPadding: 62
                background: Rectangle {
                    color: Style.colorPopupBackground
                    radius: 6
                }

                ColumnLayout {
                    id: inRectLayout
                    width: parent.width
                    spacing: 22

                    Label {
                        id: title
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 18
                        text: root.title
                        color: Style.colorTitle
                        font.weight: Font.Medium
                        font.pointSize: Fonts.size42
                    }

                    Label {
                        id: message
                        Layout.alignment: Qt.AlignHCenter
                        Layout.bottomMargin: root.messageBottomSpacing
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        text: root.message
                        horizontalAlignment: Qt.AlignHCenter
                        color: Style.colorLightText
                        font.weight: Font.Medium
                        font.pointSize: Fonts.size15
                        textFormat: root.richText ? Text.RichText : Text.AutoText
                        onLinkActivated: link => Qt.openUrlExternally(link)

                        // Switch to the proper cursor when hovering above the link
                        MouseArea {
                            id: mouseArea
                            acceptedButtons: Qt.NoButton // Don't eat the mouse clicks
                            anchors.fill: parent
                            cursorShape: message.hoveredLink
                                         != "" ? Qt.PointingHandCursor : Qt.ArrowCursor
                        }
                    }

                    RowLayout {
                        id: buttonRow
                        Layout.preferredWidth: parent.width
                        Layout.preferredHeight: leftButton.height
                        Layout.topMargin: 24
                        spacing: 42

                        MButton {
                            id: leftButton
                            property int actualWidth: root.singleButton ? parent.width : (root.buttonsWidth == -1 ? implicitWidth : root.buttonsWidth)

                            Layout.preferredWidth: root.keepButtonsSameWidth
                                                   && actualWidth < rightButton.actualWidth ? rightButton.actualWidth : actualWidth
                            Layout.preferredHeight: 40
                            Layout.alignment: Qt.AlignBottom | Qt.AlignRight
                            horizontalMargins: 16
                            borderWidth: activeFocus ? 0 : 1
                            backgroundColor: activeFocus ? Style.colorBasePurple : "transparent"
                            opacityOnPressed: 0.7
                            text: root.leftButtonText
                            fontSize: Fonts.size13
                            fontWeight: Font.Bold
                            textColor: activeFocus ? Style.colorFocusedButtonText : Style.colorUnfocusedButtonText

                            onClicked: internal.leftButtonClicked()

                            KeyNavigation.tab: rightButton
                            KeyNavigation.right: rightButton
                            Keys.onReturnPressed: internal.leftButtonClicked()
                        }

                        MButton {
                            id: rightButton
                            property int actualWidth: root.buttonsWidth
                                                      == -1 ? implicitWidth : root.buttonsWidth

                            visible: !root.singleButton
                            Layout.preferredWidth: root.keepButtonsSameWidth
                                                   && actualWidth < leftButton.actualWidth ? leftButton.actualWidth : actualWidth
                            Layout.preferredHeight: 40
                            horizontalMargins: 20
                            Layout.alignment: Qt.AlignBottom | Qt.AlignLeft
                            borderWidth: focus ? 0 : 1
                            backgroundColor: focus ? (root.rightButtonRed ? Style.colorRed : Style.colorBasePurple) : "transparent"
                            opacityOnPressed: 0.7
                            text: root.rightButtonText
                            fontSize: Fonts.size13
                            fontWeight: Font.Bold
                            textColor: focus ? Style.colorFocusedButtonText : Style.colorUnfocusedButtonText

                            onClicked: internal.rightButtonClicked()

                            KeyNavigation.tab: leftButton
                            KeyNavigation.left: leftButton
                            Keys.onReturnPressed: internal.rightButtonClicked()
                        }
                    }
                }
            }
        }
    }

    QtObject {
        id: internal

        function leftButtonClicked() {
            root.leftButtonClicked()
            decisionMade()
        }

        function rightButtonClicked() {
            root.rightButtonClicked()
            decisionMade()
        }
    }

    function giveFocus() {
        leftButton.forceActiveFocus()
    }
}
