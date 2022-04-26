


import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MusicApp extends StatefulWidget {
  const MusicApp({Key? key}) : super(key: key);

  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  //We will need some variables

  var playing = false; //at the begining we are not playing any song
  IconData playBtn = Icons.play_arrow; // the main state of the play button icon


  //Now let's start by creating our music player
  //first let's declare some object
  late AudioPlayer _Player;
  late AudioCache cache;

  Duration position = Duration();
  Duration musicLength = Duration();

  //We will create a custom slider
  Widget slider(){
    return Container(
      width: 280.0,

      child: Slider.adaptive(
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,

          value: position.inSeconds.toDouble(),
          max: musicLength.inSeconds.toDouble(),
          onChanged: (value){
            seeToSek(value.toInt());
          }
      ),
    );
  }

  //Let's create the islamic function that will allow us to go to a certain position of the music
  void seeToSek (int sec){
    Duration newPos = Duration(seconds: sec);
    _Player.seek(newPos);
  }

  //Let's initialize our player
  @override
  void initState() {
    super.initState();
    _Player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _Player);

    //Now let's handle the audio player time

    //This function will allow us to get the music duration
    _Player.onDurationChanged.listen((d) {
      setState(() {
        musicLength = d;
      });
    });

    //This function will allow us to move the cursor of the slider while we are playing the song
    _Player.onAudioPositionChanged.listen((p) {
      setState(() {
        position = p;
      });
    });


    cache.load("my_music.mp3"); //We will load the song to make the playing fast
    //as we can see I just wrote down the name of the file and not
    // the full path, this because audience automatically
    // pick the file from assets folder so make sure to name the folder "assets"
    // and and the sing directly inside that folder
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //Let's start by creating the main Ui of the app
      body: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
              end: Alignment.bottomRight,

              colors: [
                Colors.blue,
                Colors.lightBlueAccent,
              ]
          )
        ),

        child: Padding(
            padding: EdgeInsets.only(top: 48.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                //Let's add some text tile
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text("Islamic Music",style: TextStyle(fontSize: 32,color: Colors.white,fontWeight: FontWeight.bold,),),
                ),


                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text("Listen your Islamic Music",style: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.w300,),),
                ),


                //Let's add the music cover
                SizedBox(height: 24.0,),
                Center(
                  child: Container(
                    height: 280.0,
                    width: 280.0,
                    
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      image: DecorationImage(image: AssetImage("assets/pic1.png"),fit: BoxFit.fill)
                    ),
                  ),
                ),
                
                SizedBox(height: 28,),
                Center(
                  child: Text("Strangers",style: TextStyle(fontSize: 30.0,color: Colors.white,fontWeight: FontWeight.w600),),
                ),

                SizedBox(height: 55.0,),
                Expanded(
                    child: Center(
                      child: Container(

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                          color: Colors.white
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,

                          //Let's start by adding the controller
                          //Let's add the time indicator text
                          children: [
                            Container(
                              width: 400.0,

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                
                                children: [
                                  Text("${position.inMinutes}: ${position.inSeconds.remainder(60)}"),
                                  slider(),
                                  Text("${musicLength.inMinutes}: ${musicLength.inSeconds.remainder(60)}"),
                                ],
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,

                              children: [
                                IconButton(onPressed: (){}, icon: Icon(Icons.skip_previous,size: 45.0,color: Colors.lightBlueAccent,)),

                                IconButton(onPressed: (){
                                  //Here we will add the functionality of the play button

                                  if(!playing){
                                    //Now let's play the song
                                    cache.play("my_music.mp3");

                                    setState(() {
                                      playBtn = Icons.pause;
                                      playing = true;

                                    });
                                  }else{
                                    _Player.pause();
                                   setState(() {
                                    playBtn = Icons.play_arrow;
                                    playing = false;
                                  });
                                  }

                                }, icon: Icon(playBtn,size:45.0,color: Colors.blueAccent,)),

                                IconButton(onPressed: (){}, icon: Icon(Icons.skip_next,size: 45.0,color: Colors.lightBlueAccent,)),

                              ],
                            )
                          ],
                        ),
                      ),
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
