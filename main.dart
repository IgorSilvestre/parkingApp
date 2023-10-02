import 'dart:io';

const TAMANHO_PATIO = 3;

class Veiculo {
  String placa;
  String modelo;
  DateTime horaEntrada;

  Veiculo(this.placa, this.modelo, this.horaEntrada);
}

void main() {
  List<Veiculo> estacionamento = [];

  while (true) {
    print("Escolha uma opção:");
    print("1 - Entrada de Veículo");
    print("2 - Saída de Veículo");
    print("3 - Sair do Programa");

    int? opcao;
    try {
      opcao = int.parse(stdin.readLineSync()!);
    } catch (e) {
      print("Opção inválida. Use apenas números.");
      continue;
    }

    if (opcao == 1) {
      registrarEntrada(estacionamento);
    } else if (opcao == 2) {
      registrarSaida(estacionamento);
    } else if (opcao == 3) {
      break;
    } else {
      print("Opção inválida. Tente novamente.");
    }
  }
}

String formatarPlaca(String placa) {
  var placaFormatada = placa.replaceAll('-', '').toUpperCase();
  placaFormatada =
      placaFormatada.substring(0, 3) + '-' + placaFormatada.substring(3);
  return placaFormatada;
}

void registrarEntrada(List<Veiculo> estacionamento) {
  if (estacionamento.length < TAMANHO_PATIO) {
    print("Digite a placa do veículo:");
    var placa = stdin.readLineSync()!;
    var placaFormatada = formatarPlaca(placa);

    if (!RegExp(r"^[A-Z]{3}-\d{4}$").hasMatch(placaFormatada)) {
      print("Formato de placa inválido. Use o formato AAA-9999.");
      return;
    }

    // Verificando se a placa já está registrada
    if (estacionamento.any((veiculo) => veiculo.placa == placaFormatada)) {
      print("Um veículo com essa placa já está estacionado.");
      return;
    }

    print("Digite o modelo do veículo:");
    var modelo = stdin.readLineSync()!;
    var horaEntrada = DateTime.now();
    estacionamento.add(Veiculo(placaFormatada, modelo, horaEntrada));
    print("Veículo estacionado com sucesso!");
  } else {
    print("PÁTIO CHEIO! Não é possível estacionar o veículo.");
  }
}

void registrarSaida(List<Veiculo> estacionamento) {
  print("Digite a placa do veículo que está saindo:");
  var placaSaida = stdin.readLineSync()!;
  placaSaida = formatarPlaca(placaSaida); // Adicionada a formatação da placa

  Veiculo? veiculo;
  for (var v in estacionamento) {
    if (v.placa == placaSaida) {
      veiculo = v;
      break;
    }
  }

  if (veiculo != null) {
    var horaSaida = DateTime.now();
    var duracao = horaSaida.difference(veiculo.horaEntrada);
    var minutosEstacionado = duracao.inMinutes;
    var valorAPagar = minutosEstacionado * 0.1; // Taxa de R\$0.10 por minuto
    print("Placa: ${veiculo.placa}");
    print("Modelo: ${veiculo.modelo}");
    print("Valor a pagar: R\$ ${valorAPagar.toStringAsFixed(2)}");
    estacionamento.remove(veiculo);
  } else {
    print("Veículo não encontrado no estacionamento.");
  }
}
