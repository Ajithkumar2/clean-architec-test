# State Management Rules

- **Always use BLoC style**: Always use full `Bloc<Event, State>` with dedicated Event and State classes extending `Equatable`. Do not use `Cubit` in this project, even for local UI component state toggles (such as card edit/view mode toggles).
- **Event-Driven**: All state mutations must be driven by dispatching strongly typed events.
