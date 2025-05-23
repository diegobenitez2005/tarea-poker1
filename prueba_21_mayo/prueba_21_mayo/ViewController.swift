import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var stackJugador1: UIStackView!
    @IBOutlet weak var cartaJugador1_1: UIImageView!
    @IBOutlet weak var cartaJugador1_2: UIImageView!
    @IBOutlet weak var cartaJugador1_3: UIImageView!
    @IBOutlet weak var cartaJugador1_4: UIImageView!
    @IBOutlet weak var cartaJugador1_5: UIImageView!

    @IBOutlet weak var stackJugador2: UIStackView!
    @IBOutlet weak var cartaJugador2_1: UIImageView!
    @IBOutlet weak var cartaJugador2_2: UIImageView!
    @IBOutlet weak var cartaJugador2_3: UIImageView!
    @IBOutlet weak var cartaJugador2_4: UIImageView!
    @IBOutlet weak var cartaJugador2_5: UIImageView!

    @IBOutlet weak var resultadoLabel: UILabel!

    // Aquí definimos las vistas en propiedades para usarlas en toda la clase
    var vistasCartasJugador1: [UIImageView] = []
    var vistasCartasJugador2: [UIImageView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Inicializamos los arrays aquí (ya conectados los IBOutlet)
        vistasCartasJugador1 = [
            cartaJugador1_1,
            cartaJugador1_2,
            cartaJugador1_3,
            cartaJugador1_4,
            cartaJugador1_5
        ]
        vistasCartasJugador2 = [
            cartaJugador2_1,
            cartaJugador2_2,
            cartaJugador2_3,
            cartaJugador2_4,
            cartaJugador2_5
        ]

    }

    @IBAction func jugar(_ sender: UIButton) {
        print("bOTON APRENTADO")
        mostrarCartas()
        // create the alert
        
        

    }

    func mostrarCartas() {
        // Usar la función generarPartida() de tu lógica (debería estar importada)
        let resultadoPartida = generarPartida()

        for i in 0..<5 {
            let cartaRojo = resultadoPartida.manoRojo[i]
            let cartaNegro = resultadoPartida.manoNegro[i]

            let nombreImagenRojo = "\(cartaRojo.palo.rawValue)\(cartaRojo.valor.rawValue)"
            let nombreImagenNegro = "\(cartaNegro.palo.rawValue)\(cartaNegro.valor.rawValue)"

            vistasCartasJugador1[i].image = UIImage(named: nombreImagenRojo)
            vistasCartasJugador2[i].image = UIImage(named: nombreImagenNegro)
        }

        resultadoLabel.text = resultadoPartida.resultado
        print("Texto resultado: \(resultadoPartida.resultado)")
        
        let alert = UIAlertController(title: "RESULTADO!!", message: "\(resultadoPartida.resultado)", preferredStyle: UIAlertController.Style.alert)

                // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
