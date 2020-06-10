//
//  Diagnostico.swift
//  Diagnostico
//
//  Created by Bruno Maciel on 6/3/20.
//  Copyright © 2020 Bruno Maciel. All rights reserved.
//

import Foundation

final class Diagnostico {
    var n_gestacoes: Int
    var glicose: Float
    var pressao_sanguinea: Float
    var espessura_pele: Float
    var insulina: Float
    var imc: Float
    var indice_historico: Float
    var idade: Int
    var diagnostico : String?
    
    init(_ n_gestacoes: Int, glicose: Float, pressao_sanguinea: Float, espessura_pele: Float, insulina: Float, imc: Float, indice_historico: Float, idade: Int, diagnostico: String?) {
        self.n_gestacoes = n_gestacoes
        self.glicose = glicose
        self.pressao_sanguinea = pressao_sanguinea
        self.espessura_pele = espessura_pele
        self.insulina = insulina
        self.imc = imc
        self.indice_historico = indice_historico
        self.idade = idade
        self.diagnostico = diagnostico ?? nil
    }
}


extension Diagnostico: Codable {
    enum DecodKeys: String, CodingKey {
        case n_gestacoes = "n_gestacoes"
        case glicose = "glicose"
        case pressao_sanguinea = "pressao_sanguinea"
        case espessura_pele = "espessura_pele"
        case insulina = "insulina"
        case imc = "imc"
        case indice_historico = "indice_historico"
        case idade = "idade"
        case diagnostico = "diagnostico"
    }
    
    convenience init(from decoder: Decoder) {
        let container = try! decoder.container(keyedBy: DecodKeys.self)
        
        let n_gestacoes: Int = try! container.decode(Int.self, forKey: .n_gestacoes)
        let glicose: Float = try! container.decode(Float.self, forKey: .glicose)
        let pressao_sanguinea: Float = try! container.decode(Float.self, forKey: .pressao_sanguinea)
        let espessura_pele: Float = try! container.decode(Float.self, forKey: .espessura_pele)
        let insulina: Float = try! container.decode(Float.self, forKey: .insulina)
        let imc: Float = try! container.decode(Float.self, forKey: .imc)
        let indice_historico: Float = try! container.decode(Float.self, forKey: .indice_historico)
        let idade: Int = try! container.decode(Int.self, forKey: .idade)
        let diagnostico: String = try! container.decode(String.self, forKey: .diagnostico)
        
        self.init(n_gestacoes, glicose: glicose, pressao_sanguinea: pressao_sanguinea, espessura_pele: espessura_pele, insulina: insulina, imc: imc, indice_historico: indice_historico, idade: idade, diagnostico: diagnostico)
    }
}
