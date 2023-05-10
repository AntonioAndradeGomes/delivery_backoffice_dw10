import 'package:flutter/material.dart';

import '../../../core/ui/styles/text_styles.dart';
import 'menu_enum.dart';

class MenuButton extends StatelessWidget {
  final Menu menu;
  final Menu? menuSelected;
  final ValueChanged<Menu> onPressed;
  const MenuButton({
    Key? key,
    required this.menu,
    this.menuSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelected = menuSelected == menu;
    return LayoutBuilder(
      builder: (_, constrains) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onPressed(menu),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5),
              decoration: isSelected
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFFFF5E2),
                    )
                  : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'images/icons/${isSelected ? menu.assetIconSelected : menu.assetIcon}',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    menu.label,
                    overflow: TextOverflow.ellipsis,
                    style: isSelected
                        ? context.textStyles.textBold
                        : context.textStyles.textRegular,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
