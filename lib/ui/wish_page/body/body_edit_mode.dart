import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/ui/common/images_picker/image_picker_screen.dart';
import 'package:wishlist/ui/common/widget_with_title.dart';
import 'package:wishlist/ui/wish_page/bloc/wish_page_bloc.dart';
import 'package:wishlist/ui/wish_page/common/enums/price_indication_mode.dart';
import 'package:wishlist/ui/wish_page/common/images_page_view.dart';

class BodyEditMode extends StatelessWidget {
  const BodyEditMode({super.key});

  @override
  Widget build(BuildContext context) {
    WishPageBloc wishPageBloc = BlocProvider.of<WishPageBloc>(context);
    return BlocBuilder<WishPageBloc, WishPageState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ImagesPageView(images: (state as WishEditable).images),
              Positioned.fill(
                right: 24,
                bottom: 24,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_enhance),
                      onPressed: () async {
                        final result = await Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ImagePickerScreen(images: state.images);
                        }));
                        if (result is List<Link>) {
                          wishPageBloc.add(AddImagesEvent(images: result));
                        }
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
          WidgetWithTitle(
            child: TextFormField(
              controller: wishPageBloc.fieldNameController,
              decoration: InputDecoration(
                filled: true,
                errorText: state.error.$1
                    ? (wishPageBloc.fieldNameController != null &&
                            wishPageBloc.fieldNameController!.text.isEmpty
                        ? 'Поле не должно быть пустым'
                        : null)
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                hintText: 'Название',
                fillColor: Colors.black12,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          WidgetWithTitle(
            title: 'Описание',
            child: TextFormField(
              controller: wishPageBloc.fieldDescriptionController,
              decoration: InputDecoration(
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                hintText: 'Комментарий по вашему желанию',
                fillColor: Colors.black12,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const WidgetWithTitle(
            title: 'Ссылки',
            child: LinksView(),
          ),
          WidgetWithTitle(
            title: 'Цена',
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: CheckButton(
                            title: "Цена не указана",
                            isCheck: state.priceIndicationMode ==
                                PriceIndicationMode.priceNotSpecified,
                            onTap: () => wishPageBloc.add(
                                const CheckPriceIndicationModeEvent(
                                    mode: PriceIndicationMode
                                        .priceNotSpecified)))),
                    Expanded(
                        child: CheckButton(
                            title: "Указать цену",
                            isCheck: state.priceIndicationMode ==
                                PriceIndicationMode.onePrice,
                            onTap: () => wishPageBloc.add(
                                const CheckPriceIndicationModeEvent(
                                    mode: PriceIndicationMode.onePrice)))),
                    Expanded(
                        child: CheckButton(
                            title: "Указать диапазон",
                            isCheck: state.priceIndicationMode ==
                                PriceIndicationMode.priceRange,
                            onTap: () => wishPageBloc.add(
                                const CheckPriceIndicationModeEvent(
                                    mode: PriceIndicationMode.priceRange))))
                  ],
                ),
                const SizedBox(height: 4),
                state.priceIndicationMode == PriceIndicationMode.onePrice
                    ? PriceTextFormField(
                        controller: wishPageBloc.price1Controller,
                        hintText: 'Укажите цену товара',
                      )
                    : (state.priceIndicationMode ==
                            PriceIndicationMode.priceRange
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('от',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey)),
                              PriceTextFormField(
                                controller: wishPageBloc.price1Controller,
                                hintText: 'Укажите минимальную цену',
                              ),
                              const Text('до',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey)),
                              PriceTextFormField(
                                controller: wishPageBloc.price2Controller,
                                hintText: 'Укажите максимальную цену',
                              )
                            ],
                          )
                        : const SizedBox())
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () => wishPageBloc.add(const SaveWishEvent()),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.amberAccent),
                  fixedSize: MaterialStateProperty.all<Size>(
                      const Size(double.infinity, 50)),
                ),
                child: Text(
                  state is CreateWishState
                      ? 'Сохранить желание'
                      : 'Сохранить изменения',
                  style: const TextStyle(fontSize: 16),
                )),
          ),
          const SizedBox(height: 4),
        ],
      );
    });
  }
}

class LinksView extends StatelessWidget {
  const LinksView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishPageBloc, WishPageState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (Link link in (state as WishEditable).urls) LinkText(url: link),
            state.showAddLinkButton ? const AddLink() : const LinkFormField(),
          ],
        );
      },
    );
  }
}

class LinkFormField extends StatelessWidget {
  const LinkFormField({super.key});

  @override
  Widget build(BuildContext context) {
    WishPageBloc wishPageBloc = BlocProvider.of<WishPageBloc>(context);
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: wishPageBloc.fieldLinkController,
            focusNode: wishPageBloc.linkFieldFocusNode,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              filled: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              hintText: 'Введите ссылку',
              fillColor: Colors.black12,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        IconButton.filled(
          iconSize: 24,
          onPressed: () =>
              BlocProvider.of<WishPageBloc>(context).add(const SaveLinkEvent()),
          icon: const Icon(Icons.add),
        )
      ],
    );
  }
}

class LinkText extends StatelessWidget {
  final String url;

  const LinkText({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishPageBloc, WishPageState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(url),
            )),
            SizedBox(
              height: 32,
              width: 32,
              child: IconButton.filled(
                iconSize: 16,
                onPressed: () => BlocProvider.of<WishPageBloc>(context)
                    .add(EditLinkEvent(url: url)),
                icon: const Icon(Icons.edit),
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              height: 32,
              width: 32,
              child: IconButton.filled(
                iconSize: 16,
                onPressed: () => BlocProvider.of<WishPageBloc>(context)
                    .add(RemoveLinkEvent(url: url)),
                icon: const Icon(Icons.delete),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AddLink extends StatelessWidget {
  const AddLink({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => BlocProvider.of<WishPageBloc>(context)
            .add(const AddNewLinkTextFieldEvent()),
        child: const Text('Добавить новую ссылку'));
  }
}

class CheckButton extends StatelessWidget {
  final bool isCheck;
  final String title;
  final Function()? onTap;

  const CheckButton(
      {super.key, required this.title, this.isCheck = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isCheck ? Colors.amberAccent : Colors.black12,
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 0.5),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
          ),
        ),
      ),
    );
  }
}

class PriceTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;

  const PriceTextFormField(
      {super.key, required this.controller, this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        hintText: hintText,
        fillColor: Colors.black12,
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
