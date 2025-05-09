import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ConsumerWidget, ProviderScope, WidgetRef;
import 'package:to_do_list/providers/all_providers.dart' show currentTodoProvider, filteredTodoList, todoListProvider;
import 'package:to_do_list/widgets/title_widget.dart' show TitleWidget;
import 'package:to_do_list/widgets/todo_list_item_widget.dart' show TodoListItemWidget;
import 'package:to_do_list/widgets/toolbar_widget.dart' show ToolBarWidget;

class TodoApp extends ConsumerWidget {
  TodoApp({Key? key}) : super(key: key);

  final newTodoController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var allTodos = ref.watch(filteredTodoList);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          const TitleWidget(),
          TextField(
            controller: newTodoController,
            decoration:
                const InputDecoration(labelText: 'What will you do today?'),
            onSubmitted: (newTodo) {
              ref.read(todoListProvider.notifier).addTodo(newTodo);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ToolBarWidget(),
          allTodos.length == 0
              ? const Center(
                  child: Text('There are no tasks under these conditions'))
              : const SizedBox(),
          for (var i = 0; i < allTodos.length; i++)
            Dismissible(
              key: ValueKey(allTodos[i].id),
              onDismissed: (_) {
                ref.read(todoListProvider.notifier).remove(allTodos[i]);
              },
              child: ProviderScope(
                overrides: [
                  currentTodoProvider.overrideWithValue(allTodos[i]),
                ],
                child: const TodoListItemWidget(),
              ),
            ),
         /*  ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.orange),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const FutureProviderExample(),
              ));
            },
            child: const Text('Future Provider Example'),
          ), */
        ],
      ),
    );
  }
}
