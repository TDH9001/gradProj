import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;
import 'package:timeago/timeago.dart' as timeago;


class ScheduleItem {
  final String courseName;
  final String time;
  final String location;
  final String type;
  final String professor;
  final DateTime date;

  ScheduleItem({
    required this.courseName,
    required this.time,
    required this.location,
    required this.type,
    required this.professor,
    required this.date,
  });
}

class ContentItem {
  final String title;
  final String subtitle;
  final String category;
  final DateTime postedAt;
  final String? imageUrl;
  final String description;
  bool isSaved;

  ContentItem({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.postedAt,
    this.imageUrl,
    required this.description,
    this.isSaved = false,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  bool _showFullDate = false;
  late TabController _tabController;

  final Map<String, List<ScheduleItem>> _scheduleItems = {
    'Monday': [
      ScheduleItem(
        courseName: 'CyberSecurity',
        time: '9:00 AM - 11:00 AM',
        location: 'Room 302',
        type: 'Lecture',
        professor: 'Dr. Dieaa',
        date: DateTime(2023, 8, 21),
      ),
      ScheduleItem(
        courseName: 'Android Lab',
        time: '1:00 PM - 3:00 PM',
        location: 'Lab B',
        type: 'Lab',
        professor: 'Dr. Ehab',
        date: DateTime(2023, 8, 21),
      ),
    ],
    'Tuesday': [
      ScheduleItem(
        courseName: 'Database Systems',
        time: '10:00 AM - 12:00 PM',
        location: 'Room 415',
        type: 'Lecture',
        professor: 'Dr. Wael Zakaria',
        date: DateTime(2023, 8, 22),
      )
    ],
  };

  final List<ContentItem> _allItems = [
    ContentItem(
      title: "Final Project Deadline Extended",
      subtitle: "Dr.All-Academic Advisor",
      category: "Deadlines",
      postedAt: DateTime.now().subtract(const Duration(hours: 20)),
      imageUrl: 'https://picsum.photos/200/300',
      description: "The deadline for the final project has been extended by one week.",
    ),
    ContentItem(
      title: "Midterm Exam Schedule",
      subtitle: "Department Coordinator",
      category: "Events",
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
      description: "Midterm exams will begin next Monday. Check schedule for details.",
    ),
    ContentItem(
      title: "Research Paper Submission",
      subtitle: "Research Committee",
      category: "Course Updates",
      postedAt: DateTime.now().subtract(const Duration(minutes: 45)),
      imageUrl: 'https://picsum.photos/200/301',
      description: "Submission portal is now open. Submit papers by deadline.",
    ),
  ];

  List<ContentItem> get _filteredItems {
    return _allItems.where((item) {
      final matchesSearch = item.title.toLowerCase().contains(_searchController.text.toLowerCase());
      final matchesCategory = _selectedFilter == 'All' || 
          (_selectedFilter == 'Saved' ? item.isSaved : item.category == _selectedFilter);
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildScheduleView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _scheduleItems.length,
      itemBuilder: (context, index) {
        final day = _scheduleItems.keys.elementAt(index);
        final items = _scheduleItems[day]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(day, 
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
            ),
            ...items.map((item) => _buildScheduleItem(item)).toList(),
          ],
        );
      },
    );
  }

  Widget _buildScheduleItem(ScheduleItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.courseName, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Chip(
                  label: Text(item.type),
                  backgroundColor: _getTypeColor(item.type),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildScheduleDetail('Time', item.time),
            _buildScheduleDetail('Location', item.location),
            _buildScheduleDetail('Professor', item.professor),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'lecture': return Colors.blue;
      case 'lab': return Colors.green;
      case 'seminar': return Colors.orange;
      default: return Colors.grey;
    }
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
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Announcements'),
            Tab(text: 'Schedule'),
          ],
          labelColor: Colors.blue,
          indicatorColor: Colors.blue,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAnnouncements(),
          _scheduleItems.isEmpty 
              ? const Center(child: Text("No schedule available"))
              : _buildScheduleView(),
        ],
      ),
    );
  }

  Widget _buildAnnouncements() {
    return _filteredItems.isEmpty
        ? const Center(child: Text("No items found"))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) => _buildContentCard(item: _filteredItems[index]),
          );
  }

  Widget _buildContentCard({required ContentItem item}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                Text(item.title, 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(
                    item.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: item.isSaved ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () => setState(() => item.isSaved = !item.isSaved),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.subtitle, 
                  style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                GestureDetector(
                  onTap: () => setState(() => _showFullDate = !_showFullDate),
                  child: Text(
                    _showFullDate
                        ? '${item.postedAt.day}/${item.postedAt.month}/${item.postedAt.year}'
                        : timeago.format(item.postedAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.description.length > 100
                  ? '${item.description.substring(0, 100)}...'
                  : item.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            if (item.description.length > 100)
              TextButton(
                onPressed: () => _showFullDescription(context, item.description),
                child: const Text('Read More', style: TextStyle(color: Colors.blue)),
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

  void _showFilterMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
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
      ),
    );
  }

  Widget _buildFilterOption(String title, BuildContext context) {
    return ListTile(
      title: Text(title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: _selectedFilter == title ? FontWeight.bold : FontWeight.normal,
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

  void _showFullDescription(BuildContext context, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Full Announcement'),
        content: SingleChildScrollView(child: Text(description)),
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
