// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../models/paciente.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  late Paciente paciente;
  int score = 0;
  String mortalidade = "";
  bool camposInseridos = false;

  @override
  void initState() {
    super.initState();
    paciente = Paciente(
      nome: '',
      idade: 0,
      leucocitos: 0,
      glicemia: 0.0,
      ast: 0,
      ldh: 0,
      litiaseBiliar: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Novo Paciente",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do paciente.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    paciente.nome = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Idade'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a idade do paciente.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    paciente.idade = int.parse(value!);
                  },
                ),
                Row(
                  children: [
                    const Text('Litíase Biliar'),
                    Checkbox(
                      value: paciente.litiaseBiliar,
                      onChanged: (value) {
                        setState(() {
                          paciente.litiaseBiliar = value!;
                        });
                      },
                    ),
                  ],
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Leucócitos',
                    suffixText: 'cél./mm3',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o número de leucócitos.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    paciente.leucocitos = int.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Glicemia',
                    suffixText: 'mmol/L',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o valor da glicemia.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    paciente.glicemia = double.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'AST/TGO',
                    suffixText: 'UI/L',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o valor da AST/TGO.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    paciente.ast = int.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'LDH',
                    suffixText: 'UI/L',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o valor da LDH.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    paciente.ldh = int.parse(value!);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {
                            calcularMortalidade();
                            camposInseridos = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('ADICIONAR PACIENTE'),
                    ),
                  ),
                ),
                if (camposInseridos) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Pontuação: $score',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Mortalidade: $mortalidade',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void calcularMortalidade() {
    score = 0;

    if (!paciente.litiaseBiliar) {
      if (paciente.idade > 55) score++;
      if (paciente.leucocitos > 16000) score++;
      if (paciente.glicemia > 11) score++;
      if (paciente.ast > 250) score++;
      if (paciente.ldh > 350) score++;
    } else {
      if (paciente.idade > 70) score++;
      if (paciente.leucocitos > 18000) score++;
      if (paciente.glicemia > 12.2) score++;
      if (paciente.ast > 250) score++;
      if (paciente.ldh > 400) score++;
    }

    if (score >= 0 && score <= 2) {
      mortalidade = '2%\nPancreatite não é grave';
    } else if (score >= 3 && score <= 4) {
      mortalidade = '15%\nPancreatite grave';
    } else if (score >= 5 && score <= 6) {
      mortalidade = '40%\nPancreatite grave';
    } else if (score >= 7 && score <= 8) {
      mortalidade = '100%\nPancreatite muito grave';
    }
  }
}
