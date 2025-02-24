import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ContentItem {
  final String title;
  final String subtitle;
  final String category;
  final DateTime postedAt;
  final String? imageUrl;
  final String description;
  bool isSaved; // Non-nullable with default value

  ContentItem({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.postedAt,
    this.imageUrl,
    required this.description,
    this.isSaved = false, // Default value to avoid null
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  bool _showFullDate = false;

  final List<ContentItem> _allItems = [
    ContentItem(
      title: "Final Project Deadline Extended",
      subtitle: "Dr.All-Academic Advisor",
      category: "Deadlines",
      postedAt: DateTime.now().subtract(const Duration(hours: 20)),
      imageUrl: 'https://picsum.photos/200/300',
      description: "The deadline for the final project has been extended by one week. Please ensure all submissions are made by the new deadline.",
    ),
    ContentItem(
      title: "Midterm Exam Schedule",
      subtitle: "Department Coordinator",
      category: "Events",
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
      description: "The midterm exams will begin next Monday. Please check the schedule for your specific exam dates and times.",
    ),
    ContentItem(
      title: "Research Paper Submission",
      subtitle: "Research Committee",
      category: "Course Updates",
      postedAt: DateTime.now().subtract(const Duration(minutes: 45)),
      imageUrl: 'https://picsum.photos/200/301',
      description: "The research paper submission portal is now open. Please submit your papers by the deadline to avoid any penalties.",
    ),
  ];

  List<ContentItem> get _filteredItems {
    return _allItems.where((item) {
      final matchesSearch = item.title
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());
      final matchesCategory =
          _selectedFilter == 'All' || item.category == _selectedFilter;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _showFilterMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterOption('All', context),
              _buildFilterOption('Deadlines', context),
              _buildFilterOption('Events', context),
              _buildFilterOption('Course Updates', context),
              _buildFilterOption('Saved', context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String title, BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: _selectedFilter == title
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      trailing: _selectedFilter == title
          ? const Icon(Icons.check, color: Colors.blue)
          : null,
      onTap: () {
        setState(() => _selectedFilter = title);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                    hintText: 'Search...',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.filter_list, color: Colors.grey[700]),
              onPressed: () => _showFilterMenu(context),
            ),
          ],
        ),
      ),
      body: _filteredItems.isEmpty
          ? const Center(child: Text("No items found"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) => _buildContentCard(
                item: _filteredItems[index],
              ),
            ),
    );
  }

  Widget _buildContentCard({required ContentItem item}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.imageUrl != null)
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.imageUrl!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    item.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: item.isSaved ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      item.isSaved = !item.isSaved;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showFullDate = !_showFullDate;
                    });
                  },
                  child: Text(
                    _showFullDate
                        ? '${item.postedAt.day}/${item.postedAt.month}/${item.postedAt.year}'
                        : timeago.format(item.postedAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.description.length > 100
                  ? '${item.description.substring(0, 100)}...'
                  : item.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            if (item.description.length > 100)
              TextButton(
                onPressed: () {
                  _showFullDescription(context, item.description);
                },
                child: const Text(
                  'Read More',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            const SizedBox(height: 8),
            Chip(
              label: Text(item.category),
              backgroundColor: Colors.blue[50],
              labelStyle: const TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullDescription(BuildContext context, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Full Announcement'),
        content: SingleChildScrollView(
          child: Text(description),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}