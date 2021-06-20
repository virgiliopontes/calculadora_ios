//
//  ContentView.swift
//  calculadora
//
//  Created by Virgilio Pontes on 11/07/20.
//  Copyright © 2020 Virgilio Pontes. All rights reserved.
//

import SwiftUI

enum botoesCalculadora: String {
    case zero, um, dois, tres, quatro, cinco, seis, sete, oito, nove, ponto
    case igual, mais, menos, multiplicar, dividir
    case ac, maisMenos, porcentagem
    
    var title: String {
        switch self {
            case .zero: return "0"
            case .um: return "1"
            case .dois: return "2"
            case .tres: return "3"
            case .quatro: return "4"
            case .cinco: return "5"
            case .seis: return "6"
            case .sete: return "7"
            case .oito: return "8"
            case .nove: return "9"
            
            case .ponto: return "."
            case .mais: return "+"
            case .menos: return "-"
            case .maisMenos: return "+/-"
            case .dividir: return "/"
            case .porcentagem: return "%"
            case .igual: return "="
            case .multiplicar: return "X"
        default:
            return "AC"
        }
    }
    
    var width: CGFloat {
        switch self {
        case .zero:
            return (((UIScreen.main.bounds.width - 5 * 12) / 4) * 2) + 10
        default:
            return (UIScreen.main.bounds.width - 5 * 12) / 4
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .zero, .um, .dois, .tres, .quatro, .cinco, .seis, .sete, .oito, .nove, .ponto:
            return Color(.darkGray)
        case .ac, .maisMenos, .porcentagem:
            return Color(.lightGray)
        default:
            return .orange
        }
    }
    
}

//Env object
//You can treat this as the Global Application State
class GlobalEnviroment: ObservableObject {

    @Published var display = ""
    
    var resultado : Float = 0
    
    var operador : String = ""
    
    var numerosDisplay : String = ""
    
    func reciveInput(botoesCalculadora: botoesCalculadora) {
        
        if (Float(botoesCalculadora.title) != nil) {
            
            if (self.operador != "") {
                
                let numero: Float = Float(botoesCalculadora.title) ?? 0
                
                let numeroAnterior: Float = Float(self.numerosDisplay) ?? 0
                
                switch self.operador {
                case "+":
                    self.resultado = self.soma(n1: numeroAnterior, n2: numero)
                case "-":
                    self.resultado = self.subitracao(n1: numeroAnterior, n2: numero)
                case "X":
                    self.resultado = self.multiplicar(n1: numeroAnterior, n2: numero)
                case "/":
                    self.resultado = self.divisao(n1: numeroAnterior, n2: numero)
                default:
                    self.display = "Erro"
                }
                
                self.numerosDisplay = String(self.resultado)
                self.operador = ""
                
            } else {
                self.numerosDisplay += botoesCalculadora.title
            }
            
        } else {
            
            if (botoesCalculadora.title == "=") {
                self.apresentarResultado()
            } else if (botoesCalculadora.title == "AC") {
                self.resetar()
            } else  {
                self.operador = botoesCalculadora.title
            }
            
        }
        
        if (botoesCalculadora.title != "=" && botoesCalculadora.title != "AC") {
            self.display += botoesCalculadora.title
        }
        
    }
    
    func soma(n1:Float, n2:Float) -> Float {
        return n1 + n2
    }
    
    func subitracao(n1:Float, n2:Float) -> Float {
        return n1 - n2
    }
    
    func divisao(n1:Float, n2:Float) -> Float {
        return n1 / n2
    }
    
    func multiplicar(n1:Float, n2:Float) -> Float {
        return n1 * n2
    }
    
    func resetar() {
        self.display = ""
        self.resultado = 0
        self.numerosDisplay = ""
        self.operador = ""
    }
    
    func apresentarResultado() {
        self.display = String(self.resultado)
        self.numerosDisplay = String(self.resultado)
    }
    
    
}

struct ContentView: View {
    
    @EnvironmentObject var env: GlobalEnviroment
    
    let buttons: [[botoesCalculadora]] = [
        [.ac, .maisMenos, .porcentagem, .dividir],
        [.sete, .oito, .nove, .multiplicar],
        [.quatro, .cinco, .seis, .menos],
        [.um, .dois, .tres, .mais],
        [.zero, .ponto, .igual],
    ]
    
    var body: some View {
        ZStack (alignment: .bottom /*Alinhar conteúdo da View*/ ) {//ZStack é equivalnete a uma Div
            Color.black//Fundo Preto
                .edgesIgnoringSafeArea(.all)//Bordas Pretas
            
            VStack (spacing: 12) {//Conteúdo Vertical
                HStack {
                    Spacer()
                    Text(env.display).foregroundColor(.white)
                    .font(.system(size: 64))
                }.padding()
                
                
                ForEach(buttons, id: \.self) {//Percorrer array
                    HButtons in//Armazena o Item percorrido
                    
                    HStack {//Conteúdo Horizontal (Linha)
                        
                        ForEach(HButtons, id: \.self) {//Percorrer Array
                            button in//Armazena o Item percorrido
                            
                            botaoCalculadoraView(button: button)
                            
                        }
                        
                    }
                    
                }
                
            }.padding(.bottom)
        }
    }
    
}

struct botaoCalculadoraView: View {
    
    var button: botoesCalculadora
    
    @EnvironmentObject var env: GlobalEnviroment
    
    var body: some View{
        Button(action:{
            self.env.reciveInput(botoesCalculadora: self.button)
        }) {
        Text(button.title)
            .font(.system(size: 32))
            .frame(
                width: button.width,
                height: self._buttonWidth()
            )
            .foregroundColor(.white)
            .background(button.backgroundColor)
            .cornerRadius(self._buttonWidth())
        }
    }
    
    private func _buttonWidth() -> CGFloat {
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalEnviroment())
    }
}
