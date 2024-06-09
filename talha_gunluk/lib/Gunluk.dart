import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      title: 'Günlük Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final Map<String, String> kullanicilar = {
    'musa': '123',
    'talha': '258',

  };

  @override
  Widget build(BuildContext context) {
    TextEditingController kullanici_ad = TextEditingController();
    TextEditingController kullanici_sifre = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Giriş Yap'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: kullanici_ad,
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: kullanici_sifre,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String username = kullanici_ad.text;
                  String password = kullanici_sifre.text;
                  if (kullanicilar.containsKey(username) && kullanicilar[username] == password) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } else {
                    // Hatalı giriş
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Hata'),
                          content: Text('Geçersiz kullanıcı adı veya şifre'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Kapat'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Giriş Yap'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController baslik = TextEditingController();
  final TextEditingController icerik = TextEditingController();
  final List<Entry> entries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ana Sayfa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: baslik,
              decoration: InputDecoration(
                labelText: 'Başlık',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: icerik,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'İçerik',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String title = baslik.text;
                String content = icerik.text;
                DateTime now = DateTime.now();
                String date = "${now.day}/${now.month}/${now.year}"; // Şu anki tarih
                setState(() {
                  entries.add(Entry(title: title, content: content, date: date));
                });
                baslik.clear();
                icerik.clear();
              },
              child: Text('Kaydet'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('${entries[index].title} - ${entries[index].date}'),
                    subtitle: Text(entries[index].content),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editEntry(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteEntry(index);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editEntry(int index) {
    Entry entry = entries[index];
    baslik.text = entry.title;
    icerik.text = entry.content;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Giriş Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: baslik,
                decoration: InputDecoration(
                  labelText: 'Başlık',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: icerik,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'İçerik',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                String title = baslik.text;
                String content = icerik.text;
                setState(() {
                  entries[index] = Entry(title: title, content: content, date: entry.date);
                });
                baslik.clear();
                icerik.clear();
                Navigator.pop(context);
              },
              child: Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEntry(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Girişi Sil'),
          content: Text('Bu girişi silmek istiyor musunuz?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  entries.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: Text('Evet'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Hayır'),
            ),
          ],
        );
      },
    );
  }
}

class Entry {
  final String title;
  final String content;
  final String date;

  Entry({required this.title, required this.content, required this.date});
}
