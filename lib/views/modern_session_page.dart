// lib/views/modern_session_page.dart
import 'package:dashbord_cine/views/modern_create_session_page.dart';
import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../config/responsive.dart';
import '../models/session_model.dart';
import '../services/session_service.dart';
import '../widgets/session_card.dart';
import 'old/create_seesion_page.dart';

class SessionsPagee extends StatefulWidget {
  const SessionsPagee({Key? key}) : super(key: key);

  @override
  State<SessionsPagee> createState() => _SessionsPageeState();
}

class _SessionsPageeState extends State<SessionsPagee> {
  final SessionService _sessionService = SessionService();
  List<Session> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() => _isLoading = true);

    try {
      final response = await _sessionService.getAllSeances();
      setState(() {
        _sessions = response.seances;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  Future<void> _deleteSession(String sessionId) async {
    try {
      await _sessionService.deleteSeance(sessionId);
      _loadSessions();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Séance supprimée')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  void _confirmDelete(String sessionId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer cette séance?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteSession(sessionId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRed,
            ),
            child: Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: Stack(
        children: [
          _isLoading
              ? Center(
            child: CircularProgressIndicator(
              color: AppTheme.primaryRed,
            ),
          )
              : _sessions.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
            onRefresh: _loadSessions,
            color: AppTheme.primaryRed,
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _sessions.length,
              itemBuilder: (context, index) {
                return SessionCard(
                  session: _sessions[index],
                  onEdit: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateSessionPage(
                          initialSession: _sessions[index],
                        ),
                      ),
                    );
                    if (result == true) _loadSessions();
                  },
                  onDelete: () => _confirmDelete(_sessions[index].id),
                );
              },
            ),
          ),

          // Floating Action Button
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateSessionPagee(),
                  ),
                );
                if (result == true) _loadSessions();
              },
              backgroundColor: AppTheme.primaryRed,
              icon: Icon(Icons.add_rounded),
              label: Text('Nouvelle séance'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.movie_creation_outlined,
              size: 64,
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Aucune séance trouvée',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Créez votre première séance',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}