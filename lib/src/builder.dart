import 'container.dart';
import 'tag.dart';


abstract class DiBuilder {

  void register<T>(Tag<T> tag, Factory<T> factory);

  void put<T>(Tag<T> tag, T instance);

  DiContainer build();
}
