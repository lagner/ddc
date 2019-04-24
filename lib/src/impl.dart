import 'dart:core';
import 'dart:collection';

import 'container.dart';
import 'builder.dart';
import 'tag.dart';


class _Impl implements DiBuilder, DiContainer {
  final _storage = HashMap<Tag, dynamic>();

  // Builder -------------------------------------------------------

  @override
  void register<T>(Tag<T> tag, Factory<T> factory) {
    assert(!_storage.containsKey(tag), "${tag.toString()} was already registered");

    if (tag.singleton) {
      _storage[tag] = () {
        T ptr;
        return (DiContainer dc, Object argument) {
          if (ptr == null) {
            ptr = factory(dc, argument);
          }
          return ptr;
        };
      }();
    } else {
      _storage[tag] = factory;
    }
  }

  @override
  void put<T>(Tag<T> tag, T instance) {
    assert(tag.singleton, 'if you put an instance, you should clearly understand that it is singleton');
    assert(!_storage.containsKey(tag), "${tag.toString()} was already registered");

    _storage[tag] = (DiContainer, Object) => instance;
  }

  @override
  DiContainer build() {
    return this;
  }

  // Container -------------------------------------------------------

  @override
  T resolve<T>(Tag<T> tag, [Object arguments = null]) {
    final factory = _storage[tag];
    if (null == factory) {
      throw Exception("there is no factory to create ${tag.toString()}");
    }
    return factory(this, arguments);
  }

  @override
  Creator<T> creator<T>(Tag<T> tag) {
    final factory = _storage[tag];
    if (null == factory) {
      throw Exception("there is no factory to create ${tag.toString()}");
    }

    T closure([Object object]) {
      return factory(this, object);
    }
    return closure;
  }
}

DiBuilder getDiBuilder() {
  return _Impl();
}
