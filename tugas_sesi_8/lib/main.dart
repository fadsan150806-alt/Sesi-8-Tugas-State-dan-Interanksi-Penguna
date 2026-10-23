
import 'package:flutter/material.dart';

void main() {
  runApp(const CampusConnectApp());
}

const Color primaryColor = Color(0xFF3157C8);
const Color backgroundColor = Color(0xFFF5F7FC);
const Color textColor = Color(0xFF17264A);

class CampusConnectApp extends StatelessWidget {
  const CampusConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
        ),
      ),
      home: const CampusHomePage(),
    );
  }
}

class CampusTask {
  CampusTask({
    required this.title,
    required this.subject,
    required this.deadline,
    this.isDone = false,
  });

  String title;
  String subject;
  String deadline;
  bool isDone;
}

class CampusAnnouncement {
  CampusAnnouncement({
    required this.title,
    required this.description,
    required this.date,
    this.isRead = false,
  });

  String title;
  String description;
  String date;
  bool isRead;
}

class CampusHomePage extends StatefulWidget {
  const CampusHomePage({super.key});

  @override
  State<CampusHomePage> createState() => _CampusHomePageState();
}

class _CampusHomePageState extends State<CampusHomePage> {
  int selectedIndex = 0;
  String selectedDay = 'Senin';

  final List<CampusTask> tasks = [
    CampusTask(
      title: 'Menyelesaikan praktikum Flutter',
      subject: 'Pemrograman Mobile',
      deadline: 'Hari ini',
    ),
    CampusTask(
      title: 'Membuat laporan praktikum',
      subject: 'Praktikum Pemrograman',
      deadline: 'Besok',
    ),
    CampusTask(
      title: 'Mempelajari materi State',
      subject: 'Pemrograman Mobile',
      deadline: '23 Okt 2026',
      isDone: true,
    ),
  ];

  final List<CampusAnnouncement> announcements = [
    CampusAnnouncement(
      title: 'Pengumpulan Tugas Flutter',
      description:
          'Mahasiswa diminta mengumpulkan hasil aplikasi '
          'beserta link repository GitHub.',
      date: '20 Okt 2026',
    ),
    CampusAnnouncement(
      title: 'Informasi Perkuliahan',
      description:
          'Pastikan jadwal dan ruang perkuliahan diperiksa '
          'sebelum kegiatan dimulai.',
      date: '20 Okt 2026',
    ),
    CampusAnnouncement(
      title: 'Pengingat Praktikum',
      description:
          'Siapkan laptop dan pastikan perangkat pengembangan '
          'sudah dapat digunakan.',
      date: '19 Okt 2026',
    ),
  ];

  final Map<String, List<Map<String, String>>> schedule = {
    'Senin': [
      {
        'time': '08.00 - 09.40',
        'subject': 'Pemrograman Mobile',
        'room': 'Lab Komputer 1',
      },
      {
        'time': '10.00 - 11.40',
        'subject': 'Basis Data',
        'room': 'Ruang 204',
      },
    ],
    'Selasa': [
      {
        'time': '09.00 - 10.40',
        'subject': 'Struktur Data',
        'room': 'Ruang 202',
      },
      {
        'time': '13.00 - 14.40',
        'subject': 'Praktikum Pemrograman',
        'room': 'Lab Komputer 2',
      },
    ],
    'Rabu': [
      {
        'time': '08.00 - 09.40',
        'subject': 'Teori Graf',
        'room': 'Ruang 203',
      },
    ],
    'Kamis': [
      {
        'time': '10.00 - 11.40',
        'subject': 'Rekayasa Perangkat Lunak',
        'room': 'Ruang 201',
      },
    ],
    'Jumat': [
      {
        'time': '08.00 - 09.40',
        'subject': 'Sistem Operasi',
        'room': 'Ruang 205',
      },
    ],
  };

  int get completedTasks =>
      tasks.where((task) => task.isDone).length;

  int get unreadAnnouncements =>
      announcements.where((item) => !item.isRead).length;

  final List<String> pageTitles = [
    'CampusConnect',
    'Jadwal Kuliah',
    'Daftar Tugas',
    'Informasi Kampus',
  ];

  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void toggleTask(CampusTask task, bool? value) {
    setState(() {
      task.isDone = value ?? false;
    });
  }

