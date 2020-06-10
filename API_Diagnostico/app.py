from flask import Flask, request, jsonify
from diabetes_ml import diagnose

app = Flask(__name__)


@app.route('/diagnosticos/', methods=['POST'])
def diagnosticar():
    body = request.get_json(force=True)

    diagnose_probability = diagnose(n_gestacoes=body['n_gestacoes'], \
            glicose=body['glicose'], pressao_blood=body['pressao_sanguinea'], \
            grossura_pele=body['espessura_pele'], insulina=body['insulina'], \
            bmi=body['imc'], indice_historico=body['indice_historico'], \
            idade=body['idade'])

    body["diagnostico"] = diagnose_probability

    return jsonify(body), 200


if __name__ == "__main__":
    app.run(debug=True)