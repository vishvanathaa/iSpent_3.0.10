abstract class HomeContract {
  void screenUpdate();
}
class HomePresenter {
  late HomeContract _view;
  updateScreen() {
    _view.screenUpdate();
  }
}
