import 'package:flutter/material.dart';

// Classe para representar os dados do perfil do usuário
// Poderíamos criar um 'UserModel' separado, mas para simplicidade, reusamos o Map.
class UserProfileData {
  final String name;
  final String email;
  final String address; // Manter o endereço para consistência

  UserProfileData({
    required this.name,
    required this.email,
    required this.address,
  });
}

class EditProfileScreen extends StatefulWidget {
  final UserProfileData currentUserData; // Dados atuais do usuário para pré-preenchimento

  const EditProfileScreen({super.key, required this.currentUserData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>(); // Chave para o formulário
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController; // Para o endereço também

  @override
  void initState() {
    super.initState();
    // Inicializa os controladores com os dados atuais do usuário
    _nameController = TextEditingController(text: widget.currentUserData.name);
    _emailController = TextEditingController(text: widget.currentUserData.email);
    _addressController = TextEditingController(text: widget.currentUserData.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Se a validação passar, cria um novo objeto UserProfileData com os dados atualizados
      final updatedUserData = UserProfileData(
        name: _nameController.text,
        email: _emailController.text,
        address: _addressController.text,
      );

      // Retorna os dados atualizados para a tela anterior (ProfileScreen)
      Navigator.pop(context, updatedUserData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Campo Nome
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe seu nome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe seu email.';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Informe um email válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Endereço
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Endereço',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe seu endereço.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Botão Salvar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.save_outlined),
                  label: const Text(
                    'Salvar Alterações',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}