import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    width: 640
    height: 480
    color: '#03dffc'
    clip: true

    //Text {
        //text: "Игра окончена"
        //font.pixelSize: 48
        //color: "#232324"
        //anchors.centerIn: parent
   // }

    Button {
        onClicked: {
            score = 0;
            difficulty = 1;
            generateQuestion();
            timer.running = true;
            root.visible = false;
            restart();
        }
        anchors.centerIn: parent
        //y: 265
        //x: 195
        visible: root.visible
        contentItem: Image {
            source: "qrc:/iconca.png" // Замените на фактический путь к вашей иконке
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
        }
    }


    signal restart()
}
