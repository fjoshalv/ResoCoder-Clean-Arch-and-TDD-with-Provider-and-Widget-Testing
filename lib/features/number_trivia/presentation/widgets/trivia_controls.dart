import 'package:clean_arch_tdd/features/number_trivia/presentation/provider/number_trivia_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  String inputString = '';
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            inputString = value;
          },
          onSubmitted: (_) => _dispatchConcrete(),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _dispatchConcrete,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: const Text('Search'),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: _dispatchRandom,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: const Text('Get random trivia'),
              ),
            ),
          ],
        )
      ],
    );
  }

  void _dispatchConcrete() {
    controller.clear();
    Provider.of<NumberTriviaProvider>(context, listen: false)
        .getTriviaForConcreteNumber(
      inputString,
    );
  }

  void _dispatchRandom() {
    controller.clear();
    Provider.of<NumberTriviaProvider>(context, listen: false)
        .getTriviaForRandomNumber();
  }
}
