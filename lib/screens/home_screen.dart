import 'dart:convert';
import 'dart:io';

import 'banner_item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/main_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselController _controller = CarouselController();

  List<MainBanner> _mainBanners = [];
  int _current = 0;

  @override
  void initState() {
    super.initState();

    _loadMainBanner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Banner Slider')),
      body: Column(children: [
        const SizedBox(height: 10),
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items:
              _mainBanners.map((banner) => BannerItem(banner: banner)).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _mainBanners.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 10.0,
                height: 10.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
        const Expanded(
          child: Center(
            child: Text('Content'),
          ),
        ),
      ]),
    );
  }

  void _loadMainBanner() async {
    const url = 'https://www.meshopp.com/api/public/getbanner.php';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw HttpException('Bad response status code: ${response.statusCode}');
    }

    final json = jsonDecode(response.body);
    final mainBannersJson = json['results']['mainBanner'] as List;

    setState(() {
      _mainBanners =
          mainBannersJson.map((e) => MainBanner.fromJson(e)).toList();
    });
  }
}
