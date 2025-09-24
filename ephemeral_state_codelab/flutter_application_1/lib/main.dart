import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_package_1/global_state.dart';
import 'counter.dart';

/// Entry point aplikasi
void main() => runApp(MyAdvancedCounterApp());

/// Main application widget yang mengatur providers dan routing
class MyAdvancedCounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Global state provider untuk mengelola counter list
        ChangeNotifierProvider(create: (_) => GlobalState()),
        // App state provider untuk mengelola app-level settings
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: appState.appTitle,
            theme: appState.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: CounterListScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

/// Main screen yang menampilkan demo aplikasi counter
class CounterListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AppState>(
          builder: (context, appState, child) {
            return Text(appState.appTitle);
          },
        ),
        actions: [
          // Toggle dark mode button
          Consumer<AppState>(
            builder: (context, appState, child) {
              return IconButton(
                icon: Icon(appState.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: () => appState.toggleDarkMode(),
                tooltip: 'Toggle Theme',
              );
            },
          ),
          // Menu untuk reset dan clear counters
          Consumer<GlobalState>(
            builder: (context, globalState, child) {
              return PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'clear') {
                    globalState.clearAllCounters();
                  } else if (value == 'reset') {
                    globalState.resetAllCounters();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'reset',
                    child: ListTile(
                      leading: Icon(Icons.refresh),
                      title: Text('Reset All Counters'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'clear',
                    child: ListTile(
                      leading: Icon(Icons.clear_all),
                      title: Text('Clear All Counters'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
                tooltip: 'More Options',
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Part 1: Local State Management Demo
          Card(
            margin: EdgeInsets.all(16),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Part 1: Local State Management',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Counter menggunakan StatefulWidget dengan setState()',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  LocalCounterWidget(),
                ],
              ),
            ),
          ),
          // Part 2: Global State Management - List of Counters
          Expanded(
            child: Card(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
              elevation: 4,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Part 2: Global State Management',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Mengelola multiple counters menggunakan Provider & ChangeNotifier',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Consumer<GlobalState>(
                              builder: (context, globalState, child) {
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    'Total: ${globalState.counterCount}',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1),
                  Expanded(child: CounterListWidget()),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer<GlobalState>(
        builder: (context, globalState, child) {
          return FloatingActionButton(
            onPressed: () => globalState.addCounter(),
            child: Icon(Icons.add),
            tooltip: 'Add New Counter',
          );
        },
      ),
    );
  }
}