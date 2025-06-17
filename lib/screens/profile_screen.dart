import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/screens/edit_profile_screen.dart';
import 'package:perfumes_ecomerce/user_manager.dart';
import 'package:provider/provider.dart';
// Importa o nosso novo manager

// MUDOU: Agora pode ser um StatelessWidget, pois não gerencia mais o estado localmente.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos o Consumer para ouvir as mudanças do UserManager
    return Consumer<UserManager>(
      builder: (context, userManager, child) {
        // Enquanto o manager estiver carregando os dados ou se o usuário for nulo, mostra um spinner.
        if (userManager.isLoading || userManager.user == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Meu Perfil')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // Quando os dados estiverem prontos, usamos o objeto 'user' do manager
        final user = userManager.user!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Meu Perfil'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const CircleAvatar(
                  radius: 60,
                  child: Icon(Icons.person_outline, size: 60),
                ),
                const SizedBox(height: 24),

                // ATUALIZADO: Mostra os dados vindos do UserManager
                Text(
                  user.name,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  user.email,
                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                ),
                const SizedBox(height: 32),

                // Os ListTiles agora também usam os dados do manager
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('Email'),
                    subtitle: Text(user.email),
                    trailing: const Icon(Icons.edit, size: 20),
                    onTap: () {
                      // ATUALIZADO: A navegação agora é mais simples
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: const Text('Endereço'),
                    subtitle: Text(user.address),
                    trailing: const Icon(Icons.edit, size: 20),
                     onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                
                // ... (Botões de Editar Perfil e Alterar Senha permanecem os mesmos,
                // mas agora o de editar perfil não precisa mais de uma função separada) ...
                 SizedBox(
                   width: double.infinity,
                   child: ElevatedButton(
                     onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                        );
                     },
                     child: const Text('Editar Perfil', style: TextStyle(fontSize: 18)),
                   ),
                 ),
              ],
            ),
          ),
        );
      },
    );
  }
}