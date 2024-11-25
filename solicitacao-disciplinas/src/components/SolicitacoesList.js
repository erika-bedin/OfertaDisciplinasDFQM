import React from "react";

const SolicitacoesList = ({ solicitacoes, onDelete }) => {
  return (
    <div>
      <h2>Solicitações Criadas</h2>
      {solicitacoes.length === 0 ? (
        <p>Nenhuma solicitação encontrada.</p>
      ) : (
        <table border="1" cellPadding="10">
          <thead>
            <tr>
              <th>ID</th>
              <th>Responsável</th>
              <th>Curso</th>
              <th>Grade</th>
              <th>Perfil</th>
              <th>Vagas Total</th>
              <th>Ações</th>
            </tr>
          </thead>
          <tbody>
            {solicitacoes.map((solicitacao) => (
              <tr key={solicitacao.id}>
                <td>{solicitacao.id}</td>
                <td>{solicitacao.responsavel}</td>
                <td>{solicitacao.curso}</td>
                <td>{solicitacao.grade}</td>
                <td>{solicitacao.perfil}</td>
                <td>{solicitacao.numeroVagasTotal}</td>
                <td>
                  <button onClick={() => onDelete(solicitacao.id)}>Excluir</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
};

export default SolicitacoesList;