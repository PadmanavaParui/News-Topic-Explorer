import 'package:flutter/material.dart';
// import 'package:ojt_news_exp/features/home/presentation/screens/homescreen2.dart';
// import 'package:ojt_news_exp/features/home/presentation/screens/homescreen.dart';
import 'package:ojt_news_exp/features/home/presentation/screens/home_screen.dart';
//this package imports the core flutter ui toolkit (widgets, colors, material designs).

//importing Home Screen file so we can use it here.
import 'features/home/presentation/screens/homescreen.dart';
//I used relative path to point to our 'features' folder structure.


//this is the entry point
//main() is the very first function that runs wen we open the app.
void main(){
  //runApp takes  the Widget MyApp and makes it the root of the widget tree.
  //we use const to tell Flutter that this widget won't change, that is immutable
  //this optimizes performance
  runApp(const MyApp());
}


//this is the root widget
//created the MyApp class.
//MyApp class extends 'StatelessWidget'.
//It is 'Stateless' because the root of the app doesn't change its own state dynamically.
class MyApp extends StatelessWidget{

  //constructor
  const MyApp({super.key});
  //'super.key' allows Flutter to track this widget in the tree


  //The build method
  //using the build method I am describing exactly what the UI should look like.
  //this method returns a widget. It runs only when the app starts.
  @override
  Widget build(BuildContext context) {

    //I am returning material app.
    //this wraps our app with material design functionality.
    //this provides navigation, themes and text styling
    return MaterialApp(

      // we give the title News Topic Explorer
      title: 'News Topic Explorer',
      //this title appears in the Android task switcher(Recent Apps)

      //debugShowCheckedModeBanner: false, disables the debug banner.
      //the small red color banner that appears at the top of the screen when we run the app
      //gets removed.
      debugShowCheckedModeBanner: false,

      //Theme configuration:
      //defining the global styling for the app
      //apps theme, color scheme, etc
      theme: ThemeData(
        //colorscheme defines the palette.
        //'fromSeed' generates a full palette based on one primary color, here(Colors.indigo).
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),

        //tells flutter to use the latest Material 3 design specification
        useMaterial3:true,
      ),

      //The home page
      //this seta the first screen the user sees when the app loads
      // we are calling the 'HomeScreen' widget from our 'features/home' folder
      // home: const HomeScreen(),
      home: const HomeScreen()
    );
  }
}