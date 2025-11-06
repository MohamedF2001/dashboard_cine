/*
import 'package:dashbord_cine/models/movie_response.dart';
import 'package:flutter/material.dart';
import '../services/session_service.dart';
import '../models/session_model.dart';

class CreateSessionPage extends StatefulWidget {
  final Session? initialSession;
  CreateSessionPage({this.initialSession});
  @override
  _CreateSessionPageState createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> {
  final _formKey = GlobalKey<FormState>();
  final SessionService _sessionService = SessionService();

  Movie? _selectedMovie;
  String _sessionType = 'Normal'; // Correspond au type dans SessionResponse
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _price = 0; // Valeur par défaut cohérente avec l'exemple
  int _availableSeats = 120; // Valeur par défaut cohérente avec l'exemple
  String _room = 'Salle 1';
  List<Movie> _movies = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  */
/*Future<void> _loadMovies() async {
    try {
      final movieResponse = await _sessionService.fetchNowPlayingMovies();
      setState(() => _movies = movieResponse.results);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load movies: $e')),
      );
    }
  }*/ /*


  Future<void> _loadMovies() async {
    try {
      final movies = await _sessionService.fetchNowPlayingMovies();
      setState(() => _movies = movies);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load movies: $e')));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedMovie != null) {
      setState(() => _isLoading = true);

      try {
        // Création de la date complète en combinant date et heure
        final DateTime fullDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );

        final filmId = int.tryParse(_selectedMovie!.id.toString()) ?? 0;

        // Création de l'objet Session avec les champs correspondant à l'API
        final session = Session(
          id: '', // Généré par le serveur
          filmId: _selectedMovie!.id, // Adapté au modèle API
          film: _selectedMovie!.title,
          horaire: fullDateTime,
          date: _selectedDate,
          salle: _room,
          typeSeance: _sessionType,
          prix: _price,
          placesDisponibles: _availableSeats,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          v: 0,
        );

        // Conversion de l'objet Session en Map pour l'API
        final sessionData = {
          'filmId': session.filmId,
          'film': session.film,
          'horaire': session.horaire.toIso8601String(),
          'date': session.date.toIso8601String(),
          'salle': session.salle,
          'typeSeance': session.typeSeance,
          'prix': session.prix,
          'placesDisponibles': session.placesDisponibles,
        };

        await _sessionService.createSeance(sessionData);
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create session: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Session')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<Movie>(
                value: _selectedMovie,
                decoration: InputDecoration(labelText: 'Movie'),
                items: _movies.map((Movie movie) {
                  return DropdownMenuItem<Movie>(
                    value: movie,
                    child: Text(movie.title),
                  );
                }).toList(),
                onChanged: (Movie? value) {
                  setState(() => _selectedMovie = value);
                },
                validator: (value) =>
                value == null ? 'Please select a movie' : null,
              ),
              DropdownButtonFormField<String>(
                value: _sessionType,
                decoration: InputDecoration(labelText: 'Session Type'),
                items: ['Normal', '3D', 'VIP'].map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() => _sessionType = value!);
                },
              ),
              ListTile(
                title: Text('Date'),
                subtitle: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              ListTile(
                title: Text('Time'),
                subtitle: Text(_selectedTime.format(context)),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(context),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price (€)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                initialValue: _price.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) =>
                _price = int.tryParse(value) ?? _price,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Available Seats'),
                keyboardType: TextInputType.number,
                initialValue: _availableSeats.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter seat count';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) =>
                _availableSeats = int.tryParse(value) ?? _availableSeats,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Room'),
                initialValue: _room,
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a room' : null,
                onChanged: (value) => _room = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: Text('Create Session'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

import 'package:dashbord_cine/models/movie_response.dart';
import 'package:flutter/material.dart';
import '../../services/session_service.dart';
import '../../models/session_model.dart';
import '../../widgets/style.dart';

class CreateSessionPage extends StatefulWidget {
  final Session? initialSession;

  const CreateSessionPage({super.key, this.initialSession});

  @override
  _CreateSessionPageState createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> {
  final _formKey = GlobalKey<FormState>();
  final SessionService _sessionService = SessionService();

  Movie? _selectedMovie;
  String _sessionType = 'Normal';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _price = 0;
  int _availableSeats = 120;
  String _room = 'Salle 1';
  List<Movie> _movies = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMovies();
    _initFormWithExistingSession();
  }

  void _initFormWithExistingSession() {
    if (widget.initialSession != null) {
      final session = widget.initialSession!;
      setState(() {
        _sessionType = session.typeSeance;
        _selectedDate = session.date;
        _selectedTime = TimeOfDay.fromDateTime(session.horaire);
        _price = session.prix;
        _availableSeats = session.placesDisponibles;
        _room = session.salle;
        // Note: _selectedMovie sera mis à jour après le chargement des films
      });
    }
  }

  Future<void> _loadMovies() async {
    try {
      final movies = await _sessionService.fetchNowPlayingMovies();
      setState(() {
        _movies = movies;
        if (widget.initialSession != null) {
          // Trouver le film correspondant à la séance existante
          _selectedMovie = _movies.firstWhere(
            (movie) =>
                movie.id.toString() == widget.initialSession!.filmId.toString(),
            orElse: () => _movies.first,
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load movies: $e')));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedMovie != null) {
      setState(() => _isLoading = true);

      try {
        final DateTime fullDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );

        final sessionData = {
          'filmId': _selectedMovie!.id.toString(),
          'film': _selectedMovie!.title,
          'img_film': _selectedMovie!.posterPath,
          'horaire': fullDateTime.toIso8601String(),
          'date': _selectedDate.toIso8601String(),
          'salle': _room,
          'typeSeance': _sessionType,
          'prix': _price,
          'placesDisponibles': _availableSeats,
        };

        if (widget.initialSession != null) {
          // Mise à jour d'une séance existante
          await _sessionService.updateSeance(
            widget.initialSession!.id,
            sessionData,
          );
        } else {
          // Création d'une nouvelle séance
          await _sessionService.createSeance(sessionData);
        }
        Navigator.pop(context, true);
      } catch (e) {
        print("erreur $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save session: $e')));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: Colors.black.withOpacity(0.5),
        centerTitle: true,
        title: Text(
          widget.initialSession != null ? 'Edit la séance' : 'Crée la séance',
        ),
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
                ? Center(child: CircularProgressIndicator())
                : Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 500, // Largeur maximale du formulaire
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: [
                            DropdownButtonFormField<Movie>(
                              dropdownColor: Colors.black,
                              value: _selectedMovie,
                              decoration: customInputDecoration('Film'),
                              items:
                                  _movies.map((Movie movie) {
                                    return DropdownMenuItem<Movie>(
                                      value: movie,
                                      child: Text(
                                        movie.title,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (Movie? value) {
                                setState(() => _selectedMovie = value);
                              },
                              validator:
                                  (value) =>
                                      value == null
                                          ? 'Sélectionner un film'
                                          : null,
                            ),
                            SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              dropdownColor: Colors.black,
                              value: _sessionType,
                              decoration: customInputDecoration(
                                'Type de séance',
                              ),
                              items:
                                  ['Normal', '3D', 'VIP'].map((String type) {
                                    return DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(
                                        type,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (String? value) {
                                setState(() => _sessionType = value!);
                              },
                            ),
                            SizedBox(height: 10),
                            ListTile(
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              title: Text(
                                'Date',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                style: TextStyle(color: Colors.white),
                              ),
                              trailing: Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                              ),
                              onTap: () => _selectDate(context),
                            ),
                            SizedBox(height: 10),
                            ListTile(
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              title: Text(
                                'Time',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                _selectedTime.format(context),
                                style: TextStyle(color: Colors.white),
                              ),
                              trailing: Icon(
                                Icons.access_time,
                                color: Colors.white,
                              ),
                              onTap: () => _selectTime(context),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: customInputDecoration('Prix'),
                              keyboardType: TextInputType.number,
                              //initialValue: _price.toString(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entrez un prix';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Entrez un prix valide';
                                }
                                return null;
                              },
                              onChanged:
                                  (value) =>
                                      _price = int.tryParse(value) ?? _price,
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: customInputDecoration(
                                'Nombre de places',
                              ),
                              keyboardType: TextInputType.number,
                              //initialValue: _availableSeats.toString(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entrez le nombre de place svp';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Entrez une valeur valide';
                                }
                                return null;
                              },
                              onChanged:
                                  (value) =>
                                      _availableSeats =
                                          int.tryParse(value) ??
                                          _availableSeats,
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Salle',
                                labelStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              //initialValue: _room,
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Entrez le nom de la salle'
                                          : null,
                              onChanged: (value) => _room = value,
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(200, 50),
                                backgroundColor:
                                    Colors.black12, // Couleur du bouton
                                foregroundColor:
                                    Colors.white, // Couleur du texte
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ), // Bordures arrondies
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: _isLoading ? null : _submitForm,
                              child: Text(
                                widget.initialSession != null
                                    ? 'Mettre a jour la séance'
                                    : 'Créé la séance',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}
