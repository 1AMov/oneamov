import 'package:flutter/material.dart';

import '../config.dart';
import 'progress_widget.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final bool loading;
  final bool? isActive;
  final bool? isTight;
  final Color? color;
  final void Function() onPressed;
  const CustomButton(
      {super.key,
      required this.title,
      required this.loading,
      this.isActive = true,
      this.isTight = false,
      this.color = Config.themeColor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 40.0,
        width: isTight! ? null : size.width,
        child: ElevatedButton(
          onPressed: loading || !isActive! ? () {} : onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: Size.zero,
            elevation: isActive! ? 0.0 : null,
            backgroundColor: loading || !isActive! ? Colors.grey : color,
            // shadowColor: Config.boxShadow.color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading) ...[
                circularProgress(color: Colors.white, size: 15.0),
                const SizedBox(width: 10.0),
                Text(
                  "Loading...",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
              ] else ...[
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  const CustomBackButton(
      {super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          size: 18.0,
          color: Colors.grey,
        ),
        label: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.grey,
          ),
        ));
  }
}

class TransparentButton extends StatelessWidget {
  final String title;
  final IconData iconData;
  final bool loading;
  final void Function() onPressed;
  const TransparentButton(
      {super.key,
      required this.title,
      required this.iconData,
      required this.loading,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: loading
              ? Colors.grey.withOpacity(0.1)
              : Config.themeColor.withOpacity(0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        onPressed: loading ? () {} : onPressed,
        icon: loading
            ? circularProgress(color: Colors.grey, size: 15.0)
            : Icon(
                iconData,
                color: Config.themeColor,
                size: 15.0,
              ),
        label: Text(
          loading ? "Loading..." : title,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w700,
                color: loading ? Colors.grey : Config.themeColor,
              ),
        ));
  }
}

class WhiteButton extends StatelessWidget {
  final String title;
  final IconData iconData;
  final void Function() onPressed;
  const WhiteButton(
      {super.key,
      required this.title,
      required this.iconData,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        onPressed: onPressed,
        icon: Icon(
          iconData,
          color: Config.themeColor,
          size: 15.0,
        ),
        label: Text(
          title,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w700,
                color: Config.themeColor,
              ),
        ));
  }
}

class BorderButton extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry? insidePadding;
  final IconData? iconData;
  final Color color;
  final bool isActive;
  final void Function() onPressed;

  const BorderButton(
      {super.key,
      required this.title,
      this.insidePadding,
      this.iconData,
      required this.color,
      required this.isActive,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: insidePadding,
      width: size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border:
              Border.all(color: isActive ? color : Colors.grey, width: 3.0)),
      child: iconData != null
          ? TextButton.icon(
              onPressed: isActive ? onPressed : () {},
              label: Text(
                title,
                style: TextStyle(
                    color: isActive ? color : Colors.grey,
                    fontWeight: FontWeight.w800),
              ),
              icon: Icon(
                iconData,
                color: isActive ? color : Colors.grey,
              ))
          : TextButton(
              onPressed: isActive ? onPressed : () {},
              child: Text(
                title,
                style: TextStyle(
                    color: isActive ? color : Colors.grey,
                    fontWeight: FontWeight.w800),
              )),
    );
  }
}

class OptionsSelector extends StatefulWidget {
  final String selectedOption;
  final List<String> options;
  final void Function(String) onChanged;
  const OptionsSelector(
      {super.key,
      required this.selectedOption,
      required this.options,
      required this.onChanged});

  @override
  State<OptionsSelector> createState() => _OptionsSelectorState();
}

class _OptionsSelectorState extends State<OptionsSelector> {
  Widget buttonItem(String item, bool isSelected) {
    return InkWell(
      onTap: () => widget.onChanged(item),
      child: isSelected
          ? Card(
              color: Colors.white,
              elevation: 5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Text(
                  item,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Text(
                item,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(widget.options.length, (index) {
          bool isSelected = widget.selectedOption == widget.options[index];
          return buttonItem(widget.options[index], isSelected);
        }),
      ),
    );
  }
}
