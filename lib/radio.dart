
import 'dart:async';
import 'dart:math';

import  'package:just_audio/just_audio.dart';



class MyRadio{
  final player = AudioPlayer();  //Main Game music
  final player2 = AudioPlayer(); //Death Music
  final playlist = ConcatenatingAudioSource(
    // Start loading next item just before reaching it
    useLazyPreparation: true,
    // Customise the shuffle algorithm
    shuffleOrder: DefaultShuffleOrder(),
    // Specify the playlist items
    children: [
      AudioSource.asset('audio/Afterimage.wav',tag: 'Afterimage'),
      AudioSource.asset('audio/Boat Load.wav', tag: 'Boat Load'),
      AudioSource.asset('audio/Bokeh.wav', tag:'Bokeh'),
      AudioSource.asset('audio/El Dorado.wav', tag: 'El Dorado'),
      AudioSource.asset('audio/Grandpa.wav', tag:'Grandpa'),
      AudioSource.asset('audio/Insight Timer.wav', tag: 'Insight Timer'),
      AudioSource.asset('audio/Material.wav', tag: 'Material'),
      AudioSource.asset('audio/Mycelium 2.wav', tag:'Mycellium 2'),
      AudioSource.asset('audio/The Arc.wav', tag: 'The Arc'),
      AudioSource.asset('audio/The Spot.wav', tag: 'The Spot'),
      AudioSource.asset('audio/Aquafiya.wav', tag: 'Aquafiya'),

    ],
  );

  //Main Menu Music
  void mainMenu() async{
    player.setAudioSource(AudioSource.asset('audio/Aquafiya.wav'));
    await player.setVolume(.5);
    await player.setLoopMode(LoopMode.one);
    Timer(Duration(seconds: 1), () async {
      await player.play();
    });

  }

  //Game Music
  void initialize() async{
    var intValue = Random().nextInt(10); //Randomly Determines first song
    await player.setShuffleModeEnabled(true);
    await player.setVolume(.5);
    await player.setAudioSource(playlist, initialIndex: intValue, initialPosition: Duration.zero);
    await player.setLoopMode(LoopMode.all);
    Timer(Duration(seconds: 1), () async {
      player.play();
    });
  }

  //Death Music
  void death() async{
    player.pause(); //Pause main music
    player2.setAudioSource(AudioSource.asset('audio/Afterimage.wav'));
    await player2.setVolume(.5);
    await player2.setLoopMode(LoopMode.one);
    await player2.seek(Duration(seconds: 1));
    await player2.play();

  }

  //Switches from death music and resumes main music at last place
  void restart() async{
    player2.stop();
    player.play();
  }
  void dispose() async{
    await player.stop();
    await player2.stop();
  }
  String getTitle(){
    late String name;
    final currentItem = player.sequenceState?.currentSource;
    final title = currentItem?.tag as String?;
   name = title ?? '';
   return name;

  }
}