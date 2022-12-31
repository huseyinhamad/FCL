import 'package:fcl/applicaton_layer/core/services/theme_service.dart';
import 'package:fcl/applicaton_layer/pages/advice/cubit/advice_cubit.dart';
import 'package:fcl/applicaton_layer/pages/advice/widgets/advice_field.dart';
import 'package:fcl/applicaton_layer/pages/advice/widgets/custom_button.dart';
import 'package:fcl/applicaton_layer/pages/advice/widgets/error_message.dart';
import 'package:fcl/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AdvicePageWrapperProvider extends StatelessWidget {
  const AdvicePageWrapperProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<AdviceCubit>(),
      child: const AdvicePage(),
    );
  }
}

class AdvicePage extends StatelessWidget {
  const AdvicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Advicer", style: themeData.textTheme.headline1),
        centerTitle: true,
        actions: [
          Switch(
            value: Provider.of<ThemeService>(context).isDarkModeOn,
            onChanged: (_) =>
                Provider.of<ThemeService>(context, listen: false).toggleTheme(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: BlocBuilder<AdviceCubit, AdviceCubitState>(
                  builder: (context, state) {
                    if (state is AdviceInitial) {
                      return Text(
                        "Your Advice is waiting for you",
                        style: themeData.textTheme.headline1,
                      );
                    }
                    if (state is AdviceStateLoading) {
                      return CircularProgressIndicator(
                        color: themeData.colorScheme.secondary,
                      );
                    }
                    if (state is AdviceStateLoaded) {
                      return AdviceField(advice: state.advice);
                    }
                    if (state is AdviceStateError) {
                      return ErrorMessage(message: state.message);
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: Center(
                  child: CustomButton(
                      onTap: () => BlocProvider.of<AdviceCubit>(context)
                          .adviceRequested())),
            ),
          ],
        ),
      ),
    );
  }
}
