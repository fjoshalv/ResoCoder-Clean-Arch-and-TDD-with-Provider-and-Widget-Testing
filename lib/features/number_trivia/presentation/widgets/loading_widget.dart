import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('LLEGO');
    return Container(
      height: MediaQuery.of(context).size.height * 0.33,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}