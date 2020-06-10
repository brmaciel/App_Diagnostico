//
//  ViewController.swift
//  Diagnostico
//
//  Created by Bruno Maciel on 6/3/20.
//  Copyright © 2020 Bruno Maciel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var field_gestacao: UITextField!
    @IBOutlet weak var field_glicose: UITextField!
    @IBOutlet weak var field_pressaoSanguinea: UITextField!
    @IBOutlet weak var field_espessuraPele: UITextField!
    @IBOutlet weak var field_insulina: UITextField!
    @IBOutlet weak var field_imc: UITextField!
    @IBOutlet weak var field_indiceHistorico: UITextField!
    @IBOutlet weak var field_idade: UITextField!
    
    @IBOutlet weak var lb_diagnostico: UILabel!
    
    let webService = WebServiceManager.singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scrollView.contentSize.height = contentView.frame.height + 60
        
        initKeyboardToobar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // Cria ToolBar acima do teclado para facilitar a mudança entre os TextFields
    private func initKeyboardToobar() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let toolbarButton_done = UIBarButtonItem(title: "Next", style: .done, target: nil, action: #selector(changeTextField))
        let toolbarSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        keyboardToolbar.items = [toolbarSpace, toolbarButton_done]
        
        field_gestacao.inputAccessoryView = keyboardToolbar
        field_glicose.inputAccessoryView = keyboardToolbar
        field_pressaoSanguinea.inputAccessoryView = keyboardToolbar
        field_espessuraPele.inputAccessoryView = keyboardToolbar
        field_insulina.inputAccessoryView = keyboardToolbar
        field_imc.inputAccessoryView = keyboardToolbar
        field_indiceHistorico.inputAccessoryView = keyboardToolbar
        field_idade.inputAccessoryView = keyboardToolbar
    }
    
    
    
    @objc func changeTextField() {
        let all_fields = [field_gestacao, field_glicose, field_pressaoSanguinea, field_espessuraPele, field_insulina, field_imc, field_indiceHistorico, field_idade]
        if all_fields.last!!.isFirstResponder { view.endEditing(true) }
        else {
            for f in 0..<all_fields.count-1 {
                if all_fields[f]!.isFirstResponder {
                    all_fields[f]?.resignFirstResponder()
                    all_fields[f+1]?.becomeFirstResponder()
                    break
                }
            }
        }
    }
    
    
    // Cria Alerta informando Sucesso/Falha do consumo do web service
    private func showSuccessFailAlert(success: Bool, message: String) {
        let alertTitle = success ? "SUCESSO" : "ERROR"
        
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (nil) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(OKAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: Realiza o diagnóstico
    @IBAction func diagnosticar(_ sender: UIButton) {
        lb_diagnostico.text = "..."
        
        guard let n_gestacoes = Int(field_gestacao!.text!) else {
            showSuccessFailAlert(success: false, message: "Erro na entrada de dados"); return }
        guard let glicose = Float(field_glicose!.text!) else {
            showSuccessFailAlert(success: false, message: "Erro na entrada de dados"); return }
        guard let pressao_sanguinea = Float(field_pressaoSanguinea!.text!) else {
            showSuccessFailAlert(success: false, message: "Erro na entrada de dados"); return }
        guard let espessura_pele = Float(field_espessuraPele!.text!) else {
            showSuccessFailAlert(success: false, message: "Erro na entrada de dados"); return }
        guard let insulina = Float(field_insulina!.text!) else {
            showSuccessFailAlert(success: false, message: "Erro na entrada de dados"); return }
        guard let imc = Float(field_imc!.text!) else {
            showSuccessFailAlert(success: false, message: "Erro na entrada de dados"); return }
        guard let indice_historico = Float(field_indiceHistorico!.text!) else {
            showSuccessFailAlert(success: false, message: "Erro na entrada de dados"); return }
        guard let idade = Int(field_idade!.text!) else {
            showSuccessFailAlert(success: false, message: "Erro na entrada de dados"); return }
        
        let diagnostico = Diagnostico(n_gestacoes, glicose: glicose, pressao_sanguinea: pressao_sanguinea,
                                      espessura_pele: espessura_pele, insulina: insulina, imc: imc,
                                      indice_historico: indice_historico, idade: idade, diagnostico: nil)
        
        webService.sendData(diagnostico) { (success, message, diagnosticoRealizado) in
            DispatchQueue.main.async {
                self.showSuccessFailAlert(success: success, message: message)
                
                guard let resposta = diagnosticoRealizado?.diagnostico else {
                    self.lb_diagnostico.text = "..."
                    return
                }
                let probability = Float(resposta) ?? -1.0
                let val_string = probability >= 0 ? "\(probability*100)%" : "-1.0"
                let (tag, color) = Int(val_string.split(separator: ".")[0])! >= 50 ? ("Positivo", UIColor.red) : ("Negativo", UIColor.green)
                
                self.lb_diagnostico.text = val_string + " (\(tag))"
                self.lb_diagnostico.textColor = color
            
            }
        }
    }
}

