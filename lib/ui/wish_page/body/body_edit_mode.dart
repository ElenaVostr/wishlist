import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/ui/common/images_picker/image_picker_screen.dart';
import 'package:wishlist/ui/common/widgets/widget_with_title.dart';
import 'package:wishlist/ui/wish_page/bloc/wish_page_bloc.dart';
import 'package:wishlist/ui/wish_page/common/enums/price_indication_mode.dart';
import 'package:wishlist/ui/wish_page/common/widgets/check_button.dart';
import 'package:wishlist/ui/wish_page/common/widgets/images_page_view.dart';
import 'package:wishlist/ui/wish_page/common/widgets/links_view.dart';
import 'package:wishlist/ui/wish_page/common/widgets/price_text_form_field.dart';

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
