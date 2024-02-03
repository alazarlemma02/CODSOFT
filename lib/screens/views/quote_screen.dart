import 'dart:math';
import 'dart:ui';

import 'package:daily_quote/data/model/quote.dart';
import 'package:daily_quote/data/services/background_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:daily_quote/bloc/quote_bloc/quote_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({Key? key}) : super(key: key);

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  String currentImage = '';
  String getRandonImage() {
    final random = Random();
    int index = random.nextInt(backgroundImages.length);
    return backgroundImages[index];
  }

  @override
  void initState() {
    super.initState();
    currentImage = getRandonImage();
    BlocProvider.of<QuoteBloc>(context).add(FetchQuoteEvent());
  }

  @override
  Widget build(BuildContext context) {
    String currentImage = getRandonImage();
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Your Today's Quote",
          style: GoogleFonts.getFont('Orbitron', color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(currentImage),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.0),
              ),
            ),
          ),
          BlocBuilder<QuoteBloc, QuoteState>(
            builder: (context, state) {
              switch (state.runtimeType) {
                case QuoteLoadingState:
                  return buildLoadingCard();
                case QuoteLoadedState:
                  final successState = state as QuoteLoadedState;
                  return buildQuoteCard(successState.quote, currentImage);
                default:
                  return buildErrorCard('Something went wrong');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildQuoteCard(Quote quote, String currentImage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
          height: MediaQuery.of(context).size.height * 0.7,
          color: Colors.transparent,
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                        image: NetworkImage(currentImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "“${quote.quote}”",
                          style: GoogleFonts.getFont('Pacifico',
                              color: Colors.white,
                              fontSize: 26,
                              shadows: [
                                const Shadow(
                                  blurRadius: 20.0,
                                  color: Colors.black,
                                  offset: Offset(5.0, 5.0),
                                ),
                              ]),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '- ${quote.author}',
                          style: GoogleFonts.getFont('Lobster',
                              color: Colors.white,
                              fontSize: 20,
                              shadows: [
                                const Shadow(
                                  blurRadius: 20.0,
                                  color: Colors.black,
                                  offset: Offset(5.0, 5.0),
                                ),
                              ]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            BlocProvider.of<QuoteBloc>(context).add(FetchQuoteEvent());
            setState(() {
              currentImage = getRandonImage();
            });
          },
          icon: const Icon(
            Icons.next_plan_outlined,
            color: Colors.white,
            size: 40,
          ),
        ),
      ],
    );
  }

  Widget buildLoadingCard() {
    return const Center(
      child: CircularProgressIndicator(
          color: Colors.white, backgroundColor: Colors.black),
    );
  }

  Widget buildErrorCard(String message) {
    return Center(
      child: Text(
        'Error: $message',
        style: const TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }
}
