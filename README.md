# App Diagnóstico de Diabetes
Aplicativo para Diagnóstico de diabetes com Machine Learnig (App iOS + API Flask)

O processo de construção do modelo de machine learning envolve os processos de Análise exploratória dos dados, limpeza, tratamento de outliers e valores missing, técnicas de oversampling e undersampling, cross-validation, comparação de diferentes classificadores e melhoria de hyperparâmetros. E está documentado no meu [Repositório de Projetos de Machine Learning](https://github.com/brmaciel/Projects_Data/tree/master/Diagnostico_Diabetes).

O **deploy do modelo** de diagnóstico de diabetes é feito por meio de uma API com **Python** e **Flask**. E o consumo do Webservice é feito por um **App iOS** nativo construído com **Swift** e **Xcode**.

A aplicação mobile realiza o envio de informações de um paciente, e o webservice retorna como resposta a probabilidade do paciente de desenvolver a doença.

<ins>Tecnologias utilizadas:</ins> Python, Flask , Swift, Scikit-Learn, Pandas, Numpy, Matplotlib, Seaborn, imblearn
