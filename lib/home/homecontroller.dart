import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:njust_library/api_service.dart';

class HomeController extends GetxController {
  bool _isLoading = true, _hasError = false;

  List _topCirculation = [], _topBooks = [], _topTenBooks = [];

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  List get topCirculation => _topCirculation;
  List get topBooks => _topBooks;
  List get topTenBooks => _topTenBooks;

  @override
  void onInit() {
    super.onInit();
    getDashBoard(true);
  }

  setIsLoading(bool value) {
    _isLoading = value;
    update();
  }

  setHasError(bool value) {
    _hasError = value;
    update();
  }

  setTopTenBooks(value) {
    _topTenBooks = value;
    update();
  }

  setTopCirculation(value) {
    _topCirculation = value;
    update();
  }

  setTopBooks(value) {
    _topBooks = value;
    update();
  }

  getDashBoard(bool isInit) async {
    if (!isInit) setIsLoading(true);
    setHasError(false);
    try {
      await APIService.getDashboard().then((value) {
        setIsLoading(false);
        setTopBooks(value['topBooks']);
        setTopCirculation(value['circulatory']);
        setTopTenBooks(value['topTen']);
      }).timeout(Duration(seconds: 10));
    } catch (error) {
      print(error);
      setHasError(true);
      setIsLoading(false);
    }
  }
}
