from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Configuração para conexão ao banco SQL Server
app.config['SQLALCHEMY_DATABASE_URI'] = (
    "mssql+pyodbc://@localhost/SolicitacaoDisciplinas?driver=ODBC+Driver+17+for+SQL+Server&Trusted_Connection=yes"
)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False  # Evitar warnings desnecessários

db = SQLAlchemy(app)

@app.route('/')
def home():
    return "API de Solicitação de Disciplinas funcionando!"

# Modelo de tabela para as Solicitações
class Solicitacao(db.Model):
    __tablename__ = 'Solicitacoes'
    id = db.Column(db.Integer, primary_key=True)
    coordenacao_id = db.Column('CoordenacaoId', db.Integer, nullable=False)
    docente_id = db.Column('DocenteId', db.Integer)
    disciplina_id = db.Column('DisciplinaId', db.Integer, nullable=False)
    responsavel = db.Column(db.String(100), nullable=False)
    curso = db.Column(db.String(100), nullable=False)
    grade = db.Column(db.String(50), nullable=False)
    perfil = db.Column(db.String(100), nullable=False)
    numero_vagas_calouros = db.Column('NumeroVagasCalouros', db.Integer, nullable=False)
    numero_vagas_total = db.Column('NumeroVagasTotal', db.Integer, nullable=False)

    def to_dict(self):
        return {
            'id': self.id,
            'coordenacaoId': self.coordenacao_id,
            'docenteId': self.docente_id,
            'disciplinaId': self.disciplina_id,
            'responsavel': self.responsavel,
            'curso': self.curso,
            'grade': self.grade,
            'perfil': self.perfil,
            'numeroVagasCalouros': self.numero_vagas_calouros,
            'numeroVagasTotal': self.numero_vagas_total
        }

class HorarioSolicitacao(db.Model):
    __tablename__ = 'HorariosSolicitacoes'
    id = db.Column(db.Integer, primary_key=True)
    solicitacao_id = db.Column('SolicitacaoId', db.Integer, db.ForeignKey('Solicitacoes.Id'), nullable=False)
    dia_semana = db.Column('DiaSemana', db.String(20), nullable=False)
    horario_inicio = db.Column('HorarioInicio', db.Time, nullable=False)
    horario_termino = db.Column('HorarioTermino', db.Time, nullable=False)

    def to_dict(self):
        return {
            'id': self.id,
            'solicitacaoId': self.solicitacao_id,
            'diaSemana': self.dia_semana,
            'horarioInicio': str(self.horario_inicio),
            'horarioTermino': str(self.horario_termino)
        }

@app.route('/solicitacoes', methods=['GET'])
def get_solicitacoes():
    try:
        solicitacoes = Solicitacao.query.all()
        result = []
        for s in solicitacoes:
            horarios = HorarioSolicitacao.query.filter_by(solicitacao_id=s.id).all()
            result.append({
                **s.to_dict(),
                'horarios': [h.to_dict() for h in horarios]
            })
        if not result:
            return jsonify({"message": "Nenhuma solicitação encontrada"}), 200
        return jsonify(result), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/solicitacoes', methods=['POST'])
def create_solicitacao():
    try:
        data = request.get_json()
        nova_solicitacao = Solicitacao(
            coordenacao_id=data['coordenacaoId'],
            docente_id=data.get('docenteId'),
            disciplina_id=data['disciplinaId'],
            responsavel=data['responsavel'],
            curso=data['curso'],
            grade=data['grade'],
            perfil=data['perfil'],
            numero_vagas_calouros=data['numeroVagasCalouros'],
            numero_vagas_total=data['numeroVagasTotal']
        )
        db.session.add(nova_solicitacao)
        db.session.commit()

        # Adicionar horários
        horarios = data['horarios']
        for h in horarios:
            novo_horario = HorarioSolicitacao(
                solicitacao_id=nova_solicitacao.id,
                dia_semana=h['diaSemana'],
                horario_inicio=h['horarioInicio'],
                horario_termino=h['horarioTermino']
            )
            db.session.add(novo_horario)

        db.session.commit()
        return jsonify({"message": "Solicitação criada com sucesso!"}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    # Inicialização da aplicação
    app.run()
