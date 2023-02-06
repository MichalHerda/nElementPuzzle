import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.5

ApplicationWindow {
    id: mainW
    width: 640
    height: 480
    visible: true
    title: qsTr("nElementPuzzle")
    color: "blue"

    property int xDim: 4                                                // puzzle dimensions
    property int yDim: 4
    property int elemNo: (xDim * yDim) - 1                              // number of puzzle elements

    property variant listVal: []                                        // array of elements:  before draw
    property variant listRnd: []                                        //                     after draw

    property bool empty
    property bool gameOver

    function listValFill() {                                            // fill array by elements
        listVal = []
        for(let i = 1; i <= elemNo; i++) {                              // here: int i loop are array elements (values)
            listVal.push(i);
        }
    }

    function listRndFill() {                                            // draw
        listRnd = []
        let listValDecrease = elemNo
        for(let i = 0; i < elemNo; i++) {                               // here: int i loop are array index
            let rnd = Math.floor(Math.random() * listValDecrease )
            //console.log("rnd:  ",rnd)
            listRnd[i] = listVal[rnd]
            listVal.splice(rnd,1)
            listValDecrease --
            //console.log("arr1: ",listVal[0])
        }
    }

    Button {
        id: button
        width: mainW.width/3
        height: mainW.height/6
        anchors.right: parent.right

        background: Rectangle {
               color: inputHandler.pressed ? "darkgoldenrod" : "royalblue"
               border {color: inputHandler.pressed ? "red" : "cadetblue"; width: button.width/40}

               Text {
                     anchors.centerIn: parent
                     color: inputHandler.pressed ? "maroon" : "darkblue"
                     text: "Generate"
               }

               TapHandler {
                      id: inputHandler
                  }
            }



        onClicked: {
            listValFill()
            console.log("listVal: ",listVal)
            listRndFill()
            console.log("listRnd: ",listRnd)
        }

    }
        Rectangle {
            id: area
            width: mainW.width/1.5
            height: mainW.height
            anchors.left: parent.left
            color: "darkblue"
            }
        }


        /*
        Timer {
            interval: 2500
            repeat: true
            running: true
            onTriggered: {

            }
        }*/



