import 'package:compresser/meta/home.dart';
import 'package:compresser/model/home_model.provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ImagePickerProvider(),)
  ],
  child: const Compresser(),
  ));
}

class Compresser extends StatelessWidget {
  const Compresser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Compresser",
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          brightness: Brightness.dark,
          fontFamily: GoogleFonts.poppins().fontFamily,
          appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0.0,
              color: Colors.transparent,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 18))),
    );
  }
}
