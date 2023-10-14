import '../storage/storage.dart';

Storage? globalStorage;

void registerGlobalStorage(Storage storage) {
  globalStorage = storage;
}
