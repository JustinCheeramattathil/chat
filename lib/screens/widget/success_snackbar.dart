import 'package:flutter/material.dart';

class SuccessSnackBar extends StatelessWidget {
  final String errorText;
  const SuccessSnackBar({
    Key? key,
    required this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          height: 90,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 101, 235, 68),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              const SizedBox(
                width: 48,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Oooops....',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const Spacer(),
                    Text(
                      errorText,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -2,
          child: ClipRRect(
            borderRadius:
                const BorderRadius.only(bottomLeft: Radius.circular(20)),
            child: Image.asset(
              'assets/images/OIP-removebg-preview.png',
              height: 52,
              width: 45,
              color: Color.fromARGB(255, 2, 145, 2),
            ),
          ),
        ),
        Positioned(
          top: -25,
          left: 0,
          child: Image.asset(
            'assets/images/error.png',
            height: 50,
            width: 50,
          ),
        )
      ],
    );
  }
}
