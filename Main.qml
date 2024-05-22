import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: "Math Game"

    property int score: 0
    property int difficulty: 1
    property int correctAnswer: -1
    property int timeLeft: 7

    Timer {
        id: timer
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            timeLeft--;
            if (timeLeft == 0) {
                gameOver()
            }
        }
    }

    function generateQuestion() {
        var a, b, c, d, e;

        do {
            // Генерируем случайные числа для a и b в диапазоне от 0 до 10
            a = Math.floor(Math.random() * 4);
            b = Math.floor(Math.random() * 4);

            // Проверяем количество очков для генерации чисел c, d и e
            if (score > 100)   c = Math.floor(Math.random() * 4);
            if (score > 1000)  d = Math.floor(Math.random() * 4);
            if (score > 10000) e = Math.floor(Math.random() * 4);

            // Генерируем случайные операторы + или -
            var op1 = Math.random() < 0.5 ? '+' : '-';
            var op2 = Math.random() < 0.5 ? '+' : '-';
            var op3 = Math.random() < 0.5 ? '+' : '-';
            var op4 = Math.random() < 0.5 ? '+' : '-';

            // Вычисляем правильный ответ на основе операторов и чисел a, b, c, d, e
            correctAnswer = (op1 == '+' ? a + b : a - b) + (c !== undefined ? (op2 == '+' ? c : -c) : 0) + (d !== undefined ? (op3 == '+' ? d : -d) : 0) + (e !== undefined ? (op4 == '+' ? e : -e) : 0);

            // Формируем текст вопроса
            questionText.text = a + " " + op1 + " " + b + (c !== undefined ? " " + op2 + " " + c : "") + (d !== undefined ? " " + op3 + " " + d : "") + (e !== undefined ? " " + op4 + " " + e : "") + " = ?";

            // Устанавливаем время
            timeLeft = 8;
            // Добавляем проверку для генерации усложненных примеров с шансом в 30%
        } while (correctAnswer < 0 || correctAnswer > 3)

    }
    // Функция для генерации случайного цвета
//    function getRandomColor() {
//        var letters = "0123456789ABCDEF";
//        var color = "#";
//        for (var i = 0; i < 6; i++) {
//            color += letters[Math.floor(Math.random() * 16)];
//        }
//        return color;
//   }
//    function changeBackgroundColor(color) {
       // Изменяем цвет фона
        // Например, в QML это может быть свойство color у Rectangle
//        Rectangle.color = color;
//    }

    function checkAnswer(answer) {
        if (answer === correctAnswer) {
            score += difficulty;
            difficulty++;
            generateQuestion();
        } else {
            gameOver();
        }
    }

    function gameOver() {
        timer.running = false;
        gameOverScreen.visible = true;
    }

    Text {
            id: timerText
            text: "Оставшееся время: " + timeLeft
            anchors.top: parent.top
            anchors.left: parent.left
            font.bold: true
            font.pointSize: 28
        }

        Text {
            text: "Score: " + score
            font.pixelSize: 28
            font.bold: true
            anchors.top: parent.top
            anchors.right: parent.right
        }

        Column {
            spacing: 10
            anchors.centerIn: parent

            Text {
                id: questionText
                font.pixelSize: 40
                text: ""
                horizontalAlignment: Text.AlignHCenter
            }

            Button {
                text: "0"
                height: 50
                onClicked: checkAnswer(0)
                width: parent.width
            }

            Button {
                text: "1"
                height: 50
                onClicked: checkAnswer(1)
                width: parent.width
            }

            Button {
                text: "2"
                height: 50
                onClicked: checkAnswer(2)
                width: parent.width
            }

            Button {
                text: "3"
                height: 50
                onClicked: checkAnswer(3)
                width: parent.width
            }
            Button {
                text: "Перезагрузить"
                height: 50
                onClicked: {
                    score = 0;
                    difficulty = 1;
                    generateQuestion();
                    timer.running = true;
                    gameOverScreen.visible = false;
                }
                width: parent.width
            }
        }

        GameOver {
            id: gameOverScreen
            visible: false
            onRestart: {
                score = 0;
                difficulty = 1;
                generateQuestion();
                timer.running = true;
                visible = false;
            }
        }

        Component.onCompleted: generateQuestion()
    }
