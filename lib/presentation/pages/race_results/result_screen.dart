import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/result_provider.dart';
import '../../../utils/formatters.dart'; // Import the formatters utility
import '../../../data/models/result.dart';
import '../../widgets/race_navigation_bar.dart';
import '../../../services/navigation_service.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int selectedCategory = 0;
  final List<String> categories = ['All', 'Running', 'Swimming', 'Cycling'];
  TextEditingController searchController = TextEditingController();
  Timer? _refreshTimer;
  int _selectedIndex = 4; // Results tab index (now last)

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });

    // Load results when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ResultProvider>(context, listen: false).loadResults();
    });

    // Set up polling for updates
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        Provider.of<ResultProvider>(context, listen: false).loadResults();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _onNavBarTap(int index) {
    final route = NavigationService.getRouteForIndex(index);
    if (route != null && ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Title
            const Text(
              'Race Results',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 24),

            // Category filter
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: selectedCategory == index
                            ? Colors.grey[200]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: selectedCategory == index
                              ? Colors.black
                              : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[500]),
                      onPressed: () {
                        searchController.clear();
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Table header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      'Rank',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Duration',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Text(
                      'Bib',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            const Divider(height: 1),

            // Results list
            Expanded(
              child: Consumer<ResultProvider>(
                builder: (context, resultProvider, child) {
                  if (resultProvider.isLoading &&
                      resultProvider.results.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (resultProvider.error != null &&
                      resultProvider.results.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            resultProvider.error!,
                            style: TextStyle(color: Colors.red[700]),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => resultProvider.loadResults(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Only filter the displayed results, don't modify participant data
                  final filteredResults = resultProvider.getFilteredResults(
                    searchController.text,
                    categories[selectedCategory],
                  );

                  if (filteredResults.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'No results found for "${categories[selectedCategory]}" category',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filteredResults.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final result = filteredResults[index];
                      return _buildResultItem(
                          result, categories[selectedCategory]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: RaceNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
    );
  }

  Widget _buildResultItem(Result r, String category) {
    String timeText = '-';
    Duration? durationToFormat;

    switch (category) {
      case 'Running':
        durationToFormat = r.runTime;
        break;
      case 'Swimming':
        durationToFormat = r.swimTime;
        break;
      case 'Cycling':
        durationToFormat = r.cycleTime;
        break;
      default:
        durationToFormat = r.totalTime;
    }

    if (durationToFormat != null) {
      timeText = formatRaceTime(durationToFormat);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          // Rank column
          SizedBox(
            width: 60,
            child: Text(
              r.rank != null ? r.rank.toString() : '-',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Name column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Time column
          SizedBox(
            width: 100,
            child: Text(
              timeText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Bib column (for all categories)
          SizedBox(
            width: 60,
            child: Text(
              r.bib.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
