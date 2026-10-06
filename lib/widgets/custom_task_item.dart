import 'package:flutter/material.dart';
import 'package:to_do_app/models/task_model.dart';

class CustomTaskItem extends StatelessWidget {
  final TaskModel task;
  final bool showDescription;
  final VoidCallback onTitleTap;
  final VoidCallback onStatusChanged;
  final VoidCallback onDelete;

  const CustomTaskItem({
    super.key,
    required this.task,
    required this.showDescription,
    required this.onTitleTap,
    required this.onStatusChanged,
    required this.onDelete,
  });

  Color getTitleColor(BuildContext context) {
    if (task.status == 'complete') {
      return Colors.grey;
    }

    return Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
  }

  TextDecoration getTitleDecoration() {
    if (task.status == 'complete') {
      return TextDecoration.lineThrough;
    }

    return TextDecoration.none;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: task.status == 'complete',
            onChanged: (value) {
              onStatusChanged();
            },
            activeColor: const Color(0xff15B86C),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: onTitleTap,
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: getTitleColor(context),
                      decoration: getTitleDecoration(),
                    ),
                  ),
                ),

                if (task.isHighPriority)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'High Priority',
                      style: TextStyle(
                        color: task.status == 'complete'
                            ? Colors.grey
                            : Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),

                if (showDescription)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      task.description,
                      style: TextStyle(
                        color: task.status == 'complete' ? Colors.grey : null,
                        decoration: task.status == 'complete'
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}