  Future<void> addTaskDialog() async {
    final titleController = TextEditingController();
    final subjectController = TextEditingController();

    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Tambah Tugas'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Nama tugas',
                      hintText: 'Contoh: Membuat laporan',
                      prefixIcon: Icon(Icons.assignment_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Mata kuliah',
                      hintText: 'Contoh: Pemrograman Mobile',
                      prefixIcon: Icon(Icons.book_outlined),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  final subject = subjectController.text.trim();

                  if (title.isEmpty || subject.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Nama tugas dan mata kuliah wajib diisi.',
                        ),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    tasks.insert(
                      0,
                      CampusTask(
                        title: title,
                        subject: subject,
                        deadline: 'Belum ditentukan',
                      ),
                    );
                  });

                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tugas berhasil ditambahkan.'),
                    ),
                  );
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      );
    } finally {
      titleController.dispose();
      subjectController.dispose();
    }
  }

  void markAnnouncementRead(CampusAnnouncement announcement) {
    setState(() {
      announcement.isRead = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pengumuman ditandai sudah dibaca.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildHomePage(),
      buildSchedulePage(),
      buildTasksPage(),
      buildAnnouncementsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitles[selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (selectedIndex == 0)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundColor: Color(0xFFE0E8FF),
                child: Icon(Icons.person, color: primaryColor),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
      ),
      floatingActionButton: selectedIndex == 2
          ? FloatingActionButton.extended(
              onPressed: addTaskDialog,
              icon: const Icon(Icons.add),
              label: const Text('Tambah Tugas'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: changePage,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Jadwal',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Tugas',
          ),
          NavigationDestination(
            icon: Icon(Icons.campaign_outlined),
            selectedIcon: Icon(Icons.campaign),
            label: 'Info',
          ),
        ],
      ),
    );
  }

  Widget buildHomePage() {
    final progress =
        tasks.isEmpty ? 0.0 : completedTasks / tasks.length;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [primaryColor, Color(0xFF6888EA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, Mahasiswa! 👋',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Selamat datang di CampusConnect.',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.school, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Portal Aktivitas Kampus',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Ringkasan Aktivitas',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: summaryCard(
                icon: Icons.assignment_outlined,
                label: 'Total Tugas',
                value: '${tasks.length}',
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: summaryCard(
                icon: Icons.check_circle_outline,
                label: 'Selesai',
                value: '$completedTasks',
                color: const Color(0xFF16875B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        summaryCard(
          icon: Icons.notifications_active_outlined,
          label: 'Pengumuman Belum Dibaca',
          value: '$unreadAnnouncements',
          color: const Color(0xFFDF8A16),
        ),
        const SizedBox(height: 24),
        sectionHeader(
          'Progres Penyelesaian Tugas',
          'Lihat tugas',
          () => changePage(2),
        ),
        const SizedBox(height: 12),
        Card(
          color: Colors.white,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$completedTasks dari ${tasks.length} tugas selesai',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 9,
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: const Color(0xFFE5EAF5),
                ),
                const SizedBox(height: 8),
                Text('${(progress * 100).round()}% terselesaikan'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        sectionHeader(
          'Jadwal Kuliah',
          'Lihat jadwal',
          () => changePage(1),
        ),
        const SizedBox(height: 12),
        ...(schedule['Senin'] ?? []).map(scheduleCard),
        const SizedBox(height: 24),
        sectionHeader(
          'Pengumuman Terbaru',
          'Lihat semua',
          () => changePage(3),
        ),
        const SizedBox(height: 12),
        ...announcements.take(2).map(announcementCard),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget summaryCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 14),
            Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget sectionHeader(
    String title,
    String action,
    VoidCallback onTap,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        TextButton(onPressed: onTap, child: Text(action)),
      ],
    );
  }

  Widget buildSchedulePage() {
    final dailySchedule = schedule[selectedDay] ?? [];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Pilih Hari Perkuliahan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: schedule.keys.map((day) {
            return ChoiceChip(
              label: Text(day),
              selected: selectedDay == day,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    selectedDay = day;
                  });
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Text(
          'Jadwal hari $selectedDay',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (dailySchedule.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('Tidak ada jadwal kuliah.')),
            ),
          )
        else
          ...dailySchedule.map(scheduleCard),
        const SizedBox(height: 16),
        const Text(
          'Catatan: Jadwal ini merupakan data contoh. '
          'Sesuaikan dengan jadwal kuliah sebenarnya.',
          style: TextStyle(color: Colors.black54, fontSize: 12),
        ),
      ],
    );
  }

  Widget scheduleCard(Map<String, String> item) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 5,
              height: 78,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['time'] ?? '',
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['subject'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item['room'] ?? '',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTasksPage() {
    final progress =
        tasks.isEmpty ? 0.0 : completedTasks / tasks.length;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Kelola tugas perkuliahanmu.',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 18),
        Card(
          color: Colors.white,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.checklist,
                      size: 34,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        '$completedTasks dari ${tasks.length} tugas selesai',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text('${(progress * 100).round()}%'),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: progress),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        if (tasks.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: Text('Belum ada tugas. Tambahkan tugas baru.'),
            ),
          ),
        ...tasks.map((task) {
          return Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 10),
            child: CheckboxListTile(
              value: task.isDone,
              onChanged: (value) => toggleTask(task, value),
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                task.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  decoration: task.isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: task.isDone ? Colors.grey : Colors.black87,
                ),
              ),
              subtitle: Text(
                '${task.subject}\nDeadline: ${task.deadline}',
              ),
              isThreeLine: true,
              secondary: Icon(
                task.isDone
                    ? Icons.check_circle
                    : Icons.assignment_outlined,
                color: task.isDone ? Colors.green : primaryColor,
              ),
            ),
          );
        }),
        const SizedBox(height: 90),
      ],
    );
  }

  Widget buildAnnouncementsPage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          color: const Color(0xFFE5ECFF),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.notifications_active_outlined,
                  color: primaryColor,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informasi Kampus',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('$unreadAnnouncements pengumuman belum dibaca'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        ...announcements.map(announcementCard),
      ],
    );
  }

  Widget announcementCard(CampusAnnouncement announcement) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: announcement.isRead
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFE0E8FF),
                  child: Icon(
                    announcement.isRead
                        ? Icons.mark_email_read_outlined
                        : Icons.campaign_outlined,
                    color: announcement.isRead ? Colors.green : primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        announcement.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        announcement.date,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!announcement.isRead)
                  const Icon(
                    Icons.circle,
                    size: 10,
                    color: primaryColor,
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Text(announcement.description),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: announcement.isRead
                  ? const Chip(
                      avatar: Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.green,
                      ),
                      label: Text('Sudah dibaca'),
                    )
                  : TextButton.icon(
                      onPressed: () => markAnnouncementRead(announcement),
                      icon: const Icon(Icons.done),
                      label: const Text('Tandai sudah dibaca'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
