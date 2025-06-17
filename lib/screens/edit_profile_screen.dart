import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/models/user.dart';
import 'package:perfumes_ecomerce/user_manager.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  // Não precisa mais receber dados no construtor
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Os controladores serão inicializados com os dados do UserManager
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;

  bool _isInitialized = false; // Flag para inicializar apenas uma vez

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Inicializa os controladores aqui, pois temos acesso ao context
    if (!_isInitialized) {
      final userManager = Provider.of<UserManager>(context, listen: false);
      _nameController = TextEditingController(text: userManager.user?.name ?? '');
      _emailController = TextEditingController(text: userManager.user?.email ?? '');
      _addressController = TextEditingController(text: userManager.user?.address ?? '');
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
  if (_formKey.currentState!.validate()) {
    final userManager = Provider.of<UserManager>(context, listen: false);

    // Etapa crucial: Pegamos o usuário ATUAL que já está no manager.
    // Ele contém a senha hash correta que não queremos perder.
    final currentUser = userManager.user;

    // Se por algum motivo o usuário não estiver carregado, não fazemos nada.
    if (currentUser == null) return;
    
    // ATUALIZADO: Usamos o copyWith para criar uma cópia com os dados do formulário
    final updatedUserData = currentUser.copyWith(
      name: _nameController.text,
      email: _emailController.text,
      address: _addressController.text,
      // Note que NÃO passamos o hashedPassword. 
      // O copyWith vai usar automaticamente o do 'currentUser'.
    );

    // Chama o manager para atualizar os dados no banco
    await userManager.updateUser(updatedUserData);

    if(mounted) {
      // Apenas fecha a tela, não precisa mais retornar dados
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          // O resto do seu layout do formulário pode permanecer exatamente o mesmo!
          child: Column(
            // ... Seus TextFormFields ...
            children: [
               TextFormField(controller: _nameController, /* ... */),
               const SizedBox(height: 16),
               TextFormField(controller: _emailController, /* ... */),
               const SizedBox(height: 16),
               TextFormField(controller: _addressController, /* ... */),
               const SizedBox(height: 32),
               SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveProfile,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Salvar Alterações'),
                  ),
               ),
            ],
          )
        ),
      ),
    );
  }
}