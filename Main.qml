import QtQuick 2.15
import QtQuick.Controls 2.15

//import complexity 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: "Math Game"
    //color: 'red'

    property int score: 0
    property int points: 1
    property int correctAnswer: -1
    property int timeLeft: 100
    property int blitsProbability: -1
    //property Сomplexity currentСomplexity: EASY
    property list<int> nums: [0, 0, 0, 0, 0, 0]
    property list<string> operations: ['', '', '', '', '']
    property int parametersCount: 0
    property int blitsLock: 10
    property bool blitsQuestion: false

    property color startColor: "red"
    property color endColor: "blue"


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
/*
        blitsQuestion = false
        button1.visible = false;
        button2.visible = false;
        button3.visible = false;
        button4.visible = false;
        questionText1.visible = true;
        generateBlitsQuestion()
        makeQuestionText()
*/

        if(!blitsLock) blitsProbability = Math.random() * 100

        if(blitsProbability != -1)
        {
            blitsQuestion = false
            button1.visible = false;
            button2.visible = false;
            button3.visible = false;
            button4.visible = false;
            questionText1.visible = true;
            generateBlitsQuestion()
            blitsLock = 10
            blitsProbability = -1
            animation.start()
        }
        else
        {
            blitsLock--
            blitsQuestion = true
            questionText1.visible = false;
            button1.visible = true;
            button2.visible = true;
            button3.visible = true;
            button4.visible = true;
            //currentСomplexity = 1
            generateUsualQuestion()
        }
        makeQuestionText()

    }

    function generateUsualQuestion() {
        parametersCount = 2
        do {
            nums[0] = Math.floor(Math.random() * 4);
            nums[1] = Math.floor(Math.random() * 4);

            if (score > 100)
            {
                parametersCount++
                nums[2] = Math.floor(Math.random() * 4);
            }
            if (score > 1000)
            {
                parametersCount++
                nums[3] = Math.floor(Math.random() * 4);
            }
            if (score > 10000)
            {
                parametersCount++
                nums[4] = Math.floor(Math.random() * 4);
            }

            correctAnswer = nums[0];
            for(var i = 1; i < parametersCount; i++){
                operations[i-1] = Math.random() < 0.5 ? '+' : '-';
                correctAnswer += operations[i-1] === '+' ? nums[i] : -1*nums[i]
            }
        } while (correctAnswer < 0 || correctAnswer > 3)

        makeQuestionText()
        timeLeft = 7
    }

    function generateBlitsQuestion() {
        parametersCount = 3

        nums[0] = Math.floor(Math.random() * 10)
        nums[1] = Math.floor(Math.random() * 10)
        nums[2] = Math.floor(Math.random() * 10)

        parametersCount = Math.floor(Math.random() * 4 + 3);

        if (parametersCount > 3) nums[3] = Math.floor(Math.random() * 10);
        if (parametersCount > 4) nums[4] = Math.floor(Math.random() * 10);
        if (parametersCount > 5) nums[5] = Math.floor(Math.random() * 10);

        correctAnswer = parseInt(nums[0]);
        for(var i = 1; i < parametersCount; i++){
            operations[i-1] = Math.random() < 0.5 ? '+' : '-'
            correctAnswer += operations[i-1] === '+' ? parseInt(nums[i]) : parseInt(-1*nums[i])
        }

        makeQuestionText()
        timeLeft = Math.floor(Math.random() * 7 + 14);
    }

    function makeQuestionText(){
        questionText.text = ''
        console.log('sdfsdfsfd   ' + questionText.text)
        for(var i = 0; i < parametersCount; i++){
            if(i != parametersCount-1) questionText.text += String(nums[i]) + " " + operations[i] + " "
            else questionText.text += String(nums[i])
        }

        ///*
        questionText.text += ' = ?'
        console.log('---------------------')
        console.log(parametersCount)
        console.log(nums)
        console.log(correctAnswer)
        console.log(operations)
        console.log(questionText.text)
        //*/
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
            score += blitsQuestion ? 2*points : points;
            points++;
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
            visible: true

            Text {
                id: questionText
                font.pixelSize: 40
                text: ""
                horizontalAlignment: Text.AlignHCenter
            }

            TextField {
                id: questionText1
                font.pixelSize: 40
                width: questionText.width
                text: ""
                horizontalAlignment: Text.AlignHCenter
                visible: false
                validator: IntValidator {bottom: -100; top: 99}
                onAccepted: {
                    //if(blitsQuestion) animation.stop()
                    animation.stop()
                    window.color = 'white'
                    checkAnswer(parseInt(questionText1.text))
                    questionText1.text = ''
                }
            }

            Button {
                id: button1
                text: "0"
                height: 50
                onClicked: checkAnswer(0)
                width: questionText.width
                visible: true
            }

            Button {
                id: button2
                text: "1"
                height: 50
                onClicked: checkAnswer(1)
                width: questionText.width
                visible: true
            }

            Button {
                id: button3
                text: "2"
                height: 50
                onClicked: checkAnswer(2)
                width: questionText.width
                visible: true
            }

            Button {
                id: button4
                text: "3"
                height: 50
                onClicked: checkAnswer(3)
                width: questionText.width
                visible: true
            }
            Button {
                text: "Перезагрузить"
                height: 50
                onClicked: {
                    window.color = 'white'
                    score = 0;
                    points = 1;
                    generateQuestion();
                    timer.running = true;
                    gameOverScreen.visible = false;
                }
                width: questionText.width
            }
        }

        GameOver {
            id: gameOverScreen
            visible: false
            onRestart: {
                score = 0;
                points = 1;
                window.color = 'white'
                generateQuestion();
                timer.running = true;
                visible = false;
            }
        }

        SequentialAnimation {
                id: animation

                ColorAnimation {
                    target: window
                    property: "color"
                    //from: startColor
                    //to: endColor
                    from: "blue"
                    to: "red"
                    duration: 1000
                }

                ColorAnimation  {
                    target: window
                    property: "color"
                    //from: endColor
                    //to: startColor
                    from: "red"
                    to: "blue"
                    duration: 1000
                }
                loops: Animation.Infinite
            }
        Component.onCompleted: generateQuestion()
    }
