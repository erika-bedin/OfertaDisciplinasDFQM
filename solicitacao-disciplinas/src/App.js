import React, { useState, useEffect } from "react";
import FormDisciplinas from "./components/FormDisciplinas";
import SolicitacoesList from "./components/SolicitacoesList";

const App = () => {
  const [solicitacoes, setSolicitacoes] = useState([]);

  // Função para carregar as solicitações do back-end
  const fetchSolicitacoes = async () => {
    try {
      const response = await fetch("http://localhost:5000/solicitacoes");
      const data = await response.json();
      setSolicitacoes(data);
    } catch (error) {
      console.error("Erro ao carregar solicitações:", error);
    }
  };

  // Função para salvar uma nova solicitação
  const saveSolicitacao = async (novaSolicitacao) => {
    try {
      const response = await fetch("http://localhost:5000/solicitacoes", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(novaSolicitacao),
      });
      if (response.ok) {
        fetchSolicitacoes(); // Recarrega as solicitações após salvar
      }
    } catch (error) {
      console.error("Erro ao salvar solicitação:", error);
    }
  };

  // Função para excluir uma solicitação
  const deleteSolicitacao = async (id) => {
    try {
      const response = await fetch(`http://localhost:5000/solicitacoes/${id}`, {
        method: "DELETE",
      });
      if (response.ok) {
        fetchSolicitacoes(); // Recarrega as solicitações após excluir
      }
    } catch (error) {
      console.error("Erro ao excluir solicitação:", error);
    }
  };

  useEffect(() => {
    fetchSolicitacoes(); // Carrega as solicitações ao montar o componente
  }, []);

  return (
    <div>
      <h1>Gerenciador de Solicitações</h1>
      <FormDisciplinas onSave={saveSolicitacao} />
      <SolicitacoesList solicitacoes={solicitacoes} onDelete={deleteSolicitacao} />
    </div>
  );
};

export default App;