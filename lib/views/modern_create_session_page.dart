// ===================================
// FICHIER 2: lib/views/modern_create_session_page.dart
// Remplace create_seesion_page.dart
// ===================================
import 'package:flutter/material.dart';
import '../models/movie_response.dart';
import '../models/session_model.dart';
import '../services/session_service.dart';

class CreateSessionPagee extends StatefulWidget {
  final Session? initialSession;

  const CreateSessionPagee({Key? key, this.initialSession}) : super(key: key);

  @override
  _CreateSessionPageeState createState() => _CreateSessionPageeState();
}

class _CreateSessionPageeState extends State<CreateSessionPagee> {
  final _formKey = GlobalKey<FormState>();
  final SessionService _sessionService = SessionService();

  Movie? _selectedMovie;
  String _sessionType = 'Normal';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _seatsController = TextEditingController();
  final TextEditingController _roomController = TextEditingController(text: 'Salle 1');

  List<Movie> _movies = [];
  bool _isLoading = false;
  bool _isLoadingMovies = true;

  @override
  void initState() {
    super.initState();
    _loadMovies();
    _initFormWithExistingSession();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _seatsController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  void _initFormWithExistingSession() {
    if (widget.initialSession != null) {
      final session = widget.initialSession!;
      _sessionType = session.typeSeance;
      _selectedDate = session.date;
      _selectedTime = TimeOfDay.fromDateTime(session.horaire);
      _priceController.text = session.prix.toString();
      _seatsController.text = session.placesDisponibles.toString();
      _roomController.text = session.salle;
    }
  }

  Future<void> _loadMovies() async {
    setState(() => _isLoadingMovies = true);
    try {
      final movies = await _sessionService.fetchNowPlayingMovies();
      setState(() {
        _movies = movies;
        _isLoadingMovies = false;
        if (widget.initialSession != null) {
          _selectedMovie = _movies.firstWhere(
                (movie) =>
            movie.id.toString() == widget.initialSession!.filmId.toString(),
            orElse: () => _movies.first,
          );
        }
      });
    } catch (e) {
      setState(() => _isLoadingMovies = false);
      _showError('Erreur de chargement des films: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xFFE50914),
              surface: Color(0xFF1E1E1E),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xFFE50914),
              surface: Color(0xFF1E1E1E),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _selectedMovie == null) {
      _showError('Veuillez remplir tous les champs obligatoires');
      return;
    }

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
        'salle': _roomController.text,
        'typeSeance': _sessionType,
        'prix': int.parse(_priceController.text),
        'placesDisponibles': int.parse(_seatsController.text),
      };

      if (widget.initialSession != null) {
        await _sessionService.updateSeance(
          widget.initialSession!.id,
          sessionData,
        );
      } else {
        await _sessionService.createSeance(sessionData);
      }

      Navigator.pop(context, true);
    } catch (e) {
      _showError('Erreur: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFFE50914),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 0,
        title: Text(
          widget.initialSession != null
              ? 'Modifier la séance'
              : 'Créer une séance',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoadingMovies
          ? Center(
        child: CircularProgressIndicator(color: Color(0xFFE50914)),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Informations du film'),
                SizedBox(height: 16),
                _buildMovieSelector(),
                SizedBox(height: 24),

                _buildSectionTitle('Détails de la séance'),
                SizedBox(height: 16),
                _buildSessionTypeSelector(),
                SizedBox(height: 16),
                _buildDateTimeSelectors(),
                SizedBox(height: 24),

                _buildSectionTitle('Tarification et capacité'),
                SizedBox(height: 16),
                _buildPriceAndSeatsFields(),
                SizedBox(height: 16),
                _buildRoomField(),
                SizedBox(height: 32),

                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: Color(0xFFE50914),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildMovieSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF333333)),
      ),
      child: DropdownButtonFormField<Movie>(
        value: _selectedMovie,
        dropdownColor: Color(0xFF1E1E1E),
        decoration: InputDecoration(
          labelText: 'Sélectionner un film',
          labelStyle: TextStyle(color: Color(0xFFB3B3B3)),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.movie, color: Color(0xFFE50914)),
        ),
        style: TextStyle(color: Colors.white),
        items: _movies.map((Movie movie) {
          return DropdownMenuItem<Movie>(
            value: movie,
            child: Text(
              movie.title,
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (Movie? value) {
          setState(() => _selectedMovie = value);
        },
        validator: (value) => value == null ? 'Sélectionnez un film' : null,
      ),
    );
  }

  Widget _buildSessionTypeSelector() {
    final types = ['Normal', '3D', 'VIP', 'IMAX'];
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: types.map((type) {
          final isSelected = _sessionType == type;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _sessionType = type),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFE50914) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  type,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDateTimeSelectors() {
    return Row(
      children: [
        Expanded(
          child: _buildDateSelector(),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildTimeSelector(),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFF333333)),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Color(0xFFE50914)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date',
                    style: TextStyle(
                      color: Color(0xFFB3B3B3),
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return InkWell(
      onTap: () => _selectTime(context),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFF333333)),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, color: Color(0xFFE50914)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Heure',
                    style: TextStyle(
                      color: Color(0xFFB3B3B3),
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _selectedTime.format(context),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceAndSeatsFields() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            controller: _priceController,
            label: 'Prix (FCFA)',
            icon: Icons.attach_money,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Requis';
              }
              if (int.tryParse(value) == null) {
                return 'Invalide';
              }
              return null;
            },
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildTextField(
            controller: _seatsController,
            label: 'Places disponibles',
            icon: Icons.event_seat,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Requis';
              }
              if (int.tryParse(value) == null) {
                return 'Invalide';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoomField() {
    return _buildTextField(
      controller: _roomController,
      label: 'Salle',
      icon: Icons.room,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer le nom de la salle';
        }
        return null;
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF333333)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Color(0xFFB3B3B3)),
          prefixIcon: Icon(icon, color: Color(0xFFE50914)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          errorStyle: TextStyle(color: Color(0xFFE50914)),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE50914),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.initialSession != null ? Icons.update : Icons.add,
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              widget.initialSession != null
                  ? 'Mettre à jour la séance'
                  : 'Créer la séance',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}