import 'tag.dart';


typedef T Factory<T>(DiContainer container, Object arguments);

typedef T Creator<T>([Object argument]);


abstract class DiContainer {

  T resolve<T>(Tag<T> tag, [Object arguments = null]);

  Creator<T> creator<T>(Tag<T> tag);
}
