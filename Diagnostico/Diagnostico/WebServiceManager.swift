//
//  WebServiceManager.swift
//  Diagnostico
//
//  Created by Bruno Maciel on 6/3/20.
//  Copyright © 2020 Bruno Maciel. All rights reserved.
//

import Foundation

class WebServiceManager {
    private let basePath: String
    private let configuration: URLSessionConfiguration
    private let session: URLSession
    
    
    static let singleton = WebServiceManager()
    private init() {
        self.basePath = "http://127.0.0.1:5000/"
        self.configuration = {
            let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = ["Content-Type": "application/json"]
            config.timeoutIntervalForRequest = 10.0 // 10s para obter uma resposta, caso contrario cancela a requisição
            config.httpMaximumConnectionsPerHost = 5 // numero maximo de conexoes simultaneas
            return config
        }()
        self.session = URLSession(configuration: configuration)
    }
    
    
    /*****   METODO PUBLICO   *****/
    func sendData(_ diagnostico: Diagnostico, onComplete: @escaping (Bool, String, Diagnostico?) -> Void) {
        let (jsonCreated, jsonData) = createJSON(for: diagnostico)
        
        if jsonCreated {
            print("JSON criado!\n", String(data: jsonData, encoding: .utf8)!)
            self.postObject(jsonData, service: "diagnosticos/") { (sucess, erro, diagnostico) in
                onComplete(sucess, erro, diagnostico)
                print("Acesso ao WebService finalizado")
            }
        } else {
            onComplete(jsonCreated, "Erro na criação do JSON", nil)
        }
    }
    
    
    // Cria o JSON do Objeto
    private func createJSON(for diagnostico: Diagnostico) -> (Bool, Data) {
        print("Criando JSON!")
        
        if let json = try? JSONEncoder().encode(diagnostico) { return (true, json) }
        else {
            print("Erro ao criar JSON")
            return (false, Data())
        }
        
    }
    
    
    /****** METODO HTTP POST ******/
    private func postObject(_ json: Data, service: String, onComplete: @escaping (Bool, String, Diagnostico?) -> Void) {
        // Cria url do web service
        let completePath = basePath + service
        guard let uri = URL(string: completePath)
            else {  print("Erro na criação da URL"); return }
        
        // Cria a request com o json
        var request = URLRequest(url: uri)
        request.httpMethod = "POST"
        request.httpBody = json
        
        // Realiza o request
        let dataTask = session.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                // Verifica se obteve resposta
                guard let response = response as? HTTPURLResponse else {
                        print("Erro na obtenção da response");
                        onComplete(false, "Erro na comunicação com WebService", nil);
                        return
                }
                
                // Verifica se o StatusCode foi positivo
                if response.statusCode == 200 {
                    guard data != nil else {
                        print("\nErro na obtenção do data")
                        onComplete(false, "Falha na obtenção dos dados de resposta", nil)
                        return
                    }
                    
                    print("Data received: \(data!)")
                    // Espera que o WebService retorne um json com os dados do paciente e o diagnostico definido
                    do {
                        let diagnostico = try JSONDecoder().decode(Diagnostico.self, from: data!)
                        onComplete(true, "Diagnóstico Realizado", diagnostico)
                    } catch {
                        print(error.localizedDescription)
                        onComplete(false, "Falha ao converter JSON", nil)
                    }
                } else {
                    print("Erro Status code: \(response.statusCode)")
                    onComplete(false, "Status Code \(response.statusCode)", nil)
                }
            } else {
                print("\nErro na criação do DataTask: \n\(error!)")
                onComplete(false, "Erro na criação da Requisição", nil)
            }
        }
        dataTask.resume()
    }
}
