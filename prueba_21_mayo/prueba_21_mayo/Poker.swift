//
//  Poker.swift
//  prueba_21_mayo
//
//  Created by bootcamp on 2025-05-22.
//
enum Palos: String, CaseIterable {
    case corazones = "H"
    case diamantes = "D"
    case trebol = "C"
    case espadas = "S"
}

enum Valores: String, CaseIterable {
    case dos = "2"
    case tres = "3"
    case cuatro = "4"
    case cinco = "5"
    case seis = "6"
    case siete = "7"
    case ocho = "8"
    case nueve = "9"
    case T = "10"
    case J = "11"
    case Q = "12"
    case K = "13"
    case ace = "14"
}

struct Carta: CustomStringConvertible {
    let palo: Palos
    let valor: Valores

    var description: String {
        return "\(palo.rawValue)\(valor.rawValue)"
    }
}

class Mazo {
    private var mazo: [Carta] = []

    func reset() {
        mazo = []
        for palo in Palos.allCases {
            for valor in Valores.allCases {
                mazo.append(Carta(palo: palo, valor: valor))
            }
        }
    }

    func barajar() {
        mazo.shuffle()
    }

    func repartir() -> Carta? {
        return mazo.isEmpty ? nil : mazo.removeFirst()
    }

    var cantidadRestante: Int {
        return mazo.count
    }
    func imprimirMazo() {
        print(mazo)
    }
}

func valorNumerico(_ valor: Valores) -> Int? {
    return Int(valor.rawValue) ?? 0
}

func contarValores(_ mano: [Carta]) -> [Int: Int] {
    var cuenta: [Int: Int] = [:]
    for carta in mano {
        if let numero = valorNumerico(carta.valor) {
            cuenta[numero, default: 0] += 1
        }
    }
    return cuenta
}

func esColor(_ mano: [Carta]) -> Bool {
    return Set(mano.map { $0.palo }).count == 1
}

func esEscalera(_ mano: [Carta]) -> Bool {
    let valores = mano.map { valorNumerico($0.valor) ?? 0 }.sorted()

    if Set(valores) == Set([14, 2, 3, 4, 5]) {
        return true
    }

    for i in 0..<valores.count - 1 {
        if valores[i + 1] - valores[i] != 1 {
            return false
        }
    }
    return true
}

func esEscaleraColor(_ mano: [Carta]) -> Bool {
    return esColor(mano) && esEscalera(mano)
}

func esPoker(_ mano: [Carta]) -> Bool {
    return contarValores(mano).values.contains(4)
}

func esFull(_ mano: [Carta]) -> Bool {
    let valores = contarValores(mano).values.sorted()
    return valores == [2, 3]
}

func esTrio(_ mano: [Carta]) -> Bool {
    return contarValores(mano).values.contains(3) && !esFull(mano)
}

func esParDoble(_ mano: [Carta]) -> Bool {
    let pares = contarValores(mano).filter { $0.value == 2 }
    return pares.count == 2
}

func esPar(_ mano: [Carta]) -> Bool {
    let pares = contarValores(mano).filter { $0.value == 2 }
    return pares.count == 1
}

func verificarCaso(mano: [Carta]) -> String {
    if esEscaleraColor(mano) { return "Escalera de Color" }
    if esPoker(mano) { return "Póker" }
    if esFull(mano) { return "Full" }
    if esColor(mano) { return "Color" }
    if esEscalera(mano) { return "Escalera" }
    if esTrio(mano) { return "Trío" }
    if esParDoble(mano) { return "Par Doble" }
    if esPar(mano) { return "Par" }
    return "Carta Alta"
}

func obtenerValoresImportantes(_ mano: [Carta]) -> [Int] {
    let cuenta = contarValores(mano)

    let valores = cuenta.sorted {
        if $0.value != $1.value {
            return $0.value > $1.value
        } else {
            return $0.key > $1.key
        }
    }.map { $0.key }

    return valores
}

func compararJugadasIguales(_ manoRojo: [Carta], _ manoNegro: [Carta]) -> String {
    let valoresRojo = obtenerValoresImportantes(manoRojo)
    let valoresNegro = obtenerValoresImportantes(manoNegro)

    for i in 0..<min(valoresRojo.count, valoresNegro.count) {
        if valoresRojo[i] > valoresNegro[i] {
            return "Rojo gana por valor de jugada!"
        } else if valoresRojo[i] < valoresNegro[i] {
            return "Negro gana por valor de jugada!"
        }
    }

    return "Empate por valor de jugada!"
}

func verificarGanador(_ jugadaRojo: String, _ jugadaNegro: String, _ manoRojo: [Carta], _ manoNegro: [Carta]) -> String {
    let jerarquiaJugadas: [String: Int] =
        [
            "Escalera de Color": 9,
            "Póker": 8,
            "Full": 7,
            "Color": 6,
            "Escalera": 5,
            "Trío": 4,
            "Par Doble": 3,
            "Par": 2,
            "Carta Alta": 1,
        ]
    let valorRojo = jerarquiaJugadas[jugadaRojo] ?? 0
    let valorNegro = jerarquiaJugadas[jugadaNegro] ?? 0

    if valorRojo > valorNegro {
        return "Rojo gana!!"
    } else if valorRojo < valorNegro {
        return "Negro gana!!"
    } else {
        // Si es empate por tipo de jugada, comparar valores relevantes
        return compararJugadasIguales(manoRojo, manoNegro)
    }
}

let mazo = Mazo()
func verificarGanador() {
    mazo.reset()
    mazo.barajar()
    
    var manoRojo: [Carta] = []
    for _ in 0..<5 {
        if let carta = mazo.repartir() {
            manoRojo.append(carta)
        }
    }
    var manoNegro: [Carta] = []
    for _ in 0..<5 {
        if let carta = mazo.repartir() {
            manoNegro.append(carta)
        }
    }
    
    let jugadaRojo: String = verificarCaso(mano: manoRojo)
    let jugadaNegro: String = verificarCaso(mano: manoNegro)
    
    print("Mano Roja: \(manoRojo)")
    print("Jugada: \(verificarCaso(mano: manoRojo))")
    
    print("Mano Negra: \(manoNegro)")
    print("Jugada: \(verificarCaso(mano: manoNegro))")
    
    print(verificarGanador(jugadaRojo, jugadaNegro, manoRojo, manoNegro))
}

func generarPartida() -> (
    manoRojo: [Carta],
    manoNegro: [Carta],
    jugadaRojo: String,
    jugadaNegro: String,
    resultado: String
) {
    mazo.reset()
    mazo.barajar()

    var manoRojo: [Carta] = []
    var manoNegro: [Carta] = []

    for _ in 0..<5 {
        if let carta = mazo.repartir() { manoRojo.append(carta) }
        if let carta = mazo.repartir() { manoNegro.append(carta) }
    }

    let jugadaRojo = verificarCaso(mano: manoRojo)
    let jugadaNegro = verificarCaso(mano: manoNegro)
    let resultado = verificarGanador(jugadaRojo, jugadaNegro, manoRojo, manoNegro)

    return (manoRojo, manoNegro, jugadaRojo, jugadaNegro, resultado)
}
