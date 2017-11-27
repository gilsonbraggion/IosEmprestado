import Foundation

class UsuarioFacebook {
    var idUsuario: String = String()
    var nomeUsuario: String = String()
    
    init() {
    }
    
    func popularCampos(_ idUsuario : String, nomeUsuario : String) {
        self.idUsuario = idUsuario
        self.nomeUsuario = nomeUsuario
    }
}
