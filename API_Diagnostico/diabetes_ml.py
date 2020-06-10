import numpy as np
import sklearn
import pickle

scaler_x = pickle.load(open('ML_models/scaler_x.sav', 'rb'))
classifier = pickle.load(open('ML_models/modelo_Forest.sav', 'rb'))

def diagnose(n_gestacoes, glicose, pressao_blood, grossura_pele, insulina, bmi, indice_historico, idade):
    x = np.array([n_gestacoes, glicose, pressao_blood, grossura_pele, \
                  insulina, bmi, indice_historico, idade])
    
    # Pre processamento
    x_scaled = scaler_x.transform(x.reshape(1, -1))

    # Classificação
    diagnostico = classifier.predict_proba(x_scaled)

    # Valor da Probabilidade como string
    print(diagnostico)
    diagnostico = "{:.6f}".format(diagnostico[0][1])

    return diagnostico
