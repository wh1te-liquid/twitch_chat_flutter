part of 'home_screen_bloc.dart';

@immutable
abstract class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState {}

class HomeScreenLoading extends HomeScreenState {}

class HomeScreenLoaded extends HomeScreenState {
  final List<StreamTwitch> _items;
  final String _nextUrl;

  HomeScreenLoaded({
    required List<StreamTwitch> items,
    required String nextUrl,
  })  : _items = items,
        _nextUrl = nextUrl;

  String get nextUrl => _nextUrl;

  List<StreamTwitch> get items => _items;
}
