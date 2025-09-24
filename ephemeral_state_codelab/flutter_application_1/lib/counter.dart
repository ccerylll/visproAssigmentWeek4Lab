import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_package_1/global_state.dart';

class LocalCounterWidget extends StatefulWidget {
  @override
  _LocalCounterWidgetState createState() => _LocalCounterWidgetState();
}

class _LocalCounterWidgetState extends State<LocalCounterWidget> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Local Counter: $_counter', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: _counter > 0 ? () => setState(() => _counter--) : null,
              icon: Icon(Icons.remove),
              label: Text('Decrement'),
            ),
            OutlinedButton.icon(
              onPressed: _counter > 0 ? () => setState(() => _counter = 0) : null,
              icon: Icon(Icons.refresh),
              label: Text('Reset'),
            ),
            ElevatedButton.icon(
              onPressed: () => setState(() => _counter++),
              icon: Icon(Icons.add),
              label: Text('Increment'),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          'This uses local state (StatefulWidget)',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}

class CounterListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalState>(
      builder: (context, globalState, child) {
        if (globalState.counters.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline, size: 80, color: Colors.grey.shade400),
                SizedBox(height: 24),
                Text('Belum ada counter', style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 12),
                Text('Tekan tombol + untuk menambahkan counter'),
              ],
            ),
          );
        }

        return ReorderableListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: globalState.counters.length,
          onReorder: globalState.reorderCounters,
          itemBuilder: (context, index) {
            final counter = globalState.counters[index];
            return GlobalCounterItem(key: ValueKey(counter.id), counter: counter);
          },
        );
      },
    );
  }
}

/// Individual counter item in the global list - implementasi requirements Part 2 & 3
class GlobalCounterItem extends StatefulWidget {
  final CounterModel counter;
  const GlobalCounterItem({Key? key, required this.counter}) : super(key: key);

  @override
  _GlobalCounterItemState createState() => _GlobalCounterItemState();
}

class _GlobalCounterItemState extends State<GlobalCounterItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _scale = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animate() => _controller.forward().then((_) => _controller.reverse());

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalState>(
      builder: (context, globalState, child) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          color: widget.counter.color.withOpacity(0.08),
          child: ListTile(
            leading: AnimatedBuilder(
              animation: _scale,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scale.value,
                  child: CircleAvatar(
                    backgroundColor: widget.counter.color,
                    child: Text(
                      widget.counter.value.toString(),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
            title: Text(widget.counter.label, style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('Value: ${widget.counter.value}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: widget.counter.value > 0 ? () {
                    globalState.decrementCounter(widget.counter.id);
                    _animate();
                  } : null,
                  icon: Icon(Icons.remove_circle_outline),
                  color: widget.counter.color,
                ),
                IconButton(
                  onPressed: () {
                    globalState.incrementCounter(widget.counter.id);
                    _animate();
                  },
                  icon: Icon(Icons.add_circle_outline),
                  color: widget.counter.color,
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleMenuAction(value, globalState),
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'reset', child: Text('Reset')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                  child: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleMenuAction(String value, GlobalState globalState) {
    switch (value) {
      case 'edit':
        _showEditDialog(context, globalState, widget.counter);
        break;
      case 'reset':
        globalState.updateCounterValue(widget.counter.id, 0);
        _animate();
        break;
      case 'delete':
        _showDeleteDialog(globalState);
        break;
    }
  }

  void _showDeleteDialog(GlobalState globalState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Counter'),
        content: Text('Yakin ingin menghapus "${widget.counter.label}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Batal')),
          ElevatedButton(
            onPressed: () {
              globalState.removeCounter(widget.counter.id);
              Navigator.pop(context);
            },
            child: Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, GlobalState globalState, CounterModel counter) {
    final controller = TextEditingController(text: counter.label);
    Color selectedColor = counter.color;
    final colors = [
      const Color.fromARGB(255, 138, 169, 194), const Color.fromARGB(255, 152, 199, 154), const Color.fromARGB(255, 214, 198, 174), const Color.fromARGB(255, 221, 179, 176),
      const Color.fromARGB(255, 163, 125, 170), Colors.brown, const Color.fromARGB(255, 160, 192, 189), const Color.fromARGB(255, 177, 153, 161)
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Edit Counter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(labelText: 'Label', border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: colors.map((color) => GestureDetector(
                  onTap: () => setState(() => selectedColor = color),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: selectedColor == color ? Border.all(width: 3) : null,
                    ),
                  ),
                )).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Batal')),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  globalState.updateCounterLabel(counter.id, controller.text);
                  globalState.updateCounterColor(counter.id, selectedColor);
                }
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
