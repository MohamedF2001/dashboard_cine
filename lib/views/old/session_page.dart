import 'package:dashbord_cine/views/old/create_seesion_page.dart';
import 'package:dashbord_cine/views/modern_create_session_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/session_service.dart';
import '../../models/session_model.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  _SessionsPageState createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  final SessionService _sessionService = SessionService();
  List<Session> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
    //testDateFormatting();
    // Initialise le formatage des dates en français, puis démarre l'app
    /*initializeDateFormatting('fr', '')
        .then((_) {
          print("✅ Formatage des dates initialisé avec succès !");

          // Test : Affiche une date formatée pour vérifier que ça fonctionne
          testDateFormatting();
        })
        .catchError((error) {
          print("❌ Erreur lors de l'initialisation : $error");
        });*/
  }

  /// Teste que le formatage des dates fonctionne bien en français
  void testDateFormatting() {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE dd MMMM yyyy', 'fr').format(now);
    print("Date de test : $formattedDate"); // Ex: "lundi 14 octobre 2024"
  }

  Future<void> _loadSessions() async {
    setState(() => _isLoading = true);
    try {
      final response = await _sessionService.getAllSeances();
      setState(
        () => _sessions = response.seances,
      ); // Accédez à la propriété seances
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load sessions: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteSession(String sessionId) async {
    try {
      await _sessionService.deleteSeance(sessionId);
      _loadSessions(); // Recharger la liste après suppression
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Session deleted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete session: $e')));
    }
  }

  void _confirmDelete(String sessionId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Confirm Delete'),
            content: Text('Are you sure you want to delete this session?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteSession(sessionId);
                },
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0.5),
        centerTitle: true,
        title: const Text(
          'Séances de films',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadSessions,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black12,
        foregroundColor: Colors.white70,
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateSessionPagee()),
          );
          if (result == true) _loadSessions();
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.5), // Noir très sombre
              Colors.black.withOpacity(0.6), // Noir un peu plus clair
              Colors.black.withOpacity(0.7), // Blanc très léger
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child:
            _isLoading
                ? Center(
                  child: CircularProgressIndicator(color: Colors.black12),
                )
                : _sessions.isEmpty
                ? Center(child: Text('Pas de sessions trouvées'))
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: _sessions.length,
                    itemBuilder: (context, index) {
                      final session = _sessions[index];
                      return InkWell(
                        onTap: () {
                        },
                        child: Card(
                          elevation: 0.5,
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                // Image container with fixed size
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    width: 100,
                                    height: 140,
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w500${session.imgFilm}',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (_, __, ___) => Container(
                                            color: Colors.grey[300],
                                            child: Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                size: 40,
                                              ),
                                            ),
                                          ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        session.film,
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      _buildInfoRow(
                                        Icons.access_time,
                                        session.formattedTime.toString(),
                                      ),
                                      _buildInfoRow(
                                        Icons.calendar_today,
                                        session.formattedDate,
                                      ),
                                      _buildInfoRow(
                                        Icons.movie_filter,
                                        'Type: ${session.typeSeance.toUpperCase()}',
                                      ),
                                      _buildInfoRow(
                                        Icons.room,
                                        'Salle: ${session.salle}',
                                      ),
                                      _buildInfoRow(
                                        Icons.event_seat,
                                        'Places disponible: ${session.placesDisponibles}',
                                      ),
                                      _buildInfoRow(
                                        Icons.money,
                                        'Prix: ${session.prix} F CFA',
                                      ),
                                    ],
                                  ),
                                ),
                                // Menu button
                                PopupMenuButton(
                                  iconColor: Colors.white,
                                  itemBuilder:
                                      (context) => [
                                        PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit, size: 20),
                                              SizedBox(width: 8),
                                              Text('Edit'),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                size: 20,
                                                color: Colors.red,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _editSession(session);
                                    } else if (value == 'delete') {
                                      _confirmDelete(session.id);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      ),
    );
  }

  Future<void> _editSession(Session session) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateSessionPage(initialSession: session),
      ),
    );
    if (result == true) _loadSessions();
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
