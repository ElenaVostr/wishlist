part of 'wish_page_bloc.dart';

sealed class WishPageEvent extends Equatable {
  const WishPageEvent();
}

/// Событие отметки желания исполненным
class WishDoneEvent extends WishPageEvent {
  const WishDoneEvent();

  @override
  List<Object?> get props => [];
}

/// Событие удаления желания
class DeleteWishEvent extends WishPageEvent {
  const DeleteWishEvent();

  @override
  List<Object?> get props => [];
}

/// Включили режим редактирования
class EnableEditModeEvent extends WishPageEvent {
  const EnableEditModeEvent();

  @override
  List<Object?> get props => [];
}

/// Подтверждаем обновление или сохранение нового желания
class SaveWishEvent extends WishPageEvent {
  const SaveWishEvent();

  @override
  List<Object?> get props => [];
}

/// Обновить поля желания
class UpdateWishFieldsEvent extends WishPageEvent {
  final Wish wish;
  const UpdateWishFieldsEvent({required this.wish});

  @override
  List<Object?> get props => [wish];
}

/// Нажали на кнопку "Добавить новую ссылку": добавляет пустое поле для ввода новой ссылки
class AddNewLinkTextFieldEvent extends WishPageEvent {
  const AddNewLinkTextFieldEvent();

  @override
  List<Object?> get props => [];
}

/// Сохранение введенной ссылки
class SaveLinkEvent extends WishPageEvent {
  const SaveLinkEvent();

  @override
  List<Object?> get props => [];
}

/// Удалить ранее сохраненную ссылку
class RemoveLinkEvent extends WishPageEvent {
  final String url;
  const RemoveLinkEvent({required this.url});

  @override
  List<Object?> get props => [url];
}

/// Редактировать ранее сохраненную ссылку
class EditLinkEvent extends WishPageEvent {
  final String url;
  const EditLinkEvent({required this.url});

  @override
  List<Object?> get props => [url];
}

/// Активировать режим указания цены
class CheckPriceIndicationModeEvent extends WishPageEvent {
  final PriceIndicationMode mode;
  const CheckPriceIndicationModeEvent({required this.mode});

  @override
  List<Object?> get props => [mode];
}

/// Добавить выбранные изображения
class AddImagesEvent extends WishPageEvent {
  final List<Link> images;
  const AddImagesEvent({required this.images});

  @override
  List<Object?> get props => [images];
}

/// Убрать сообщение об ошибке
class RemoveErrorStateEvent extends WishPageEvent {
  const RemoveErrorStateEvent();

  @override
  List<Object?> get props => [];
}